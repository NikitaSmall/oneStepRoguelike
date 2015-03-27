require 'libtcod'

class Drawing
  LIMIT_FPS = 20
  SCREEN_ROWS = 45
  SCREEN_COLS = 80

  DEFAULT_SCREEN_FORE_COLOR = TCOD::Color::LIGHTER_GRAY
  DEFAULT_SCREEN_BACK_COLOR = TCOD::Color::BLACK

  def initialize(msg_log_rows)
    @msg_log_rows = msg_log_rows
    @screen_msg_log_offset_rows = SCREEN_ROWS - @msg_log_rows
    TCOD.console_set_custom_font('dejavu16x16_gs_tc.png',
                                 TCOD::FONT_TYPE_GREYSCALE | TCOD::FONT_LAYOUT_TCOD, 0, 0)
    TCOD.console_init_root(SCREEN_COLS, SCREEN_ROWS, 'Kill the Enemy of the Eldar!', false, TCOD::RENDERER_SDL)
    TCOD.sys_set_fps(LIMIT_FPS)

    @screen_map_offset_rows = 3
    @screen_map_offset_cols = 3
  end

  def draw_all(id=nil)
    draw_background
    draw_markers
    draw_map
    draw_actors

    #draw_frames if $screen.windows_pool.count > 0
    draw_frame(id) unless id.nil?

    draw_log

    TCOD.console_flush()
  end

  def draw_frames
    $screen.windows_pool.each do |window|
      window.show
    end
  end

  def draw_frame(id)
    $screen.windows_pool.get_window(id).show
  end

  def draw_background
    TCOD.console_set_default_foreground(nil, DEFAULT_SCREEN_FORE_COLOR)
    TCOD.console_set_default_background(nil, DEFAULT_SCREEN_BACK_COLOR)
    (0..SCREEN_ROWS).each do |screen_row|
      (0..SCREEN_COLS).each do |screen_col|
        TCOD.console_put_char(nil, screen_col, screen_row, ' '.ord, TCOD::BKGND_SET)
      end
    end
  end

  def draw_markers
    (0..(SCREEN_COLS - 30)).step(5) do |col_num|
      col_num.to_s.chars.each_with_index do |char, i|
        location = { x: col_num + @screen_map_offset_cols, y: i}
        draw_char_to_location(char, location, fore_color: TCOD::Color::WHITE)
      end
    end

    (0..(SCREEN_ROWS - 15)).step(5) do |row_num|
      row_num.to_s.chars.each_with_index do |char, i|
        location = { x: i, y: row_num + @screen_map_offset_cols}
        draw_char_to_location(char, location, fore_color: TCOD::Color::WHITE)
      end
    end
  end

  def draw_map
    player = $player
    $level.grid.each_with_index do |level_row, row_ind|
      level_row.each_with_index do |tile, col_ind|
        screen_location = map_loc_to_screen_loc(col_ind, row_ind)
        #TODO: line of sight
        fore_color = TCOD::Color::LIGHT_GREY
        #back_color = TCOD::Color::rgb(0x24, 0x24, 0x24)
        back_color = TCOD::Color::BLACK

        draw_char_to_location(tile, screen_location, fore_color: fore_color, back_color: back_color)
      end
    end
  end

  def draw_actors
    player = $actors[:player]
    $actors.values.each do |actor|
      screen_location = map_loc_to_screen_loc(actor.x, actor.y)
      back_color = #if actor.player? # || player.within_line_of_sight(actor.x, actor.y)
        #TCOD::Color.rgb(0x24, 0x24, 0x24)
      #else
        TCOD::Color::BLACK
      #end
      draw_char_to_location(actor.sigil, screen_location, fore_color: actor.fore_color, back_color: back_color)
    end
  end

  def draw_log
    $msg_log.last(@msg_log_rows).each_with_index do |msg, i|
      TCOD.console_print(nil, TCOD::LEFT, @screen_msg_log_offset_rows + i, msg)
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

  def map_loc_to_screen_loc(col, row)
    {
        x: col + @screen_map_offset_cols,
        y: row + @screen_map_offset_rows
    }
  end
end