require 'rails_helper'

RSpec.describe "new page", type: :feature do
  let!(:user1) { User.create!(name: "Anthony", email: "anthony@gmail.com", password: "password") }

  describe 'new user form' do
    it 'has a name and email' do
      visit register_path

      expect(page).to have_field(:name)
      expect(page).to have_field(:email)
      expect(page).to have_field(:password)
    end

    it 'can create a new user' do
      visit register_path

      fill_in(:name, with: "Tony Pepperoni")
      fill_in(:email, with: "thebigpepperoni@gmail.com")
      fill_in(:password, with: "password")
      fill_in(:password_confirmation, with: "password")

      click_button "Register"
      
      expect(page).to have_content("Tony Pepperoni's Dashboard")
      expect(page).to_not have_content(user1.name)
    end

    describe "sad path form testing" do
      it 'will not allow any field to be blank' do
        visit register_path

        click_button "Register"
    
        expect(page).to have_content("Name can't be blank, Email can't be blank, and Password can't be blank")
      end

      it 'will only allow unique email addresses (no copies) to sign up' do
        visit register_path

        fill_in(:name, with: "Tony")
        fill_in(:email, with: "anthony@gmail.com")
        fill_in(:password, with: "password")

        click_button "Register"

        expect(page).to have_content("Email has already been taken")
      end

      it "will not allow registration with passwords that don't match" do
        visit register_path

        fill_in(:name, with: "Tony Pepperoni")
        fill_in(:email, with: "thebigpepperoni@gmail.com")
        fill_in(:password, with: "password")
        fill_in(:password_confirmation, with: "paword")
  
        click_button "Register"

        expect(page).to have_field(:name)
        expect(page).to have_field(:email)
        expect(page).to have_field(:password)
        expect(page).to have_field(:password_confirmation)
      end
    end
  end
end