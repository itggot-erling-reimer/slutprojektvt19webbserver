require 'sinatra'
require 'sqlite3'
require 'slim'


class App < Sinatra::Base
    enable :session
  db = SQLite3::Database.new("db/forum19db.db") 


    get "/" do
        
        @user = session[:user]
        test = session[:test]
        print test
        slim:index
    end

    get "/login" do
        slim:login
    end

    post "/login" do
        username = params['username']
        password = params['password']
    
        db = SQLite3::Database.open('db/forum19db.db')
        user = db.execute('SELECT * FROM users WHERE username = ?', [username])
    
        # if BCrypt::Password.new(user.first[2]) == password
        #   print 'Login Succesful'
        #   session[:user] = user[0]
        #   redirect '/'
        # else
        #   print 'Wrong username or password, please try again'
        #   redirect '/login'
        # end



        if user.first[3] == password
            print 'Login Succesful'
            session[:user] = user[0]
            session[:test] = "jaaaa"
            redirect '/'
        else
            print 'Wrong username or password, please try again'
            redirect '/login'
        end
        
    end
    
    get "/register" do
        slim:register
    end
    post "/register" do
        username = params["username"]
        password = params["password"]
        email = params["email"]

        existing_username = db.execute('SELECT username FROM users WHERE username = ?', [username])
        if !existing_username.empty?
            print 'username already exists'
            redirect '/register'
        else
            #hash = BCrypt::Password.create(password)
            print 'Register succesful'
            db.execute('INSERT INTO users(username, email, password) VALUES(?,?,?)', [username, email, password])
            redirect '/login'
        end


        db.execute("INSERT INTO users(username, password, email) VALUES (?,?,?)", [username, password, email])
    end
end
