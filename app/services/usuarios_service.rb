class UsuariosService
	def self.model() ::Usuario; end

	def self.index(opts, params)
		usuarios = model.all.map(&:to_frontend_obj)

		resp = { usuarios: usuarios }

		[ :success, resp ]
	end

	def self.show(opts, params)
		usuario = model.find_by(id: params[:id])

		return [:success, { usuario: usuario, message: 'oi' } ] if !usuario.blank?
		[:error, usuario.errors.full_messages]
	end
end