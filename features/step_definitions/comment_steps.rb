Given /^I have created a comment "([^\"]*)" on a (.*)$/ do |body, commentable_type|
  @comment = send("create_#{commentable_type}_comment", body, @contract.id, @current_user.login)
  @contract.comments.count.should == 1
end

Given /^someone else has created a comment "([^\"]*)" on this (.*)$/ do |body, commentable_type|
  @comment = send("create_#{commentable_type}_comment", body, @contract.id, "notbob")
end

When /^I hit enter to save the comment$/ do
  submit_form "new_comment"
end

When /^I click "([^\"]*)" in the comment area$/ do |action|
  click_link "#{action}_comment_#{@comment.id}"
end

When /^I change my comment to "([^\"]*)"$/ do |description|
  fill_in 'body', :with => description
end

Then /^I should not see "([^\"]*)" in the comment area$/ do |action|
  response.body.should_not contain("#{action}_comment_#{@comment.id}")
end

