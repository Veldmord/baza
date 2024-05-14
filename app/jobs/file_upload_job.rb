class FileUploadJob
    include Sidekiq::Worker
    def perform(file_path, filename)
      spreadsheet = Caxlsx::File.open(file_path)
      header = spreadsheet.worksheets.first.rows.first
  
      spreadsheet.worksheets.first.rows.drop(1).each do |row|
        data = Fz223.new(Hash[header.zip(row)])
        data.file_name = filename
        data.save
      end
    end
  end