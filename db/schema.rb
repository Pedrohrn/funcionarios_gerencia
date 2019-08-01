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

ActiveRecord::Schema.define(version: 2019_07_31_132713) do

  create_table "administrativo_funcionario_cargos", force: :cascade do |t|
    t.string "nome", null: false
    t.datetime "inativado_em"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_administrativo_funcionario_cargos_on_nome", unique: true
  end

  create_table "administrativo_funcionario_grupos", force: :cascade do |t|
    t.string "nome", null: false
    t.datetime "inativado_em"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_administrativo_funcionario_grupos_on_nome", unique: true
  end

  create_table "administrativo_funcionario_recessos", force: :cascade do |t|
    t.string "observacoes"
    t.datetime "data_inicio", null: false
    t.datetime "data_fim", null: false
    t.integer "funcionario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "administrativo_funcionarios", force: :cascade do |t|
    t.integer "cargo_id"
    t.integer "pessoa_id", null: false
    t.integer "grupo_id"
    t.datetime "vigencia_inicio"
    t.datetime "vigencia_fim"
    t.json "expedientes"
    t.datetime "inativado_em"
    t.json "visualizacoes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "administrativo_pessoas", force: :cascade do |t|
    t.string "nome", null: false
    t.json "telefones"
    t.integer "cpf"
    t.integer "rg"
    t.integer "nascimento"
    t.string "email"
    t.json "emails_alternativos"
    t.string "cidade"
    t.string "bairro"
    t.string "complemento"
    t.string "logradouro"
    t.integer "cep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_administrativo_pessoas_on_cpf", unique: true
    t.index ["email"], name: "index_administrativo_pessoas_on_email", unique: true
    t.index ["nome"], name: "index_administrativo_pessoas_on_nome"
  end

end
