module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures.
  def login_as(user)
    #@request.session[:user_id] = user ? users(user).id : nil
    
    if user.is_a?(User)
      id = user.id
    elsif user.is_a?(Symbol)
      user = users(user)
      id = user.id
    elsif user.nil?
      id = nil
    end
    # Stub out the controller if it's defined.
    # This means, e.g., that if a spec defines mocked-out photos for a user,
    # it current_user.photos will have the right assocation.
    if defined?(controller)
      controller.stub!(:current_user).and_return(user)
    else
      @request.session[:user_id] = id
    end
    user
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
end
