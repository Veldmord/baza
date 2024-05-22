class TempsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @temps = Temp.page(params[:page]).per(20)
        if params[:sort].present?
            column_name = params[:sort]
            direction = params[:direction] || 'asc'
            @temps = @temps.order("#{column_name} #{direction}")
        end
    end

    def show
        @temp = Temp.page(params[:page]).per(20)
    end

    def new
        @temp = Temp.new
    end

    def create
        @temp = Temp.new(temp_params)
    end

    def all_graph
        filtered = []
        columns = [:op_cost, :ip_cost, :sum_cost, :op_quantity, :ip_quantity, :sum_quantity, :export_cost, :export_quantity, :import_cost, :import_quantity, :prom_cost, :prom_quantity]
        Rails.logger.debug "okpd: #{params[:okpd].inspect}"
        if params[:okpd].nil?
          okpd = "20.40"
        else
          okpd = params[:okpd]
          Rails.logger.debug "okpd: #{okpd.inspect}"
      
          parts = okpd.split('.')
          quarter = params[:quarter]
          year = params[:year]
          Rails.logger.debug "year: #{year.inspect}"
          part_s = ""
          parts.each_with_index do |part, index|
            part_s += index == 0 ? part : '.' + part
            temps = Temp.where(okpd: part_s).where(monthly_quarter: quarter.map { |q| "#{q}/#{year}" })
            temp_data = columns.each_with_object({}) do |column, hash|
              # Заменяем nil на 0, чтобы избежать ошибки при суммировании
              hash[column] = temps.pluck(column).compact.sum { |value| value || 0 }
            end
            temp_data[:okpd] = part_s
            filtered << Temp.new(temp_data)
          end
      
          render json: filtered
          Rails.logger.debug "рендер"
        end
    end

    def auto_complete_okpd
        @okpds = Temp.where("okpd ILIKE ?", "#{params[:term]}%").limit(10)
        render json: @okpds.map(&:okpd)
    end
    
    def show_table #нужно написать с разбивкой на 26, 26.хх, 26.хх.хх и тд 
        @filters = params.permit(:okpd, :monthly_quarter, :sort, :direction)

        
        @results = Temp.where("okpd LIKE ? AND monthly_quarter LIKE ?", "%#{@filters[:okpd]}%", "%#{@filters[:monthly_quarter]}%")
       # @results = Temp.where(okpd: "*#{@filters[:okpd]}*", monthly_quarter: "*#{@filters[:monthly_quarter]}*")
        
        if @filters[:sort].present?
           column = @filters[:sort]
           direction = @filters[:direction]
           @results = @results.order("#{column} #{direction}")
        end

        @results = @results.page(params[:page]).per(20)

        respond_to do |format|
            format.html
            format.js 
        end
    end

    def show_table_complete
        term = params[:term]
        results = Temps.where("okpd LIKE ?", "%#{term}%").limit(10).pluck(:okpd)
        render json: results
    end

    def destroy
        #Temp.destroy_by(file_name: params[:file_name])
    end
    
    def upload
        if[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
            filename = params[:file].original_filename
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header,spreadsheet.row(i)].transpose]
                data = Temp.new(row)
                data.file_name = filename
                data.save
            end
        redirect_to temps_path
        end
    end

end
