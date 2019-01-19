require_relative 'cookbook'

class Recipe
  attr_accessor :name, :description, :time, :done, :id, :is_read

  def initialize(name, description, time = "N/A", done = false, is_read="no")
    @name = name
    @description = description
    @time = time
    @done = done
    @id = object_id
    @is_read = is_read
  end

  def done!
    @done = true
  end
end
