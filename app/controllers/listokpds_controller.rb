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
        if params[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)
          
            start_time = Time.now # Замеряем время начала работы скрипта
            updated_count = 0
            created_count = 0
          
            (2..spreadsheet.last_row).each do |i|
              row = Hash[[header, spreadsheet.row(i)].transpose]
              id = row['id'] # Предполагаем, что в Excel файле есть столбец 'id'
          
              if id.present?
                listokpd = Listokpd.find_by(id: id)
          
                # Обновляем, только если есть изменения
                if listokpd && listokpd.attributes.except("created_at", "updated_at") != row.stringify_keys
                  listokpd.update(row)
                  updated_count += 1
                end
              else
                # Если id нет, создаем новую запись 
                Listokpd.create(row)
                created_count += 1
              end
            end
          
            end_time = Time.now # Замеряем время окончания работы скрипта
            duration = end_time - start_time # Вычисляем время выполнения скрипта
          
            redirect_to listokpds_path, notice: "Файл успешно загружен и обработан. \n Обновлено записей: #{updated_count}. \n Создано записей: #{created_count}. \n Время выполнения: #{duration} секунд."
        else
        redirect_to listokpds_path, alert: 'Файл не выбран.'
        end
    end

    def temp_table
    end 
end