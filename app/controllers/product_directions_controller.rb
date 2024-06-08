class ProductDirectionsController < ApplicationController
    def index
        @product_directions = ProductDirection.page(params[:page]).per(20)
        if params[:sort].present?
            column_name = params[:sort]
            direction = params[:direction] || 'asc'
            @product_directions = @product_directions.order("#{column_name} #{direction}")
        end
    end
    def new
        @product_direction = ProductDirection.new
    end
    def create
        @product_direction = ProductDirection.new(product_direction_params)
    end

    def edit
        @product_direction = ProductDirection.find(params[:id])
    end

    def update
        @product_direction = ProductDirection.find(params[:id])
        if @product_direction.update(product_direction_params)
            redirect_to product_directions_path
        else 
            render :edit
        end

    end
    
    def product_direction_params
        params.require(:product_direction).permit(
            :id_direction,
            :name_of_direction,
            :boss)
    end

    def upload
        if[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header,spreadsheet.row(i)].transpose]
                ProductDirection.create(row)
            end
        redirect_to product_directions_path
        end
    end
end
