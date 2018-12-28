require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      require_keys = %w(payee amount)
      require_keys.each do |key|
        unless expense.key?(key)
          message = "Invalid expense: `#{key}` is required"
          return RecordResult.new(false, nil, message)
        end
      end

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end
  end
end
