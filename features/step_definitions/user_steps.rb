include AuthenticatedTestHelper

Given /^a user "([^\"]*)" with login "([^\"]*)" and password "([^\"]*)"$/ do |full_name, login, password|
  first_name, last_name = full_name.split(" ")
  @current_user = User.new(:first_name => first_name, :last_name => last_name, :login => login, :password => password)
  @current_user.save(false)
end

When /^I enter login "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  visit login_path
  fill_in "Login", :with => login
  fill_in "Password", :with => password
end

When /^I am logged in as a "([^\"]*)"$/ do |user_role|
  @current_user = Factory(:user)
  @current_user.roles << Role.find_by_name(user_role)
  @current_user.save(false)
  User.count.should == 1
  visit login_path
  fill_in "Login", :with => @current_user.login
  fill_in "Password", :with => @current_user.password
  click_button "Log in"
  response.should contain(@current_user.full_name)
end
