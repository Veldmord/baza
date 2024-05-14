class ListokpdsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @listokpds = Listokpd.all
        if params[:filters].present?
          params[:filters].each do |column, value|
            @listokpds = @listokpds.where("#{column} LIKE ?", "%#{value}%") if value.present?
          end
        end
        @listokpds = @listokpds.order("#{params[:sort]} #{params[:direction]}") if params[:sort].present? && params[:direction].present?
        @listokpds = @listokpds.page(params[:page]).per(20)
    
        respond_to do |format|
          format.html
          format.js { 
            render layout: false }# Добавляем эту строку
        end
      
    end

    def show
        @listokpd = Listokpd.page(params[:page]).per(20)
    end

    def new
        @listokpd = Listokpd.new
    end

    def create
        @listokpd = Listokpd.new(listokpd_params)
    end

    def edit
        @listokpd = Listokpd.find(params[:id])
    end

    def update
        @listokpd = Listokpd.find(params[:id])
        if listokpd.update(listokpd_params)
            redirect_to listokpd_path
        else 
            render :edit
        end

    end

    def destroy
        Listokpd.destroy(params[:id])
        redirect_to listokpd_path
    end
    
    def listokpd_params
        params.require(:listokpd).permit(
            :okpd_2,
            :trans_2,
            :okpd_4,
            :trans_4,
            :okpd_6,
            :trans_6,
            :okpd_9,
            :trans_9,
            :notes,
            :dep_1440,
            :notes_1440,
            :prod_dicret,
            :full_name)
    end
    
    def upload
        if[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
            #filename = params[:file].original_filename
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header,spreadsheet.row(i)].transpose]
                Listokpd.create(row)
            end
        redirect_to listokpds_path
        end
    end

    def temp_table
    end 
end