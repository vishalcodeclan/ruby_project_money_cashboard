require_relative('../models/category')
require_relative('../models/transaction')
require_relative('../models/vendor')
require_relative('../models/budget')
require('pry-byebug')
require('date')

Transaction.delete_all
Budget.delete_all
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
v9 = Vendor.new({"name" => "Expedia"})
v10 = Vendor.new({"name" => "Skyscanner"})
v11 = Vendor.new({"name" => "Jack Wills"})

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
  "amount_set" => 300.00,
  "start_date" => Date.new(2017,1),
  "category_id" => c1.id
  })

  b2 = Budget.new({
    "amount_set" => 400.00,
    "start_date" => Date.new(2017,2),
    "category_id" => c1.id
    })

    b3 = Budget.new({
      "amount_set" => 100.00,
      "start_date" => Date.new(2017,1),
      "category_id" => c2.id
      })

      b4 = Budget.new({
        "amount_set" => 100.00,
        "start_date" => Date.new(2017,2),
        "category_id" => c2.id
        })

        b5 = Budget.new({
          "amount_set" => 200.00,
          "start_date" => Date.new(2017,1),
          "category_id" => c3.id
          })

          b6 = Budget.new({
            "amount_set" => 300.00,
            "start_date" => Date.new(2017,2),
            "category_id" => c3.id
            })

            b7 = Budget.new({
              "amount_set" => 500.00,
              "start_date" => Date.new(2017,1),
              "category_id" => c4.id
              })

              b8 = Budget.new({
                "amount_set" => 600.00,
                "start_date" => Date.new(2017,2),
                "category_id" => c4.id
                })

                b9 = Budget.new({
                  "amount_set" => 300.00,
                  "start_date" => Date.new(2018,1),
                  "category_id" => c5.id
                  })

                  b10 = Budget.new({
                    "amount_set" => 500.00,
                    "start_date" => Date.new(2018,1),
                    "category_id" => c5.id
                    })

                    b11 = Budget.new({
                      "amount_set" => 600.00,
                      "start_date" => Date.new(2018,2),
                      "category_id" => c5.id
                      })





b1.save
b2.save
b3.save
b4.save
b5.save
b6.save
b7.save
b8.save
b9.save
b10.save
b11.save

t1 = Transaction.new({
  "transaction_date" => Date.new(2017,1,2),
  "amount" => 10.50,
  "category_id" => c1.id,
  "vendor_id" => v1.id
  })

  t2 = Transaction.new({
    "transaction_date" => Date.new(2017,1,2),
    "amount" => 15.50,
    "category_id" => c1.id,
    "vendor_id" => v1.id
    })
  t3 = Transaction.new({
    "transaction_date" => Date.new(2017,1,3),
    "amount" => 30.50,
    "category_id" => c2.id,
    "vendor_id" => v1.id
    })
  t4 = Transaction.new({
    "transaction_date" => Date.new(2017,1,4),
    "amount" => 18.40,
    "category_id" => c2.id,
    "vendor_id" => v4.id
    })
  t5 = Transaction.new({
    "transaction_date" => Date.new(2017,1,5),
    "amount" => 40.79,
    "category_id" => c3.id,
    "vendor_id" => v5.id
    })
  t6 = Transaction.new({
    "transaction_date" => Date.new(2017,2,6),
    "amount" => 35.79,
    "category_id" => c3.id,
    "vendor_id" => v6.id
    })
  t7 = Transaction.new({
    "transaction_date" => Date.new(2017,2,7),
    "amount" => 45.21,
    "category_id" => c4.id,
    "vendor_id" => v7.id
    })
  t8 = Transaction.new({
    "transaction_date" => Date.new(2017,2,8),
    "amount" => 30.41,
    "category_id" => c4.id,
    "vendor_id" => v8.id
    })
  t9 = Transaction.new({
    "transaction_date" => Date.new(2017,2,9),
    "amount" => 25.31,
    "category_id" => c5.id,
    "vendor_id" => v8.id
    })
  t10 = Transaction.new({
    "transaction_date" => Date.new(2017,3,10),
    "amount" => 20.21,
    "category_id" => c5.id,
    "vendor_id" => v10.id
    })
  t11 = Transaction.new({
    "transaction_date" => Date.new(2017,3,11),
    "amount" => 15.55,
    "category_id" => c5.id,
    "vendor_id" => v11.id
    })

    t12 = Transaction.new({
      "transaction_date" => Date.new(2018,1,11),
      "amount" => 15.55,
      "category_id" => c5.id,
      "vendor_id" => v11.id
      })

      t13 = Transaction.new({
        "transaction_date" => Date.new(2018,1,11),
        "amount" => 15.55,
        "category_id" => c5.id,
        "vendor_id" => v11.id
        })

        t14 = Transaction.new({
          "transaction_date" => Date.new(2018,2,11),
          "amount" => 15.55,
          "category_id" => c5.id,
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
t12.save
t13.save
t14.save

# Transaction.unique_dates_string
# Transaction.find_multiple_by_month_year("2017-01-01", "2019-01-01")
# Transaction.find_date_range('2017-01-01', '2017-02-01')

# Budget.find_by_month_year("2017-01-15")
# Budget.balance_find_multiple_by_month_year('2017-01-01', '2017-01-30')
binding.pry
nil
