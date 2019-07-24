class UsuariosService
	def self.model() ::Usuario; end

	def self.index(opts, params)
		usuarios = model.all.map(&:to_frontend_obj)

		resp = { usuarios: usuarios }

		[ :success, resp ]
	end

	def self.show(opts, params)
		usuario = model.find_by(id: params[:id])

		return [:success, {usuario: usuario} ] if !usuario.blank?
		[:error, recesso.errors.full_messages]
	end

	def self.submit(opts, params)
		cargo = params.delete(:cargo) || {}
		grupo = params.delete(:grupo) || {}

		#gestao =
		params.delete(:gestao)
		params[:cargo_id] = cargo.blank? ? 1 : cargo[:id]
		params[:grupo_id] = grupo.blank? ? 1 : grupo[:id]

		usuario, errors = nil, []
		ApplicationRecord.transaction do
			usuario = model.find_by(id: params[:id]) || model.new
			usuario.lock!
			usuario.assign_attributes(params)

			unless usuario.save
				errors = usuario.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, {usuario: usuario.to_frontend_obj}]
	end

	def self.destroy(opts, params)
		usuario, errors = nil, []
		ApplicationRecord.transaction do
			usuario = model.find_by(id: params[:id])
			usuario.lock!
			usuario.destroy

			unless usuario.destroy
				errors = errors
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, {}]
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
		usuario, errors = nil, []
		ApplicationRecord.transaction do
			usuario = model.find_by(id: params[:id])
			usuario.lock!

			usuario.inativado_em = usuario.inativado? ? nil : Time.now

			unless usuario.save
				errors = errors
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, {usuario: usuario.to_frontend_obj}]
	end
end