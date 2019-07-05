class GruposController < ApplicationController
	def service() ::GruposService; end

	def index
		respond_to do |format|
			format.json{
				st, resp = service.index({}, get_params)

				case st
				when :success then render json: resp, status: :ok
				when :error then render json: { errors: resp }, status: :ok
				end
			}
		end
	end

	def show

	end

	def create

	end

	def update

	end

	def micro_update

	end

	def destroy

	end

	def grupos_params
		attrs = [ :id, :nome, :inativado_em ]

		resp = params.require(:grupo).permit(attrs).to_h
		resp.deep_symbolize_keys
	end
end