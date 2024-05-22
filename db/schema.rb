# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_05_22_140839) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customs", force: :cascade do |t|
    t.string "export_import"
    t.date "date"
    t.string "TNVD"
    t.string "country"
    t.integer "quantity"
    t.integer "USD"
    t.bigint "RUB"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "monthly_quarter"
    t.boolean "updated_row"
  end

  create_table "functional_groups", force: :cascade do |t|
    t.boolean "on_of"
    t.integer "id_dashboard"
    t.string "name_of_group"
    t.string "okpd"
    t.string "operator"
    t.string "fz1"
    t.string "fz2"
    t.string "fz3"
    t.string "fz4"
    t.string "fz5"
    t.string "fz6"
    t.string "fz7"
    t.string "fz8"
    t.string "fz9"
    t.string "fz10"
    t.string "fz11"
    t.string "fz12"
    t.string "fz13"
    t.string "fz14"
    t.string "fz15"
    t.string "fz16"
    t.string "fz17"
    t.string "fz18"
    t.string "fz19"
    t.string "fz20"
    t.string "dh1"
    t.string "dh2"
    t.string "dh3"
    t.string "dh4"
    t.string "dh5"
    t.string "dh6"
    t.string "dh7"
    t.string "dh8"
    t.string "dh9"
    t.string "dh10"
    t.string "dh11"
    t.string "dh12"
    t.string "dh13"
    t.string "dh14"
    t.string "dh15"
    t.string "dh16"
    t.string "dh17"
    t.string "dh18"
    t.string "dh19"
    t.string "dh20"
    t.string "dh21"
    t.string "dh22"
    t.string "dh23"
    t.string "dh24"
    t.string "dh25"
    t.string "dhkf1"
    t.string "dhkf2"
    t.string "dhkf3"
    t.string "dhkf4"
    t.string "dhkf5"
    t.string "dhkf6"
    t.string "dhkf7"
    t.string "dhkf8"
    t.string "dhkf9"
    t.string "dhkf10"
    t.string "dhkf11"
    t.string "dhkf12"
    t.string "dhkf13"
    t.string "dhkf14"
    t.string "dhkf15"
    t.string "dhkf16"
    t.string "dhkf17"
    t.string "dhkf18"
    t.string "dhkf19"
    t.string "dhkf20"
    t.string "dhkf21"
    t.string "dhkf22"
    t.string "dhkf23"
    t.string "dhkf24"
    t.string "dhkf25"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fz223s", force: :cascade do |t|
    t.string "file_name"
    t.string "okpd"
    t.text "okpd_name"
    t.integer "Country_Code"
    t.string "Manufacturer_Country"
    t.text "Commodity_by_Contract"
    t.string "Registration_Number"
    t.string "Contract_Number"
    t.date "Contract_Date"
    t.date "Publication_Date"
    t.date "End_Date"
    t.string "Unit_of_Measure"
    t.string "OP_IP"
    t.integer "Quantity"
    t.integer "Price_per_Unit"
    t.integer "Position_Amount"
    t.bigint "Contract_Amount"
    t.text "Contract_Documents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "monthly_quarter"
    t.boolean "updated_row"
  end

  create_table "fz44s", force: :cascade do |t|
    t.string "file_name"
    t.string "okpd"
    t.text "okpd_name"
    t.integer "Country_Code"
    t.string "Manufacturer_Country"
    t.text "Commodity_by_Contract"
    t.string "Registration_Number"
    t.string "Contract_Number"
    t.date "Contract_Date"
    t.date "Publication_Date"
    t.date "End_Date"
    t.string "Unit_of_Measure"
    t.string "OP_IP"
    t.integer "Quantity"
    t.integer "Price_per_Unit"
    t.integer "Position_Amount"
    t.bigint "Contract_Amount"
    t.text "Contract_Documents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "monthly_quarter"
    t.boolean "updated_row"
  end

  create_table "listokpds", force: :cascade do |t|
    t.string "okpd_2"
    t.text "trans_2"
    t.string "okpd_4"
    t.text "trans_4"
    t.string "okpd_6"
    t.text "trans_6"
    t.string "okpd_9"
    t.text "trans_9"
    t.text "notes"
    t.text "dep_1440"
    t.text "notes_1440"
    t.string "nic"
    t.string "full_name"
    t.text "prod_direct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ekb"
    t.string "thematically_fixed"
    t.integer "id_direction"
  end

  create_table "okpds", force: :cascade do |t|
    t.string "OKPD6"
    t.string "OKPD6Trans"
    t.string "OKPD9"
    t.string "OKPD9Trans"
    t.string "TNVD6"
    t.string "TNVD6Trans"
    t.string "TNVD10"
    t.string "TNVD10Trans"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pp719s", force: :cascade do |t|
    t.string "company"
    t.string "ogrn"
    t.string "hregistration_number"
    t.string "registration_number"
    t.string "product"
    t.string "okpd"
    t.string "tnvd"
    t.string "manufactured"
    t.integer "point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_directions", force: :cascade do |t|
    t.integer "id_direction"
    t.string "name_of_direction"
    t.string "boss"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proms", force: :cascade do |t|
    t.string "file_name"
    t.string "monthly_quarter"
    t.string "okpd"
    t.bigint "cost"
    t.bigint "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "updated_row"
  end

  create_table "tables", force: :cascade do |t|
    t.string "table_name"
    t.integer "count_records"
    t.string "link"
    t.text "about"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "temps", force: :cascade do |t|
    t.string "okpd"
    t.string "monthly_quarter"
    t.bigint "op_cost"
    t.bigint "ip_cost"
    t.bigint "sum_cost"
    t.bigint "op_quantity"
    t.bigint "ip_quantity"
    t.bigint "sum_quantity"
    t.bigint "export_cost"
    t.bigint "export_quantity"
    t.bigint "import_cost"
    t.bigint "import_quantity"
    t.bigint "prom_cost"
    t.bigint "prom_quantity"
    t.float "kty"
    t.float "kty_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "code_dethp"
    t.integer "market_share"
    t.integer "market_volume"
    t.index ["monthly_quarter", "okpd"], name: "idx_temp_unique", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
