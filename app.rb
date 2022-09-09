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
    session[:email] = params[:email]
    redirect('/spaces')
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

  get '/spaces/:id' do
    repo = SpaceRepository.new
    @space = repo.find(params[:id])
    return erb(:space)
  end

  post '/spaces/:id' do
    redirect('/sign_in') unless session[:id]

    repo = SpaceRepository.new
    space = repo.find(params[:id])
    
    request = Request.new
    request.space_id = space.id
    request.owner_user_id = space.user_id
    request.requester_user_id = session[:id].to_i
    request.date = params[:date]
    request.confirmed = false
    
    RequestRepository.new.create(request)

    redirect('/requests')
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

  get '/requests' do 
    @is_signed_in = session[:id]
    repo = RequestRepository.new
    spacerepo = SpaceRepository.new
    @request_received = repo.filter_by_owner_user_id(session[:id])
    @request_sent = repo.filter_by_requester_user_id(session[:id])

    return erb(:all_requests)
  end

  get '/requested/:id' do
    repo = RequestRepository.new
    spacerepo = SpaceRepository.new
    userrepo = UserRepository.new

    @is_signed_in = session[:id]
    @request_obj = repo.find(params[:id])
    @requester_user = userrepo.find(@request_obj.requester_user_id)
    @space = spacerepo.find(@request_obj.space_id)

      #if @request_obj.owner_user_id != @is_signed_in
      #binding.irb
      #redirect('/requests')
    #end

    return erb(:requested)
  end

  post '/requested/:id' do
    repo = RequestRepository.new
    request_id = params[:id].to_i
    if (params['confirmation'] == 'true')
      repo.confirm(request_id)
    else
      repo.delete(request_id)
   end
    redirect('/requests')
  end

  #get '/404' do
  #end
end