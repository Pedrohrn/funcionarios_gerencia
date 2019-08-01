class Administrativo::FuncionarioCargo < ApplicationRecord
	has_many :funcionarios, class_name: 'Administrativo::Funcionario', foreign_key: :cargo_id

	VALIDATES_PRESENCES = [
		{ key: :nome, label: 'nome' },
	]

	VALIDATES_LENGTH = [
		{ key: :nome, label: 'Nome', max_length: 150 },
	]

	validate :validar_campos

	def to_frontend_obj
		{
			id: id,
			nome: nome,
			inativado_em: inativado_em,
		}
	end

	def inativado?
		inativado_em.present?
	end

	def validar_campos
		VALIDATES_PRESENCES.each{ |obj|
			next if send(obj[:key]).present?
			errors.add(:base, "#{obj[:label]} não pode ser vazio!")
		}

		VALIDATES_LENGTH.each{ |obj|
			next if send(obj[:key]).to_s.length <= obj[:max_length] || send(obj[:key]).to_s.blank?
			errors.add(:base, "#{obj[:label]} é muito longo! O máximo permitido é #{obj[:max_length]} caracteres")
		}

		errors.empty?
	end

end
