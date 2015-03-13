<?php
/**
 * @author Scott Driscoll <scott.driscoll@opensoftdev.com>
 */

require_once('vendor/autoload.php');

use Symfony\Component\Yaml\Yaml;
use Symfony\Component\Console\Application;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Doctrine\DBAL\DriverManager;
use SD\Migrations;
use SD\Invaders;
use SD\ConsoleHelper\OutputHelper;
use SD\ConsoleHelper\ScreenBuffer;
use SD\ConsoleHelper\Keyboard;

$config = Yaml::parse(file_get_contents('config/parameters.yml'));

$connectionParams = [
    'driver' => 'pdo_pgsql',
    'host' => $config['parameters']['databases.default.host'],
    'port' => $config['parameters']['databases.default.port'],
    'user' => $config['parameters']['databases.default.user'],
    'password' => $config['parameters']['databases.default.password'],
    'dbname' => $config['parameters']['databases.default.name'],
    'driverOptions' => []
];

$connection = DriverManager::getConnection($connectionParams);

$console = new Application();

$console
    ->register('migrations')
    ->setDescription('Creates the database')
    ->setCode(
        function (InputInterface $input, OutputInterface $output) use ($connection) {
            $migration = new Migrations($connection);
            $migration->migrate();
            $output->writeln('<info>Database Created</info>');
        }
    );

$console->register('run')
    ->setDescription('Runs the game')
    ->setCode(
        function (InputInterface $input, OutputInterface $output) use ($connection) {
            $invaders = new Invaders($connection, new OutputHelper($output), new ScreenBuffer(), new Keyboard());
            $invaders->play();
        }
    );

$console->run();
