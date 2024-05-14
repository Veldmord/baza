class ReportsController < ApplicationController
    def okpd_group

        # SQL запрос
        sql_query = <<-SQL
        SELECT 
            l.okpd_9, 
            SUM(f.Position_Amount) AS price, 
            SUM(f.Quantity) AS count,
            SUM(CASE 
                WHEN c.export_import = 'ЭК' THEN c.USD 
                ELSE 0 
            END) AS export_usd,
            SUM(CASE 
                WHEN c.export_import = 'ИМ' THEN c.USD 
                ELSE 0 
            END) AS import_usd
        FROM 
            listokpds l
        LEFT JOIN 
            fz223s f ON l.okpd_9 = f.okpd
        LEFT JOIN 
            okpds o ON l.okpd_9 = o.OKPD9
        LEFT JOIN 
            customs c ON o.TNVD10 = c.TNVD
        GROUP BY 
            l.okpd_9
        SQL

        # Выполнение SQL запроса
        @okpd_group = ActiveRecord::Base.connection.execute(sql_query)
        
    end 
end