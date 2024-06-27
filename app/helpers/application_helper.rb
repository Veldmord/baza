module ApplicationHelper
    def format_rub(amount)
        "#{number_with_delimiter(amount.to_i, delimiter: ' ')} ₽"
    end

    def sort_indicator(column)
      return unless column == sort_column
  
      direction = sort_direction == "asc" ? "▲" : "▼"
      " <span class='sort-indicator'>#{direction}</span>"
    end
end
