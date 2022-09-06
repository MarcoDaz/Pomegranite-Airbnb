require 'space_repository'
require 'space'

def reset_users_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
  
  describe SpaceRepository do
    before(:each) do
      reset_users_table
    end
  end

RSpec.describe '#all' do 
    it 'Returns all the spaces' do 
    repo = SpaceRepository.new

    spaces = repo.all

    expect(spaces.length).to eq(4)

    expect(spaces[0].id).to eq(1)
    expect(spaces[0].name).to eq('308 Negra Arroyo Lane, Albuquerque')
    expect(spaces[0].description).to eq( 'Quaint house with pool out back')
    expect(spaces[0].price).to eq(100)
    expect(spaces[0].available_from).to eq('09/23/2022')
    expect(spaces[0].available_to).to eq('09/30/2022')
    expect(spaces[0].user_id).to eq(2)

    expect(spaces[1].id).to eq(2)
    expect(spaces[1].name).to eq("671 Lincoln Avenue in Winnetka")
    expect(spaces[1].description).to eq("Great for a christmas visit")
    expect(spaces[1].price).to eq(200)
    expect(spaces[1].available_from).to eq("12/22/2022")
    expect(spaces[1].available_to).to eq("12/30/2022")
    expect(spaces[1].user_id).to eq(1)

    expect(spaces[2].id).to eq(3)
    expect(spaces[2].name).to eq("251 N. Bristol Avenue, Brentwood")
    expect(spaces[2].description).to eq("Royalty once lived here")
    expect(spaces[2].price).to eq(300)
    expect(spaces[2].available_from).to eq("01/20/2023")
    expect(spaces[2].available_to).to eq("01/30/2023")
    expect(spaces[2].user_id).to eq(2)
    end
end

    context '#Find' do
    xit 'Gets a single space' do
    
    repo = SpaceRepository.new
    
    spaces = repo.find(1)
    
    expect(spaces.id).to eq(1)
    expect(spaces.name).to eq('308 Negra Arroyo Lane, Albuquerque')
    expect(spaces.description).to eq('Quaint house with pool out back')
    expect(spaces.price).to eq(100)
    expect(spaces.available_from).to eq('09/23/2022')
    expect(spaces.available_to).to eq('09/30/2022')
    expect(spaces.user_id).to eq(2)
    
    spaces = repo.find(2)

    expect(spaces.id).to eq(2)
    expect(spaces.name).to eq("671 Lincoln Avenue in Winnetka")
    expect(spaces.description).to eq("Great for a christmas visit")
    expect(spaces.price).to eq(200)
    expect(spaces.available_from).to eq("12/22/2022")
    expect(spaces.available_to).to eq("12/30/2022")
    expect(spaces.user_id).to eq(1)

    spaces = repo.find(3)
    
    expect(spaces.id).to eq(3)
    expect(spaces.name).to eq("251 N. Bristol Avenue, Brentwood")
    expect(spaces.description).to eq("Royalty once lived here")
    expect(spaces.price).to eq(300)
    expect(spaces.available_from).to eq("01/20/2023")
    expect(spaces.available_to).to eq("01/30/2023")
    expect(spaces.user_id).to eq(2)
    end
end

    context "#Create" do
    xit "creates a new space" do 

    repo = SpaceRepository.new

    space = Spaces.new

    space.name = '240 North Neptune Avenue, Los Angeles'
    space.description = "Large, slightly dilapidated house, perfect for if you're in the business of making soap."
    space.price = 50
    space.available_from = "05/20/23"
    space.available_to = "05/25/24"
    space.user_id = 1

    expect(repo.create(space)).to eq(nil)

    spaces = repo.all

    last_space = spaces.last

    expect(last_space.id).to eq(4)
    expect(last_space.name).to eq('240 North Neptune Avenue, Los Angeles')
    expect(last_space.description).to eq("Large, slightly dilapidated house, perfect for if you're in the business of making soap")
    expect(last_space.price).to eq(50)
    expect(last_space_available_from).to eq("05/20/23")
    expect(last_space_available_to).to eq("05/25/24")
    expect(last_space.user_id).to eq(1)
    end
end

