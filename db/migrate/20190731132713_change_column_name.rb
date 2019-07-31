class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
  	rename_column :administrativo_funcionarios, :grupo_id, :funcionario_grupo_id
  	rename_column :administrativo_funcionarios, :cargo_id, :funcionario_cargo_id
  end
end
