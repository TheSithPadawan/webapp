-- trigger 1 to check for meeting time conflict
CREATE OR REPLACE FUNCTION check_meeting_times()
  RETURNS trigger AS
$$
BEGIN
  IF EXISTS(SELECT * FROM has_weekly_meetings WHERE has_weekly_meetings.sectionid = NEW.sectionid
  AND has_weekly_meetings.day = NEW.day AND has_weekly_meetings.time_start < NEW.time_end AND
  has_weekly_meetings.time_end > NEW.time_start) THEN
    BEGIN
      RAISE EXCEPTION 'Time conflict detected';
      ROLLBACK;
      RETURN NULL;
    END;
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER check_val_before_insert
  BEFORE INSERT
  ON has_weekly_meetings
  FOR EACH ROW
  EXECUTE PROCEDURE check_meeting_times();

-- DROP IF NECESSARY
-- DROP TRIGGER check_val_before_insert ON has_weekly_meetings;

-- trigger 2: check for enrollment limit
CREATE OR REPLACE FUNCTION check_enrollment_limit()
  RETURNS trigger AS
$$
DECLARE enroll_limit integer;
DECLARE current_num integer;
BEGIN
  -- pre compute
  CREATE TABLE current_enrollment AS
    SELECT students_enrolled.sectionid, count(*) AS sum
    FROM students_enrolled
    GROUP BY students_enrolled.sectionid;
  SELECT sections.enrollment_limit INTO enroll_limit
  FROM sections WHERE sections.sectionid = NEW.sectionid;
  SELECT current_enrollment.sum INTO current_num
  FROM current_enrollment WHERE current_enrollment.sectionid = NEW.sectionid;
  IF (current_num >= enroll_limit) THEN
    -- raise exception here
    BEGIN
      RAISE EXCEPTION 'Enrollment limit exceeded for section %', NEW.sectionid;
      -- clean up
      DROP TABLE current_enrollment;
      RETURN NULL;
    END;
  END IF;
  -- clean up
  DROP TABLE current_enrollment;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER check_limit_before_insert
  BEFORE INSERT
  ON students_enrolled
  FOR EACH ROW
EXECUTE PROCEDURE check_enrollment_limit();

-- DROP IF NECESSARY
-- DROP TRIGGER check_limit_before_insert ON students_enrolled;

-- trigger 3: checking for conflicting sections of faculty
-- first produce a table for weekly meeting schedule for the faculty
-- insert new section taught by a faculty to an intermediate table
-- bind the trigger to the intermediate table, check before insert; if it works, insert to the correct table

SELECT taught_by.sectionid, has_weekly_meetings.day, has_weekly_meetings.time_start, has_weekly_meetings.time_end,
  taught_by.faculty_name
  FROM has_weekly_meetings INNER JOIN taught_by ON taught_by.sectionid = has_weekly_meetings.sectionid
WHERE faculty_name = 'Sanjoy Dasgupta';

CREATE OR REPLACE FUNCTION check_faculty_schedule()
  RETURNS trigger AS
$$
BEGIN
  -- precompute faculty schedule
  CREATE TABLE temp_faculty_section AS
    SELECT *
    FROM taught_by
    WHERE sectionid = NEW.sectionid;

  CREATE TABLE faculty_schedule AS
    SELECT has_weekly_meetings.sectionid,
      has_weekly_meetings.day,
      has_weekly_meetings.time_start,
      has_weekly_meetings.time_end,
      taught_by.faculty_name
    FROM has_weekly_meetings
    JOIN taught_by
      ON taught_by.sectionid = has_weekly_meetings.sectionid
    JOIN temp_faculty_section
      ON temp_faculty_section.faculty_name = taught_by.faculty_name;

  IF EXISTS (
    SELECT *
    FROM faculty_schedule
    WHERE faculty_schedule.day = NEW.day
      AND faculty_schedule.time_start < NEW.time_end
      AND faculty_schedule.time_end > NEW.time_start) THEN
    BEGIN
      RAISE EXCEPTION 'Time conflict for section';
        DROP TABLE temp_faculty_section;
      DROP TABLE faculty_schedule;
      RETURN NULL;
    END;
  END IF;

  DROP TABLE temp_faculty_section;
  DROP TABLE faculty_schedule;

  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER check_faculty_schedule_before_insert
  BEFORE INSERT
  ON has_weekly_meetings
  FOR EACH ROW
