class MovieService
  def self.conn
    Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.params['api_key'] = ENV['movie_api_key']
    end
  end

  def self.top_rated_movies_response
    response = conn.get('3/movie/top_rated?language=en-US&limit=20')
    parse(response)
  end

  def self.search_results_response(search_params)
    response = conn.get("/3/search/movie?query=#{search_params}")
    parse(response)
  end

  def self.find_movie_response(movie_id)
    response = conn.get("3/movie/#{movie_id}")
    parse(response)
  end

  def self.find_cast_response(movie_id)
    response = conn.get("3/movie/#{movie_id}/credits")
    parse(response)
  end

  def self.find_reviews_response(movie_id)
    response = conn.get("3/movie/#{movie_id}/reviews")
    parse(response)
  end

  def self.parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  private_class_method :conn, :parse
end