class FuncionarioGruposService
	def self.model() ::Administrativo::FuncionarioGrupo; end

	def self.index(opts, params)
		grupos = model.all.map(&:slim_obj)

		resp = { grupos: grupos }

		[ :success, resp ]
	end

	def self.show(opts, params)
		grupo = model.find_by(id: params[:id])

		return [:success, {grupo: grupo.to_frontend_obj}] if grupo.present?
		[:error, grupo.errors.full_messages ]
	end

	def self.submit(opts, params)
		grupo, errors = nil, []
		ApplicationRecord.transaction do
			grupo = model.lock.find_by(id: params[:id]) || model.new

			grupo.assign_attributes(params)

			unless grupo.save
				errors = grupo.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [ :error, errors ] if errors.any?
		[:success, { grupo: grupo.to_frontend_obj }]
	end

	def self.destroy(opts, params)
		grupo, errors = nil, []
		ApplicationRecord.transaction do
			grupo = model.find_by(id: params[:id])

			funcionarios = Administrativo::Funcionario.where(grupo_id: params[:id]) || []

			if funcionarios.empty?
				grupo.funcionarios.any?
				unless grupo.destroy
					errors = grupo.errors.full_messages
					raise ActiveRecord::Rollback
				end
			else
				errors = ['O grupo possuí usuários e não poderá ser excluído!']
			end
		end

		return [ :error, errors ] if errors.any?
		[:success, {}]
	end

	def self.micro_update(opts, params)
		case params[:micro_update_type].to_s.to_sym
		when :inativar, :reativar
			self.inativar_reativar(params)
		else
			[:error, "Tipo de operação não permitida!"]
		end
	end

	def self.inativar_reativar(params)
		grupo, errors = nil, []
		ApplicationRecord.transaction do
			grupo = model.lock.find_by(id: params[:id])

			grupo.inativado_em = grupo.inativado? ? nil : Time.now

			unless grupo.save
				errors = grupo.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { grupo: grupo.to_frontend_obj }]
	end
end