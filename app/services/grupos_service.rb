class GruposService
	def self.model() ::Grupo; end

	def self.index(opts, params)
		grupos = model.all.map(&:to_frontend_obj)

		resp = { grupos: grupos }

		[ :success, resp ]
	end
end