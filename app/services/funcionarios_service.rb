class FuncionariosService
	def self.model() ::Administrativo::Funcionario; end

	def self.index(opts, params)
		funcionarios = model.all.map(&:to_frontend_obj)

		resp = { funcionarios: funcionarios }

		[ :success, resp ]
	end

	def self.show(opts, params)
		funcionario = model.find_by(id: params[:id])

		return [:success, {funcionario: funcionario} ] if !funcionario.blank?
		[:error, recesso.errors.full_messages]
	end

	def self.submit(opts, params)
		cargo = params.delete(:cargo) || {}
		grupo = params.delete(:grupo) || {}

		#gestao =
		params.delete(:gestao)
		params[:cargo_id] = cargo.blank? ? 1 : cargo[:id]
		params[:grupo_id] = grupo.blank? ? 1 : grupo[:id]

		funcionario, errors = nil, []
		ApplicationRecord.transaction do
			funcionario = model.find_by(id: params[:id]) || model.new
			funcionario.lock!
			funcionario.assign_attributes(params)

			unless funcionario.save
				errors = funcionario.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, {funcionario: funcionario.to_frontend_obj, status: 'success'}]
	end

	def self.destroy(opts, params)
		funcionario, errors = nil, []
		ApplicationRecord.transaction do
			funcionario = model.find_by(id: params[:id])
			funcionario.lock!
			funcionario.destroy

			unless funcionario.destroy
				errors = errors
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, {status: 'success'}]
	end

	def self.micro_update(opts, params)
		case params[:micro_update_type].to_s.to_sym
		when :inativar, :reativar
			inativar_reativar(params)
		else
			[:error, 'Tipo de operação não permitida!']
		end
	end

	private

	def self.inativar_reativar(params)
		funcionario, errors = nil, []
		ApplicationRecord.transaction do
			funcionario = model.find_by(id: params[:id])
			funcionario.lock!

			funcionario.inativado_em = funcionario.inativado? ? nil : Time.now

			unless funcionario.save
				errors = errors
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, {funcionario: funcionario.to_frontend_obj, status: 'success'}]
	end
end