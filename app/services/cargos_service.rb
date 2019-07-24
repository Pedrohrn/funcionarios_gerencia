class CargosService
	def self.model() ::Cargo; end

	def self.index(opts, params)
		cargos = model.all.map(&:to_frontend_obj)

		resp = { cargos: cargos }

		return [ :success, resp ] if resp.present?
		[ :error, { message: 'Nenhum registro encontrado!'} ]
	end

	def self.submit(opts, params)
		cargo, errors = nil, []
		ApplicationRecord.transaction do
			cargo = model.find_by(id: params[:id]) || model.new
			cargo.lock!

			cargo.assign_attributes(params)

			unless cargo.save
				errors = cargo.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return [ :error, errors] if errors.any?
		[ :success, {cargo: cargo.to_frontend_obj} ]
	end

	def self.destroy(opts, params)
		cargo, errors = nil, []
		ApplicationRecord.transaction do
			cargo = model.find_by(id: params[:id])

			cargos = Usuario.where(cargo_id: params[:id]) || []

			if cargos.empty?
				cargo.destroy

				unless cargo.destroy
					errors = [ { message: 'Registro não encontrado!'}]
					raise ActiveRecord::Rollback
				end
			else
				errors = ['O cargo possui vínculos com usuários e não poderá ser excluído!']
			end
		end

		return [:error, errors] if errors.any?
		[:success,  {status: 'success'} ]
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
		cargo, errors = nil, []
		ApplicationRecord.transaction do
			cargo = model.find_by(id: params[:id])
			cargo.lock!

			cargo.inativado_em = cargo.inativado? ? nil : Time.now

			unless cargo.save
				errors = cargo.errors.full_messages
				raise ActiveRecord::Rollback
			end
		end

		return if [:error, errors] if errors.any?
		[:success, { cargo: cargo.to_frontend_obj }]
	end

end