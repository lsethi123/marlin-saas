require 'spec_helper'

RSpec.describe "user session", type: :feature, ctrl_clean: true, js: true do   

  before { login }

  it "signs me in from login page" do
    expect(page).to have_content 'Create new Property'
  end

  it "logs me out" do
    click_link 'Logout'
    expect(page).to have_link 'Login' 
  end

end