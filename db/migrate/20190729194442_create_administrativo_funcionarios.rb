class CreateAdministrativoFuncionarios < ActiveRecord::Migration[5.2]
  def change
    create_table :administrativo_funcionarios do |t|
    	t.integer :cargo_id
    	t.integer :pessoa_id, null: false
    	t.integer :grupo_id
    	t.datetime :vigencia_inicio
    	t.datetime :vigencia_fim
    	t.json :expedientes
    	t.datetime :inativado_em
    	t.json :visualizacoes

      t.timestamps
    end

  end
end
