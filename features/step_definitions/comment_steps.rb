When /^I hit enter to save the comment$/ do
  submit_form "new_comment"
end

Given /^I have created a comment "([^\"]*)" on a (.*)$/ do |body, commentable_type|
  @comment = send("create_#{commentable_type}_comment", body, @contract.id, @current_user.login)
  @contract.comments.count.should == 1
end

When /^I click "([^\"]*)" in the comment area$/ do |action|
  click_link "#{action}_comment_#{@comment.id}"
end

When /^I change my comment to "([^\"]*)"$/ do |description|
  fill_in 'body', :with => description
end


