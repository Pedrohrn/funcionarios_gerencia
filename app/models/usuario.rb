class Usuario < ApplicationRecord
	belongs_to 	:cargo
	belongs_to 	:grupo
	has_many 		:recessos

	accepts_nested_attributes_for :recessos

	def slim_obj
		{
			id: id,
			nome: nome,
			grupo: grupo.slim_obj,
			cargo: cargo.to_frontend_obj,
			vigencia_inicio: vigencia_inicio,
			vigencia_fim: vigencia_fim,
			horarios: horarios,
			email: email,
			telefone: telefone,
			inativado_em: inativado_em,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:cpf] = cpf
		attrs[:rg] = rg
		attrs[:ferias] = recessos
		attrs
	end
end
