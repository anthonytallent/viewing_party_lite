require 'rails_helper'

RSpec.describe 'The Movie Results Index', type: :feature do
  let!(:user1) { User.create!(name: "Anthony", email: "anthony@gmail.com", password: "password") }
  let!(:user2) { User.create!(name: "Thomas", email: "thomas@gmail.com", password: "password") }
  let!(:user3) { User.create!(name: "Jessica", email: "jessica@gmail.com", password: "password") }
  
  describe 'the discover page button' do
    it 'takes a user back to their discover page' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key&language=en-US&limit=20").
      to_return(status: 200, body: File.read('spec/fixtures/top_rated_movies_response.json'), headers: {})

      visit user_movies_path(user1)
      
      expect(page).to have_button("Discover Page")

      within("#discover-page-button") do
        click_button("Discover Page")
      end

      expect(current_path).to eq(user_discover_index_path(user1))
    end
  end

  describe 'the display movie results area' do
    it 'will display the top 20 rated movies when button pressed' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key&language=en-US&limit=20").
      to_return(status: 200, body: File.read('spec/fixtures/top_rated_movies_response.json'), headers: {})

      visit user_discover_index_path(user1)

      click_button("Top Rated Movies")

      expect(current_path).to eq(user_movies_path(user1))

    end

    it 'will display the search results after a search has occurred' do
      stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key&query=star%20wars").
      to_return(status: 200, body: File.read('spec/fixtures/search_for_starwars.json'), headers: {})

      visit user_discover_index_path(user1)

      fill_in :query, with: "star wars"
      click_button("Search")

      expect(current_path).to eq(user_movies_path(user1))

      within("#display-movies") do
        expect(page).to have_content("Star Wars: The Rise of Skywalker")
        expect(page).to have_content("Star Wars: The Last Jedi")
        expect(page).to have_content("Star Wars: The Force Awakens")
      end
    end
  end
end