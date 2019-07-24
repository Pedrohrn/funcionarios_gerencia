class Grupo < ApplicationRecord
	has_many :usuarios

	validates_uniqueness_of :nome, :case_sensitive => true, message: 'Já existe um grupo com esse nome! Escolha outro!'

	VALIDATES_PRESENCES = [
		{ key: :nome, label: 'Nome' },
	]

	VALIDATES_LENGTH = [
		{ key: :nome, label: 'Nome', max_length: 100 },
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

		VALIDATES_LENGTH.each{ |obj|
			next if send(obj[:key]).to_s.length <= obj[:max_length] || send(obj[:key]).to_s.blank?
			errors.add(:base, "#{obj[:label]} é muito longo! O máximo permitido é #{obj[:max_length]} caracteres")
		}

		errors.empty?
	end

end
