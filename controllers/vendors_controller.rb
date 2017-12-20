require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/budget.rb')
require_relative('../models/category.rb')
require_relative('../models/transaction.rb')
require_relative('../models/vendor.rb')

get '/vendors' do
  @vendors = Vendor.all
  erb(:"vendors/index")
end

get '/vendors/new' do
  erb(:"vendors/new")
end

post '/vendors' do
  vendor = Vendor.new(params)
  vendor.save
  redirect to('/vendors')
end

get '/vendors/transactions/' do
  @transactions = Vendor.find_transactions(params[:id])
  @transactions_total = Vendor.total_transactions(params[:id])
  erb(:"vendors/transactions")
end

get '/vendors/:id' do
  @vendor = Vendor.find(params[:id])
  erb(:"vendors/show")
end

post ('/vendors/:id/delete') do
  Vendor.delete(params[:id])
  redirect to "/vendors"
end

get '/vendors/:id/edit' do
  @vendor = Vendor.find(params[:id])
  erb(:"vendors/edit")
end

post '/vendors/:id' do
  vendor = Vendor.new(params)
  vendor.update
  redirect to "/vendors/#{params['id']}"
end
