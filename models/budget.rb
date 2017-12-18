require_relative('../db/sql_runner')
require('pry')

class Budget

  attr_reader :id, :amount_set, :start_date, :end_date, :category_id, :total

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount_set = options['amount_set'].to_i
    @start_date = options['start_date']
    @end_date= options['end_date']
    @category_id = options['category_id'].to_i
  end

  def save
    sql = "INSERT INTO budgets
    (amount_set, start_date, end_date, category_id)
    VALUES ($1, $2, $3, $4) RETURNING *"
    values = [@amount_set, @start_date, @end_date, @category_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end


  def Budget.delete_all
    sql = "DELETE FROM budgets"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE budgets SET
    (amount_set, start_date, end_date, category_id)
    = ($1, $2, $3, $4) WHERE id = $5"
    values = [@amount_set, @start_date, @end_date, @category_id,  @id]
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

  def Budget.monthly(month)
    sql = "SELECT SUM(amount_set) FROM budgets
    WHERE EXTRACT(MONTH FROM end_date) = $1"
    return SqlRunner.run(sql, [month]).first['sum'].to_i
  end

  def Budget.find_by_month(month)
    sql = "SELECT * FROM budgets
    WHERE EXTRACT(MONTH FROM start_date) = $1"
    hashes = SqlRunner.run(sql, [month])
    return hashes.map {
      |budget| Budget.new(budget) }
  end

  def Budget.find_date_range(start_month, end_month)
    sql = "SELECT * FROM budgets WHERE
    start_date >= $1 AND end_date <= $2;"
    hashes = SqlRunner.run(sql, [start_month, end_month])
    return hashes.map {
      |transaction| Budget.new(transaction) }
    end

    def Budget.total_date_range(start_month, end_month)
      sql = "SELECT SUM(amount_set) FROM budgets WHERE
      EXTRACT(MONTH FROM start_date) >= $1 AND
      EXTRACT(MONTH FROM end_date) <= $2;"
      return SqlRunner.run(sql, [start_month, end_month]).first['sum'].to_i
      end

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

end
