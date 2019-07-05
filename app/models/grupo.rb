class Grupo < ApplicationRecord
	has_many :usuarios

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
		usuarios(&:to_frontend_obj)
	end

end
