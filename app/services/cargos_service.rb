class CargosService
	def self.model() ::Cargo; end

	def self.index(opts, params)
		cargos = model.all.map(&:to_frontend_obj)

		resp = { cargos: cargos }

		[ :success, resp ]
	end

end