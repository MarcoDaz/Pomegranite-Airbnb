Spaces Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

_In this template, we'll use an example table `students`_

```
# EXAMPLE

Table: Spaces

Columns:
id | name | description | price | available from | available to | user_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{spaces}.sql)

-- Write your SQL seed here.

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE spaces RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO spaces (name, description, price, available_from, available_to, user_id) VALUES ('308 Negra Arroyo Lane, Albuquerque', 'Quaint house with pool out back', '23/09/2022', '30/09/2022');

INSERT INTO spaces (name, description, price, available_from, available_to, user_id) VALUES ('671 Lincoln Avenue in Winnetka', 'Great for a christmas visit', '22/12/2022', '30/12/2022');

INSERT INTO spaces (name, description, price, available_from, available_to, user_id) VALUES ('251 N. Bristol Avenue, Brentwood', 'Royalty once lived here', '20/01/2023', '30/01/2023');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_spaces.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: spaces

# Model class
# (in lib/spaces.rb)
class Spaces
end

# Repository class
# (in lib/student_repository.rb)
class SpacesRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: spaces

# Model class
# (in lib/spaces.rb)

class Spaces

  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :description, :price, :available_from, :available_to, :user_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:

```

_You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed._

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: spaces

# Repository class
# (in lib/spaces_repository.rb)

class SpaceRepository

  # Selecting all records
  # No arguments
def all
        sql = 'SELECT id, name, description, price, available_from, available_to, user_id FROM spaces;'
        result_set = DatabaseConnection.exec_params(sql, [])

        spaces = []

        result_set.each do |record|
            space = Spaces.new
            space.id = record['id']
            space.name = record['name']
            space.description = record['description']
            space.price = record['price']
            space.available_from = record['available_from']
            space.available_to = record['available_to']
            space.user_id = record['user_id']

            spaces << space
        end
    return spaces
  end

  # Gets a single record by its ID
  # One argument: the id (number)

  def find(id)

    sql = 'SELECT id, name, description, price, available_from, available_to, user_id FROM spaces WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [])

    space = result_set[0]

     space = Spaces.new

            space.id = record['id']
            space.name = record['name']
            space.description = record['description']
            space.price = record['price']
            space.available_from = record['available_from']
            space.available_to = record['available_to']
            space.user_id = record['user_id']

        return space
  end

  # Add more methods below for each operation you'd like to implement.

   def create(space)
    sql = 'INSERT INTO spaces (name, description, price, available_from, available_to, user_id) VALUES($1, $2, $3, $4, $5, $6);'

    sql_params = [space.name, space.description, space.price, space.available_from, space.available_to, space.user_id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
   end

   #def filter_by_availability(available_from, available_to)
   #sql = 'SELECT id, name, description, price, available_from, available_to, user_id FROM spaces WHERE available_from = $1, available_to = $2;'
   #end

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

````ruby

# EXAMPLES

# 1

# Get all spaces

repo = SpaceRepository.new

spaces = repo.all

spaces.length # =>  3

spaces[0].id # =>  1
spaces[0].name # =>  '308 Negra Arroyo Lane, Albuquerque'
spaces[0].description # => 'Quaint house with pool out back'
spaces[0].price# => 100
spaces[0].available_from # => '09/23/2022'
spaces[0].available_to # =>'09/30/2022'
spaces[0].user_id => 2

spaces[1].id # =>  2
spaces[1].name # => "671 Lincoln Avenue in Winnetka"
spaces[1].description # =>  "Great for a christmas visit"
spaces[1].price# => 200
spaces[1].available_from # => "12/22/2022"
spaces[1].available_to # =>"12/30/2022"
spaces[1].user_id # => 1

spaces[2].id # =>  3
spaces[2].name # => "251 N. Bristol Avenue, Brentwood"
spaces[2].description # =>  "Royalty once lived here"
spaces[2].price# => 300
spaces[2].available_from # => "01/20/2023"
spaces[2].available_to # => "01/30/2023"
spaces[2].user_id # => 2

# 2

# Get a single space

repo = SpaceRepository.new

spaces = repo.find(1)

spaces.id # =>  1
spaces.name # =>  '308 Negra Arroyo Lane, Albuquerque'
spaces.description # => 'Quaint house with pool out back'
spaces.price # => 100
spaces.available_from # => '09/23/2022'
spaces.available_to # =>'09/30/2022'
spaces.user_id # => 2

spaces = repo.find(2)

spaces.id # =>  2
spaces.name # => "671 Lincoln Avenue in Winnetka"
spaces.description # =>  "Great for a christmas visit"
spaces.price # => 200
spaces.available_from # => "12/22/2022"
spaces.available_to # =>"12/30/2022"
spaces.user_id # => 1

spaces = repo.find(3)

spaces.id # =>  3
spaces.name # => "251 N. Bristol Avenue, Brentwood"
spaces.description # =>  "Royalty once lived here"
spaces.price # => 300
spaces.available_from # => "01/20/2023"
spaces.available_to # => "01/30/2023"
spaces.user_id => 2

# 3

# Creates a new space

repo = SpaceRepository.new

space = Spaces.new

space.name = '240 North Neptune Avenue, Los Angeles'
space.description = "Large, slightly dilapidated house, perfect for if you're in the business of making soap."
space.price = 50
space.available_from = "05/20/23"
space.available_to = "05/25/24"
space.user_id = 1

repo.create(space) # => nil

spaces = repo.all

last_space = spaces.last

last_space.id # => 4
last_space.name # => '240 North Neptune Avenue, Los Angeles'
last_space.description # => "Large, slightly dilapidated house, perfect for if you're in the business of making soap"
last_space.price # => 50
last_space_available_from # => "05/20/23"
last_space_available_to # => "05/25/24"
last_space.user_id = 1



Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_students_table
  seed_sql = File.read('spec/seeds_students.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'students' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do
    reset_students_table
  end

  # (your tests will go here).
end
````

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
