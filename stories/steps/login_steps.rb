steps_for(:login) do
  
  #############################################################
  #  Given Statements
  #############################################################
  Given "'$user' is logged in" do
    post "/sessions", :login => 'admin', :password => 'test'
  end
  
  Given "a username '$username'" do |username|
    @username = username
  end

  Given "a password '$password'" do |password|
    @password = password
  end

  Given "a firstname '$firstname'" do |firstname|
    @firstname = firstname
  end

  Given "a lastname '$lastname'" do |lastname|
    @lastname = lastname
  end

  Given "an email '$email'" do |email|
    @email = email
  end

  Given "an office id '$office_id'" do |office_id|
    @office_id = office_id
  end

  Given "a role '$role'" do |role|
    @role = role
  end

  Given "there is no user with this username" do
    User.find_by_login(@username).should be_nil
  end

  #############################################################
  #  When Statements
  #############################################################

  When "the user logs in with username and password" do
    post "/sessions/create", :user => { :login => @username, :password => @password }
  end
  
  When "the above user logs in with username and password" do
    post "/sessions", :login => @username, :password => @password
  end
  
  When "the user creates an account with username, password and email" do
    
    post "/users/create", :user => {:login => @username,
                          :first_name => @firstname,
                          :last_name => @lastname,
                          :email => @email,
                          :password => @password,
                          :password_confirmation => @password,
                          :office_id => @office_id,
                          :role => @role}
  end

  #############################################################
  #  Then Statements
  #############################################################
  Then "the login form should be shown again" do
    response.should render_template("sessions/new")
  end

  Then "the home page should be shown" do
    response.should redirect_to(home_path)
  end

  Then "there should be a user named '$username'" do |username|
    User.find_by_login(username).should_not be_nil
  end

  Then "should redirect to '$path'" do |path|
    response.should redirect_to(path)
  end
  
end
