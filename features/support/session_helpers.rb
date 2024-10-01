module SessionHelpers
  def get_current_user_id
    page.driver.browser.instance_variable_get(:@rack_app).session[:user_id]
  end
end

World(SessionHelpers)