require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "scraper"

# cookbook = Cookbook.new('recipes.csv')
COOKBOOK_FILE = File.join(__dir__, 'recipes.csv')
COOKBOOK = Cookbook.new(COOKBOOK_FILE)

configure :development do
  set :bind, '0.0.0.0'
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/about' do
  erb :about
end

get '/' do
  @recipes = COOKBOOK.refresh
  erb :index
end

get '/recipes/:id' do
  @recipe = COOKBOOK.find_from_id(params[:id])
  # binding.pry
  puts params[:id]
  "The username is #{params[:id]}"
  @recipe.is_read = "yes"
  erb :recipe
end

get '/new' do
  erb :new
end

post '/recipes' do
  # @recipes = COOKBOOK.all
  recipe = Recipe.new(params[:recipe_name], params[:recipe_description], params[:preparation_time], false)
  # binding.pry
  COOKBOOK.add_recipe(recipe)
  redirect '/'
end

get '/destroy' do
  erb :destroy
end

post '/recipe_to_destroy' do
  cookbook_file = File.join(__dir__, 'recipes.csv')
  cookbook = Cookbook.new(cookbook_file)
  recipe_to_destroy = nil
  cookbook.all.each { |recipe| recipe.name == params[:recipe_name] ? recipe_to_destroy = recipe : next }
  if recipe_to_destroy.nil?
    redirect'/inexistent_recipe'
  else
    cookbook.remove_recipe(cookbook.recipes.index(recipe_to_destroy))
    redirect'/'
  end
end

get '/inexistent_recipe' do
  erb :inexistent_recipe
end

get '/marmiton_import' do
  erb :marmiton_import
end

post '/scrape' do
  ingredient = params[:ingredient_name]
  app = Scraper.new(ingredient)
  app.return_top_5_recipes.each do |recipe_hash|
    COOKBOOK.add_recipe(Recipe.new(recipe_hash[:title], recipe_hash[:description], recipe_hash[:time]))
  end
  COOKBOOK.refresh
  redirect'/'
end
# Creating a new recipe takes two steps in the context of our web app. We need one step to display a form. We'll use a GET /new HTTP request to display the form.

# The <form> will be the equivalent of the gets in the terminal. We need fields for the recipe's name, description, and any other field you find relevant to add. Submitting this form should trigger the following HTTP request:

# POST /recipes
# This request should trigger some code in app.rb to add the recipe in the cookbook. At the end of this code, find a way to redirect the user to the / url of your web app (the index).
