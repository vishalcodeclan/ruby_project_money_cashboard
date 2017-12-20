require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative('controllers/transactions_controller')
require_relative('controllers/budgets_controller')
require_relative('controllers/balance_controller')
require_relative('controllers/categories_controller')
require_relative('controllers/vendors_controller')


get '/?' do
  @unique_year_months = Budget.unique_dates_string
  erb(:"monthly_balance/home")
end
