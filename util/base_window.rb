#require './util/tile'
class Point
  attr_accessor :char, :foreground, :background

  def initialize(char=' ', foreground=TCOD::Color::LIGHTER_GRAY, background=TCOD::Color::BLACK)
    @char = char
    @foreground = foreground
    @background = background
  end

  def set_char(char, foreground, background)
    @char = char
    @foreground = foreground
    @background = background
  end
end

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

    rows, cols = (@w - @x), (@h - @y)

    @tiles = Array.new(rows)
    rows.times do |y_ind|
      @tiles[y_ind] = Array.new(cols)
      cols.times do |x_ind|
        @tiles[y_ind][x_ind] = Point.new
      end
    end

  end

  def putch(char, x, y, options={})
    default_options = {
        fore_color: TCOD::Color::LIGHTER_GRAY,
        back_color: TCOD::Color::BLACK
    }

    options = default_options.merge(options)

    @tiles[y][x] = Point.new(char, options[:fore_color], options[:back_color])
  end

  def puts(string, x_start, y_start, options={})
    i = 0
    string.each_char do |char|
      putch(char, x_start + i, y_start, options)
      i += 1
    end
  end

end