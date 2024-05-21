class Fz223sController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @fz223s = Fz223.page(params[:page]).per(20)
        if params[:sort].present?
            column_name = params[:sort]
            direction = params[:direction] || 'asc'
            @fz223s = @fz223s.order("#{column_name} #{direction}")
        end
    end
    def show
        @fz223 = Fz223.page(params[:page]).per(20)
    end
    def new
        @fz223 = Fz223.new
    end
    def create
        @fz223 = Fz223.new(fz223_params)
    end
    
    def fz223_params
        params.require(:fz223).permit(
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

    def destroy
        Fz223.destroy_by(file_name: params[:file_name])
    end
    
    def upload
        if[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
            filename = params[:file].original_filename
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header,spreadsheet.row(i)].transpose]
                data = Fz223.new(row)
                data.file_name = filename
                data.updated_row = true
                data.save
            end
        redirect_to fz223s_path
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
                    fz223s 
                GROUP BY 
                    okpd 
                ORDER BY 
                    okpd"
        @fz223s = ActiveRecord::Base.connection.execute(sql)
        @count_files = Fz223.group(:file_name)
       #@fz223s = Fz223.group(:okpd).sum(:Quantity)
    end 
end
