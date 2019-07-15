class GruposController < ApplicationController
	def service() ::GruposService; end

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

	def show
		st, resp = service.show({}, get_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def create
		st, resp = service.create({}, grupos_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def update
		st, resp = service.update({}, grupos_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def micro_update
		st, resp = service.micro_update({}, micro_update_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def destroy
		st, resp = service.micro_update({}, grupos_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def grupos_params
		attrs = [ :id, :nome, :inativado_em ]

		resp = params.require(:grupo).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

	def micro_update_params
		attrs = [ :id, :inativado_em, :micro_update_type ]

		resp = params.require(:grupo).permit(attrs).to_h
		resp.deep_symbolize_keys
	end
end