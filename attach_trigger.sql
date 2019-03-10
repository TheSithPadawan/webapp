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
  BEGIN
    refresh materialized view grade_aggregate;
    RETURN NULL;
  END;
  $$;

-- trigger binds to has_taken table
CREATE TRIGGER update_mat_vew
  AFTER INSERT OR DELETE OR UPDATE
  ON has_taken
  FOR EACH ROW
EXECUTE PROCEDURE refresh_mat_view();