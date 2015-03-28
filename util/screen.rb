#TODO: refactor and make update without create/delete methods
require './util/windows_pool'

class Screen
  attr_accessor :windows_pool, :height, :width

  def initialize
    @windows_pool = WindowsPool.new
  end

  def update

  end

end