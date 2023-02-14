require 'rails_helper'

RSpec.describe 'The User Dashboard (Show Page)', type: :feature do

  let!(:user1) { User.create!(name: "Anthony", email: "anthony@gmail.com", password: "password") }
  let!(:user2) { User.create!(name: "Thomas", email: "thomas@gmail.com", password: "password") }
  let!(:user3) { User.create!(name: "Jessica", email: "jessica@gmail.com", password: "password") }
  let!(:party1) { Party.create!(duration: 160, start_time: Time.now, movie_id: 1 ) }
  let!(:user_party1) { UserParty.create!(user: user1, party: party1, is_host: true) } 
  let!(:user_party2) { UserParty.create!(user: user2, party: party1, is_host: false) } 

  before :each do
    stub_request(:get, "https://api.themoviedb.org/3/movie/1/credits?api_key").
    to_return(status: 200, body: File.read("spec/fixtures/robot_chicken_credits_response.json"), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/1?api_key").
    to_return(status: 200, body: File.read("spec/fixtures/robot_chicken_response.json"), headers: {})
 
    stub_request(:get, "https://api.themoviedb.org/3/movie/1/reviews?api_key").
    to_return(status: 200, body: File.read("spec/fixtures/citizen_kane_reviews_response.json"), headers: {})

    visit login_path
    fill_in :email, with: user1.email
    fill_in :password, with: user1.password
    click_button "Login"
  end


  describe 'the basics' do
    it 'has the users name in the title' do

      expect(page).to have_content("#{user1.name}'s Dashboard")      
      expect(page).to_not have_content("#{user2.name}'s Dashboard")      
    end
    
    it 'has a button to discover movies' do

      expect(page).to have_button("Discover Movies")
    end
    
    it 'will take you to discover movies page on button click' do

      click_button("Discover Movies")

      expect(current_path).to eq(discover_path)

      expect(page).to have_content("#{user1.name}'s Discover Movies Page")
    end
  end

  describe 'the viewing parties section' do
    it 'lists the parties the user is invited to' do

      within "#viewing-parties" do
        expect(page).to have_content(party1.start_time.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(party1.start_time.strftime('%I:%M %P'))
        expect(page).to have_content(party1.duration)
        expect(page).to have_content(user1.name)
        expect(page).to have_content(user2.name)
      end
    end
  end
end