module LoginSupport
    def sign_in_as(user)
        visit root_path
        click_link "Sign in"
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log in"
    end
end

# This will automatically include this module in all(?) rspec tests
# RSpec.configure do |config|
#     config.include LoginSupport
# end