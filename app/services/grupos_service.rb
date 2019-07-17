class GruposService
	def self.model() ::Grupo; end

	def self.index(opts, params)
		grupos = model.all.map(&:slim_obj)

		resp = { grupos: grupos }

		[ :success, resp ]
	end

	def self.show(opts, params)
		grupo = model.find_by(id: params[:id])

		return [:success, { grupo: grupo.to_frontend_obj }] if grupo.present?
		[:error, grupo.errors.full_messages ]
	end

	def self.create(opts, params)
		grupo = model.find_by(id: params[:id]) || model.new

		grupo.assign_attributes(params)

		return [:success, { grupo: grupo.to_frontend_obj, message: 'Registro cadastrado com sucesso!' }] if grupo.save
		[ :error, grupo.errors.full_messages ]
	end

	def self.destroy(opts, params)
		grupo = model.find_by(id: params[:id])

		grupo.assign_attributes(params)

		return [:success, { message: 'Registro excluído com sucesso!' }] if grupo.destroy
		[ :error, grupo.errors.full_messages ]
	end

	def self.update(opts, params)
		grupo = model.find_by(id: params[:id])

		grupo.assign_attributes(params)

		return [:success, { grupo: grupo.to_frontend_obj, message: 'Registro atualizado com sucesso!' }] if grupo.save
		[ :error, grupo.errors.full_messages ]
	end

	def self.micro_update(opts, params)
		case params[:micro_update_type].to_s.to_sym
		when :inativar, :reativar
			self.inativar_reativar(params)
		else
			[:error, "Tipo de operação não permitida!"]
		end

		return [:success, { grupo: grupo.to_frontend_obj, message: 'Registro atualizado com sucesso' }] if grupo.save
		[ :error, grupo.errors.full_messages ]
	end

	private

	def self.inativar_reativar(params)
		grupo = model.find_by(id: params[:id])

		grupo.inativado_em = grupo.inativado? ? nil : Time.now

		return [:success, { grupo: grupo.to_frontend_obj }] if grupo.save
		[:error, grupo.errors.full_messages]
	end
	private_class_method :desativar_reativar
end