EXECUTE PROCEDURE check_faculty_schedule();

-- DROP IF NECESSARY
-- DROP TRIGGER check_faculty_schedule_before_insert ON faculty_taught;

-- check for conflicting reviews
CREATE OR REPLACE FUNCTION check_review_conflicts()
  RETURNS trigger AS
$$
BEGIN
  -- precompute faculty schedule
  CREATE TABLE temp_faculty_review AS
    SELECT *
    FROM taught_by
    WHERE sectionid = NEW.sectionid;

  CREATE TABLE faculty_schedule AS
    SELECT review_session.sectionid,
      review_session.date_of,
      review_session.time_start,
      review_session.time_end,
      taught_by.faculty_name
    FROM review_session
    JOIN taught_by
      ON taught_by.sectionid = review_session.sectionid
    JOIN temp_faculty_review
      ON temp_faculty_review.faculty_name = taught_by.faculty_name;

  IF EXISTS (
    SELECT *
    FROM faculty_schedule
    WHERE faculty_schedule.date_of = NEW.date_of
      AND faculty_schedule.time_start < NEW.time_end
      AND faculty_schedule.time_end > NEW.time_start) THEN
    BEGIN
      RAISE EXCEPTION 'Time conflict for review session';
        DROP TABLE temp_faculty_review;
      DROP TABLE faculty_schedule;
      RETURN NULL;
    END;
  END IF;

  DROP TABLE temp_faculty_review;
  DROP TABLE faculty_schedule;

  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER check_review_conflicts_before_insert
  BEFORE INSERT
  ON review_session
  FOR EACH ROW
EXECUTE PROCEDURE check_review_conflicts();

