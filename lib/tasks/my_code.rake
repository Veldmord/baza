namespace :my do
    task prod_temp: :environment do 
        monthly_quarters = ["2022", "1/2023", "2/2022", "3/2023", "4/2023"]
        prod_dist = ProductDirection.pluck(:id_direction).uniq
        monthly_quarters.each do |monthly_quarter|
            prod_dist.each do |prod_d|
                sum_total = 0
                okpds = Listokpd.where(id_direction: prod_d).pluck(:okpd_9)
                temp_filt = Temp.where(monthly_quarter: monthly_quarter, okpd: okpds)
                puts prod_d
                # Создаем или находим запись в таблице Add и сохраняем сумму
                table_prod = SumDirect.find_or_create_by!(monthly_quarter: monthly_quarter, id_direction: prod_d)
                columns = [:op_cost, :ip_cost, :sum_cost, :op_quantity, :ip_quantity, :sum_quantity, :export_cost, :export_quantity, :import_cost, :import_quantity, :prom_cost, :prom_quantity, :market_volume]
                #columns = [:market_volume]
                columns.each do |column|
                    sum = temp_filt.pluck(column).compact.sum
                    table_prod.send("#{column}=", sum)
                    puts sum
                end
                table_prod.save!
            end
        end
    end

    task tet: :environment do 
        monthly_quarters = ["2022", "1/2023", "2/2022", "3/2023", "4/2023"]
        prod_dist = ProductDirection.pluck(:id_direction).uniq
        monthly_quarters.each do |monthly_quarter|
            prod_dist.each do |prod_d|
                sum_total = 0
                okpds = Listokpd.where(id_direction: prod_d).pluck(:okpd_9)
                temp_filt = Temp.where(monthly_quarter: monthly_quarter, okpd: okpds)
              
                # Создаем или находим запись в таблице Add и сохраняем сумму
                table_prod = SumDirect.find_or_create_by!(monthly_quarter: monthly_quarter, id_direction: prod_d)
                columns = [:op_cost, :ip_cost, :sum_cost, :op_quantity, :ip_quantity, :sum_quantity, :export_cost, :export_quantity, :import_cost, :import_quantity, :prom_cost, :prom_quantity, :market_volume]
                #columns = [:market_volume]
                columns.each do |column|
                    sum = temp_filt.pluck(column).compact.sum
                    table_prod.send("#{column}=", sum)
                end
                table_prod.save!
            end
        end
    end

    task sum_year: :environment do 
        monthly_quarters = ["2022", "2023"]
        prod_dist = SumDirect.pluck(:id_direction).uniq
        monthly_quarters.each do |monthly_quarter|
            prod_dist.each do |prod_d|
                temp_filt = SumDirect.where("monthly_quarter Like ? and id_direction = ?", "%#{monthly_quarter}", prod_d)
                table_prod = SumDirect.find_or_create_by!(monthly_quarter: monthly_quarter, id_direction: prod_d)
                columns = [:op_cost, :ip_cost, :sum_cost, :op_quantity, :ip_quantity, :sum_quantity, :export_cost, :export_quantity, :import_cost, :import_quantity, :prom_cost, :prom_quantity, :market_volume]
                #columns = [:market_volume]
                columns.each do |column|
                    sum = temp_filt.pluck(column).compact.sum
                    table_prod.send("#{column}=", sum)
                end
                table_prod.save!
            end
        end
    end

    desc "Заполняет поле okpd_rang в зависимости от длины okpd (учитывая разделители)"
    task update_okpd_rang: :environment do
        TempYear.find_each do |record|
            okpd_length = record.okpd.gsub(/[^0-9]/, '').length # Удаляем разделители перед подсчетом
            record.update_column(:okpd_rang, okpd_length == 6 ? 6 : 9)
        end
        puts "Поле okpd_rang успешно обновлено."
    end

    desc "Рассчитывает критичность для 9-значных окпд и заполняет поле critical"
    task :calculate_criticality => :environment do
        TempYear.where(okpd_rang: 9).find_each do |record|
            criticality = record.import_cost - record.export_cost
            record.update_column(:critical, criticality > 1_000_000_000)
        end
        puts "Поле critical успешно обновлено для 9-значных окпд."
    end
end