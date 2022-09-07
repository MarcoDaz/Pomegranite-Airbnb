require 'space'

class SpaceRepository
  def all
    sql = 'SELECT id, name, description, price, available_from, available_to, user_id FROM spaces;'
    result_set = DatabaseConnection.exec_params(sql, [])

    spaces = []

    result_set.each do |record|
      space = Spaces.new
      space.id = record['id'].to_i
      space.name = record['name']
      space.description = record['description']
      space.price = record['price'].to_i
      space.available_from = record['available_from']
      space.available_to = record['available_to']
      space.user_id = record['user_id'].to_i

      spaces << space
    end
    
    return spaces
  end

    def find(id)
  
      sql = 'SELECT id, name, description, price, available_from, available_to, user_id FROM spaces WHERE id = $1;'

      sql_params = [id]

      result_set = DatabaseConnection.exec_params(sql, sql_params)
  
      record = result_set[0]
  
       space = Spaces.new
            space.id = record['id'].to_i
            space.name = record['name']
            space.description = record['description']
            space.price = record['price'].to_i
            space.available_from = record['available_from']
            space.available_to = record['available_to']
            space.user_id = record['user_id'].to_i
        return space
    end
  
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