-- function refresh a materialized view at insertion
CREATE OR REPLACE FUNCTION refresh_mat_view()
  RETURNS TRIGGER LANGUAGE plpgsql
  AS $$
  DECLARE courseid VARCHAR;
          faculty VARCHAR;
          quarter quarter_enum;
          year    int;
  BEGIN
    -- compute delta
    CREATE TABLE tmp_cpqg AS
      SELECT NEW.courseid, taught_by.faculty_name, NEW.quarter, NEW.year,
        COUNT(*) FILTER (WHERE NEW.grade = ANY ('{A+,A,A-}')) AS A,
        COUNT(*) FILTER (WHERE NEW.grade = ANY ('{B+,B,B-}')) AS B,
        COUNT(*) FILTER (WHERE NEW.grade = ANY ('{C+,C,C-}')) AS C,
        COUNT(*) FILTER (WHERE NEW.grade = 'D') AS D,
        COUNT(*) FILTER (WHERE NOT NEW.grade = ANY ('{A+,A,A-,B+,B,B-,C+,C,C-,D}')) AS other
      FROM taught_by WHERE NEW.sectionid = taught_by.sectionid
      GROUP BY NEW.courseid, taught_by.faculty_name, NEW.quarter, NEW.year;

    -- for each delta perform update
    -- the following code performs the update
    IF EXISTS (SELECT * FROM grade_aggregate, tmp_cpqg WHERE tmp_cpqg.courseid = grade_aggregate.courseid
    AND tmp_cpqg.faculty_name = grade_aggregate.faculty_name AND tmp_cpqg.quarter = grade_aggregate.quarter
    AND tmp_cpqg.year = grade_aggregate.year) THEN
      -- either grade update or new student records
      IF NEW.grade IN ('A+', 'A', 'A-') THEN
        UPDATE grade_aggregate
        SET A = tmp_cpqg.A
        FROM tmp_cpqg
        WHERE tmp_cpqg.courseid = grade_aggregate.courseid
              AND tmp_cpqg.faculty_name = grade_aggregate.faculty_name AND tmp_cpqg.quarter = grade_aggregate.quarter
              AND tmp_cpqg.year = grade_aggregate.year;
      ELSEIF NEW.grade IN ('B+', 'B', 'B-') THEN
        UPDATE grade_aggregate
        SET B = tmp_cpqg.B
        FROM tmp_cpqg
        WHERE tmp_cpqg.courseid = grade_aggregate.courseid
              AND tmp_cpqg.faculty_name = grade_aggregate.faculty_name AND tmp_cpqg.quarter = grade_aggregate.quarter
              AND tmp_cpqg.year = grade_aggregate.year;
      ELSEIF NEW.grade IN ('C+', 'C', 'C-') THEN
        UPDATE grade_aggregate
        SET C = tmp_cpqg.C
        FROM tmp_cpqg
        WHERE tmp_cpqg.courseid = grade_aggregate.courseid
              AND tmp_cpqg.faculty_name = grade_aggregate.faculty_name AND tmp_cpqg.quarter = grade_aggregate.quarter
              AND tmp_cpqg.year = grade_aggregate.year;
      ELSEIF NEW.grade IN ('D+', 'D', 'D-') THEN
        UPDATE grade_aggregate
        SET D = tmp_cpqg.D
        FROM tmp_cpqg
        WHERE tmp_cpqg.courseid = grade_aggregate.courseid
              AND tmp_cpqg.faculty_name = grade_aggregate.faculty_name AND tmp_cpqg.quarter = grade_aggregate.quarter
              AND tmp_cpqg.year = grade_aggregate.year;
      ELSE
        UPDATE grade_aggregate
        SET other = tmp_cpqg.other
        FROM tmp_cpqg
        WHERE tmp_cpqg.courseid = grade_aggregate.courseid
              AND tmp_cpqg.faculty_name = grade_aggregate.faculty_name AND tmp_cpqg.quarter = grade_aggregate.quarter
              AND tmp_cpqg.year = grade_aggregate.year;
      END IF;
    ELSE
      -- it's a new row for a new course
      INSERT INTO grade_aggregate SELECT * FROM tmp_cpqg;
    END IF;

    -- if it's an update need to change the old record also
    IF tg_op = 'UPDATE' THEN
      SELECT faculty_name INTO faculty FROM tmp_cpqg WHERE OLD.courseid = tmp_cpqg.courseid;
      IF OLD.grade IN ('A+', 'A', 'A-') THEN
        UPDATE grade_aggregate
        SET A = grade_aggregate.A - 1
        WHERE OLD.courseid =grade_aggregate.courseid AND old.quarter = grade_aggregate.quarter
        AND old.year = grade_aggregate.year AND grade_aggregate.faculty_name = faculty;
      ELSEIF NEW.grade IN ('B+', 'B', 'B-') THEN
        UPDATE grade_aggregate
        SET B = grade_aggregate.B - 1
        WHERE OLD.courseid =grade_aggregate.courseid AND old.quarter = grade_aggregate.quarter
              AND old.year = grade_aggregate.year AND grade_aggregate.faculty_name = faculty;
      ELSEIF NEW.grade IN ('C+', 'C', 'C-') THEN
        UPDATE grade_aggregate
        SET C = grade_aggregate.C - 1
        WHERE OLD.courseid =grade_aggregate.courseid AND old.quarter = grade_aggregate.quarter
              AND old.year = grade_aggregate.year AND grade_aggregate.faculty_name = faculty;
      ELSEIF NEW.grade IN ('D+', 'D', 'D-') THEN
        UPDATE grade_aggregate
        SET D = grade_aggregate.D - 1
        WHERE OLD.courseid =grade_aggregate.courseid AND old.quarter = grade_aggregate.quarter
              AND old.year = grade_aggregate.year AND grade_aggregate.faculty_name = faculty;
      ELSE
        UPDATE grade_aggregate
        SET other = grade_aggregate.other - 1
        WHERE OLD.courseid =grade_aggregate.courseid AND old.quarter = grade_aggregate.quarter
              AND old.year = grade_aggregate.year AND grade_aggregate.faculty_name = faculty;
      END IF;
    END IF;
    DROP TABLE tmp_cpqg;
    RETURN NEW;
    END;
  $$;

-- trigger binds to has_taken table
CREATE TRIGGER update_mat_vew
  BEFORE INSERT OR UPDATE
  ON has_taken
  FOR EACH ROW
EXECUTE PROCEDURE refresh_mat_view();

