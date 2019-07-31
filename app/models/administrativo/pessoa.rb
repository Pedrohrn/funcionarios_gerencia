class Administrativo::Pessoa < ApplicationRecord
	has_many :funcionarios

	VALIDATES_PRESENCES = [
		{ key: :nome, label: 'Nome' },
		{ key: :cpf, label: 'CPF' },
	]

	VALIDATES_LENGTH = [
		{ key: :nome, max_length: 120, label: 'nome' },
		{ key: :rg, max_length: 30, label: 'rg' },
		{ key: :cep, max_length: 7, label: 'cep' },
		{ key: :logradouro, max_length: 150, label: 'logradouro' },
		{ key: :complemento, max_length: 100, label: 'complemento' },
	]

	validate :validar_campos

	accepts_nested_attributes_for :funcionarios

	def slim_obj
		{
			id: id,
			nome: nome,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:email] = email
		attrs[:cpf] = cpf
		attrs[:rg] = rg
		attrs[:data_nascimento] = nascimento
		attrs[:telefones] = telefone_obj
		attrs[:cidade] = cidade
		attrs[:logradouro] = logradouro
		attrs[:bairro] = bairro
		attrs[:complemento] = complemento
		attrs[:cep] = cep
		attrs
	end

	def telefone_obj
		telefones
	end

	def emails_alternativos_obj
		emails
	end

	def validar_campos
		VALIDATES_PRESENCES.each{ |obj|
			next if send(obj[:key]).present?
			errors.add(:base, "#{obj[:label]} não pode ser vazio!")
		}

		VALIDATES_LENGTH.each{ |obj|
			next if send(obj[:key]).to_s.length <= obj[:max_length] || send(obj[:key]).to_s.blank?
			errors.add(:base, "O tamanho do #{obj[:key]} é maior que o permitido (#{obj[:max_length]})!")
		}

		errors.empty?
	end
end
