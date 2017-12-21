require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/budget.rb')
require_relative('../models/category.rb')
require_relative('../models/transaction.rb')
require_relative('../models/vendor.rb')

get '/balance' do
@year = Transaction.year(params[:start_date])
@month = Transaction.month(params[:start_date])
@budget_total = Budget.total_by_month_year(params[:start_date])
@budgets = Budget.find_by_month_year(params[:start_date])
@transactions = Transaction.find_by_month_year(params[:start_date])
@transaction_total = Transaction.total_by_month_year(params[:start_date])
erb(:"monthly_balance/balance")
end

get '/home' do
  @unique_year_months = Budget.unique_dates_string
  erb(:"monthly_balance/home2")
end

get '/balance2' do
  @year1 = Transaction.year(params[:start_date])
  @month1 = Transaction.month(params[:start_date])
  @year2 = Transaction.year(params[:end_date])
  @month2= Transaction.month(params[:end_date])
  @transactions = Transaction.find_multiple_by_month_year(params[:start_date], params[:end_date])
  @transaction_total = Transaction.total_multiple_by_month_year(params[:start_date], params[:end_date])
  @budgets = Budget.find_multiple_by_month_year(params[:start_date], params[:end_date])
  @budget_total = Budget.total_multiple_by_month_year(params[:start_date], params[:end_date])
  @budgets_hashes = Budget.balance_find_multiple_by_month_year(params[:start_date], params[:end_date])
  erb(:"monthly_balance/balance2")
end
