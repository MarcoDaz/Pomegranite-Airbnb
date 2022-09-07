class UserRepository
    def sign_in(email, submitted_password)
            user = find_by_email(email)

        return nil if user.nil?

        encrypted_submitted_password = BCrypt::Password.create(submitted_password)

        if user.password == encrypted_submitted_password
            # login success
            # return true            
        else
            # wrong password
            # return true            
        end
    end

    def find_by_email(email)
        sql = 'SELECT * FROM users WHERE email = $1;'
        record = DatabaseConnection.exec_params(sql, [id])[0]

        return false if record == nil

        user = User.new
        user.id = record['id'].to_i
        user.email = record['email']

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
        sql = 'SELECT id, email, password FROM users;'
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