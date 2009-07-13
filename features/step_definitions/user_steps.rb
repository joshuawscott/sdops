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

When /^I am logged in as a "([^\"]*)" with only the "([^\"]*)" team$/ do |user_role,user_team|
  @sugar_user = SugarUser.find(user_team+"_user_id")
  @sugar_team = SugarTeam.find_by_name(user_team)
  @current_user = Factory(:user)
  @current_user.roles << Role.find_by_name(user_role)
  User.count.should == 1
  SugarTeamMembership.count(:conditions => ['user_id = ?', @sugar_user.id]).should == 1
  visit login_path
  fill_in "Login", :with => @current_user.login
  fill_in "Password", :with => @current_user.password
  click_button "Log in"
  response.should contain(@current_user.full_name)
end

#Dallas: 25abc605-6caf-b0db-b3fb-44ce9772703f
#Philadelphia: 85d5b628-c1c4-ce0b-a281-44ce972c25f5

Given /^I am logged in without a role$/ do
  @current_user = Factory(:user)
  User.count.should == 1
  visit login_path
  fill_in "Login", :with => @current_user.login
  fill_in "Password", :with => @current_user.password
  click_button "Log in"
  response.should contain(@current_user.full_name)
end

