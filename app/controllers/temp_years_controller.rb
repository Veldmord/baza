class TempYearsController < ApplicationController
    def index
        @temp_years = TempYear.where(okpd_rang: 9).order(okpd: "ASC")
    
        # Фильтры
        @temp_years = @temp_years.where(monthly_quarter: params[:monthly_quarter]) if params[:monthly_quarter].present?
        @temp_years = @temp_years.where(okpd: params[:okpd]) if params[:okpd].present?
        @temp_years = @temp_years.where(critical: params[:critical]) if params[:critical].present?
    
        # Уникальные значения для фильтров
        @years = @temp_years.pluck(:monthly_quarter).uniq
        @okpds = @temp_years.pluck(:okpd).sort

        @temp_years = @temp_years.page(params[:page]).per(20)

        respond_to do |format|
            format.html
            format.js { render locals: { temp_years: @temp_years , okpds: @okpds} }
        end
    end
end
