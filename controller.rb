require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('models/budget.rb')
require_relative('models/category.rb')
require_relative('models/transaction.rb')
require_relative('models/vendor.rb')





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

get '/budgets' do
  @budgets = Budget.all
  erb(:"budgets/index")
end

get '/budgets/new' do
  @categories = Category.all
  erb(:"budgets/new")
end

post '/budgets' do
  budget = Budget.new(params)
  budget.save
  redirect to('/budgets')
end

get '/budgets/:id' do
  @budget = Budget.find(params[:id])
  erb(:"budgets/show")
end

post ('/budgets/:id/delete') do
  Budget.delete(params[:id])
  redirect to "/budgets"
end

get '/budgets/:id/edit' do
  @categories = Category.all
  @budget = Budget.find(params[:id])
  erb(:"budgets/edit")
end

post '/budgets/:id' do
  budget = Budget.new(params)
  budget.update
  redirect to "/budgets/#{params['id']}"
end
