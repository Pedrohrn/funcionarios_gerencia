class CreateUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :usuarios do |t|
    	t.string :nome, null: false
    	t.integer :grupo_id
    	t.integer :cargo_id
    	t.integer :telefone
        t.datetime :data_nascimento
    	t.datetime :horarios
    	t.datetime :vigencia_inicio
    	t.datetime :vigencia_fim
    	t.integer :cpf
    	t.integer :rg
    	t.integer :gestao_id
    	t.string :email
    	t.datetime :inativado_em

      t.timestamps
    end
  end
end
