require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/create_space' do
    return erb(:create_space)
  end
end