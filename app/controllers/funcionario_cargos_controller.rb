class FuncionarioCargosController < ApplicationController
	def service() ::FuncionarioCargosService; end

	def index
		respond_to do |format|
			format.json{
				st, resp = service.index({}, get_params)

				case st
				when :success then render json: resp, status: :ok
				when :error then render json: { errors: resp }, status: :error
				end
			}
		end
	end

	def submit
		st, resp = service.submit({}, cargos_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def destroy
		st, resp = service.destroy({}, get_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :ok
		end
	end

	def micro_update
		st, resp = service.micro_update({}, micro_update_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :ok
		end
	end

	def cargos_params
		attrs = [ :id, :nome, :inativado_em ]

		resp = params.require(:cargo).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

	def micro_update_params
		attrs =  [:id, :inativado_em, :micro_update_type]

		resp = params.require(:cargo).permit(attrs).to_h
		resp.deep_symbolize_keys
	end
end