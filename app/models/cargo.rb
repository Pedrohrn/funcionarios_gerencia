class Cargo < ApplicationRecord
	has_many :usuarios

	VALIDATES_PRESENCES = [
		{ key: :nome, label: 'nome' },
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

		errors.empty?
	end

end
