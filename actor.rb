class Actor
  attr_accessor :sigil, :fore_color, :back_color, :x, :y, :hp, :sight_range, :name, :allegiance, :player, :damage
  GENERIC_ACTOR_OPTIONS = {
      sigil: '*',
      fore_color: TCOD::Color::WHITE,
      back_color: TCOD::Color::BLACK,
      x: -1,
      y: -1,
      hp: 1,
      damage: 1,
      sight_range: 7,
      name: 'A random Fea flying around',
      allegiance: :player,
      player: false
  }

  def initialize(current_level, options)
    options = GENERIC_ACTOR_OPTIONS.merge options

      @sigil = options[:sigil]
      @fore_color = options[:fore_color]
      @back_color = options[:back_color]
      @x = options[:x]
      @y = options[:y]
      @hp = options[:hp]
      @damage = options[:damage]
      @sight_range = options[:sight_range]
      @name = options[:name]
      @allegiance = options[:allegiance]
      @player = options[:player]

    @dungeon = current_level

     place_in_map! if outside_map?
  end

  def self.init_actors(dungeon_level)
    actors = Hash.new

    #actors[:player] = create_player(dungeon_level, "Fingolfin, the Elvenking")

    15.times do |n|
      bsym = :"Orc ##{n}"
      actors[bsym] = create_orc(dungeon_level, "Orc ##{n}")
    end

    return actors
  end

  def self.create_player(dungeon_level, name)
    Actor.new(dungeon_level, {
                  sigil: '@',
                  fore_color: TCOD::Color::WHITE,
                  back_color: TCOD::Color::DARKER_GREY,
                  hp: 7,
                  damage: 1,
                  name: name,
                  allegiance: :player,
                  player: true
    })
  end

  def self.create_orc(dungeon_level, name)
    Actor.new(dungeon_level, {
                               sigil: 'o',
                               fore_color: TCOD::Color::SEPIA,
                               back_color: TCOD::Color::BLACK,
                               hp: 1,
                               damage: 1,
                               name: name,
                               allegiance: :baddies
    })
  end

  def outside_map?
    @x == -1 || @y == -1
  end

  def place_in_map!
    @x, @y = @dungeon.get_spawn_point
  end

  def tcod_map
    @tcod_map ||= make_tcod_map_from_level
  end

  def make_tcod_map_from_level
    level = @dungeon.grid
    tmap = TCOD::Map.new(level.first.count, level.count)
    level.each_with_index do |level_row, row_index|
      level_row.each_with_index do |tile, col_index|
        tmap.set_properties(col_index, row_index,
                            @dungeon.transparent?(col_index, row_index),
                            @dungeon.walkable?(col_index, row_index))
      end
    end
    return tmap
  end

  def player?
    @player
  end

  def alive?
    @hp > 0
  end

  def hurt(damage)
    @hp -= damage
  end

  def kill!

  end

  def self.actor_at_pos(col, row)

  end
end