class CustomsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @customs = Custom.page(params[:page]).per(20)
    end
    def show
        @custom = Custom.page(params[:page]).per(20)
    end
    def new
        @custom = Custom.new
    end
    def create
        @custom = Custom.new(custom_params)
    end
    
    def custom_params
        params.require(:custom).permit(
            :export_import,
            :date,
            :TNVD,
            :country,
            :quantity,
            :USD,
            :RUB)

    end
    
    def upload
        if[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
            #filename = params[:file].original_filename
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header,spreadsheet.row(i)].transpose]
                row['date'] = converter_date(row['date']) if row['date'].present?
                Custom.create(row)
            end
        redirect_to customs_path
        end
    end

    def converter_date (date_str)
        parts = date_str.split("/")
        year = parts[1]
        month = parts[0]
        format_date = "#{year}-#{month}-01"
        return format_date
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
                    customs 
                GROUP BY 
                    okpd 
                ORDER BY 
                    okpd"
        @customs = ActiveRecord::Base.connection.execute(sql)

       #@customs = Custom.group(:okpd).sum(:Quantity)

    end 
end
