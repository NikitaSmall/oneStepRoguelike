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

  def exit_game
    msg_log "Press any key to flee from Morgoth"
    GlobalUtilityState::DRAWER.draw_all
    k = get_input
    while k == nil do
      k = get_input
    end
    exit 0
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