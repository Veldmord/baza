class Fz44sController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @fz44s = Fz44.page(params[:page]).per(20)
    end
    def show
        @fz44 = Fz44.page(params[:page]).per(20)
    end
    def new
        @fz44 = Fz44.new
    end
    def create
        @fz44 = Fz44.new(fz44_params)
    end

    def destroy
        Fz223.destroy_by(file_name: params[:file_name])
    end
    
    def fz44_params
        params.require(:fz44).permit(
            :okpd,
            :okpd_name,
            :Country_Code,
            :Manufacturer_Country,
            :Commodity_by_Contract,
            :Registration_Number,
            :Contract_Number,
            :Contract_Date,
            :Publication_Date,
            :End_Date,
            :Unit_of_Measure,
            :OP_IP,
            :Quantity,
            :Price_per_Unit,
            :Position_Amount,
            :Contract_Amount,
            :Contract_Documents)
    end
    
    def upload #загрузка блоками
        if params[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
            filename = params[:file].original_filename
          
            # Initialize an empty array to store data for bulk insertion
            data_to_insert = []
          
            (2..spreadsheet.last_row).each_slice(1000) do |batch| 
              batch.each do |i|
                row = Hash[[header,spreadsheet.row(i)].transpose]
                data = Fz44.new(row)
                data.file_name = filename
                data.updated_row = true
          
                publication_date = data.Publication_Date
                month = publication_date.month
                year = publication_date.year
                quarter = case month
                          when 1, 2, 3 then 1
                          when 4, 5, 6 then 2
                          when 7, 8, 9 then 3
                          when 10, 11, 12 then 4
                          end
                result = "#{quarter}/#{year}"
                data.monthly_quarter = result

                data_attributes = data.attributes.except('id', 'created_at', 'updated_at') 
                # Add the prepared data object to the array 
                data_to_insert << data_attributes 
              end
          
              # Bulk insert the accumulated data
              Fz44.insert_all(data_to_insert)
          
              # Clear the array for the next batch
              data_to_insert.clear
            end
          
            redirect_to fz44s_path
          end
    end

    def temp_table
        @fz44s = Fz44.select(
            "okpd",
            "SUM(CASE WHEN \"OP_IP\" = 'ОП' THEN \"Quantity\" ELSE 0 END) AS quantity_count_op",
            "SUM(CASE WHEN \"OP_IP\" = 'ИП' THEN \"Quantity\" ELSE 0 END) AS quantity_count_ip",
            "SUM(CASE WHEN \"OP_IP\" = 'ОП' THEN \"Position_Amount\" ELSE 0 END) AS position_count_op",
            "SUM(CASE WHEN \"OP_IP\" = 'ИП' THEN \"Position_Amount\" ELSE 0 END) AS position_count_ip"
          ).group("okpd").order("okpd")
        
        @count_files = Fz44.select(:file_name).group(:file_name)
    end 
end
