require 'rails_helper'

RSpec.describe "Landing Page", type: :view do
  before do
    render template: "landing_page/index"
  end

  it "displays the correct title" do
    expect(rendered).to have_title("Welcome to NEO")
  end

  it "displays a welcome heading" do
    expect(rendered).to have_selector("h1", text: "Welcome to NEO")
  end

  it "has a gradient background" do
    expect(rendered).to have_css("body", style: { background: /linear-gradient/ })
  end
end
