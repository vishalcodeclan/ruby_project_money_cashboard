require_relative('../db/sql_runner')

class Vendor

  attr_reader :id, :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save
    sql = "INSERT INTO vendors (name)
    VALUES ($1) RETURNING *"
    @id = SqlRunner.run(sql, [@name]).first['id'].to_i
  end

  def Vendor.delete_all
    sql = "DELETE FROM vendors"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE vendors set (name) = ($1)"
    SqlRunner.run(sql, [@name])
  end

  def Vendor.all
    sql = "SELECT * FROM vendors"
    vendors_hashes = SqlRunner.run(sql)
    return vendors_hashes.map {
      |vendor| Vendor.new(vendor) }
  end

  def Vendor.find(id)
    sql = "SELECT * FROM vendors WHERE id = $1"
    vendor_hash = SqlRunner(sql, [id])
    return Vendor.new(vendor_hash.first)
  end

  def Vendor.delete(id)
    sql = "DELETE FROM vendors WHERE id = $1"
    SqlRunner.run(sql, [id])
  end

  def amount_spent
    sql = "SELECT SUM(amount) FROM transactions where vendor_id = $1"
    return SqlRunner.run(sql, [@id]).first['sum'].to_i
  end

end
