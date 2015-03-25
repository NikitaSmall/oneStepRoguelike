require 'libtcod'
require 'cave_gen'

require './dungeon'

class Game
  MAP_ROWS = 32
  MAP_COLS = 48

  def initialize
    map = Dungeon.new
    puts map.grid
  end
end

game = Game.new