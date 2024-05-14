
class OkpdsController < ApplicationController
    skip_before_action :verify_authenticity_token
    #это связка окпд и тнвэд
    #def index 
    #    @okpds = Okpd.page(params[:page]).per(20)
    #end

    def index
        @okpds = Okpd.page(params[:page]).per(20)
    end
    def new
        @okpd = Okpd.new
    end
    def create
        @okpd = Okpd.new(okpd_params)
    end

    def okpd_params
        params.require(:okpd).permit(:OKPD6,:OKPD6Trans,:OKPD9,:OKPD9Trans,:TNVD10,:TNVD10Trans,:TNVD6,:TNVD6Trans)
    end

    def upload
        if[:file].present?
            spreadsheet = Roo::Spreadsheet.open(params[:file].path)
            header = spreadsheet.row(1)

            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header,spreadsheet.row(i)].transpose]
                Okpd.create(row)
            end
        redirect_to okpd_path
        end
    end

end
