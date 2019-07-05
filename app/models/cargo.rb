class Cargo < ApplicationRecord
	has_many :usuarios

	def to_frontend_obj
		{
			id: id,
			nome: nome,
			inativado_em: inativado_em,
		}
	end


end
