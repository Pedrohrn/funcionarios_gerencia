class CargosController < ApplicationController
	def service() ::CargosService; end

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

	def create

	end

	def update

	end

	def destroy
	end

	def micro_update

	end

	def show

	end

	def cargos_params
		attrs = [ :id, :nome, :inativado_em ]

		resp = params.require(:cargo).permit(attrs).to_h
		resp.deep_symbolize_keys
	end
end