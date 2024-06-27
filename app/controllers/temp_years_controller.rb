class TempYearsController < ApplicationController
    def index
        @q = TempYear.ransack(params[:q])
        @temp_years = @q.result(distinct: true).where(okpd_rang: 9)
        
        # Фильтры
        @temp_years = @temp_years.where(monthly_quarter: params[:monthly_quarter]) if params[:monthly_quarter].present?
        @temp_years = @temp_years.where(okpd: params[:okpd]) if params[:okpd].present?
        @temp_years = @temp_years.where('dynamic_ip >= ?', params[:dynamic_ip_from].to_f / 100) if params[:dynamic_ip_from].present?
        @temp_years = @temp_years.where('dynamic_ip <= ?', params[:dynamic_ip_to].to_f / 100) if params[:dynamic_ip_to].present?
        @temp_years = @temp_years.where('dynamic_op >= ?', params[:dynamic_op_from].to_f / 100) if params[:dynamic_op_from].present?
        @temp_years = @temp_years.where('dynamic_op <= ?', params[:dynamic_op_to].to_f / 100) if params[:dynamic_op_to].present?
        @temp_years = @temp_years.where('part_op >= ?', params[:part_op_from].to_f / 100) if params[:part_op_from].present?
        @temp_years = @temp_years.where('part_op <= ?', params[:part_op_to].to_f / 100) if params[:part_op_to].present?
        @temp_years = @temp_years.where('crit_value >= ?', params[:value_crit]) if params[:value_crit].present? && params[:critical].presence == "true"
        #puts @temp_years.inspect
        # Уникальные значения для фильтров
        @years = @temp_years.map(&:monthly_quarter).uniq.sort
        @okpds = @temp_years.pluck(:okpd).sort
        @count_okpd = @temp_years.count
    
        @temp_years = @temp_years.page(params[:page]).per(20)
    
        respond_to do |format|
          format.html
        end
    end
    private

    def sort_column
      TempYear.column_names.include?(params[:sort_column]) ? params[:sort_column] : "okpd"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : "asc"
    end
  
end
