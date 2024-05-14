class PromsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @proms = Prom.page(params[:page]).per(20)
        if params[:sort].present?
            column_name = params[:sort]
            direction = params[:direction] || 'asc'
            @proms = @proms.order("#{column_name} #{direction}")
        end
    end
    def show
        @prom = Prom.page(params[:page]).per(20)
    end
    def new
        @prom = Prom.new
    end
    def create
        @prom = Prom.new(prom_params)
    end
    
    def prom_params
        params.require(:prom).permit(
            :okpd,
            :quantity,
            :monthly_quarter,
            :cost)
    end
    
    def upload
        if[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
            filename = params[:file].original_filename
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header,spreadsheet.row(i)].transpose]
                data = Prom.new(row)
                data.file_name = filename
                data.save
            end
        redirect_to proms_path
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
                    proms 
                GROUP BY 
                    okpd 
                ORDER BY 
                    okpd"
        @proms = ActiveRecord::Base.connection.execute(sql)
        @count_files = Prom.group(:file_name)
       #@proms = Prom.group(:okpd).sum(:Quantity)
    end 
end
