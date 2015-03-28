class Point
  attr_accessor :char, :foreground, :background

  def initialize
    @char = ' '
  end

  def set_char(char, foreground, background)
    @char = char
    @foreground = foreground
    @background = background
  end
end