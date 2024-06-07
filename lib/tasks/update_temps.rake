namespace :update_temps do
    #Астоматическая проверка на наличие ново8го квартала
    #(готово)нужно загрузить таможню за 2023 год 
    #Скрестить обновления и загрузку
    #нужна метка под только загруженные данные
    #подсчет таможни в зависимости от рег рынка
    #прогноз
    #сделать загузку кусками

    task market_vol: :environment do #подсчет 
        monthly_quarters = ["2022", "1/2023", "2/2023", "3/2023", "4/2023"]
        #okpds = Okpd.pluck(:OKPD9).uniq
        okpds = Okpd.pluck(:OKPD9).uniq
        monthly_quarters.each do |monthly_quarter|
            puts monthly_quarter
            okpds.each do |okpd|
                # Create a new temp record or update an existing one
                temp = Temp.find_or_create_by!(monthly_quarter: monthly_quarter, okpd: okpd)
                
                temp.import_cost ||=0
                temp.export_cost ||=0
                temp.prom_cost ||=0

                temp.market_volume = temp.import_cost - temp.export_cost + temp.prom_cost
                puts "#{temp.market_volume}"
                temp.save!
            end
        end
    end

    task update_second: :environment do  #появилось новое поле code_dethp
        # Код из моего предыдущего ответа идет здесь
        monthly_quarters = ["2022", "1/2023", "2/2023", "3/2023", "4/2023"]
        #okpds = Okpd.pluck(:OKPD9).uniq
        okpds = Okpd.where.not(OKPD6: "26.40").pluck(:OKPD9).uniq
        monthly_quarters.each do |monthly_quarter|
        puts monthly_quarter
        okpds.each do |okpd|
            # Create a new temp record or update an existing one
            temp = Temp.find_or_create_by!(monthly_quarter: monthly_quarter, okpd: okpd)

            # Calculate op_cost, ip_cost, sum_cost, op_quantity, ip_quantity, and sum_quantity
            op_cost = 0
            ip_cost = 0
            op_quantity = 0
            ip_quantity = 0

            Fz223.where(monthly_quarter: monthly_quarter, okpd: okpd).each do |fz223|
                if fz223.OP_IP == "ОП"
                    op_cost += fz223.Position_Amount
                    op_quantity += fz223.Quantity
                elsif fz223.OP_IP == "ИП"
                    ip_cost += fz223.Position_Amount
                    ip_quantity += fz223.Quantity
                end
            end

            Fz44.where(monthly_quarter: monthly_quarter, okpd: okpd).each do |fz44|
                if fz44.OP_IP == "ОП"
                    op_cost += fz44.Position_Amount
                    op_quantity += fz44.Quantity
                elsif fz44.OP_IP == "ИП"
                    ip_cost += fz44.Position_Amount
                    ip_quantity += fz44.Quantity
                end
            end

            temp.op_cost = op_cost
            temp.ip_cost = ip_cost
            temp.sum_cost = op_cost + ip_cost
            temp.op_quantity = op_quantity
            temp.ip_quantity = ip_quantity
            temp.sum_quantity = op_quantity + ip_quantity
            puts "#{temp.okpd} - #{temp.op_cost} - #{temp.ip_cost} - #{temp.sum_cost} - #{temp.op_quantity} - #{temp.ip_quantity} - #{temp.sum_quantity}"
            temp.save!
        end
    end
    end

    task prom_culc: :environment do #подсчет 
        proms = Prom.where("quantity IS NOT NULL OR \"cost\" IS NOT NULL")
        #puts proms.count(:id)
        proms.each do |prom|
            temp_cost = Temp.where("monthly_quarter Like ? and okpd = ?", "%#{prom.monthly_quarter.split("/")[1]}", prom.okpd).sum(:sum_cost)
            temp_quantity = Temp.where("monthly_quarter Like ? and okpd = ?", "%#{prom.monthly_quarter.split("/")[1]}", prom.okpd).sum(:sum_quantity)
            puts "temp_cost" + temp_cost.to_s
            puts "temp_quantity" + temp_quantity.to_s
            cost_per_one = temp_quantity != 0 && temp_cost != 0 ? temp_cost/temp_quantity : 0
            #puts "cost_per_one" + cost_per_one.to_s
            if prom.cost.nil? then
                prom.cost = cost_per_one != 0 ? prom.quantity * cost_per_one : nil
            else
                prom.quantity = cost_per_one != 0 ? prom.cost/cost_per_one : nil
            end
            prom.save!
        end
    end

    task custom_rate: :environment do 
        monthly_quarters = ["2022", "1/2023", "2/2023", "3/2023", "4/2023"]
        okpds = Okpd.pluck(:OKPD9).uniq
        monthly_quarters.each do |monthly_quarter|
            year = monthly_quarter.split('/').last
            puts monthly_quarter
            okpds.each do |okpd|
                # Create a new temp record or update an existing one
                temp = Temp.find_or_create_by!(monthly_quarter: monthly_quarter, okpd: okpd)

                # Calculate export_cost, export_quantity, import_cost, and import_quantity
                export_cost = 0
                export_quantity = 0
                import_cost = 0
                import_quantity = 0
                #okpd_record = 
                
                Okpd.where(OKPD9: okpd).each do |tnvd|
                    sum_okpds = 0
                    okpds_c = Okpd.where(TNVD10: tnvd.TNVD10).pluck(:OKPD9)
                    #sum_okpds += Temp.where(okpd: okpds_c, monthly_quarter: monthly_quarter).sum(:sum_cost)
                    sum_okpds += Temp.where("okpd IN (?) and monthly_quarter Like ?", okpds_c, "%#{year}%").sum(:sum_cost)
                    one_okpd = Temp.where("okpd IN (?) and monthly_quarter Like ?", okpd, "%#{year}%").sum(:sum_cost)
                    param_for_custom = (sum_okpds.to_f == 0 || one_okpd.to_f == 0) ? "0" : one_okpd.to_f / sum_okpds.to_f
                    puts "tnvd - %#{tnvd.TNVD10}%"
                    puts "one_okpd - %#{one_okpd}%"
                    puts "sum_okpds - %#{sum_okpds}%"
                    puts "param_for_custom - %#{param_for_custom}%"
                    customs = Custom.where(monthly_quarter: monthly_quarter, TNVD: tnvd.TNVD10)

                    customs.each do |customs|
                    if customs.export_import == "ЭК"
                        export_cost += customs.RUB*param_for_custom.to_f
                        export_quantity += customs.quantity*param_for_custom.to_f
                    elsif customs.export_import == "ИМ"
                        import_cost += customs.RUB*param_for_custom.to_f
                        import_quantity += customs.quantity*param_for_custom.to_f
                        
                    end
                    end
                end

                temp.export_cost = export_cost
                temp.export_quantity = export_quantity
                temp.import_cost = import_cost
                temp.import_quantity = import_quantity

                puts "export_cost - %#{export_cost}%"
                puts "export_quantity - %#{export_quantity}%"
                puts "import_cost - %#{import_cost}%"
                puts "import_quantity - %#{import_quantity}%"

                temp.save!
            end
        end
    end

    task group_data: :environment do #main
        monthly_quarters = Temp.all.pluck(:monthly_quarter).uniq
        okpds = Okpd.pluck(:OKPD9).uniq 
        all_combination = []
        
        okpds.each do |okpd|
            parts = okpd.split(".")
            current_combination = ""
            parts.each_with_index do |part, index|
                next if index == 3
                current_combination += index == 0? part : "." + part
                all_combination << current_combination
            end
        end

        #all_combination.uniq!.sort!
        all_combination.uniq!.sort! { |a, b| b.split('.').size <=> a.split('.').size }
        puts "#{all_combination.count}"
        all_combination.each do |combination|
            puts "#{combination}"
            monthly_quarters.each do |quarter|
                count_dethp = combination.split(".").count
                temp = Temp.find_or_create_by!(monthly_quarter: quarter, okpd: combination, code_dethp: count_dethp)
                #temp_filt = Temp.where("okpd Like ?", "%#{combination}%").where(monthly_quarter: quarter, code_dethp: count_dethp + 1 )
                temp_filt = Temp.where("okpd Like ? and monthly_quarter = ? and code_dethp = ?", "%#{combination}%", quarter, count_dethp +1)
                columns = [:op_cost, :ip_cost, :sum_cost, :op_quantity, :ip_quantity, :sum_quantity, :export_cost, :export_quantity, :import_cost, :import_quantity, :prom_cost, :prom_quantity, :market_volume]
                #columns = [:market_volume]
                columns.each do |column|
                    sum = temp_filt.pluck(column).compact.sum
                    temp.send("#{column}=", sum)
                end
                temp.code_dethp = count_dethp
                temp.save!
            end
        end
    end

    task up2022: :environment do #Help
        # Код из моего предыдущего ответа идет здесь
        monthly_quarter = "2022"
        okpds = Listokpd.all.pluck(:okpd_9).uniq
        okpds.each do |okpd |
            # Create a new temp record or update an existing one
            temp = Temp.find_or_create_by!(monthly_quarter: monthly_quarter, okpd: okpd)

            # Calculate op_cost, ip_cost, sum_cost, op_quantity, ip_quantity, and sum_quantity
            op_cost = 0
            ip_cost = 0
            op_quantity = 0
            ip_quantity = 0

            Fz223.where("monthly_quarter Like ?", "%#{monthly_quarter}%").where(okpd: okpd).each do |fz223|
            if fz223.OP_IP == "ОП"
                op_cost += fz223.Position_Amount
                op_quantity += fz223.Quantity
            elsif fz223.OP_IP == "ИП"
                ip_cost += fz223.Position_Amount
                ip_quantity += fz223.Quantity
            end
            end

            Fz44.where("monthly_quarter Like ?", "%#{monthly_quarter}%").where(okpd: okpd).each do |fz44|
            if fz44.OP_IP == "ОП"
                op_cost += fz44.Position_Amount
                op_quantity += fz44.Quantity
            elsif fz44.OP_IP == "ИП"
                ip_cost += fz44.Position_Amount
                ip_quantity += fz44.Quantity
            end
            end

            temp.op_cost = op_cost
            temp.ip_cost = ip_cost
            temp.sum_cost = op_cost + ip_cost
            temp.op_quantity = op_quantity
            temp.ip_quantity = ip_quantity
            temp.sum_quantity = op_quantity + ip_quantity

            temp.save!
        end
    end

    task custom: :environment do 
        monthly_quarters = ["2022", "1/2023", "2/2023", "3/2023", "4/2023"]
        okpds = Listokpd.all.pluck(:okpd_9)
        monthly_quarters.each do |monthly_quarter|
            puts monthly_quarter
            okpds.each do |okpd|
                # Create a new temp record or update an existing one
                temp = Temp.find_or_create_by!(monthly_quarter: monthly_quarter, okpd: okpd)

                # Calculate export_cost, export_quantity, import_cost, and import_quantity
                export_cost = 0
                export_quantity = 0
                import_cost = 0
                import_quantity = 0
                #okpd_record = 
                Okpd.where(OKPD9: okpd).each do |tnvd|
                    customs = Custom.where(monthly_quarter: monthly_quarter, TNVD: tnvd.TNVD10)

                    customs.each do |customs|
                    if customs.export_import == "ЭК"
                        export_cost += customs.RUB
                        export_quantity += customs.quantity
                    elsif customs.export_import == "ИМ"
                        import_cost += customs.RUB
                        import_quantity += customs.quantity
                    end
                    end
                end

                temp.export_cost = export_cost
                temp.export_quantity = export_quantity
                temp.import_cost = import_cost
                temp.import_quantity = import_quantity

                temp.save!
            end
        end
    end


    task update_first: :environment do  #появилось новое поле code_dethp
            # Код из моего предыдущего ответа идет здесь
        monthly_quarters = ["2022", "1/2023", "2/2023", "3/2023", "4/2023"]
        okpds = Listokpd.all.pluck(:okpd_9)
        monthly_quarters.each do |monthly_quarter|
            puts monthly_quarter
            okpds.each do |okpd|
                # Create a new temp record or update an existing one
                temp = Temp.find_or_create_by!(monthly_quarter: monthly_quarter, okpd: okpd)

                # Calculate op_cost, ip_cost, sum_cost, op_quantity, ip_quantity, and sum_quantity
                op_cost = 0
                ip_cost = 0
                op_quantity = 0
                ip_quantity = 0

                Fz223.where(monthly_quarter: monthly_quarter, okpd: okpd).each do |fz223|
                    if fz223.OP_IP == "ОП"
                        op_cost += fz223.Position_Amount
                        op_quantity += fz223.Quantity
                    elsif fz223.OP_IP == "ИП"
                        ip_cost += fz223.Position_Amount
                        ip_quantity += fz223.Quantity
                    end
                end

                Fz44.where(monthly_quarter: monthly_quarter, okpd: okpd).each do |fz44|
                    if fz44.OP_IP == "ОП"
                        op_cost += fz44.Position_Amount
                        op_quantity += fz44.Quantity
                    elsif fz44.OP_IP == "ИП"
                        ip_cost += fz44.Position_Amount
                        ip_quantity += fz44.Quantity
                    end
                end

                temp.op_cost = op_cost
                temp.ip_cost = ip_cost
                temp.sum_cost = op_cost + ip_cost
                temp.op_quantity = op_quantity
                temp.ip_quantity = ip_quantity
                temp.sum_quantity = op_quantity + ip_quantity

                # Calculate export_cost, export_quantity, import_cost, and import_quantity
                export_cost = 0
                export_quantity = 0
                import_cost = 0
                import_quantity = 0
                #okpd_record = 
                Okpd.where(OKPD9: okpd).each do |tnvd|
                    customs = Custom.where(monthly_quarter: monthly_quarter, TNVD: tnvd.TNVD10)

                    customs.each do |customs|
                    if customs.export_import == "ЭК"
                        export_cost += customs.RUB
                        export_quantity += customs.quantity
                    elsif customs.export_import == "ИМ"
                        import_cost += customs.RUB
                        import_quantity += customs.quantity
                    end
                    end
                end

                temp.export_cost = export_cost
                temp.export_quantity = export_quantity
                temp.import_cost = import_cost
                temp.import_quantity = import_quantity

                # Calculate prom_cost and prom_quantity
                prom = Prom.where(monthly_quarter: monthly_quarter, okpd: okpd).first
                temp.prom_cost = prom&.cost || 0
                temp.prom_quantity = prom&.quantity || 0

                temp.save!
            end
        end
    end

    task update_4hours: :environment do # нужно переделать, выбираем окпд и проходимся по ним
        # Get the list of updated records in the original tables
        updated_fz223s = Fz223.where(updated_at: 4.hour.ago..Time.current)
        updated_fz44s = Fz44.where(updated_at: 4.hour.ago..Time.current)
        updated_customs = Customs.where(updated_at: 4.hour.ago..Time.current)
        
        unique_combinations = (updated_fz223s.pluck(:monthly_quarter, :okpd) +
        updated_fz44s.pluck(:monthly_quarter, :okpd) +
        updated_customs.pluck(:monthly_quarter, :okpd)).uniq

        unique_combinations.each do |monthly_quarter, okpd|
                # Create a new temp record or update an existing one
                temp = Temp.find_or_create_by!(monthly_quarter: monthly_quarter, okpd: okpd)

                # Calculate op_cost, ip_cost, sum_cost, op_quantity, ip_quantity, and sum_quantity
                op_cost = 0
                ip_cost = 0
                op_quantity = 0
                ip_quantity = 0

                Fz223.where(monthly_quarter: monthly_quarter, okpd: okpd).each do |fz223|
                    if fz223.OP_IP == "ОП"
                        op_cost += fz223.Position_Amount
                        op_quantity += fz223.Quantity
                    elsif fz223.OP_IP == "ИП"
                        ip_cost += fz223.Position_Amount
                        ip_quantity += fz223.Quantity
                    end
                end

                Fz44.where(monthly_quarter: monthly_quarter, okpd: okpd).each do |fz44|
                    if fz44.OP_IP == "ОП"
                        op_cost += fz44.Position_Amount
                        op_quantity += fz44.Quantity
                    elsif fz44.OP_IP == "ИП"
                        ip_cost += fz44.Position_Amount
                        ip_quantity += fz44.Quantity
                    end
                end

                temp.op_cost = op_cost
                temp.ip_cost = ip_cost
                temp.sum_cost = op_cost + ip_cost
                temp.op_quantity = op_quantity
                temp.ip_quantity = ip_quantity
                temp.sum_quantity = op_quantity + ip_quantity

                # Calculate export_cost, export_quantity, import_cost, and import_quantity
                export_cost = 0
                export_quantity = 0
                import_cost = 0
                import_quantity = 0

                Customs.where(monthly_quarter: monthly_quarter, okpd: okpd).each do |customs|
                    if customs.export_import == "ЭК"
                        export_cost += customs.RUB
                        export_quantity += customs.quantity
                    elsif customs.export_import == "ИМ"
                        import_cost += customs.RUB
                        import_quantity += customs.quantity
                    end
                end

                temp.export_cost = export_cost
                temp.export_quantity = export_quantity
                temp.import_cost = import_cost
                temp.import_quantity = import_quantity

                # Calculate prom_cost and prom_quantity
                prom = Prom.where(monthly_quarter: monthly_quarter, okpd: okpd).first
                temp.prom_cost = prom&.cost || 0
                temp.prom_quantity = prom&.quantity || 0

                temp.save!
        end
    ############
        # Update the temps table based on the updated records
        updated_fz223s.each do |fz223|
          update_temp(fz223.monthly_quarter, fz223.okpd, fz223.OP_IP, fz223.Position_Amount, fz223.Quantity,"clear")
        end
    
        updated_fz44s.each do |fz44|
          update_temp(fz44.monthly_quarter, fz44.okpd, fz44.OP_IP, fz44.Position_Amount, fz44.Quantity, nil)
        end
    
        updated_customs.each do |customs|
          update_temp(customs.monthly_quarter, customs.okpd, nil, customs.RUB, customs.quantity, nil)
        end
      end
    
      def update_temp(monthly_quarter, okpd, op_ip, amount, quantity, clear_all) #нужно добавить параметр 
        temp = Temp.find_or_create_by!(monthly_quarter: monthly_quarter, okpd: okpd)
    
        if !clear_all.nil?
            temp.op_cost = 0
            temp.op_quantity = 0
            temp.ip_cost = 0
            temp.ip_quantity = 0
            temp.export_cost = 0
            temp.export_quantity = 0
        end

        if op_ip == "ОП"
          temp.op_cost += amount
          temp.op_quantity += quantity
        elsif op_ip == "ИП"
          temp.ip_cost += amount
          temp.ip_quantity += quantity
        else
          temp.export_cost += amount
          temp.export_quantity += quantity
        end
    
        temp.sum_cost = temp.op_cost + temp.ip_cost
        temp.sum_quantity = temp.op_quantity + temp.ip_quantity
    
        temp.save!
    end

    task replace_fz223: :environment do 
        Fz223.where(monthly_quarter: nil).each do |fz223|
            publication_date = fz223.Publication_Date
            month = publication_date.month
            year = publication_date.year
            quarter = case month
                       when 1, 2, 3 then 1
                       when 4, 5, 6 then 2
                       when 7, 8, 9 then 3
                       when 10, 11, 12 then 4
                       end
            result = "#{quarter}/#{year}"
            fz223.update(monthly_quarter: result)
        end
    end

    task replace_fz44: :environment do 
        Fz44.where(monthly_quarter: nil).each do |fz44|
            publication_date = fz44.Publication_Date
            month = publication_date.month
            year = publication_date.year
            quarter = case month
                       when 1, 2, 3 then 1
                       when 4, 5, 6 then 2
                       when 7, 8, 9 then 3
                       when 10, 11, 12 then 4
                       end
            result = "#{quarter}/#{year}"
            fz44.update(monthly_quarter: result)
        end
    end

    task replace_custom: :environment do 
        Custom.where(monthly_quarter: nil).each do |custom|
            publication_date = custom.date
            month = publication_date.month
            year = publication_date.year
            quarter = case month
                       when 1, 2, 3 then 1
                       when 4, 5, 6 then 2
                       when 7, 8, 9 then 3
                       when 10, 11, 12 then 4
                       end
            result = "#{quarter}/#{year}"
            custom.update(monthly_quarter: result)
        end
    end
  end