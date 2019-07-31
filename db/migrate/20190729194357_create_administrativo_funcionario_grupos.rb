class CreateAdministrativoFuncionarioGrupos < ActiveRecord::Migration[5.2]
  def change
    create_table :administrativo_funcionario_grupos do |t|
    	t.string :nome, null: false
    	t.datetime :inativado_em
    	t.integer :order

      t.timestamps
    end

    add_index :administrativo_funcionario_grupos, :nome, unique: true
  end
end
