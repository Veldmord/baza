module ApplicationHelper
    def format_rub(amount)
        "#{number_with_delimiter(amount.to_i, delimiter: ' ')} ₽"
      end
end
