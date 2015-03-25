require 'libtcod'
require 'cave_gen'

require './dungeon'
require './drawing'
require './actor'

class Game
  MAP_ROWS = 32
  MAP_COLS = 48

  MSG_LOG_ROWS = 6
  MSG_LOG_COLS = 80
  MAX_MSG_LENGHT = MSG_LOG_COLS - 2

  def initialize
    $msg_log = []
    map = Dungeon.new
    $level = map
    $actors = Actor.init_actors($level)
    $player = Actor.create_player($level, "Fingolfin, the Elvenking")

    $prng = Random.new
    $drawer = Drawing.new MSG_LOG_ROWS

    puts map.grid
  end

  def process_input
    entered_key = get_input
    exit_game if entered_key == TCOD::KEY_ESCAPE
    process_player_input entered_key
  end

  def get_input
    key = TCOD.console_wait_for_keypress(true)

    if key.vk == TCOD::KEY_ESCAPE
      return TCOD::KEY_ESCAPE
    end

    if key.pressed
      return key.c
    end

    return nil
  end

  def process_player_input (input)
    return false unless input
    return false if input == "\x00"

    player = GlobalGameState::PLAYER

    player_moved = if input == 'w'
      player.move :north
    elsif input == 's'
      player.move :south
    elsif input == 'a'
      player.move :west
    elsif input == 'd'
      player.move :east
    elsif input == '.'
      player.move :rest
    else
      msg_log "DEBUG: unknown command #{input}"
      false
    end

    return player_moved
  end

  def exit_game
    msg_log "Press any key to flee from Morgoth"
    GlobalUtilityState::DRAWER.draw_all
    k = get_input
    while k == nil do
      k = get_input
    end
    exit 0
  end

  def game
    msg_log "The glorious Fingolfin stands apart Morgoth, the great Enemy of Eldar and Mankind..."

    until TCOD.console_is_window_closed
      GlobalUtilityState::DRAWER.draw_all

      player_acted = process_input
      if player_acted
        # process_non_player_actors
        if player_is_alone?
          msg_log "You beat Morgoth! Eternal glory to you!"
          exit_game
        end
      end
    end
  end

end

module GlobalGameState
  PRNG = $prng
end

module GlobalGameState
  DUNGEON_LEVEL = $level
  ACTORS = $actors
  PLAYER = $player
  MSG_LOG = $msg_log
end

module GlobalUtilityState
  DRAWER = $drawer
end

game = Game.new
#game.game