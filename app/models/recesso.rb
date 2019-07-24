class Recesso < ApplicationRecord
	belongs_to :usuario

	VALIDATES_PRESENCES = [
		{ key: :data_fim, label: 'Data fim' },
		{ key: :data_inicio, label: 'Data inicio' },
	]

	VALIDATES_LENGTH = [
		{ key: :observacoes, label: "Observações", max_length: 500}
	]

	validate :validar_campos

	def slim_obj
		{
			id: id,
			usuario: usuario.to_frontend_obj,
			data_fim: data_fim,
			data_inicio: data_inicio,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:observacoes] = observacoes
		attrs[:cadastrado_em] = created_at
		attrs
	end

	def validar_campos
		VALIDATES_PRESENCES.each{ |obj|
			next if send(obj[:key]).present?
			errors.add(:base, "#{obj[:label]} não pode ser vazio!")
		}

		VALIDATES_LENGTH.each{ |obj|
			next if send(obj[:key]).to_s.length <= obj[:max_length] || send(obj[:key]).to_s.blank?
			errors.add(:base, "#{obj[:label]} é muito longa! O máximo permitido é de 500 caracteres")
		}

		errors.empty?
	end

end
