require './util/base_window'

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
