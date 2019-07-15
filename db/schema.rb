# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_11_200908) do

  create_table "cargos", force: :cascade do |t|
    t.string "nome", null: false
    t.datetime "inativado_em"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grupos", force: :cascade do |t|
    t.string "nome", null: false
    t.datetime "inativado_em"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recessos", force: :cascade do |t|
    t.string "observacoes"
    t.datetime "data_inicio", null: false
    t.datetime "data_fim", null: false
    t.integer "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nome", null: false
    t.integer "grupo_id"
    t.integer "cargo_id"
    t.integer "telefone"
    t.datetime "ferias_inicio"
    t.datetime "ferias_fim"
    t.datetime "horarios"
    t.datetime "vigencia_inicio"
    t.datetime "vigencia_fim"
    t.integer "cpf"
    t.integer "rg"
    t.integer "gestao_id"
    t.string "email"
    t.datetime "inativado_em"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
