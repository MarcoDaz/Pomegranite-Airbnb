# User Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email text UNIQUE,
  password text
);


```
# EXAMPLE

Table: users

Columns:
id | email | password
```

## 2. Create Test SQL seeds


```sql


TRUNCATE TABLE users RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (email, password) VALUES ("123@gmail.com", "123456");
INSERT INTO users (email, password) VALUES ("def@gmail.com", "123456");
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names


```ruby


# Model class
# (in lib/user.rb)
class User
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby


# Model class
# (in lib/user.rb)

class User
  attr_accessor :id, :email, :password
end

```


## 5. Define the Repository Class interface

```ruby

# Repository class
# (in lib/user_repository.rb)

class UserRepository
    def sign_in(email, password)
            user = find_by_email(email)

        return nil if user.nil?

        encrypted_submitted_password = BCrypt::Password.create(submitted_password)

        if user.password == encrypted_submitted_password
            # login success
        else
            # wrong password
        end
    end

    def find_by_email(email)
        sql = 'SELECT * FROM users WHERE email = $1;'
        result_set = DatabaseConnection.exec_params(sql, [id])

        user = User.new
        user.id = result_set[0]['id'].to_i
        user.email = result_set[0]['email']

        return user
    end

    def create(new_user)
        encrypted_password = BCrypt::Password.create(new_user.password)

        sql = '
            INSERT INTO users (email, password)
            VALUES($1, $2);
        '
        sql_params = [
            new_user.email,
            encrypted_password
        ]
    end

    def all
        users = []
        sql = 'SELECT id, name, genre FROM users;'
        result_set = DatabaseConnection.exec_params(sql, [])
    
    result_set.each do |record|

      user = User.new
      user.id = record['id'].to_i
      user.email = record['email']

      users << user
    end

    return users
  end

    

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby


repo = UserRepository.new

#1 sign a user in 
repo = UserRepository.new
result = repo.sign_in('123@gmail.com', '123456')
result2 = repo.sign_in('123@gmail.com', '1234las')
result # => true
result2 # => false

#2 password missing
repo = UserRepository.new
result = repo.sign_in('123@gmail.com', '')
result # => false

#3 find existing user
repo = UserRepository.new
user = repo.find_by_email('123@gmail.com')
user.id # => 1
user.email # => '123@gmail.com'
user.password # => '123456'

#4 find non-existent email
repo = UserRepository.new
repo.find_by_email('12334@gmail.com') # => fail "user not found"

#5 create user
repo = UserRepository.new
new_user = User.new
new_user.email# => 'douglas@gmail.com'
new_user.password# => 'makers12'
repo.create(new_user)
repo.all.last# => 'douglas@gmail.com'


```


## 7. Reload the SQL seeds before each test run

```ruby

# file: spec/user_repository_spec.rb

def reset_users_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end


end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
