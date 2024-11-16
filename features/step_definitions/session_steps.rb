# frozen_string_literal: true

Given('I am not logged in') do
  page.driver.browser.clear_cookies
end
