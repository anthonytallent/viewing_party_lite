require 'rails_helper'

RSpec.describe "Logging In" do
  let!(:user1) { User.create!(name: "Anthony", email: "anthony@gmail.com", password: "password") }
  it "can log in with valid credentials" do
    visit root_path
    click_link "Login"

    expect(current_path).to eq(login_path)

    fill_in :email, with: user1.email
    fill_in :password, with: user1.password
    
    click_button "Login"

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, #{user1.name}!")
  end

  it "sad path: won't log you in if you put the wrong password in" do
    visit root_path
    click_link "Login"

    fill_in :email, with: user1.email
    fill_in :password, with: "bloop"

    click_button "Login"

    expect(page).to have_field(:email)
    expect(page).to have_field(:password)
    expect(page).to have_content("Invalid email or password")
  end
end