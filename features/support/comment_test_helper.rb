def create_contract_comment(body, commentable_id, user)
  Factory(:comment, :commentable_type => "contract", :body => body, :commentable_id => commentable_id, :user => user)
end
