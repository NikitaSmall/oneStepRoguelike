require 'libtcod'

class Drawing
  LIMIT_FPS = 20
  SCREEN_ROWS = 50
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

  def draw_all
    draw_background
    draw_markers
    draw_map

    draw_log

    TCOD.console_flush()
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

  end

  def draw_map

  end

  def draw_log

  end
end