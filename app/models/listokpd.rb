class Listokpd < ApplicationRecord
    #has_many :fz223s, foreign_key: "okpd"
    has_many :okpds, class_name: "Okpd", foreign_key: "OKPD9"
end
