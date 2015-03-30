class Character
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