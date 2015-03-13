CREATE FUNCTION update_board() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE
        board_width int;
        board_height int;
        alien_direction_right bool;
        alien unit%rowtype;

        BEGIN
            board_width := 30;
            board_height := 20;
            alien_direction_right := (SELECT direction_right FROM unit WHERE player = FALSE LIMIT 1);

            -- Remove aliens and projectiles who have collided
            FOR alien IN SELECT * FROM unit u INNER JOIN projectile p ON u.x = p.x AND u.y = p.y AND p.player = TRUE LOOP
              DELETE FROM unit u WHERE u.player = FALSE AND u.x = alien.x AND u.y = alien.y;
              DELETE FROM projectile WHERE x = alien.x AND y = alien.y AND player = TRUE;
            END LOOP;
--            DELETE FROM unit WHERE id IN (
--              SELECT u.id FROM unit u
--              INNER JOIN projectile p ON u.x = p.x AND u.y = p.y AND p.player = TRUE
--              WHERE u.player = FALSE
--            );

            -- If the player has been hit, then kill him
            DELETE FROM unit WHERE id IN (
              SELECT u.id FROM unit u
              INNER JOIN projectile p ON u.x = p.x AND u.y = p.y AND p.player = FALSE
              WHERE u.player = TRUE
            );

            -- Update alien projectiles
            UPDATE projectile SET y = y + 1, last_update = now() WHERE player = FALSE AND now() >= last_update + speed;

            -- Remove dead projectiles
            DELETE FROM projectile WHERE y > board_height OR y < 1;

            -- Update player projectiles
            UPDATE projectile SET y = y - 1, last_update = now() WHERE player = TRUE AND now() >= last_update + speed;

            -- Update alien positions
            IF alien_direction_right = TRUE THEN
              UPDATE unit SET x = x + 1, last_update = now() WHERE player = FALSE and now() >= last_update + speed;
              IF (SELECT count(1) FROM unit WHERE player = FALSE and x = board_width) > 0 THEN
                UPDATE unit SET x = x - 1, y = y + 1, direction_right = FALSE WHERE player = FALSE;
              END IF;
            ELSE
              UPDATE unit SET x = x - 1, last_update = now() WHERE player = FALSE and now() >= last_update + speed;
              IF (SELECT count(1) FROM unit WHERE player = FALSE and x = 0) > 0 THEN
                UPDATE unit SET x = x + 1, y = y + 1, direction_right = TRUE WHERE player = FALSE;
                END IF;
              END IF;

            -- Add alien projectiles, each has a small chance to add a projectile per update
            FOR alien IN SELECT * FROM unit WHERE player = FALSE LOOP
              IF trunc(random() * 1500 + 1) = 50 THEN
                INSERT INTO projectile (x, y, player, speed) VALUES (alien.x, alien.y, FALSE, '0.1 second');
              END IF;
            END LOOP;
        END;$$;
