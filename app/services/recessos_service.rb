class RecessosService
	def self.model() ::Recesso; end

	def self.index(opts, params)
		recessos = model.where(usuario_id: params[:usuario_id])
		resp = { recessos: recessos }

		[ :success, resp ]
	end

	def self.show(opts, params)
		recesso = model.find_by(id: params[:id])

		return [:success, { recesso: recesso.to_frontend_obj }] if recesso.present?
		[:error, recesso.errors.full_messages]
	end

	def self.submit(opts, params)
		recesso, errors = nil, []
		ApplicationRecord.transaction do
			recesso = model.find_by(id: params[:id]) || model.new
			recesso.lock!

			recesso.assign_attributes(params)

			unless recesso.save
				errors = recesso.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { recesso: recesso.to_frontend_obj, status: 'success' }]
	end

	def self.destroy(opts, params)
		recesso, errors = nil, []
		ApplicationRecord.transaction do
			recesso = model.find_by(id: params[:id])
			recesso.lock!

			recesso.destroy
			unless recesso.destroy
				errors = recesso.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, {status: 'success'}]
	end

end