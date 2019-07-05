class CreateCargos < ActiveRecord::Migration[5.2]
  def change
    create_table :cargos do |t|
    	t.string :nome, null: false
    	t.datetime :inativado_em

      t.timestamps
    end
  end
end
