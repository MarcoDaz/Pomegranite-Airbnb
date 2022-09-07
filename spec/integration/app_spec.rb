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
  
  context 'GET /create_space' do
    it 'returns an html form for listing a new space' do
      response = get('/create_space')
      body = response.body

      expect(response.status).to eq 200

      expect(body).to include '<h1>List a Space</h1>'
      expect(body).to include '<form action="/create_space" method="POST">'
      expect(body).to include '<input type="text" name="name" id="name" required>'
      expect(body).to include '<input type="text" description="description" id="description" required>'
      expect(body).to include '<input type="number" price="price" id="price" required>'
      expect(body).to include '<input type="date" available_from="available_from" id="available_from" required>'
      expect(body).to include '<input type="date" available_to="available_to" id="available_to" required>'
    end
  end
end 