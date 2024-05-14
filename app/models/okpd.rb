class Okpd < ApplicationRecord
    has_many :customs, class_name: "Custom", foreign_key: "TNVD" 
    belongs_to :listokpd, class_name: "Listokpd",foreign_key: "okpd_9"
end
