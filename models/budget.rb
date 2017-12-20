require_relative('../db/sql_runner')
require('pry')
require('date')

class Budget

  attr_reader :id, :amount_set, :start_date, :end_date, :category_id, :total

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount_set = options['amount_set'].to_f
    @start_date = options['start_date']
    @category_id = options['category_id'].to_i
  end

  def save
    sql = "INSERT INTO budgets
    (amount_set, start_date, category_id)
    VALUES ($1, $2, $3) RETURNING *"
    values = [@amount_set, @start_date, @category_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end


  def Budget.delete_all
    sql = "DELETE FROM budgets"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE budgets SET
    (amount_set, start_date, category_id)
    = ($1, $2, $3) WHERE id = $4"
    values = [@amount_set, @start_date, @category_id,  @id]
    SqlRunner.run(sql, values)
  end

  def category
    sql = "SELECT * from categories where id = $1"
    values = [@category_id]
    result = SqlRunner.run(sql, values)
    return Category.new(result.first)
  end

  def Budget.all
    sql = "SELECT * FROM budgets"
    budgets_hashes = SqlRunner.run(sql)
    return budgets_hashes.map {
      |budget| Budget.new(budget) }
  end

  def Budget.find(id)
    sql = "SELECT * FROM budgets WHERE id = $1"
    budget_hash = SqlRunner.run(sql, [id])
    return Budget.new(budget_hash.first)
  end

  def Budget.delete(id)
    sql = "DELETE FROM budgets WHERE id = $1"
    SqlRunner.run(sql, [id])
  end

  def Budget.total
    sql = "SELECT SUM(amount_set) FROM budgets"
    return SqlRunner.run(sql).first['sum'].to_i
  end

  def Budget.monthly(date)
    sql = "SELECT SUM(amount_set) FROM budgets
    WHERE start_date = $1"
    return SqlRunner.run(sql, [date]).first['sum'].to_i
  end

  def Budget.find_by_month_year(date)
    sql = "SELECT * FROM budgets
    WHERE start_date = $1"
    hashes = SqlRunner.run(sql, [date])
    result = hashes.map {
      |budget| Budget.new(budget) }
      return result
  end

  def Budget.find_multiple_by_month_year(date1, date2)
    sql = "SELECT * FROM budgets
    WHERE start_date >= $1 and start_date <= $2"
    hashes = SqlRunner.run(sql, [date1, date2])
    result = hashes.map {
      |budget| Budget.new(budget) }
      return result
  end



  # def Budget.find_multiple_by_month_year(date1, date2)
  #   parsed_date1 = Date.parse(date1)
  #   parsed_date2 = Date.parse(date2)
  #
  #   year = parsed_date.strftime("%Y")
  #   month = parsed_date.strftime("%m")
  #
  #
  # end

  def Budget.total_by_month_year(date)
    budgets_objects = Budget.find_by_month_year(date)
    budgets_array = budgets_objects.map { |budget| budget.amount_set }
    counter = 0.0
    budgets_array.each { |budget| counter += budget }
    return counter
  end

  def Budget.total_multiple_by_month_year(date1, date2)
    budgets_objects = Budget.find_multiple_by_month_year(date1, date2)
    budgets_array = budgets_objects.map { |budget| budget.amount_set }
    counter = 0.0
    budgets_array.each { |budget| counter += budget }
    return counter
  end


  def Budget.unique_dates_string
    sql = "SELECT * FROM budgets"
    result = SqlRunner.run(sql)
    result1 = result.map {
      |budget| Budget.new(budget) }
    array_dates = result1.map { |budget| budget.start_date}
    unique_dates = array_dates.uniq
    result2 = unique_dates.map { |date1| Date.parse(date1)}
    # result3 = result2.map { |date2| date2.strftime("%Y-%m")}
    return result2
  end

  def Budget.return_unique_month_array

    array_dates = Budget.unique_dates_string
    result = array_dates.map { |date2| date2.strftime("%Y-%m")}
    # return result[0].to_i
    # result1 = result.map { |date| date.to_i }
    return result
    # return result1
    # return result1[0]
  end


  # def Budget.find_date_range(start_month, end_month)
  #   sql = "SELECT * FROM budgets WHERE
  #   start_date >= $1 AND end_date <= $2;"
  #   hashes = SqlRunner.run(sql, [start_month, end_month])
  #   return hashes.map {
  #     |transaction| Budget.new(transaction) }
  #   end
  #
  #   def Budget.total_date_range(start_month, end_month)
  #     sql = "SELECT SUM(amount_set) FROM budgets WHERE
  #     EXTRACT(MONTH FROM start_date) >= $1 AND
  #     EXTRACT(MONTH FROM end_date) <= $2;"
  #     return SqlRunner.run(sql, [start_month, end_month]).first['sum'].to_i
  #     end

  def above_budget(month)
    sql = "SELECT * from transactions INNER JOIN budgets
    ON transactions.category_id = budgets.category_id
    WHERE EXTRACT(MONTH FROM transaction_date) = $1;"
    hashes = SqlRunner.run(sql, [month])
    array_expenditures = hashes.map { |hash| hash['amount'].to_i }
    total_expenditure = 0
    array_expenditures.each { |amount1| total_expenditure += amount1}
    if total_expenditure > hashes.first['amount_set'].to_i
      return "Budget exceeded by
      #{total_expenditure - hashes.first['amount_set'].to_i}"
    else
      return "Budget not exceeded, there is still
      #{hashes.first['amount_set'].to_i - total_expenditure}
      remaining to spend"
    end
  end



  # def Budget.full_view
  #   sql = "select * from transactions inner join
  #   budgets ON transactions.category_id =
  #   budgets.category_id INNER JOIN vendors
  #   ON vendors.id = transactions.vendor_id
  #   INNER JOIN categories ON categories.id =
  #   transactions.category_id;"


  def total_spend
    parsed_date = Date.parse(@start_date)
    year = parsed_date.strftime("%Y")
    month = parsed_date.strftime("%m")
    # year = @start_date.strftime("%Y")
    # month = @start_date.strftime("%m")
    sql = "select * from transactions where extract(month
    from transaction_date) = $1 and
    extract(year from transaction_date) = $2 and category_id = $3"
    hashes = SqlRunner.run(sql, [month, year, @category_id])
    result = hashes.map {
      |transaction| Transaction.new(transaction) }
    transaction_array = result.map { |transaction|
        transaction.amount }
    counter = 0.0
    transaction_array.each { |transaction| counter += transaction }
    return counter
  end


  # def Transaction.find_by_month_year(date)
  #   parsed_date = Date.parse(date)
  #   year = parsed_date.strftime("%Y")
  #   month = parsed_date.strftime("%m")
  #   sql = "select * from transactions where extract(month
  #   from transaction_date) = $1 and
  #   extract(year from transaction_date) = $2;"
  #   hashes = SqlRunner.run(sql, [month, year])
  #   return hashes.map {
  #     |transaction| Transaction.new(transaction) }
  #   end
  #
  #
  #   def Transaction.total_by_month_year(date)
  #     transaction_objects = Transaction.find_by_month_year(date)
  #     transaction_array = transaction_objects.map { |transaction|
  #       transaction.amount }
  #     counter = 0.0
  #     transaction_array.each { |transaction| counter += transaction }
  #     return counter
  #   end

  def Budget.find_by_category(category_id)
    sql = "select * from budgets inner join
    categories on budgets.category_id = categories.id
    where category_id = $1;"
    hashes = SqlRunner.run(sql, [category_id])
    return hashes.map {
      |budget| Budget.new(budget)}
    end

    def Budget.total_by_category(category_id)
      sql = "SELECT SUM(amount_set) FROM budgets INNER JOIN categories
      ON budgets.category_id = categories.id
      WHERE category_id = $1"
      return SqlRunner.run(sql, [category_id]).first['sum'].to_f
    end


end
