class TablesController < ApplicationController

    def index
        @tables = Table.all
    end

    def show
        @table = Table.find(params[:id])
    end

    def new
        @table = Table.new
    end

    def edit
        @table = Table.find(params[:id])
    end

    def create
        @table = Table.new (table_params)
        if @table.save
            redirect_to tables_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def update
        @table = Table.find(params[:id])
        @table.update(table_params)
        redirect_to tables_path
    end

    def destroy
        @table = Table.find(params[:id])
        @table.destroy
        redirect_to tables_path, notice: "Table was successfully destroyed!"
    end

    def table_params 
        params.require(:table).permit(:table_name, :count_records, :link, :about)
    end

    
    
end
