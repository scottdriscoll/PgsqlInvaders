CREATE FUNCTION get_board() RETURNS text[]
    LANGUAGE plpgsql
        AS $$DECLARE
            board text[];
            alien unit%rowtype;
            missile projectile%rowtype;
            player_x int;

            BEGIN
                -- See if player lost
                IF (SELECT count(1) FROM unit WHERE player = TRUE) = 0 OR (SELECT count(1) FROM unit WHERE player = FALSE AND y = 20) > 0 THEN
                  board[0] := '+------------------------------+';
                  board[1] := '|          You Lose!           |';
                  FOR board_y IN 2..20 LOOP
                    board[board_y] := '|                              |';
                  END LOOP;
                  board[21] := '+------------------------------+';

                  return board;
                END IF;

                -- See if player won
                IF (SELECT count(1) FROM unit WHERE player = FALSE) = 0 THEN
                  board[0] := '+------------------------------+';
                  board[1] := '|          You Win!            |';
                  FOR board_y IN 2..20 LOOP
                    board[board_y] := '|                              |';
                  END LOOP;
                  board[21] := '+------------------------------+';

                  return board;
                END IF;

                -- Return game board
                player_x := (SELECT x FROM unit WHERE player = TRUE LIMIT 1);
                board[0] := '+------------------------------+';

                -- Add aliens and projectiles
                FOR board_y IN 1..20 LOOP
                    board[board_y] := '|                              |';
                    FOR alien IN SELECT * FROM unit u WHERE player = FALSE AND y = board_y LOOP
                        board[board_y] := overlay(board[board_y] placing 'x' from alien.x + 1 for 1);
                    END LOOP;

                    FOR missile IN SELECT * FROM projectile WHERE y = board_y LOOP
                        board[board_y] := overlay(board[board_y] placing '|' from missile.x + 1 for 1);
                    END LOOP;
                END LOOP;

                board[21] := '+------------------------------+';

                -- Add player
                board[20] := overlay(board[20] placing '^' from player_x + 1 for 1);

                return board;
            END;$$;
