require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'byebug'
require_relative './model.rb'

enable :sessions

get('/showregister') do
  slim(:register)
end

get('/') do
  slim(:login)
end



# post('/login') do
#   username = params[:username]
#   username = params[:password]
#   db = sqlite3::Database.new('db/database.db')
#   db.results_as_hash = true
#   result = db.execute("SELECT * FROM users WHERE username = ?", username).first
#   pwdigest = result["pwdigest"]
#   id = result["id"]

#   if BCrypt::Password.new(pwdigest) == password
#     session[:id] = id 
    
#     redirect('main')
#   else
#     "Wrong password."
#   end
# end

 get('/main') do
   id = session[:id].to_i
   db = sqlite3::Database.new('db/database.db')
   db.results_as_hash = true
   result = db.execute("SELECT * FROM database WHERE user_id = ?",id)
   slim(:"/main/index", locals:{main:result})
 end


post('/users/new') do
  username = params[:username]
  password = params[:password]
  password_confirm[:password_confirm]

  end

   if (password == password_confirm)
     password_digest = BCrypt::Password.create(password)
     db = sqlite3::Database.new('db/database.db')
     db.execute("INSERT INTO users (username, pwdigest) VALUES (?,?)", username, password_diges)
     redirect('/main')

    else
    "Lösenorden matchar inte"
  end
end