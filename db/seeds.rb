require_relative('../models/category')
require_relative('../models/transaction')
require_relative('../models/vendor')
require('pry-byebug')
require('date')

Transaction.delete_all
Category.delete_all
Vendor.delete_all

c1 = Category.new({"name" => "Eating Out"})
c2 = Category.new({"name" => "Fuel"})
c3 = Category.new({"name" => "Gifts"})
c4 = Category.new({"name" => "Holidays"})
c5 = Category.new({"name" => "Clothes"})
c6 = Category.new({"name" => "Entertainment"})
c7 = Category.new({"name" => "Groceries"})
c8 = Category.new({"name" => "Kids"})
c9 = Category.new({"name" => "Shopping"})
c10 = Category.new({"name" => "Sports"})
c11 = Category.new({"name" => "Travel"})

c1.save
c2.save
c3.save
c4.save
c5.save
c6.save
c7.save
c8.save
c9.save
c10.save
c11.save

v1 = Vendor.new({"name" => "Nandos"})
v2 = Vendor.new({"name" => "BP"})
v3 = Vendor.new({"name" => "John Lewis"})
v4 = Vendor.new({"name" => "Thomas Cook"})
v5 = Vendor.new({"name" => "M&S"})
v6 = Vendor.new({"name" => "Cineworld"})
v7 = Vendor.new({"name" => "Tesco"})
v8 = Vendor.new({"name" => "Toys R Us"})
v9 = Vendor.new({"name" => "Amazon"})
v10 = Vendor.new({"name" => "JD Sports"})
v11 = Vendor.new({"name" => "Expedia"})

v1.save
v2.save
v3.save
v4.save
v5.save
v6.save
v7.save
v8.save
v9.save
v10.save
v11.save

b1 = Budget.new({
  "amount" => 50,
  "start_date" => Date.new(2017,1,1),
  "end_date" => Date.new(2017,1,30),
  "category_id" => c1.id
  })

b2 = Budget.new({
    "amount" => 100,
    "start_date" => Date.new(2017,1,1),
    "end_date" => Date.new(2017,1,30),
    "category_id" => c2.id
    })

b3 = Budget.new({
      "amount" =>150,
      "start_date" => Date.new(2017,1,1),
      "end_date" => Date.new(2017,1,30),
      "category_id" => c3.id
      })

b1.save
b2.save
b3.save

t1 = Transaction.new({
  "transaction_date" => Date.new(2017,1,2),
  "amount" => 20,
  "category_id" => c1.id,
  "vendor_id" => v1.id
  "budget_id" => b1.id
  })

  t2 = Transaction.new({
    "transaction_date" => Date.new(2017,1,2),
    "amount" => 25,
    "category_id" => c1.id,
    "vendor_id" => v2.id
    })
  t3 = Transaction.new({
    "transaction_date" => Date.new(2017,1,3),
    "amount" => 50,
    "category_id" => c1.id,
    "vendor_id" => v3.id
    })
  t4 = Transaction.new({
    "transaction_date" => Date.new(2017,1,4),
    "amount" => 1000,
    "category_id" => c4.id,
    "vendor_id" => v4.id
    })
  t5 = Transaction.new({
    "transaction_date" => Date.new(2017,1,5),
    "amount" => 40,
    "category_id" => c5.id,
    "vendor_id" => v5.id
    })
  t6 = Transaction.new({
    "transaction_date" => Date.new(2017,1,6),
    "amount" => 35,
    "category_id" => c6.id,
    "vendor_id" => v6.id
    "budget" => nil
    })
  t7 = Transaction.new({
    "transaction_date" => Date.new(2017,1,7),
    "amount" => 45,
    "category_id" => c7.id,
    "vendor_id" => v7.id
    })
  t8 = Transaction.new({
    "transaction_date" => Date.new(2017,1,8),
    "amount" => 300,
    "category_id" => c8.id,
    "vendor_id" => v8.id
    })
  t9 = Transaction.new({
    "transaction_date" => Date.new(2017,2,9),
    "amount" => 250,
    "category_id" => c9.id,
    "vendor_id" => v9.id
    })
  t10 = Transaction.new({
    "transaction_date" => Date.new(2017,2,10),
    "amount" => 200,
    "category_id" => c10.id,
    "vendor_id" => v10.id
    })
  t11 = Transaction.new({
    "transaction_date" => Date.new(2017,3,11),
    "amount" => 150,
    "category_id" => c11.id,
    "vendor_id" => v11.id
    })

t1.save
t2.save
t3.save
t4.save
t5.save
t6.save
t7.save
t8.save
t9.save
t10.save
t11.save

binding.pry
nil
