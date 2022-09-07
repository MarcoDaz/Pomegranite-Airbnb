require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_database
  albums_seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(albums_seed_sql)
end

RSpec.describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Reset database before each test
  before(:each) do
    reset_database
  end

  # Reset database after all tests are done
  after(:all) do
    reset_database
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