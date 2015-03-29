require './util/windows/base_window'

class InformWindow < BaseWindow
  attr_accessor :content, :name

  def initialize(id, x, y, h, w, name, content, methods={})
    super(id, x, y, h, w, methods)

    @name = name
    @content = content

    put_frame
    put_name

    put_content
  end

  def put_frame
    (@y..(@y + @h)).each do |y|
      (@x..(@x + @w)).each do |x|
        putch(" ", x, y)
      end
    end

    (@x..(@x + @w)).each do |x|
      putch("#", x, @y)
      putch("#", x, @y+@h)
    end

    (@y..(@y + @h)).each do |y|
      putch("#", @x, y)
      putch("#", @x+@w, y)
    end
  end

  def put_name
    puts(@name, @offset + @x, @y)
  end

  def put_content
    y = 0
    if @content.lambda?
      content = @content.call
    else
      content = @content
    end
    content.each do |name, value|
      if "#{name}: #{value}".length + 2 * @offset >= @w
        lines = string_to_lines("#{name}: #{value}")
        lines.each do |line|
          puts(line, @offset + @x, @offset + y + @y)
          y += 1
        end
      else
        puts("#{name}: #{value}", @offset + @x, @offset + y + @y)
        y += 1
      end
    end
  end
end