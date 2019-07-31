class CreateAdministrativoPessoas < ActiveRecord::Migration[5.2]
  def change
    create_table :administrativo_pessoas do |t|
    	t.string :nome, null: false
    	t.json :telefones
    	t.integer :cpf
    	t.integer :rg
    	t.integer :nascimento
    	t.string :email
    	t.json :emails_alternativos
    	t.string :cidade
    	t.string :bairro
    	t.string :complemento
    	t.string :logradouro
    	t.integer :cep

      t.timestamps
    end

    add_index :administrativo_pessoas, :cpf, unique: true
    add_index :administrativo_pessoas, :nome
    add_index :administrativo_pessoas, :email, unique: true
  end
end
