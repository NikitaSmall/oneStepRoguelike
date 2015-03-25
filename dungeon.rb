require 'libtcod'
require 'cave_gen'

class Dungeon
  attr_accessor :grid

  MAP_ROWS = 32
  MAP_COLS = 48

  FLOR_CHAR = '.'
  WALL_CHAR = '#'

  def initialize
    cave = CaveGen::Cave.new(MAP_ROWS, MAP_COLS)
    map = cave.get_string

    @grid = Array.new
    map.each_line do |s|
      s[MAP_COLS] = ''
      @grid << s
    end
  end

  def out_of_bounds?(col, row)
    return !in_bounds?(col, row)
  end

  def in_bounds?(col, row)
    return true if (col > 0 && col < MAP_COLS - 1) && (row > 0 && row < MAP_ROWS - 1)
  end

  def transparent?(col, row)
    return false if out_of_bounds?(col, row)
    @grid[row][col] != WALL_CHAR
  end

  def walkable?(col, row)
    return false if out_of_bounds?(col, row)
    @grid[row][col] == FLOR_CHAR
  end

  def get_rand_point
    @rand_point = [rand(1..@height-2), rand(1..@width-2)]
  end

  def get_free_rand_point
    point = get_rand_point
    while !walkable?(point[0], point[1])
      point = get_rand_point
    end
    return point
  end

  def make_free_cell(col, row)
    @grid[row][col] = FLOR_CHAR
  end

  def get_spawn_point
    point = get_free_rand_point
    make_free_cell(point[0], point[1])

    return point
  end

end