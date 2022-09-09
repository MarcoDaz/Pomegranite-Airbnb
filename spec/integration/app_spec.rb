require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do 
  def reset_database
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_database
  end

  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET to /" do
    it "returns 200 OK with the right content" do
      response = get("/")

      expect(response.status).to eq(200)

      expect(response.body).to include('<h1>Welcome to MakersBnb</h1>')
      expect(response.body).to include('We Operate an online marketplace for lodging, primarily homestays for vacation rentals, and tourist activities, all around the world!')
    end
  end
  
  context "POST /sign_up" do
    it 'Creates a new user and returns the sign up success page' do 
      response = post(
        '/sign_up',
        email: 'exampleemail123@gmail.com',
        password: 'examplepassword123'
      )

      repo = UserRepository.new
      latest_user = repo.all.last

      expect(response.status).to eq(200)
      
      expect(latest_user.email).to eq('exampleemail123@gmail.com')

      expect(response.body).to include('<h1>Your account was successfully created!</h1>')
    end 
  end

  context "GET /sign_in" do
    it " login form" do
      response = get('/sign_in')
      expect(response.status).to eq(200)
      expect(response.body).to include("method='post'")
      expect(response.body).to include("action='/sign_in'")
      expect(response.body).to include("name='email'")
    end
  end

  context "POST /login" do
    it "logs in" do
      response = post('/sign_in', email: '123@gmail.com', password: '123456')
      expect(response.status).to eq(302)
      expect(response.body).to eq('')
    end
  end

  it "doesn't log in with wrong password" do
    response = post('/sign_in', email: '123@gmail.com', password: '121212')
    expect(response.status).to eq(302)
  end


  context 'GET /create_space' do
    it 'redirects to sign_in if not logged in' do
      post('/sign_out')
      response = get('/create_space')

      expect(response.status).to eq 302
    end

    it 'returns an html form for listing a new space' do
      post('/sign_in', email: '123@gmail.com', password: '123456')

      response = get('/create_space')
      body = response.body

      expect(response.status).to eq 200

      expect(body).to include '<h1>List a Space</h1>'
      expect(body).to include '<form action="/create_space" method="POST">'
      expect(body).to include '<input type="text" name="name" id="name" required>'
      expect(body).to include '<input type="text" name="description" id="description" required>'
      expect(body).to include '<input type="number" name="price" id="price" required>'
      expect(body).to include '<input type="date" name="available_from" id="available_from" required>'
      expect(body).to include '<input type="date" name="available_to" id="available_to" required>'
    end
  end

  context 'POST /create_space' do
    it 'redirects to sign_in if not signed in' do
      response = post('create_space')

      # redirect to /sign_in
      expect(response.status).to eq 302
    end

    it 'creates a space if signed in and redirects to /spaces' do
      post('/sign_in', email: '123@gmail.com', password: '123456')

      response = post(
        '/create_space',
        name: 'Dreamland Hotel',
        description: '123 Imaginary St.',
        price: 999,
        available_from: '2023-01-01',
        available_to: '2023-12-01'
      )

      # redirect to /spaces
      expect(response.status).to eq 302

      repo = SpaceRepository.new
      latest_space = repo.all.last

      expect(latest_space.name).to eq 'Dreamland Hotel'
      expect(latest_space.description).to eq '123 Imaginary St.'
      expect(latest_space.price).to eq 999
      expect(latest_space.available_from).to eq '2023-01-01'
      expect(latest_space.available_to).to eq '2023-12-01'
    end
  end

  context "GET /requests" do
    it 'returns a list of requests I have made and received' do
      post('/sign_in',email: '123@gmail.com', password: '123456')
      response = get('/requests')

      expect(response.status).to eq(200)
      expect(response.body).to include("Requests I have made:")
      expect(response.body).to include("Requests I have received:")
    end
  end

  context 'GET /spaces' do
    it 'returns the spaces form' do
      response = get('/spaces')
      expect(response.status).to eq(200)
      expect(response.body).to include '<h1>Book a space</h1>'
    end
  end

  context 'GET /spaces/:id' do
    it 'returns spaces/1' do
      response = get('/spaces/1')
      expect(response.status).to eq(200)

      expect(response.body).to include '<h1>308 Negra Arroyo Lane, Albuquerque</h1>'
      expect(response.body).to include '<h2>Quaint house with pool out back</h2>'
    end
  end

  context 'POST /spaces/:id' do
    it 'redirects if not signed in ' do
      response = post('/spaces/1')
      expect(response.status).to eq 302
    end

    it 'creates a new request for the matching space' do
      post('/sign_in', email: '123@gmail.com', password: '123456')

      response = post(
        '/spaces/1',
        date: '2022-09-25'
      )

      latest_request = RequestRepository.new.all.last
      expect(latest_request.space_id).to eq 1
      expect(latest_request.owner_user_id).to eq 2
      expect(latest_request.requester_user_id).to eq 1
      expect(latest_request.date).to eq '2022-09-25'
      expect(latest_request.confirmed).to eq false

      expect(response.status).to eq 302
    end
  end

  context "GET /requested/:id" do
    it 'returns a detailed page of the request you received' do
    response = get('/requested/2')
    
      expect(response.status).to eq(200)
      expect(response.body).to include('Confirm Booking')
      expect(response.body).to include('Deny Booking')
      expect(response.body).to include('Date Requested')
      expect(response.body).to include('Requests For Your Space: 671 Lincoln Avenue in Winnetka')

    end
  end

  context "POST /requested/:id" do
    it 'returns a detailed page of the request you received' do
    response = post('/requested/2',confirmation: true)
      expect(response.status).to eq(302)
      expect(response.body).to eq('')
    end
    
    it 'deletes a request if booking is denied' do 
      response = post('/requested/2',confirmation: false)
      repo = RequestRepository.new
      expect(response.status).to eq(302)
      expect(response.body).to eq('')
      expect(repo.all.length).to eq 1
    end
  end

  context 'GET /sign_out' do
    it 'changes the header for spaces.erb' do
      post('/sign_in', email: '123@gmail.com', password: '123456')

      response1 = get('/spaces')
      expect(response1.status).to eq 200
      expect(response1.body).to include 'Sign Out'

      get('sign_out')

      response2 = get('spaces')
      expect(response2.status).to eq 200
      expect(response2.body).to include 'Login'
    end
  end
end 