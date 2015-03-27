#TODO: refactor and make update without create/delete methods

class Screen
  attr_accessor :windows_pool, :height, :width

  def initialize
    @windows_pool = WindowsPool.new
  end

  def update

  end

end

class WindowsPool
  attr_accessor :windows

  def initialize
    @windows = Hash.new
  end

  def create_window (id, window_class, name, content, methods={}, x=0, y=0, h=30, w=60)
    @windows[id] = window_class.new(name, content, methods, x, y, h, w)
  end

  def remove_window(id)
    @windows.delete(id)
  end

  def get_window(id)
    @windows[id]
  end

  def count
    i = 0
    @windows.each do
      i += 1
    end
    i
  end

  def each(&block)
    @windows.values.each(&block)
  end

end

class BaseWindow
  attr_accessor :x, :y, :h, :w, :content, :name, :methods

  DEFAULT_SCREEN_FORE_COLOR = TCOD::Color::LIGHTER_GRAY
  DEFAULT_SCREEN_BACK_COLOR = TCOD::Color::BLACK

  def initialize(name, content, methods, x, y, h, w)
    @name = name
    @content = content

    @h = h
    @w = w
    @x = x
    @y = y

    @methods = methods

    @offset = (h / 10).to_i
  end

  def show
    draw_frame
    draw_name

    draw_content
  end

  def draw_frame
    (@x..(@x + @w)).each do |x|
      (@y..(@y + @h)).each do |y|
        draw_char_to_location(" ", {x: x, y: y})
      end
    end

    (@x..(@x + @w)).each do |x|
      draw_char_to_location("#", {x: x, y: @y})
      draw_char_to_location("#", {x: x, y: @y+@h})
    end

    (@y..(@x + @h)).each do |y|
      draw_char_to_location("#", {x: @x, y: y})
      draw_char_to_location("#", {x: @x+@w, y: y})
    end
  end

  def draw_name
    draw_word(@name, @offset, @y)
  end

  def draw_content
    y = 0
    @content.each do |name, value|
      draw_word("#{name}: #{value}", @offset, @offset + y)
      y += 1
    end
  end

  def draw_word(word, x_start, y_start)
    i = 0
    word.each_char do |letter|
      draw_char_to_location(letter, {x: i + x_start, y: y_start})
      i += 1
    end
  end

  def draw_char_to_location(char, location, options={})
    default_options = {
        fore_color: DEFAULT_SCREEN_FORE_COLOR,
        back_color: DEFAULT_SCREEN_BACK_COLOR
    }

    options = default_options.merge(options)

    TCOD.console_set_default_foreground(nil, options[:fore_color])
    TCOD.console_set_default_background(nil, options[:back_color])
    TCOD.console_put_char(nil, location[:x], location[:y], char.ord, TCOD::BKGND_SET)
    TCOD.console_set_default_foreground(nil, DEFAULT_SCREEN_FORE_COLOR)
    TCOD.console_set_default_background(nil, DEFAULT_SCREEN_BACK_COLOR)
  end

end