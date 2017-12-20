require_relative('../db/sql_runner')

class Category

  attr_reader :id, :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save
    sql = "INSERT INTO categories (name)
    VALUES ($1) RETURNING *"
    @id = SqlRunner.run(sql, [@name]).first['id'].to_i
  end

  def update
    sql = "UPDATE categories set (name) = ($1)"
    SqlRunner.run(sql, [@name])
  end

  def Category.delete_all
    sql = "DELETE FROM categories"
    SqlRunner.run(sql)
  end

  def Category.all
    sql = "SELECT * FROM categories"
    categories_hashes = SqlRunner.run(sql)
    return categories_hashes.map {
      |category| Category.new(category) }
  end

  def Category.find(id)
    sql = "SELECT * FROM categories WHERE id = $1"
    category_hash = SqlRunner.run(sql, [id])
    return Category.new(category_hash.first)
  end

  def Category.delete(id)
    sql = "DELETE FROM categories WHERE id = $1"
    SqlRunner.run(sql, [id])
  end

  def amount_spent
    sql = "SELECT SUM(amount) FROM transactions where category_id = $1"
    return SqlRunner.run(sql, [@id]).first['sum'].to_i
  end

  def transaction
    sql = "SELECT * FROM transactions where category_id =  $1"
    result = SqlRunner.run(sql, [@id])
    return Transaction.new(result.first)
  end

  def budget
    sql =  "SELECT * FROM budgets where category_id = $1"
    result = SqlRunner.run(sql, [@id])
    if result.count > 0
      return Budget.new(result.first)
    end
  end

  def Category.find_transactions(category_id)
    sql = "select * from transactions inner join categories on
    transactions.category_id = categories.id where category_id = $1"
    hashes = SqlRunner.run(sql, [category_id])
    return hashes.map {
      |transaction| Transaction.new(transaction)}
  end

  def Category.total_transactions(category_id)
    sql = "select SUM(amount) from transactions inner join categories on
    transactions.category_id = categories.id where category_id = $1"
    return SqlRunner.run(sql, [category_id]).first['sum'].to_f
  end



  def Category.any_transactions?(category_id)
    result = Category.find_transactions(category_id)
    if result.length > 0
      return false
    else
      return true
    end
  end
  # def budget_exist?
  # sql =  "SELECT * FROM budgets where category_id = $1"
  #   budget_hash = SqlRunner.run(sql, [@id])
  #   if budget_hash ==  nil
  #     return false
  #   else
  #     return true
  #   end
  # end

  # def budget_exist?
  #   sql = "SELECT * FROM  budgets"
  #

  # def Category.budget_exist?(id)
  #   categories = Category.all
  #   ids = categories.map { |category|  category.id }
  #   return ids.include?(id)
  # end


end
