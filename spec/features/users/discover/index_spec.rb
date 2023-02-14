require 'rails_helper'

RSpec.describe 'Discover Index Page', type: :feature do
  let!(:user1) { User.create!(name: "Anthony", email: "anthony@gmail.com", password: "password") }

  before :each do
    visit login_path
    fill_in :email, with: user1.email
    fill_in :password, with: user1.password
    click_button "Login"
  end

  describe "the default basics" do
    it 'has a title' do
      visit discover_path

      expect(page).to have_content("#{user1.name}'s Discover Movies Page")
    end
  end

  describe 'Top Rated Movies Search Button' do
    it 'has a button that will display the top rated movies' do
      visit discover_path

      expect(page).to have_button("Top Rated Movies")

    end

    it 'brings you to the movie results page and displays the top rated movies' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key&language=en-US&limit=20").
      to_return(status: 200, body: File.read('spec/fixtures/top_rated_movies_response.json'), headers: {})

      visit discover_path

      click_button "Top Rated Movies"
      expect(current_path).to eq(movies_path)
    end
  end

  describe 'Movie Search by Title Field and Button' do
    it 'has a field to type movies into and a button to search for those movies' do
      visit discover_path

      expect(page).to have_field(:query)
      expect(page).to have_button("Search")
    end
  end
end