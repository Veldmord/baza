class TempYearsController < ApplicationController
    def index
        @temp_years = TempYear.where(okpd_rang: 9).order(okpd: "ASC")

        # Фильтры
        @temp_years = @temp_years.where(monthly_quarter: params[:monthly_quarter]) if params[:monthly_quarter].present?
        @temp_years = @temp_years.where(okpd: params[:okpd]) if params[:okpd].present?
        @temp_years = @temp_years.where(critical: params[:critical]) if params[:critical].present?
        @temp_years = @temp_years.where('dynamic_ip >= ?', params[:dynamic_ip_from].to_f / 100) if params[:dynamic_ip_from].present?
        @temp_years = @temp_years.where('dynamic_ip <= ?', params[:dynamic_ip_to].to_f / 100) if params[:dynamic_ip_to].present?
        @temp_years = @temp_years.where('dynamic_op >= ?', params[:dynamic_op_from].to_f / 100) if params[:dynamic_op_from].present?
        @temp_years = @temp_years.where('dynamic_op <= ?', params[:dynamic_op_to].to_f / 100) if params[:dynamic_op_to].present?
        @temp_years = @temp_years.where('part_op >= ?', params[:part_op_from].to_f / 100) if params[:part_op_from].present?
        @temp_years = @temp_years.where('part_op <= ?', params[:part_op_to].to_f / 100) if params[:part_op_to].present?

        # Уникальные значения для фильтров
        @years = @temp_years.pluck(:monthly_quarter).uniq
        @okpds = @temp_years.pluck(:okpd).sort

        @temp_years = @temp_years.page(params[:page]).per(20)

        respond_to do |format|
            format.html
            #format.js { render locals: { temp_years: @temp_years, okpds: @okpds } }
        end
    end
end
