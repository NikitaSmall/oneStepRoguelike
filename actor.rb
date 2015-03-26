require 'libtcod'

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

    actors[:player] = create_player(dungeon_level, "Fingolfin, the Elvenking")

    15.times do |n|
      bsym = :"Orc ##{n}"
      actors[bsym] = create_orc(dungeon_level, "Orc ##{n}")
    end

    actors[:morgoth] = create_morgoth(dungeon_level, "Morgoth, the Great Enemy")

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

  def self.create_morgoth(dungeon_level, name)
    Actor.new(dungeon_level, {
                               sigil: 'M',
                               fore_color: TCOD::Color::SEPIA,
                               back_color: TCOD::Color::BLACK,
                               hp: 10,
                               damage: 2,
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
    $actors.delete(($actors.key(self)))
  end

  def self.actor_at_pos(col, row)
    $actors.values.each do |actor|
      if actor.x == col && actor.y == row
        return actor
      end
    end
    return nil
  end

  def move(direction)
    return true if direction == :rest

    return false if outside_map?
    return false unless can_move? direction

    dx, dy = direction_to_delta(direction)

    other_actor = Actor.actor_at_pos(@x + dx, @y + dy)
    if other_actor
      if enemy? other_actor
        attack! other_actor

        return true
      end
    else
      @x += dx
      @y += dy
    end

    true
  end

  def enemy?(target)
    @allegiance != target.allegiance
  end

  def attack!(target)
    target.hurt(@damage)
    if target.alive?
      Game.msg_log "#{@name} hurted #{target.name} for #{@damage} hp"
    else
      Game.msg_log "#{@name} killed #{target.name}"
      target.kill!
    end
  end

  def direction_to_delta(direction)
    return [0, 1] if direction == :south
    return [0, -1] if direction == :north
    return [-1, 0] if direction == :west
    return [1, 0] if direction == :east
    return [0, 0]
  end

  def delta_to_direction(dx, dy)
    return :south if dx == 0 && dy == 1
    return :north if dx == 0 && dy == -1
    return :west if dx == 1 && dy == 0
    return :east if dx == -1 && dy == 0
    return :rest
  end

  def can_move? (direction)
    dx, dy = direction_to_delta(direction)
    @dungeon.walkable?(@x + dx, @y + dy)
  end

  def decide_move
    directions = [:south, :north, :west, :east, :rest]
    options = Array.new

    directions.each do |dir|
      options << dir if can_move? dir
    end
    return options.sample
  end

end