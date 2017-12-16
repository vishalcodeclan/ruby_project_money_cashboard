require_relative('../db/sql_runner')

class Transaction

  attr_reader :id, :transaction_date, :amount, :category_id, :vendor_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @transaction_date = options['transaction_date']
    @amount = options['amount'].to_i
    @category_id = options['category_id'].to_i
    @vendor_id = options['vendor_id'].to_i
  end

  def save
    sql = "INSERT INTO transactions
    (transaction_date, amount, category_id, vendor_id)
    VALUES ($1, $2, $3, $4) RETURNING *"
    values = [@transaction_date, @amount, @category_id, @vendor_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def Transaction.delete_all
    sql = "DELETE FROM transactions"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE transactions SET
    (transaction_date, amount, category_id, vendor_id)
    = ($1, $2, $3, $4)"
    values = [@transaction_date, @amount, @category_id, @vendor_id]
    SqlRunner.run(sql, values)
  end

  def Transaction.all
    sql = "SELECT * FROM transactions"
    transactions_hashes = SqlRunner.run(sql)
    return transactions_hashes.map {
      |transaction| Transaction.new(transaction) }
  end

  def Transaction.find(id)
    sql = "SELECT * FROM transactions WHERE id = $1"
    transaction_hash = SqlRunner.run(sql, [id]).first
    return Transaction.new(transaction_hash)
  end

  def Transaction.delete(id)
    sql = "DELETE FROM transactions WHERE id = $1"
    SqlRunner.run(sql, [id])
  end

  def Transaction.total_amount_spent
    sql = "SELECT SUM(amount) FROM transactions"
    return SqlRunner.run(sql).first['sum'].to_i
  end

  def Transaction.total_amount_spent_month(month)
    sql = "SELECT SUM(amount) FROM transactions
    WHERE EXTRACT(MONTH FROM transaction_date) = $1"
    return SqlRunner.run(sql, [month]).first['sum'].to_i
  end

  def category
    sql = "SELECT * from categories where id = $1"
    values = [@category_id]
    result = SqlRunner.run(sql, values)
    return Category.new(result.first)
  end

  def vendor
    sql = "SELECT * from vendors where id = $1"
    values = [@vendor_id]
    result = SqlRunner.run(sql, values)
    return Vendor.new(result.first)
  end

  def budget
    sql = "SELECT * from budgets where category_id = $1"
    values = [@category_id]
    result = SqlRunner.run(sql, values)
    return Budget.new(result.first)
  end




end
