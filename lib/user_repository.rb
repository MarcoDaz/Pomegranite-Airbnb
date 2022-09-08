require_relative 'user'

class UserRepository
  def check_for_user(id)
    return false if id == nil
    
    sql = 'SELECT * FROM users WHERE id = $1'
    result = DatabaseConnection.exec_params(sql, [id]).to_a[0]
    
    return result ? true : false
  end

  def sign_in(email, password)
    user = find_by_email(email)

    return user.password == password
  end

  def find_by_email(email)
    sql = 'SELECT * FROM users WHERE email = $1;'
    result = DatabaseConnection.exec_params(sql, [email]).to_a
    
    return false if result.length == 0

    result = result[0]
    user = User.new
    user.id = result['id']
    user.email = result['email']
    user.password = result['password']

    return user
  end

  def create(new_user)
    sql = '
      INSERT INTO users (email, password)
      VALUES($1, $2);
    '
    sql_params = [new_user.email, new_user.password]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def all
    users = []
    sql = 'SELECT * FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])


    result_set.each do |record|
      user = User.new
      user.id = record['id'].to_i
      user.email = record['email']
      # password unecesasry

      users << user
    end
    
    return users
  end
end