require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/budget.rb')
require_relative('../models/category.rb')
require_relative('../models/transaction.rb')
require_relative('../models/vendor.rb')

get '/transactions' do

  @transactions = Transaction.all
  erb(:"transactions/index")
end

get('/transactions/new') do
  @categories = Category.all
  @vendors = Vendor.all
  erb(:"transactions/new")
end

post '/transactions' do
  transaction = Transaction.new(params)
    transaction.save
    redirect to('/transactions')
end

get '/transactions/:id' do
  @transaction = Transaction.find(params[:id])
  erb(:"transactions/show")
end

get '/transactions/month/:month' do
  @transactions = Transaction.find_by_month(params[:month])
  @total = Transaction.total_amount_spent_month(params[:month])
  erb(:"transactions/month")
end

get '/transactions/month/:start/:end' do
  @transactions = Transaction.find_date_range(params[:start], params[:end])
  @transaction_total = Transaction.total_date_range(params[:start], params[:end])
  erb(:"transactions/multiple_months")
end

get '/transactions/:id/edit' do
  @categories = Category.all
  @vendors = Vendor.all
  @transaction = Transaction.find(params[:id])
  erb(:"transactions/edit")
end

post '/transactions/:id' do
  transaction = Transaction.new(params)
  transaction.update
  redirect to "/transactions/#{params['id']}"
end

post ('/transactions/:id/delete') do
  Transaction.delete(params[:id])
  redirect to ("/transactions")
end

get '/transactions/category/:name' do
  @transactions_category = Transaction.find_by_category(params[:name])
  @transactions_total = Transaction.total_by_category(params[:name])
  erb(:"transactions/category")
end
