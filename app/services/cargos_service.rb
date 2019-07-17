class CargosService
	def self.model() ::Cargo; end

	def self.index(opts, params)
		cargos = model.all.map(&:to_frontend_obj)

		resp = { cargos: cargos }

		return [ :success, resp ] if resp.present?
		[ :error, { message: 'Nenhum registro encontrado!'} ]
	end

	def self.create(opts, params)
		self.submit(opts, params)
	end

	def self.update(opts, params)
		self.submit(opts, params)
	end

	def self.submit(opts, params)
		cargo = model.find_by(id: params[:id]) || model.new

		cargo.assign_attributes(params)

		return [ :success, { cargo: cargo.to_frontend_obj, message: 'Operação realizada com sucesso!' } ] if cargo.save
		[ :error, { message: cargo.errors.full_messages } ]
	end

	def self.destroy(opts, params)
		cargo = model.find_by(id: params[:id])

		cargo.destroy

		return [:success, { message: 'Registro excluído com sucesso!' }] if cargo.destroy
		[:error, { message: cargo.errors.full_messages }]
	end

	def self.micro_update(opts, params)
		case params[:micro_update_type].to_s.to_sym
		when :inativar, :reativar
			self.inativar_reativar(params)
		else
			[:error, "Tipo de operação não permitida!"]
		end
	end

	private

	def self.inativar_reativar(params)
		cargo = model.find_by(id: params[:id])

		cargo.inativado_em = cargo.inativado? ? nil : Time.now

		return [:success, { cargo: cargo.to_frontend_obj }] if cargo.save
		[:error, cargo.errors.full_messages]
	end

end