class TempYear < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
        ["code_dethp", "created_at", "crit_value", "critical", "dynamic_ip", "dynamic_op", "export_cost", "export_quantity", "id", "import_cost", "import_quantity", "ip_cost", "ip_quantity", "kty", "kty_cost", "market_share", "market_volume", "monthly_quarter", "name_okpd", "okpd", "okpd_rang", "op_cost", "op_quantity", "part_op", "prom_cost", "prom_quantity", "sum_cost", "sum_quantity", "updated_at"]
      end
end
