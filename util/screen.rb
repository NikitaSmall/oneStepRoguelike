#TODO: refactor and make update without create/delete methods
require './util/windows_pool'

class Screen
  attr_accessor :windows_pool, :height, :width

  def initialize
    @windows_pool = WindowsPool.new
  end

  def update
    @windows_pool.windows.each do |window|
      if defined? window.content
        window.put_content
      end
    end
  end

  def draw_frame(frame_id)
    update
    frame = @windows_pool.get_window(frame_id)
    (frame.y..(frame.y + frame.h)).each do |y|
      (frame.x..(frame.x + frame.w)).each do |x|
        draw_char_to_location(frame.tiles[y][x].char, x, y, {fore_color: frame.tiles[y][x].foreground, back_color: frame.tiles[y][x].background})
      end
    end
  end

  def draw_char_to_location(char, x, y, options={})
    default_options = {
        fore_color: TCOD::Color::LIGHTER_GRAY,
        back_color: TCOD::Color::BLACK
    }

    options = default_options.merge(options)

    TCOD.console_set_default_foreground(nil, options[:fore_color])
    TCOD.console_set_default_background(nil, options[:back_color])
    TCOD.console_put_char(nil, x, y, char.ord, TCOD::BKGND_SET)
    TCOD.console_set_default_foreground(nil, TCOD::Color::LIGHTER_GRAY)
    TCOD.console_set_default_background(nil, TCOD::Color::BLACK)
  end

end