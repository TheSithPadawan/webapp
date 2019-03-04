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