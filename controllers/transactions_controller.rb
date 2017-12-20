require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/budget.rb')
require_relative('../models/category.rb')
require_relative('../models/transaction.rb')
require_relative('../models/vendor.rb')

get '/transactions' do
  @unique_year_months = Transaction.unique_dates_string
  @transactions = Transaction.all
  @categories = Category.all
  erb(:"transactions/index")
end

get('/transactions/new') do
  @categories = Category.all
  @vendors = Vendor.all
  erb(:"transactions/new")
end

post '/transactions' do
  vendor = Vendor.new(params)
  vendor.save
  params_new = {
    "transaction_date" => params[:transaction_date],
    "amount" => params[:amount],
    "category_id" => params[:category_id],
    "vendor_id" => vendor.id
  }
  transaction = Transaction.new(params_new)
  transaction.save
  redirect to ('/transactions')
end

get '/transactions/date_range' do
  @transactions = Transaction.find_multiple_by_month_year(params[:start_date], params[:end_date])
  @transaction_total = Transaction.total_multiple_by_month_year(params[:start_date], params[:end_date])
  erb(:"transactions/date")
end

get '/transactions/:id' do
  @transaction = Transaction.find(params[:id])
  erb(:"transactions/show")
end

# get '/transactions/month/:start/:end' do
#   @transactions = Transaction.find_date_range(params[:start], params[:end])
#   @transaction_total = Transaction.total_date_range(params[:start], params[:end])
#   erb(:"transactions/multiple_months")
# end

get '/transactions/:id/edit' do
  @categories = Category.all
  @vendors = Vendor.all
  @transaction = Transaction.find(params[:id])
  erb(:"transactions/edit")
end

post '/transactions/:id' do
  vendor_params = { "name" => params[:name] }
  vendor = Vendor.new(vendor_params)
  vendor.save
  params_new = {
    "transaction_date" => params[:transaction_date],
    "amount" => params[:amount],
    "category_id" => params[:category_id],
    "vendor_id" => vendor.id,
    "id" => params[:id]
  }
  transaction = Transaction.new(params_new)
  transaction.update
  redirect to "/transactions/#{params['id']}"
end


post ('/transactions/:id/delete') do
  Transaction.delete(params[:id])
  redirect to ("/transactions")
end

get '/transactions/history/category/' do
  @transactions_category = Transaction.find_by_category(params[:category_id])
  @transactions_total = Transaction.total_by_category(params[:category_id])
  erb(:"transactions/category")
end
