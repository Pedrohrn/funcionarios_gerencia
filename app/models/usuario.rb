class Usuario < ApplicationRecord
	belongs_to 	:cargo
	belongs_to 	:grupo
	has_many 		:recessos, dependent: :destroy

	VALIDATES_PRESENCES = [
		{ key: :nome, label: 'Nome' },
		{ key: :cpf, label: 'CPF' },
	]

	VALIDATES_UNIQUENESS = [
		{ key: :cpf, label: 'CPF' },
		{ key: :email, label: 'E-mail'}
	]

	VALIDATES_LENGTH = [
		{ key: :nome, max_length: 120, label: 'nome' },
		{ key: :rg, max_length: 30, label: 'rg' },
		{ key: :cep, max_length: 7, label: 'cep' },
		{ key: :logradouro, max_length: 150, label: 'logradouro' },
		{ key: :complemento, max_length: 100, label: 'complemento' },
	]

	validate :validar_campos#, :validar_tamanhos, :validar_uniqueness

	accepts_nested_attributes_for :recessos, allow_destroy: true

	def slim_obj
		{
			id: id,
			nome: nome,
			grupo: grupo.slim_obj,
			cargo: cargo.to_frontend_obj,
			vigencia_inicio: vigencia_inicio,
			vigencia_fim: vigencia_fim,
			expedientes: expediente_obj,
			email: email,
			telefones: telefone_obj,
			inativado_em: inativado_em,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:data_nascimento] = data_nascimento
		attrs[:cpf] = cpf
		attrs[:rg] = rg
		attrs[:ferias] = recessos
		attrs[:logradouro] = logradouro
		attrs[:complemento] = complemento
		attrs[:cep] = cep
		attrs[:bairro] = bairro
		attrs[:cidade] = cidade
		attrs
	end

	def telefone_obj   
		telefones
	end

	def expediente_obj
		expedientes
	end

	def inativado?
		inativado_em.present?
	end

	def validar_campos
		VALIDATES_PRESENCES.each{ |obj|
			next if send(obj[:key]).present?
			errors.add(:base, "#{obj[:label]} não pode ser vazio!")
		}

		errors.empty?
	end

	def validar_uniqueness
		VALIDATES_UNIQUENESS.each{ |obj|
			aux = Usuario.where(obj[:key] == obj.to_s)
			puts aux
			next if aux.empty?
			errors.add(:base, "Já existe um #{obj[:label]} igual a este cadastrado!")
		}

		errors.empty?
	end

	def validar_tamanhos
		VALIDATES_LENGTH.each{ |obj|
			puts obj[:label].to_s.length
			next if obj[:label].length <= obj[:max_length]
			errors.add(:base, "O tamanho do #{obj[:key]} é maior que o permitido (#{obj[:max_length]})!")
		}

		errors.empty?
	end
end
