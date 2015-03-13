PgsqlInvaders!
==============

Space Invaders written entirely in PostgreSQL!

Keyboard input and display is handled with PHP, the rest of the game is handled by Pgsql.

### Installation

Clone project, run `composer install`.

Enter your database information. The database will be created automatically.

Run `php game.php migrations` to create the database and set up the tables. You only need to do this once.

Run `php game.php run` to play the game!
