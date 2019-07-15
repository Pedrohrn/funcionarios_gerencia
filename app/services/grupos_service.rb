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
		case params[:micro_update_type]
		when :inativar
			self.inativar(params)
		end

		return [:success, { grupo: grupo.to_frontend_obj, message: 'Registro atualizado com sucesso' }] if grupo.save
		[ :error, grupo.errors.full_messages ]
	end

	def self.inativar(params)

	end
end