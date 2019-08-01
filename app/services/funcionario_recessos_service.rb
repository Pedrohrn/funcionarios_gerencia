class FuncionarioRecessosService
	def self.model() ::Administrativo::FuncionarioRecesso; end

	def self.index(opts, params)
		recessos = model.where(funcionario_id: params[:funcionario_id])
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
			recesso = model.lock.find_by(id: params[:id]) || model.new

			recesso.assign_attributes(params)

			unless recesso.save
				errors = recesso.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, { recesso: recesso.to_frontend_obj }]
	end

	def self.destroy(opts, params)
		recesso, errors = nil, []
		ApplicationRecord.transaction do
			recesso = model.lock.find_by(id: params[:id])
			recesso.destroy
			unless recesso.destroy
				errors = recesso.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [:error, errors] if errors.any?
		[:success, {}]
	end

end