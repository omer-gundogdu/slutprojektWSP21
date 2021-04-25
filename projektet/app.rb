require 'sinatra'
require 'slim'
require 'SQLite3'
require 'bcrypt'
require 'byebug'
require_relative './model.rb'

enable :sessions

get('/') do
  slim(:login)
end

post '/mina_annonser' do
  id = session[:id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM posts WHERE id = ?", id)
  redirect ('/posts/show')
end
get '/mina_annonser' do
  name = params[:namn]
  price = params[:pris]
  id = session[:id].to_i
  db = SQLite3::Database.new('db/database.db')
  db.results_as_hash = true
  result = db.execute('SELECT * FROM posts WHERE user_id = ?', id)
  slim(:"/posts/show",locals:{posts:result})
end

get ('/posts/ny_annons') do
  slim(:'/posts/ny_annons')
end
post ('/posts/ny_annons') do
  name = params[:namn]
  price = params[:pris]
  user_id = session[:id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  db.execute("INSERT INTO posts (name, price, user_id) VALUES (?,?,?)", name, price, user_id)
  redirect('/posts/ny_annons')
end

get ("/posts/annonser") do
  id = session[:id].to_i
  user_id = 
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM posts")
  slim(:"/posts/annonser",locals:{posts:result})
end

get('/index') do
  slim(:index)
end

post('/login') do
  username = params[:username]
  password = params[:password]
  db = SQLite3::Database.new('db/database.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM users WHERE username = ?", username).first
  pwdigest = result["pwdigest"]
  id = result["id"]

  if BCrypt::Password.new(pwdigest) == password
    session[:id] = id 
    redirect('index')
  else
    "Wrong password."
    slim(:'wrong_login')
  end
end
post('/users/new') do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]

  if (password == password_confirm)
    password_digest = BCrypt::Password.create(password)
    db = SQLite3::Database.new('db/database.db')
    db.execute("INSERT INTO users (username, pwdigest) VALUES (?,?)", username, password_digest)
    redirect('/index')

  else
  "Lösenorden matchar inte"
  end
end
get('/showregister') do
  slim(:register)
end

# get('/post/:post_id') do
#   post_id = params[:post_id]
#   user_id = session[:id].to_i
#   db = SQLite3::Database.new("db/database.db")
#   db.results_as_hash = true
#   result = db.execute("SELECT * FROM posts WHERE user_id = ?", id)
#   slim(:"/posts/#{post["post_id"]}", locals:{posts:result})
# end