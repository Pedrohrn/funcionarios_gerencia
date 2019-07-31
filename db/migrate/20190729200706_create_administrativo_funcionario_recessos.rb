class CreateAdministrativoFuncionarioRecessos < ActiveRecord::Migration[5.2]
  def change
    create_table :administrativo_funcionario_recessos do |t|
    	t.string :observacoes
    	t.datetime :data_inicio, null: false
    	t.datetime :data_fim, null: false
    	t.integer :funcionario_id, null: false

      t.timestamps
    end
  end
end
