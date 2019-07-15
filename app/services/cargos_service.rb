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

	def micro_update(opts, params)
		cargo = model.find_by(id: params[:id])

		case params[:micro_update_type]
		when :inativar
			self.destroy(opts, params)
		when :desativar
			self.destroy(opts, params)
		end
	end

end