class CreateUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :usuarios do |t|
    	t.string :nome, null: false
      t.string :email
      t.string :cidade
      t.string :logradouro
      t.string :complemento
      t.string :bairro
      t.integer :cep
      t.integer :gestao_id
      t.integer :cargo_id
    	t.integer :grupo_id
      t.integer :gestao_id
      t.integer :cargo_id
      t.integer :cpf
      t.integer :rg
    	t.datetime :inativado_em
      t.datetime :data_nascimento
      t.datetime :vigencia_inicio
      t.datetime :vigencia_fim
      t.json :telefones
      t.json :expedientes
      t.json :visualizacoes

      t.timestamps
    end
  end
end
