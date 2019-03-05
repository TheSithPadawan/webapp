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
