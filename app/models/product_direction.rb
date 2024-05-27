class ProductDirection < ApplicationRecord
    has_many :listokpds, foreign_key: "id_direction"
end
