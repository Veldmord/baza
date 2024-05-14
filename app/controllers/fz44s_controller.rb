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
        if[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
            filename = params[:file].original_filename
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header,spreadsheet.row(i)].transpose]
                data = Fz44.new(row)
                data.file_name = filename
                data.save
            end
        redirect_to fz44s_path
        end
    end

    def temp_table
        sql = "
                    SELECT 
                    okpd, 
                    SUM(CASE WHEN OP_IP = 'ОП' THEN Quantity ELSE 0 END) AS quantity_count_OP,
                    SUM(CASE WHEN OP_IP = 'ИП' THEN Quantity ELSE 0 END) AS quantity_count_IP,
                    SUM(CASE WHEN OP_IP = 'ОП' THEN Position_Amount ELSE 0 END) AS position_count_OP,
                    SUM(CASE WHEN OP_IP = 'ИП' THEN Position_Amount ELSE 0 END) AS position_count_IP
                FROM 
                    fz44s 
                GROUP BY 
                    okpd 
                ORDER BY 
                    okpd"
        @fz44s = ActiveRecord::Base.connection.execute(sql)

       #@fz44s = Fz44.group(:okpd).sum(:Quantity)

    end 
end
