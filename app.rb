require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/user_repository'
require_relative 'lib/database_connection'
DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/sign_up' do
    user = User.new 
    repo = UserRepository.new

    user.email = params[:email]
    user.password = params[:password]

    repo.create(user)
    
    return erb(:sign_up_success)
  end

end