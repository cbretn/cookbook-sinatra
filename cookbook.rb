require_relative "recipe"
require 'csv'

# The Cookbook class
class Cookbook
  attr_accessor :recipes

  def initialize(csv_file_path)
    @path = csv_file_path
    @recipes = []
    refresh_csv
  end

  def all
    @recipes
  end

  def refresh
    refresh_csv
    # binding.pry
    @recipes
  end

  def refresh_csv
    @recipes = []

    CSV.foreach(@path) do |row|
      if row[4] == "yes"
        recipe = Recipe.new(row[0], row[1], row[2], row[3], row[4])
      else
        recipe = Recipe.new(row[0], row[1], row[2], row[3])
      end
      @recipes << recipe unless @recipes.include?(recipe)
    end
  end

  def add_recipe(recipe)
    @recipes << recipe
    update_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    update_csv
    puts "Delete Complete!"
  end

  def find_from_id(id)
    id_recipe = nil
    @recipes.each do |recipe|
      if recipe.id == id.to_i
        id_recipe = recipe
      end
    end
    # binding.pry
    return id_recipe
  end

  def find_index(recipe)
    @recipes.index(recipe)
  end

  private

  def update_csv
    CSV.open(@path, "wb") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name.to_s, recipe.description.to_s, recipe.time.to_s, recipe.done.to_s, recipe.is_read]
      end
    end
  end
end
