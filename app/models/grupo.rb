class Grupo < ApplicationRecord
	has_many :usuarios

	validates_uniqueness_of :nome, :case_sensitive => true, message: 'Já existe um grupo com esse nome! Escolha outro!'

	VALIDATES_PRESENCES = [
		{ key: :nome, label: 'Nome' },
	]

	validate :validar_campos

	def slim_obj
		{
			id: id,
			nome: nome,
			inativado_em: inativado_em,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:usuarios] = usuarios_obj
		attrs
	end

	def usuarios_obj
		usuarios.map(&:slim_obj)
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
