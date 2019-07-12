class Recesso < ApplicationRecord
	belongs_to :usuario

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
		attrs
	end

end
