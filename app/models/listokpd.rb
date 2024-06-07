class Listokpd < ApplicationRecord
    #has_many :fz223s, foreign_key: "okpd"
    #has_many :okpds, class_name: "Okpd", foreign_key: "OKPD9"
    belongs_to :product_ditections, foreign_key: "id_direction", :class_name => "ProductDirection"

    def self.to_excel
        attributes = %w{
            id 
            okpd_2 
            trans_2 
            okpd_4
            trans_4
            okpd_6
            trans_6
            okpd_9
            trans_9
            notes
            dep_1440
            notes_1440
            nic
            full_name
            prod_direct
            created_at
            updated_at
            ekb
            thematically_fixed
            id_direction
        }

        CSV.generate(col_sep: "\t", encoding: "UTF-8") do |csv|
          csv << attributes
    
          all.find_each do |listokpd|
            csv << attributes.map{ |attr| listokpd.send(attr) }
          end
        end
    end

end
