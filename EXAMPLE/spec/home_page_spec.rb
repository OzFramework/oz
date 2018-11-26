require 'rspec'

describe HomePage, web: true do
  it_behaves_like "a web page"

  it "should be able to navigate to the casual dresses page" do
    start_at "Home"
    hover_over "Dresses Button"
    click_on "Casual Dresses Button"
    on_page? "Casual Dresses"
  end

  it "should be able to navigate to the sign in page" do
    start_at "Home"
    click_on "Sign In Button"
    on_page? "Sign In"
  end
end