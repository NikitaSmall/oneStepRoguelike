require './util/windows/character'

class BaseWindow
  attr_accessor :id, :x, :y, :h, :w, :tiles, :methods

  def initialize(id, x, y, h, w, methods)
    @id = id

    @h = h
    @w = w
    @x = x
    @y = y

    @methods = methods
    @offset = (h / 10).to_i
    @offset = 1 if @offset < 1

    rows, cols = @w, @h

    @tiles = Array.new(rows)
    rows.times do |y_ind|
      @tiles[y_ind] = Array.new(cols)
      cols.times do |x_ind|
        @tiles[y_ind][x_ind] = Character.new
      end
    end

  end

  def putch(char, x, y, options={})
    default_options = {
        fore_color: TCOD::Color::LIGHTER_GRAY,
        back_color: TCOD::Color::BLACK
    }

    options = default_options.merge(options)

    @tiles[y][x] = Character.new(char, options[:fore_color], options[:back_color])
  end

  def puts(string, x_start, y_start, options={})
    i = 0
    string.each_char do |char|
      putch(char, x_start + i, y_start, options)
      i += 1
    end
  end

  def string_to_lines(string)
    lines = Array.new
    while string.length + 2 * @offset >= @w
      lines << string.slice!(0..(@w - 2 * @offset))
    end
    lines << string
    lines
  end

end