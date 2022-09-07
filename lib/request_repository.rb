require 'request'

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
      result_set = DatabaseConnection.exec_params(sql, [])
      # Returns an array of request objects.
      requests = []
      result_set.each do |record|
        request = Request.new
        request.id = record['id'].to_i
        request.space_id = record['space_id'].to_i
        request.owner_user_id = record['owner_user_id'].to_i
        request.requester_user_id = record['requester_user_id'].to_i
        request.date = record['date']
        request.confirmed = record['confirmed']

        requests << request
      end

      return requests
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
  
      result_set = DatabaseConnection.exec_params(sql, [id])
      # Returns a single request object.

      record = result_set[0]

      request = Request.new
      request.space_id = record['space_id'].to_i
      request.owner_user_id = record['owner_user_id'].to_i
      request.requester_user_id = record['requester_user_id'].to_i
      request.date = record['date']
      request.confirmed = record['confirmed']
      request.id = record['id'].to_i

      return request
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
  
      result_set = DatabaseConnection.exec_params(sql, [owner_user_id])
      # Returns an array of Request objects
      requests = []
      result_set.each do |record|
        request = Request.new
        request.id = record['id'].to_i
        request.space_id = record['space_id'].to_i
        request.owner_user_id = record['owner_user_id'].to_i
        request.requester_user_id = record['requester_user_id'].to_i
        request.date = record['date']
        request.confirmed = record['confirmed']

        requests << request
      end

      return requests

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
  
      result_set = DatabaseConnection.exec_params(sql, [requester_user_id])
      # Returns an array of Request objects
      requests = []
    
      result_set.each do |record|
        request = Request.new
        request.id = record['id'].to_i
        request.space_id = record['space_id'].to_i
        request.owner_user_id = record['owner_user_id'].to_i
        request.requester_user_id = record['requester_user_id'].to_i
        request.date = record['date']
        request.confirmed = record['confirmed']

        requests << request
      end

    return requests
    end

  end