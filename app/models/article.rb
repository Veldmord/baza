class Article < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true, length: {maximum: 10}
end
