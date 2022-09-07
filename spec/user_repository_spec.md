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

  it "sign a user in" do
    repo = UserRepository.new
    result = repo.sign_in('123@gmail.com','$2a$12$QYL4W2L6oFSooO0oz2Q4Uu6fKT1scKqMw8vIbzXI85ndi1M1zSOp.')
    expect(result).to eq true
  end

  it "fails password missing" do
    repo = UserRepository.new
    result = repo.sign_in('123@gmail.com','')
    expect(result).to eq false
  end

  it "find existing user" do
    repo = UserRepository.new
    user = repo.find_by_email('123@gmail.com')
    expect(user['id']).to eq "1"
    expect(user['email']).to eq '123@gmail.com'
    expect(user['password']).to eq '$2a$12$QYL4W2L6oFSooO0oz2Q4Uu6fKT1scKqMw8vIbzXI85ndi1M1zSOp.'
  end
  
  it "find non-existent email" do
    repo = UserRepository.new
    expect { repo.find_by_email('123456@gmail.com') }.to raise_error 
  end

  it "creates user" do
    repo = UserRepository.new
    new_user = User.new
    new_user.email = 'douglas@gmail.com'
    new_user.password = 'makers12'
    repo.create(new_user)

    users = repo.all
    expect(users.length).to eq(3)
    expect(users.last.email).to eq('douglas@gmail.com')
  end
end