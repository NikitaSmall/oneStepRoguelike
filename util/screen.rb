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

  def create_window (id, window_class, name, content, methods={}, x=0, y=0, h=30, w=80)
    @windows[id] = window_class.new(name, content, methods, x, y, h, w)
  end

  def remove_window(id)
    @windows.except!(id)
  end

  def get_window(id)
    @windows[id]
  end
end

class BaseWindow
  attr_accessor :x, :y, :h, :w, :content, :name, :methods

  def initialize(name, content, methods, x, y, h, w)
    @name = name
    @content = content

    @h = h
    @w = w
    @x = x
    @y = y

    @methods = methods
  end
end