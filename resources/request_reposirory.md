```ruby
# EXAMPLE
# Table name: request

# Repository class
# (in lib/student_repository.rb)

CREATE TABLE "public"."requests" (
    "id" SERIAL,
    "space_id" int,
    "owner_user_id" int,
    "requester_user_id" int,
    "date" date,
    "confirmed" boolean, 
    PRIMARY KEY ("id")
);

class RequestRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    sql = '
      SELECT
        id,
        space_id,
        owner_user_id,
        requester_user_id,
        date,
        confirmed
      FROM requests;
    '
    DatabaseConnection.exec_params(sql, [])
    # Returns an array of request objects.
  end

  # Gets a single record
  # Given its id
  def find(id)
    # Executes the SQL query:
    sql = '
      SELECT
        id,
        space_id,
        owner_user_id,
        requester_user_id,
        date,
        confirmed
      FROM requests
      WHERE id = $1;
      '

    DatabaseConnection.exec_params(sql, [id])
    # Returns a single request object.
  end

  # Creates a request record
  # Given a Request Object
  def create(request)
    repository = RequestRepository.new

    sql = "
      INSERT INTO requests (
        space_id,
        owner_user_id,
        requester_user_id,
        date,
        confirmed
      ) VALUES($1, $2, $3, $4, $5);
    "
    params = [
      request.space_id,
      request.owner_user_id,
      request.requester_user_id,
      request.date,
      request.confirmed
    ]
  
    DatabaseConnection.exec_params(sql, params)

    return nil
  end

  # Updates request record's confirmed attribute to true
  # Given a Request object
  def confirm(request)
    # Executes the SQL query:
    sql = "UPDATE requests
      SET confirmed = true
      WHERE id = $1;"

    DatabaseConnection.exec_params(sql, [request.id])

    return nil
  end

  def delete(id)    
    sql = "DELETE FROM requests WHERE id = $1;"
    DatabaseConnection.exec_params(sql, [id])

    return nil
  end

  # Filters requests by the owner_user_id
  # Given a owner_user_id
  def filter_by_owner_user_id(owner_user_id)
    # Executes the SQL query:
    sql = "
      SELECT
        id,
        space_id,
        owner_user_id,
        requester_user_id,
        date,
        confirmed
      FROM requests
      WHERE owner_user_id = $1;
    "

    DatabaseConnection.exec_params(sql, [owner_user_id])
    # Returns an array of Request objects
  end

  # Filter requests by the requester_user_id
  def filter_by_requester_user_id(requester_user_id)
    sql = "
      SELECT
        id,
        space_id,
        owner_user_id,
        requester_user_id,
        date,
        confirmed
      FROM requests
      WHERE requester_user_id = $1;
    "

    DatabaseConnection.exec_params(sql, [requester_user_id])
    # Returns an array of Request objects
  end

end

require './resources/request_repository'

RSpec.describe RequestRepository

# 1
# Get all students
repo = RequestRepository.new

requests = repo.all

requests.length # =>  2

requests[0].id # =>  1
requests[0].space_id # =>  1
requests[0].owner_user_id # => 2
requests[0].requester_user_id # => 1
requests[0].date # => '24/09/2022'
requests[0].confirmed # => false

requests[1].id # => 2
requests[1].space_id # => 2
requests[1].owner_user_id # => 1
requests[1].requester_user_id # => 2
requests[1].date # => '26/12/2022'
requests[1].confirmed # => false

# 2
# Get a single student

repo = RequestRepository.new

request = repo.find(1)
request[0].id # =>  1
request[0].space_id # =>  1
request[0].owner_user_id # => 2
request[0].requester_user_id # => 1
request[0].date # => '24/09/2022'
request[0].confirmed # => false

# 3
# create a request
repo = RequestRepository.new

new_request = Request.new
new_request.space_id = 1
new_request.owner_user_id = 2
new_request.requester_user_id = 1
new_request.date = '09/25/2022'
new_request.confirmed = false

repo.create(new_request)

all_requests = repo.all
all_requests.last.date # => '09/25/2022'

# 4
# confirm a request
repo = RequestRepository.new
request1 = repo.find(1)
repo.confirm(request1)

updated_request1 = repo.find(1)

updated_request1.confirmed # => true

# 5
# delete a request
repo = RequestRepository.new

repo.all # => 2
repo.delete(1)
repo.all # => 1

# 6
# filter a request by owner user id
repo = RequestRepository.new

requests_of_owner2 = repo.filter_by_owner_user_id(2)

requests_of_owner2[0].id # =>  1
requests_of_owner2[0].space_id # =>  1
requests_of_owner2[0].owner_user_id # => 2
requests_of_owner2[0].requester_user_id # => 1
requests_of_owner2[0].date # => '24/09/2022'
requests_of_owner2[0].confirmed # => false

# 7
# filter a request by requester user id
repo = RequestRepository.new

requests_of_requester1 = repo.filter_by_requester_user_id(1)
requests_of_requester1[0].id # => 2
requests_of_requester1[0].space_id # => 2
requests_of_requester1[0].owner_user_id # => 1
requests_of_requester1[0].requester_user_id # => 2
requests_of_requester1[0].date # => '26/12/2022'
requests_of_requester1[0].confirmed # => false
```