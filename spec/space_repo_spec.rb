require 'space_repository'
require 'space'

RSpec.describe SpaceRepository do 
  def reset_users_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_users_table
  end

  describe '#all' do 
    it 'Returns all the spaces' do 
      repo = SpaceRepository.new

      spaces = repo.all

      expect(spaces.length).to eq(3)

      expect(spaces[0].id).to eq(1)
      expect(spaces[0].name).to eq('308 Negra Arroyo Lane, Albuquerque')
      expect(spaces[0].description).to eq( 'Quaint house with pool out back')
      expect(spaces[0].price).to eq(100)
      expect(spaces[0].available_from).to eq('2022-09-23')
      expect(spaces[0].available_to).to eq('2022-09-30')
      expect(spaces[0].user_id).to eq(2)

      expect(spaces[1].id).to eq(2)
      expect(spaces[1].name).to eq("671 Lincoln Avenue in Winnetka")
      expect(spaces[1].description).to eq("Great for a christmas visit")
      expect(spaces[1].price).to eq(200)
      expect(spaces[1].available_from).to eq('2022-12-22')
      expect(spaces[1].available_to).to eq('2022-12-30')
      expect(spaces[1].user_id).to eq(1)

      expect(spaces[2].id).to eq(3)
      expect(spaces[2].name).to eq("251 N. Bristol Avenue, Brentwood")
      expect(spaces[2].description).to eq("Royalty once lived here")
      expect(spaces[2].price).to eq(300)
      expect(spaces[2].available_from).to eq('2023-01-20')
      expect(spaces[2].available_to).to eq('2023-01-30')
      expect(spaces[2].user_id).to eq(2)
    end
  end

  describe '#Find' do
    it 'Gets a single space' do
      repo = SpaceRepository.new
      
      spaces = repo.find(1)
      
      expect(spaces.id).to eq(1)
      expect(spaces.name).to eq('308 Negra Arroyo Lane, Albuquerque')
      expect(spaces.description).to eq('Quaint house with pool out back')
      expect(spaces.price).to eq(100)
      expect(spaces.available_from).to eq('2022-09-23')
      expect(spaces.available_to).to eq('2022-09-30')
      expect(spaces.user_id).to eq(2)
      
      spaces = repo.find(2)

      expect(spaces.id).to eq(2)
      expect(spaces.name).to eq("671 Lincoln Avenue in Winnetka")
      expect(spaces.description).to eq("Great for a christmas visit")
      expect(spaces.price).to eq(200)
      expect(spaces.available_from).to eq("2022-12-22")
      expect(spaces.available_to).to eq("2022-12-30")
      expect(spaces.user_id).to eq(1)

      spaces = repo.find(3)
      
      expect(spaces.id).to eq(3)
      expect(spaces.name).to eq("251 N. Bristol Avenue, Brentwood")
      expect(spaces.description).to eq("Royalty once lived here")
      expect(spaces.price).to eq(300)
      expect(spaces.available_from).to eq("2023-01-20")
      expect(spaces.available_to).to eq("2023-01-30")
      expect(spaces.user_id).to eq(2)
    end
  end

  describe "#Create" do
    it "creates a new space" do 
      repo = SpaceRepository.new

      space = Spaces.new

      space.name = '240 North Neptune Avenue, Los Angeles'
      space.description = "Large, slightly dilapidated house, perfect for if you're in the business of making soap."
      space.price = 50
      space.available_from = "2023-05-20"
      space.available_to = "2024-05-25"
      space.user_id = 1

      expect(repo.create(space)).to eq(nil)

      spaces = repo.all

      last_space = spaces.last

      expect(last_space.id).to eq(4)
      expect(last_space.name).to eq('240 North Neptune Avenue, Los Angeles')
      expect(last_space.description).to eq("Large, slightly dilapidated house, perfect for if you're in the business of making soap.")
      expect(last_space.price).to eq(50)
      expect(last_space.available_from).to eq("2023-05-20")
      expect(last_space.available_to).to eq("2024-05-25")
      expect(last_space.user_id).to eq(1)
    end
  end
end