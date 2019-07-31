class CreateAdministrativoFuncionarioCargos < ActiveRecord::Migration[5.2]
  def change
    create_table :administrativo_funcionario_cargos do |t|
    	t.string :nome, null: false
    	t.datetime :inativado_em

      t.timestamps
    end

    add_index :administrativo_funcionario_cargos, :nome, unique: true
  end
end
