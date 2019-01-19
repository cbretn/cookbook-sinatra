require 'nokogiri'
require 'open-uri'
require 'pry-byebug'

class Scraper
  def initialize(word)
    @url = "https://www.marmiton.org/recettes/recherche.aspx?type=all&aqt=#{word}"
    @html_file = open(@url).read
    @html_doc = Nokogiri::HTML(@html_file)
  end

  def return_top_5_recipes
    # define an array of hashes for each recipe
    five_recipes = [{}, {}, {}, {}, {}]
    # get titles
    @html_doc.search('.recipe-card .recipe-card__title')[0..4].each_with_index do |title, index|
      five_recipes[index][:title] = title.text
    end
    # get descriptions
    @html_doc.search('.recipe-card .recipe-card__description')[0..4].each_with_index do |desc, index|
      five_recipes[index][:description] = desc.text.delete("\r").delete("\n").delete("\t")
    end
    # get preptime
    @html_doc.search('.recipe-card .recipe-card__duration .recipe-card__duration__value')[0..4].each_with_index do |time, index|
      five_recipes[index][:time] = time.text
    end
    # return array of hashes
    return five_recipes
  end
end

# p Scraper.new("banane").return_top_5_recipes
# p Scraper.new("chocolat").return_top_5_recipes

