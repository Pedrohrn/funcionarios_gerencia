class Recesso < ApplicationRecord
	belongs_to :usuario

	VALIDATES_PRESENCES = [
		{ key: :data_fim, label: 'Data fim' },
		{ key: :data_inicio, label: 'Data inicio' },
	]

	validate :validar_campos
	validate :validar_observacoes

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

		errors.empty?
	end

	def validar_observacoes
		if observacoes.length > 2000
			errors.add(:base, "A observação é muito longa! O máximo permido são 2000 caracteres!")
		end
	end

end
