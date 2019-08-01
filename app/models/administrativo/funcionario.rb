class Administrativo::Funcionario < ApplicationRecord
	belongs_to 	:pessoa,		class_name: 'Administrativo::Pessoa'
	belongs_to 	:grupo, 		class_name: 'Administrativo::FuncionarioGrupo', foreign_key: :grupo_id
	belongs_to 	:cargo, 		class_name: 'Administrativo::FuncionarioCargo', foreign_key: :cargo_id
	has_many 		:recessos, 	class_name: 'Administrativo::FuncionarioRecesso', dependent: :destroy

	accepts_nested_attributes_for :recessos, allow_destroy: true
	accepts_nested_attributes_for :pessoa, allow_destroy: true

	VALIDATES_PRESENCES = [
		{ key: :pessoa, label: 'Pessoa' },
	]

	validate :validar_campos

	def slim_obj
		{
			id: id,
			pessoa: pessoa.to_frontend_obj,
			grupo: grupo.slim_obj,
			cargo: cargo.to_frontend_obj,
			vigencia_inicio: vigencia_inicio,
			vigencia_fim: vigencia_fim,
			expedientes: expediente_obj,
			inativado_em: inativado_em,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:ferias] = recessos
		attrs
	end

	def expediente_obj
		expedientes
	end

	def validar_campos
		VALIDATES_PRESENCES.each{ |obj|
			next if send(obj[:key]).present?
			errors.add(:base, "#{obj[:label]} não pode ser vazio!")
		}

		errors.empty?
	end

	def inativado?
		inativado_em.present?
	end

end
