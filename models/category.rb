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
    category_hash = SqlRunner(sql, [id])
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



end
