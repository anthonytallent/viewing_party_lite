require 'rails_helper'

RSpec.describe "index page", type: :feature do
  let!(:user1) { User.create!(name: "Anthony", email: "anthony@gmail.com", password: "password") }
  let!(:user2) { User.create!(name: "Thomas", email: "thomas@gmail.com", password: "password") }
  let!(:user3) { User.create!(name: "Jessica", email: "jessica@gmail.com", password: "password") }
  let!(:user4) { User.create!(name: "Alex", email: "alex@gmail.com", password: "password") }
  let!(:user5) { User.create!(name: "Kelsie", email: "kelsie@gmail.com", password: "password") }

  describe 'Page Defaults' do
    it 'The title of the application' do
      visit root_path

      expect(page).to have_content("Viewing Party")
    end

    it 'has a link to landing page' do
      visit root_path

      within("#navigation") do
        expect(page).to have_link("Home", href: root_path)
      end
    end
  end

  describe "Create new user button" do
    
    it 'has a button to create a new user' do
      visit root_path

      expect(page).to have_button("Create New User")
    end

    it 'will load the New User Page' do
      visit root_path

      expect(current_path).to eq(root_path)

      click_button "Create New User"

      expect(current_path).to eq(register_path)
    end
  end

  describe 'the existing users area' do
    before :each do
      visit login_path
      fill_in :email, with: user1.email
      fill_in :password, with: user1.password
      click_button "Login"
    end

    it 'has a list of existing users names' do
      visit root_path

      within("#user-list-home") do
        expect(page).to have_content(user1.email)
        expect(page).to have_content(user2.email)
        expect(page).to have_content(user3.email)
        expect(page).to have_content(user4.email)
        expect(page).to have_content(user5.email)
      end
    end

    it 'has a link to each users show page' do
      visit root_path
      
      within("#user-#{user1.id}") do
        expect(page).to have_content(user1.email)
      end

      within("#user-#{user2.id}") do
        expect(page).to have_content(user2.email)
      end

      within("#user-#{user3.id}") do
        expect(page).to have_content(user3.email)
      end
    end
  end
end