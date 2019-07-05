class UsuariosController < ApplicationController
	def service() ::UsuariosService; end

	def index
		respond_to do |format|
			format.html { layout_erp }
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

	def show

	end

	def update

	end

	def micro_update

	end

	def destroy

	end

	def usuarios_params
		attrs = [ :id, :nome, :grupo, :cargo, :cpf, :rg, :ferias_inicio, :ferias_fim, :vigencia_inicio, :vigencia_fim, :horarios, :email, :contatos, :inativado_em ]

		resp = params.require(:usuario).permit(attrs).to_h
		resp.deep_symbolize_keys
	end
end