require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/user_repository'
require_relative 'lib/space_repository'
require_relative 'lib/request_repository'
require_relative 'lib/database_connection'

DatabaseConnection.connect('makersbnb_test')

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
    enable :sessions
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

  get '/sign_in' do
    return erb(:sign_in)
  end

  post '/sign_in' do
    email = params[:email]
    password = params[:password]
    repo = UserRepository.new
    user = repo.find_by_email(email)
    redirect('/sign_in') unless repo.sign_in(email, password)
    session[:id] = user.id
    redirect('/requests')
  end

  get "/sign_out" do
    session.clear
    redirect("/")
  end 

  get '/spaces' do
    @is_signed_in = session[:id]

    repo = SpaceRepository.new
    @spaces = repo.all
    return erb(:spaces)
  end

  get '/create_space' do
    repo = UserRepository.new
    
    if repo.check_for_user(session[:id])
      return erb(:create_space)
    else
      redirect('/sign_in')
    end
  end

  post '/create_space' do
    repo = UserRepository.new
  
    if repo.check_for_user(session[:id])
      space = Spaces.new
      space.name = params['name']
      space.description = params['description']
      space.price = params['price']
      space.available_from = params['available_from']
      space.available_to = params['available_to']
      space.user_id = session[:id]

      SpaceRepository.new.create(space)

      redirect('/spaces')
    else
      redirect('/sign_in')
    end
  end
end