require 'sinatra'
require 'sqlite3'
require 'slim'


class App < Sinatra::Base
  db = SQLite3::Database.new("db/forum19db.db") 


    get "/" do
        slim:index
    end
    
    get "/register" do
        slim:register
    end
    post "/register" do
        username = params["username"]
        password = params["password"]
        email = params["email"]
        db.execute("INSERT INTO users(username, password, email) VALUES (?,?,?)", [username, password, email])
    end
end
