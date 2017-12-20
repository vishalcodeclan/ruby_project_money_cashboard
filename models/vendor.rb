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
    sql = "UPDATE vendors set name = $1 where id = $2"
    SqlRunner.run(sql, [@name, @id])
  end

  def Vendor.all
    sql = "SELECT * FROM vendors"
    vendors_hashes = SqlRunner.run(sql)
    return vendors_hashes.map {
      |vendor| Vendor.new(vendor) }
  end

  def Vendor.find_transactions(vendor_id)
    sql = "select * from transactions inner join vendors on
    transactions.vendor_id = vendors.id where vendor_id = $1"
    hashes = SqlRunner.run(sql, [vendor_id])
    return hashes.map {
      |transaction| Transaction.new(transaction)}
  end

  def Vendor.total_transactions(vendor_id)
    sql = "select SUM(amount) from transactions inner join vendors on
    transactions.vendor_id = vendors.id where vendor_id = $1"
    return SqlRunner.run(sql, [vendor_id]).first['sum'].to_f
  end

  def Vendor.find(id)
    sql = "SELECT * FROM vendors WHERE id = $1"
    vendor_hash = SqlRunner.run(sql, [id])
    return Vendor.new(vendor_hash.first)
  end

  def Vendor.find_name?(name)
    sql = "SELECT * FROM vendors"
    vendors_hashes = SqlRunner.run(sql)
    vendors = vendors_hashes.map {
      |vendor1| Vendor.new(vendor1) }
    for  vendor in vendors
      if vendor.name == name
        return true
      end
    end
      return false
  end

  def Vendor.any_transactions?(vendor_id)
    result = Vendor.find_transactions(vendor_id)
    if result.length > 0
      return false
    else
      return true
    end
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
