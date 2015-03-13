CREATE FUNCTION move_player(direction_right boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN
        IF direction_right = TRUE THEN
            UPDATE unit SET x = x + 1 WHERE player = TRUE AND x < 30;
        ELSE
            UPDATE unit SET x = x - 1 WHERE player = TRUE AND x > 1;
        END IF;
    END;$$;
