require 'libtcod'
require 'cave_gen'

require './dungeon'
require './drawing'
require './actor'

require './util/screen'

class Game
  MAP_ROWS = 32
  MAP_COLS = 48

  MSG_LOG_ROWS = 7
  MSG_LOG_COLS = 80
  MAX_MSG_LENGTH = MSG_LOG_COLS - 2

  def initialize
    $msg_log = Array.new
    map = Dungeon.new
    $level = map
    $actors = Actor.init_actors($level)
    #$player = Actor.create_player($level, "Fingolfin, the Elvenking")

    $prng = Random.new
    $drawer = Drawing.new MSG_LOG_ROWS

    $screen = Screen.new

    stats = lambda do
      return {"Player name" => $actors[:player].name,
              "Health points remain" => $actors[:player].hp}
    end

    $screen.windows_pool.create_window(:stats, InformWindow, 'Stats', stats, {}, 1, 0, 20, 30)


    #map.grid.each do |row|
    #  row.each do |tile|
    #    print tile
    #  end
    #  puts
    #end
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

    player = $actors[:player]

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
    elsif input == 'c'
      $drawer.draw_all(:stats)
      false
    else
      Game.msg_log "DEBUG: unknown command #{input}"
      false
    end

    return player_moved
  end

  def exit_game
    Game.msg_log "Press any key to flee from Morgoth"
    $drawer.draw_all
    k = get_input
    while k == nil do
      k = get_input
    end
    exit 0
  end

  def process_non_player_actors
    $actors.values.select {|a| not a.player? }.each do |actor|
      move_dir = actor.decide_move
      actor.move move_dir
    end
  end

  def game
    Game.msg_log "The glorious Fingolfin stands apart Morgoth, the great Enemy of Eldar and Mankind..."

    $drawer.draw_all
    until TCOD.console_is_window_closed

      #TODO: Make a normal sequence of game flow
      player_acted = process_input
      if player_acted
        process_non_player_actors
        if player_is_alone?
          Game.msg_log "You beat Morgoth! Eternal glory to you!"
          exit_game
        end
        $drawer.draw_all
      end
    end
  end

  def player_is_alone?
    if $actors.count == 1 && $actors[:player] != nil
      return true
    else
      return false
    end
  end

  def self.msg_log(message)
    while message.length > MAX_MSG_LENGTH
      short = message[0...MAX_MSG_LENGTH]
      $msg_log.push short + ' _'
      message = message[MAX_MSG_LENGTH..-1]
    end
    $msg_log.push message if message.length > 0
  end

end

game = Game.new
game.game