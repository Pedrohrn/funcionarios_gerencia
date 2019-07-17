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

	def self.create(opts,params)
		self.submit(opts, params)
	end

	def self.update(opts, params)
		self.submit(opts, params)
	end

	def self.submit(opts, params)
		puts 'params'
		puts params
		cargo = params.delete(:cargo)
		grupo = params.delete(:grupo)
		#gestao =
		params.delete(:gestao)

		params[:cargo_id] = cargo[:id]
		params[:grupo_id] = grupo[:id]

		usuario = model.find_by(id: params[:id]) || model.new
		usuario.assign_attributes(params)

		message = usuario.new_record? ? 'Registro cadastrado com sucesso!' : 'Registro atualizado com sucesso!'

		return [:success, { usuario: usuario.to_frontend_obj, message: message }] if usuario.save
		[:error, usuario.errors.full_messages]
	end

	def self.destroy(opts, params)
		usuario = model.find_by(id: params[:id])
		usuario.destroy

		return [:success, { message: 'Registro excluído com sucesso!' }] if usuario.destroy
		[:error, usuario.errors.full_messages]
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
		usuario = model.find_by(id: params[:id])

		usuario.inativado_em = usuario.inativado? ? nil : Time.now

		return [:success, { usuario: usuario.to_frontend_obj, message: 'Registro atualizado com sucesso!' }] if usuario.save
		[:error, usuario.errors.full_messages]
	end
end