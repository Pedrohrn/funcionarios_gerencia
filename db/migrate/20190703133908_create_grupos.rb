class CreateGrupos < ActiveRecord::Migration[5.2]
  def change
    create_table :grupos do |t|
    	t.string :nome, null: false
    	t.datetime :inativado_em

      t.timestamps
    end
  end
end
