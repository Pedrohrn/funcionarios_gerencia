class Usuario < ApplicationRecord
	belongs_to :cargo
	belongs_to :grupo

	def slim_obj
		{
			id: id,
			nome: nome,
			grupo: grupo.to_frontend_obj,
			cargo: cargo.to_frontend_obj,
			ferias_inicio: ferias_inicio,
			ferias_fim: ferias_fim,
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
		attrs
	end
end
