require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/budget.rb')
require_relative('../models/category.rb')
require_relative('../models/transaction.rb')
require_relative('../models/vendor.rb')

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

get '/budgets/month/:month' do
  @budgets = Budget.find_by_month(params[:month])
  @total = Budget.monthly(params[:month])
  erb(:"budgets/month")
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

get '/budgets/months/:start/:end' do
  @budgets = Budget.find_date_range(params[:start], params[:end])
  @total = Budget.total_date_range(params[:start], params[:end])
  erb(:"budgets/multiple_months")
end
