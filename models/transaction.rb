require_relative('../db/sql_runner')
require('pry-byebug')
require('date')

class Transaction

  attr_reader :id, :transaction_date, :amount, :category_id, :vendor_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @transaction_date = options['transaction_date']
    @amount = options['amount'].to_f
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

  # def check_budget?
  #   sql = "select * from budgets"
  #   result = SqlRunner.run(sql)
  #   budgets = result.map {
  #     |budget| Budget.new(budget) }
  #   for budget in budgets
  #     return true if budget.category_id == @category_id
  #   end
  #   return false
  # end

  # def check_budget?
  #   sql = "select * from budgets"
  #   result = SqlRunner.run(sql)
  #   budgets = result.map {
  #     |budget| Budget.new(budget) }
  #     for budget in budgets
  #       if budget.category_id == @category_id &&
  #         (Date.parse(@transaction_date) >= Date.parse(budget.start_date)) &&
  #         (Date.parse(@transaction_date) <= Date.parse(budget.end_date))
  #         return true
  #       end
  #     end
  #       return false
  #     end

      # def check_budget?
      #   sql = "select * from budgets"
      #   result = SqlRunner.run(sql)
      #   budgets = result.map {
      #     |budget| Budget.new(budget) }
      #     for budget in budgets
      #       if budget.category_id == @category_id &&
      #         (@transaction_date >= Date.parse(budget.start_date)) &&
      #         (@transaction_date <= Date.parse(budget.end_date))
      #         return true
      #       end
      #     end
      #       return false
      #     end
      def check_budget?
        sql = "select * from budgets"
        result = SqlRunner.run(sql)
        budgets = result.map {
          |budget| Budget.new(budget) }
          for budget in budgets
            if budget.category_id == @category_id &&
              @amount < (budget.amount_set - Transaction.total_by_category(@category_id))
              return true
            end
          end
            return false
          end

          # def check_vendor_exists?
          #   sql = "select * from vendors"
          #   result = SqlRunner.run(sql)
          #   vendors = result.map {
          #     |vendor| Vendor.new(vendor) }

def Transaction.delete_all
  sql = "DELETE FROM transactions"
  SqlRunner.run(sql)
end

def update
  sql = "UPDATE transactions SET
  (transaction_date, amount, category_id, vendor_id)
  = ($1, $2, $3, $4) WHERE id = $5"
  values = [@transaction_date, @amount, @category_id, @vendor_id, @id]
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

  def Transaction.month(date)
    parsed_date = Date.parse(date)
    return parsed_date.strftime("%m")
  end

  def Transaction.year(date)
    parsed_date = Date.parse(date)
    return parsed_date.strftime("%Y")
  end

  def Transaction.find_by_month_year(date)
    parsed_date = Date.parse(date)
    year = parsed_date.strftime("%Y")
    month = parsed_date.strftime("%m")
    sql = "select * from transactions where extract(month
    from transaction_date) = $1 and
    extract(year from transaction_date) = $2;"
    hashes = SqlRunner.run(sql, [month, year])
    return hashes.map {
      |transaction| Transaction.new(transaction) }
    end


    def Transaction.total_by_month_year(date)
      transaction_objects = Transaction.find_by_month_year(date)
      transaction_array = transaction_objects.map { |transaction|
        transaction.amount }
      counter = 0.0
      transaction_array.each { |transaction| counter += transaction }
      return counter
    end

  



    #
    # def Transaction.find_by_month_year(date)
    #   sql = "SELECT * FROM transactions
    #   WHERE EXTRACT(MONTH FROM transaction_date) = $1"
    #   hashes = SqlRunner.run(sql, [date])
    #   return hashes.map {
    #     |transaction| Transaction.new(transaction) }
    #   end

    def Transaction.find_by_category(category)
      sql = "SELECT * FROM transactions INNER JOIN categories
      ON transactions.category_id = categories.id
      WHERE name = $1"
      hashes = SqlRunner.run(sql, [category])
      return hashes.map {
        |transaction| Transaction.new(transaction)}
      end

      def Transaction.total_by_category(category)
        sql = "SELECT SUM(amount) FROM transactions INNER JOIN categories
        ON transactions.category_id = categories.id
        WHERE name = $1"
        return SqlRunner.run(sql, [category]).first['sum'].to_i
      end



      def Transaction.delete(id)
        sql = "DELETE FROM transactions WHERE id = $1"
        SqlRunner.run(sql, [id])
      end

      def delete
        sql = "DELETE FROM transactions WHERE id = $1"
        SqlRunner.run(sql, [@id])
      end

      def Transaction.total_amount_spent
        sql = "SELECT SUM(amount) FROM transactions"
        return SqlRunner.run(sql).first['sum'].to_i
      end

      def Transaction.total_amount_budget_exists
        sql = "SELECT * from transactions INNER JOIN budgets
        ON transactions.category_id = budgets.category_id"
        hashes = SqlRunner.run(sql)
        array_expenditures = hashes.map { |hash| hash['amount'].to_i }
        total_expenditure = 0
        array_expenditures.each { |amount1| total_expenditure += amount1}
        return total_expenditure
      end

      def Transaction.total_amount_spent_month(month)
        sql = "SELECT SUM(amount) FROM transactions
        WHERE EXTRACT(MONTH FROM transaction_date) = $1"
        return SqlRunner.run(sql, [month]).first['sum'].to_i
      end

      # def Transaction.find_date_range(start_month, end_month)
      #   sql = "SELECT * FROM transactions WHERE
      #   EXTRACT(MONTH FROM transaction_date) >= $1 AND
      #   EXTRACT(MONTH FROM transaction_date) <= $2;"
      #   hashes = SqlRunner.run(sql, [start_month, end_month])
      #   return hashes.map {
      #     |transaction| Transaction.new(transaction) }
      #   end

      # def Transaction.find_date_range(start_month, end_month)
      #   sql = "SELECT * FROM transactions WHERE
      #   transaction_date >= $1 AND
      #   transaction_date <= $2;"
      #   hashes = SqlRunner.run(sql, [start_month, end_month])
      #   return hashes.map {
      #     |transaction| Transaction.new(transaction) }
      #   end

      def Transaction.find_date_range(start_month, end_month)
        sql = "SELECT * FROM transactions WHERE transaction_date
        >= $1 AND transaction_date  <= $2;"
        hashes = SqlRunner.run(sql, [start_month, end_month])
        return hashes.map {
          |transaction| Transaction.new(transaction) }
        end


        #
        # def Transaction.find_date_range(start_month, end_month)
        #   sql = "SELECT * FROM transactions WHERE
        #   EXTRACT(MONTH FROM transaction_date) >= $1 AND
        #   EXTRACT(MONTH FROM transaction_date) <= $2;"
        #   hashes = SqlRunner.run(sql, [start_month, end_month])
        #   return hashes.map {
        #     |transaction| Transaction.new(transaction) }
        #   end

        def Transaction.total_date_range(start_month, end_month)
          sql = "SELECT SUM(amount) FROM transactions WHERE
          transaction_date >= $1 AND transaction_date <= $2;"
          return SqlRunner.run(sql, [start_month, end_month]).first['sum'].to_i
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

        def Transaction.total_budget
          sql = "SELECT SUM(amount_set) FROM budgets"
          return SqlRunner.run(sql).first['sum'].to_i
        end

  end
