class FuncionarioRecessosController < ApplicationController
	def service() ::FuncionarioRecessosService; end

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

	def submit
		st, resp = service.submit({}, recessos_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :ok
		end
	end

	def destroy
		st, resp = service.destroy({}, get_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def recessos_params
		attrs = [:id, :observacoes, :data_inicio, :data_fim, :funcionario_id]

		resp = params.require(:recesso).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

end