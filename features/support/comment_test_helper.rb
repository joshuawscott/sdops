def create_contract_comment(body, commentable_id, user)
  Factory(:comment, :commentable_type => "SupportDeal", :body => body, :commentable_id => commentable_id, :user => user)
end
