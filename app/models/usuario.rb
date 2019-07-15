class Usuario < ApplicationRecord
	belongs_to 	:cargo
	belongs_to 	:grupo
	has_many 		:recessos, dependent: :destroy

	accepts_nested_attributes_for :recessos, allow_destroy: true

	#before_validation :set_telefone

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
			telefones: telefone_obj,
			inativado_em: inativado_em,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:cpf] = cpf
		attrs[:rg] = rg
		attrs[:ferias] = recessos
		attrs[:logradouro] = logradouro
		attrs[:complemento] = complemento
		attrs[:cep] = cep
		attrs[:bairro] = bairro
		attrs[:cidade] = cidade
		attrs
	end

	def telefone_obj
		telefones
	end
end
