namespace :excel do
    task list: :environment do 
        data = Listokpd.to_excel
        filename = "listokpds_#{Time.now.strftime('%Y%m%d_%H%M%S')}.xls"
        filepath = Rails.root.join("public", filename)
    
        File.open(filepath, 'w') { |f| f.write(data) }
    
        puts "Файл успешно создан: #{filepath}"
    end

    task ex_list: :environment do
        require 'csv'
    
        filename = "listokpds_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
        filepath = Rails.root.join('public', filename)
    
        Axlsx::Package.new do |p|
          p.workbook.add_worksheet(name: 'Listokpds') do |sheet|
            sheet.add_row ['id', 'okpd_2', 'trans_2', 'okpd_4', 'trans_4', 'okpd_6', 'trans_6', 'okpd_9', 'trans_9', 'notes', 'dep_1440', 'notes_1440', 'nic', 'full_name', 'prod_direct', 'created_at', 'updated_at', 'ekb', 'thematically_fixed', 'id_direction']
            Listokpd.all.each do |listokpd|
              sheet.add_row [listokpd.id, listokpd.okpd_2, listokpd.trans_2, listokpd.okpd_4, listokpd.trans_4, listokpd.okpd_6, listokpd.trans_6, listokpd.okpd_9, listokpd.trans_9, listokpd.notes, listokpd.dep_1440, listokpd.notes_1440, listokpd.nic, listokpd.full_name, listokpd.prod_direct, listokpd.created_at, listokpd.updated_at, listokpd.ekb, listokpd.thematically_fixed, listokpd.id_direction]
            end
          end
          p.serialize(filepath.to_s)
        end
    
        puts "Excel file generated at: #{filepath}"
      end

end
