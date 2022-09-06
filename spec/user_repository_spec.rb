require 'user'
require 'user_repository'

def reset_users_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
end
  
    describe UserRepository do
    before(:each) do 
        reset_users_table
    end

    it 'sign a user in' do
    repo = UserRepository.new

    result = repo.sign_in('123@gmail.com', '123456')
    result2 = repo.sign_in('123@gmail.com', '1234las')
    expect(result).to eq true
    expect(result).to eq false
    end
  
end