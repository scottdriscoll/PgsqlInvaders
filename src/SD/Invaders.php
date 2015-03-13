<?php

namespace SD;

use Doctrine\DBAL\Connection;
use SD\ConsoleHelper\OutputHelper;
use SD\ConsoleHelper\ScreenBuffer;
use SD\ConsoleHelper\Keyboard;

/**
 * @author Scott Driscoll <scott.driscoll@opensoftdev.com>
 */
class Invaders
{
    const FRAMES_PER_SEC = 60;

    const ONE_SEC_MICRO = 1000000;

    /**
     * @var Connection
     */
    private $connection;

    /**
     * @var OutputHelper
     */
    private $output;

    /**
     * @var ScreenBuffer
     */
    private $buffer;

    /**
     * @var Keyboard
     */
    private $keyboard;

    /**
     * @var bool
     */
    private $gameOver = false;

    /**
     * @param Connection $connection
     * @param OutputHelper $output
     * @param ScreenBuffer $buffer
     * @param Keyboard $keyboard
     */
    public function __construct(Connection $connection, OutputHelper $output, ScreenBuffer $buffer, Keyboard $keyboard)
    {
        $this->connection = $connection;
        $this->output = $output;
        $this->buffer = $buffer;
        $this->keyboard = $keyboard;
    }

    public function play()
    {
        declare(ticks = 1);
        pcntl_signal(SIGINT, [$this, 'gameOver']);
        pcntl_signal(SIGTERM, [$this, 'gameOver']);

        $this->output->disableKeyboardOutput();
        $this->output->hideCursor();
        $this->buffer->initialize(35, 25);

        $this->connection->exec('SELECT new_game()');

        while (!$this->gameOver) {
            $timeStart = microtime(true);
            $this->output->clear();
            $this->buffer->clearScreen();

            switch ($this->keyboard->readKey()) {
                case Keyboard::LEFT_ARROW:
                    $this->connection->exec('SELECT move_player(false)');
                    break;
                case Keyboard::RIGHT_ARROW:
                    $this->connection->exec('SELECT move_player(true)');
                    break;
                case ' ':
                    $this->connection->exec('SELECT fire_weapon()');
                    break;
            }
            $this->connection->exec('SELECT update_board()');
            $board = $this->connection->fetchAssoc('SELECT get_board()');
            $board = explode(',', $board['get_board']);

            $y = 0;
            foreach ($board as $line) {
                $line = str_replace(['"', '{', '}', '[0:21]='], '', $line);

                $x = 0;
                foreach (str_split($line) as $letter) {
                    $this->buffer->putNextValue($x++, $y, $letter);
                }
                $y++;
            }

            $this->buffer->paintChanges($this->output);
            $this->buffer->nextFrame();
            $this->output->dump();

            $time = microtime(true) - $timeStart;
            $timeToSleep = (self::ONE_SEC_MICRO / self::FRAMES_PER_SEC) - $time * self::ONE_SEC_MICRO;

            if ($timeToSleep > 0) {
                usleep($timeToSleep);
            }
        }
    }

    public function gameOver()
    {
        $this->gameOver = true;
    }
}
