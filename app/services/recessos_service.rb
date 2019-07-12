class RecessosService
	def self.model() ::Recesso; end

	def self.index(opts, params)
		recessos = model.where(usuario_id: params[:usuario_id])
		resp = { recessos: recessos }

		[ :success, resp ]
	end

	def self.show(opts, params)
		recesso = model.find_by(id: params[:id])

		return [ :success, { recesso: recesso.to_frontend_obj } ] if recesso.present?
		[:error, recesso.errors.full_messages]
	end

	def self.create(opts, params)
		recesso = model.new

		recesso.assign_attributes(params)

		return [:success, { recesso: recesso.to_frontend_obj, message: 'Registro cadastrado com sucesso!' }] if recesso.save
		[:error, recesso.errors.full_messages]
	end

	def self.update(opts, params)
		recesso = model.find_by(id: params[:id])

		recesso.assign_attributes(params)

		return [:success, { recesso: recesso.to_frontend_obj, message: 'Registro atualizado com sucesso!' }] if recesso.save
		[:error, recesso.errors.full_messages]
	end

	def self.destroy(opts, params)
		recesso = model.find_by(id: params[:id])

		recesso.destroy

		return [:success, { message: 'Registro excluído com sucesso!' }] if recesso.destroy
		[:error, recesso.errors.full_messages]
	end

end