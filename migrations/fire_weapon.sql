CREATE FUNCTION fire_weapon() RETURNS void
    LANGUAGE plpgsql
        AS $$BEGIN

        INSERT INTO projectile (x, y, player, speed) VALUES (
          (SELECT x FROM unit WHERE player = TRUE),
          (SELECT y FROM unit WHERE player = TRUE) - 1,
          true,
          '.1 second'
        );

        END;$$;
