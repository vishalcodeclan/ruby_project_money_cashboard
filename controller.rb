require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('models/budget.rb')
require_relative('models/category.rb')
require_relative('models/transaction.rb')
require_relative('models/vendor.rb')

get '/transactions' do
  @transactions = Transaction.all

  erb(:index)
end

get('/transactions/new') do
  @categories = Category.all
  @vendors = Vendor.all
  erb(:new)
end

post '/transactions' do
  transaction = Transaction.new(params)
  transaction.save
  redirect to('/transactions')
end

get '/transactions/:id' do
  @transaction = Transaction.find(params[:id])
  erb(:show)
end

get '/transactions/:id/edit' do
  @categories = Category.all
  @vendors = Vendor.all
  @transaction = Transaction.find(params[:id])
  erb(:edit)
end

post '/transactions/:id' do
  transaction = Transaction.new(params)
  transaction.update
  redirect to "/transactions/#{params['id']}"
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
