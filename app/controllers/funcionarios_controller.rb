class FuncionariosController < ApplicationController
	def service() ::FuncionariosService; end

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

	def submit
		st, resp = service.submit({}, funcionarios_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def show
		st, resp = service.show({}, get_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: { errors: resp }, status: :error
		end
	end

	def micro_update
		st, resp = service.micro_update({}, micro_update_params)

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

	def funcionarios_params
		attrs = [ :id, :vigencia_inicio, :vigencia_fim, :expedientes, :inativado_em ]
		attrs << {cargo: [:id]}
		attrs << {grupo: [:id]}
		attrs << {
			telefones: []
		}
		attrs << {
			expedientes: [
				:hora_inicio,
				:hora_fim,
				dias: [],
			]
		}
		attrs << {
			pessoa: [
				:id,
				:nome,
				:email,
				:telefones,
				:emails_alternativos,
				:data_nascimento,
				:cep,
				:logradouro,
				:complemento,
				:cidade,
				:bairro,
				emails_alternativos: [],
				contatos: [],
			]
		}

		resp = params.require(:funcionario).permit(attrs).to_h
		resp.deep_symbolize_keys
	end

	def micro_update_params
		attrs = [:id, :micro_update_type, :inativado_em]

		resp = params.require(:funcionario).permit(attrs).to_h
		resp.deep_symbolize_keys
	end
end