require './util/inform_window'

class WindowsPool
  attr_accessor :windows

  def initialize
    @windows = Array.new
  end

  def create_window (id, window_class, name, content, methods={}, x=0, y=0, h=30, w=60)
    @windows << window_class.new(id, x, y, h, w, name, content, methods)
  end

  def remove_window(id)
    @windows.each_with_index do |window, index|
      window.delete_at(index) if window.id == id
    end
  end

  def get_window(id)
    @windows.each do |window|
      return window if window.id == id
    end
  end

  def each(&block)
    @windows.values.each(&block)
  end

end
