class CreateRecessos < ActiveRecord::Migration[5.2]
  def change
    create_table :recessos do |t|
    	t.string :observacoes
    	t.datetime :data_inicio, null: false
    	t.datetime :data_fim, null: false
    	t.integer :usuario_id, null: false

      t.timestamps
    end
  end
end
