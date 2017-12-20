require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/budget.rb')
require_relative('../models/category.rb')
require_relative('../models/transaction.rb')
require_relative('../models/vendor.rb')

get '/categories' do
  @categories = Category.all
  erb(:"categories/index")
end

get '/categories/new' do
  erb(:"categories/new")
end

post '/categories' do
  category = Category.new(params)
  category.save
  redirect to('/categories')
end

get '/categories/transactions/' do
  @transactions = Category.find_transactions(params[:id])
  @transactions_total = Category.total_transactions(params[:id])
  erb(:"categories/transactions")
end

get '/categories/:id' do
  @category = Category.find(params[:id])
  erb(:"categories/show")
end

post ('/categories/:id/delete') do
  if Category.any_transactions?(params[:id])
    Category.delete(params[:id])
    redirect to "/categories"
  else
    erb(:"categories/cannot_delete")
  end
end

get '/categories/:id/edit' do
  @category = Category.find(params[:id])
  erb(:"categories/edit")
end

post '/categories/:id' do
  category = Category.new(params)
  category.update
  redirect to "/categories/#{params['id']}"
end