CREATE OR REPLACE FUNCTION refresh_cpg_view()
  RETURNS TRIGGER LANGUAGE plpgsql
  AS $$
  DECLARE
    new_faculty TEXT;
    new_A INT;
    new_B INT;
    new_C INT;
    new_D INT;
    new_other INT;
  BEGIN
    -- compute new row
    CREATE TABLE tmp_cpg AS
      SELECT NEW.courseID, taught_by.faculty_name,
          COUNT(*) FILTER (WHERE NEW.grade = ANY ('{A+,A,A-}')) AS A,
          COUNT(*) FILTER (WHERE NEW.grade = ANY ('{B+,B,B-}')) AS B,
          COUNT(*) FILTER (WHERE NEW.grade = ANY ('{C+,C,C-}')) AS C,
          COUNT(*) FILTER (WHERE NEW.grade = 'D') AS D,
          COUNT(*) FILTER (WHERE NOT NEW.grade = ANY ('{A+,A,A-,B+,B,B-,C+,C,C-,D}')) AS other
      FROM faculty_taught
      JOIN taught_by
          ON NEW.sectionID = taught_by.sectionID AND taught_by.faculty_name = faculty_taught.faculty_name
      WHERE faculty_taught.courseID = NEW.courseID AND faculty_taught.quarter = NEW.quarter AND faculty_taught.year = NEW.year
      GROUP BY NEW.courseID, taught_by.faculty_name;

    -- pull new faculty and grade
    SELECT tmp_cpg.faculty_name INTO STRICT new_faculty FROM tmp_cpg WHERE tmp_cpg.courseID = NEW.courseID;
    SELECT tmp_cpg.A INTO STRICT new_A FROM tmp_cpg WHERE tmp_cpg.courseID = NEW.courseID;
    SELECT tmp_cpg.B INTO STRICT new_B FROM tmp_cpg WHERE tmp_cpg.courseID = NEW.courseID;
    SELECT tmp_cpg.C INTO STRICT new_C FROM tmp_cpg WHERE tmp_cpg.courseID = NEW.courseID;
    SELECT tmp_cpg.D INTO STRICT new_D FROM tmp_cpg WHERE tmp_cpg.courseID = NEW.courseID;
    SELECT tmp_cpg.other INTO STRICT new_other FROM tmp_cpg WHERE tmp_cpg.courseID = NEW.courseID;

    IF OLD IS NOT NULL THEN
      RAISE NOTICE 'update grade cpg';
      -- this is an update
        IF OLD.grade IN ('A+', 'A', 'A-') THEN
          EXECUTE '
          UPDATE CPG
              SET A = A - 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
        ELSEIF OLD.grade IN ('B+', 'B', 'B-') THEN
          EXECUTE '
          UPDATE CPG
              SET B = B - 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
        ELSEIF OLD.grade IN ('C+', 'C', 'C-') THEN
          EXECUTE '
          UPDATE CPG
              SET C = C - 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
        ELSEIF OLD.grade IN ('D') THEN
          EXECUTE '
          UPDATE CPG
              SET D = D - 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
        ELSE
          EXECUTE '
          UPDATE CPG
              SET other = other - 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM CPG WHERE courseID = NEW.courseID AND faculty_name = new_faculty) THEN
      RAISE NOTICE 'increment grade cpg';
      -- add grade
      IF (new_A > 0) THEN
          EXECUTE '
          UPDATE CPG
              SET A = A + 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
      ELSIF (new_B > 0) THEN
          EXECUTE '
          UPDATE CPG
              SET B = B + 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
      ELSIF (new_C > 0) THEN
          EXECUTE '
          UPDATE CPG
              SET C = C + 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
      ELSIF (new_D > 0) THEN
          EXECUTE '
          UPDATE CPG
              SET D = D + 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
      ELSIF (new_other > 0) THEN
          EXECUTE '
          UPDATE CPG
              SET other = other + 1
          WHERE courseID =' || quote_literal(NEW.courseID) || ' AND faculty_name = ' || quote_literal(new_faculty);
      END IF;
    ELSE
      -- new row
      RAISE NOTICE 'new row cpg';
      INSERT INTO CPG (SELECT * FROM tmp_cpg);
    END IF;

    DROP TABLE tmp_cpg;
    RETURN NULL;
  END;
  $$;

CREATE TRIGGER trigger_update_cpg
  AFTER INSERT OR UPDATE
  ON has_taken
  FOR EACH ROW
EXECUTE PROCEDURE refresh_cpg_view();

