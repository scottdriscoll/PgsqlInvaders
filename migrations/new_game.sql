CREATE FUNCTION new_game() RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN

        DELETE FROM unit;
        DELETE FROM projectile;

        -- Add aliens
        FOR y IN 1..5 LOOP
            FOR x IN 10..20 LOOP
                INSERT INTO unit (x, y, player, speed, direction_right) VALUES (x, y, false, '.3 second', true);
            END LOOP;
        END LOOP;

        -- Add player
        INSERT INTO unit (x, y, player) VALUES (15, 20, true);
    END;$$;
