<?php

namespace SD;

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\DriverManager;

/**
 * @author Scott Driscoll <scott.driscoll@opensoftdev.com>
 */
class Migrations
{
    /**
     * @var Connection
     */
    private $connection;

    /**
     * @param Connection $connection
     */
    public function __construct(Connection $connection)
    {
        $this->connection = $connection;
    }

    public function migrate()
    {
        $params = $this->connection->getParams();
        $name = $params['dbname'];
        unset($params['dbname']);

        /** @var Connection $db */
        $db = DriverManager::getConnection($params);
        $db->getSchemaManager()->createDatabase($name);
        $db->close();

        $this->connection->exec(file_get_contents(__DIR__ . '/../../migrations/projectile.sql'));
        $this->connection->exec(file_get_contents(__DIR__ . '/../../migrations/unit.sql'));
        $this->connection->exec(file_get_contents(__DIR__ . '/../../migrations/fire_weapon.sql'));
        $this->connection->exec(file_get_contents(__DIR__ . '/../../migrations/get_board.sql'));
        $this->connection->exec(file_get_contents(__DIR__ . '/../../migrations/move_player.sql'));
        $this->connection->exec(file_get_contents(__DIR__ . '/../../migrations/new_game.sql'));
        $this->connection->exec(file_get_contents(__DIR__ . '/../../migrations/update_board.sql'));
    }
}
