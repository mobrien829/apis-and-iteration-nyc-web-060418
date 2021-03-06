require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  #make the web request
  x = 1
  collected_films = []
  films_hash = {}
  while collected_films.size < 1
  all_characters = RestClient.get("https://swapi.co/api/people/?page=" + "#{x}")
  character_hash = JSON.parse(all_characters)
  x +=1
  find_character_urls(character_hash, character, hash, collected_films)
  make_film_hash(collected_films, films_hash)
  end
  films_hash
end

def make_film_hash(collected_films, films_hash)
  collected_films.each do |url|
    film_api = RestClient.get(url)
    film_info_hash = JSON.parse(film_api)
    films_hash[url] = film_info_hash
  end
end

def find_character_urls(character_hash, character, hash, collected_films)
  character_hash["results"].each do |hash|
  hash.find do |name, value|
    if name == "name" && value.downcase == "#{character}"
      collect_urls(hash, collected_films)
      break
    end
  end
end
end

def collect_urls(hash, collected_films)
  hash["films"].each do |url|
    collected_films << url
  end
end


def parse_character_movies(films_hash)
  titles_array = []
  films_hash.each do |url, movie_data|
    movie_data.find do |key, title|
      if key == "title"
        titles_array << title
      end
    end
  end
  titles_array.each_with_index do |name, index|
    puts "#{index+1} #{name}"
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end
# BONUS
#
# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
