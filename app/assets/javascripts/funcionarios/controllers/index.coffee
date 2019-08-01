angular.module('scApp').lazy
.controller 'CorpoDiretivo::IndexCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'Funcionario', 'Grupo', 'Cargo', 'Recesso', 'CorpoDiretivo::FormFactory'
	(scModal, scAlert, scToggle, scTopMessages, Templates, Funcionario, Grupo, Cargo, Recesso, FormFactory)->
		vm = this
		vm.templates = Templates

		vm.formFact = new FormFactory

		vm.settings =
			diasSemana: [
				{ key: 'DOM', label: 'domingo', checked: false, value: 1 },
				{ key: 'SEG', label: 'segunda', checked: false, value: 2 },
				{ key: 'TER', label: 'terça', 	checked: false, value: 3 },
				{ key: 'QUA', label: 'quarta', 	checked: false, value: 4 },
				{ key: 'QUI', label: 'quinta', 	checked: false, value: 5 },
				{ key: 'SEX', label: 'sexta', 	checked: false, value: 6 },
				{ key: 'SAB', label: 'sábado', 	checked: false, value: 7 },
			]

			filtroOpcoes: [
				{ key: 'de_ferias', 		label: 'De férias', 		checked: false },
				{ key: 'em_expediente', label: 'Em expediente', checked: false },
				{ key: 'inativo', 			label: 'Inativo', 			checked: false },
				{ key: 'com_cpf', 			label: 'Com CPF', 			checked: false },
				{ key: 'sem_cpf', 			label: 'Sem CPF', 			checked: false },
				{ key: 'com_telefone', 	label: 'Com Telefone', 	checked: false },
				{ key: 'sem_telefome', 	label: 'Sem Telefone',	checked: false },
				{ key: 'com_email', 		label: 'Com e-mail', 		checked: false },
				{ key: 'sem_email', 		label: 'Sem e-mail', 		checked: false },
			]

			dadosPessoais: [
				{ key: 'nome', 				label: 'Nome' },
				{ key: 'grupos', 			label: 'Grupos' },
				{ key: 'cargo', 			label: 'Cargo' },
				{ key: 'email', 			label: 'E-mail' },
				{ key: 'contatos', 		label: 'Contatos' },
				{ key: 'cpf', 				label: 'Cpf' },
				{ key: 'rg', 					label: 'RG' },
				{ key: 'nascimento', 	label: 'Nascimento' },
				{ key: 'expedientes', label: 'Expedientes' },
				{ key: 'vigencia', 		label: 'Vigência' },
				{ key: 'endereco', 		label: 'Endereço' },
				{ key: 'anexos', 			label: 'Anexos' },
			]

			grupos_list: [
				{ label: 'Proprietários' },
				{ label: 'Moradores' },
				{ label: 'Moradores responsáveis' },
				{ label: 'Imobiliárias' },
				{ label: 'Porteiros' },
			]

		vm.init = ->
			vm.filtro.exec()

		vm.showCtrl =
			aux: []
			statusList: [
				{ key: 'em_expediente', label: 'Em expediente', color: 'green'},
				{ key: 'inativo', label: 'inativo', color: 'yellow'},
				{ key: 'vigencia_expirada', label: 'Vigência expirada', color: 'red' },
				{ key: 'fora_do_expediente', label: 'Fora do expediente', color: 'cian'},
			]

			diasInit: (funcionario)->
				return if funcionario.expedientes_carregados || funcionario.expedientes == null
				funcionario.expedientes_carregados = true
				funcionario.expedientes_frontend = angular.copy funcionario.expedientes
				for expediente in funcionario.expedientes_frontend
					aux = angular.copy expediente.dias
					expediente.dias = []
					for item in aux
						dia = vm.settings.diasSemana.find (obj)-> obj.value == item
						expediente.dias.push(dia)

			userStatusInit: (funcionario)->
				return if funcionario.carregado
				funcionario.carregado = true

				funcionario.status = @statusList.find (obj)->

		vm.logCtrl =
			modal: new scModal()
			list: []
			carregando: false

			init: (registro)->
				registro.acc = new scToggle()

			loadList: ->
				return if @carregando
				@carregando = true

		vm.filtro =
			filtro_avancado: false
			options_are_visible: false
			days_are_visible: false
			cargos_are_visible: false
			day_count: 0
			cargo_count: 0
			option_count: 0

			showOptions: ->
				@options_are_visible = !@options_are_visible

			toggleOption: (option)->
				option.checked = !option.checked
				if option.checked
					@option_count++
				else
					@option_count--

			showDays: ->
				@days_are_visible = !@days_are_visible

			dayToggle: (day)->
				day.checked = !day.checked
				if day.checked
					@day_count++
				else
					@day_count--

			showCargos: ->
				@cargos_are_visible = !@cargos_are_visible

			cargoToggle: (cargo)->
				cargo.checked = !cargo.checked
				if cargo.checked
					@cargo_count++
				else
					@cargo_count--

			exec: ->
				vm.listCtrl.loadList()

			showFiltro: ->
				@filtro_avancado = !@filtro_avancado

			toggleAtivos: ->
				@ativos = !@ativos

			toggleInativos: ->
				@inativos = !@inativos

		vm.screenMode =
			list: true
			sort: false

			changeMode: ->
				@list = !@list
				@sort = !@list

		vm.listCtrl =
			list: []
			loading: false

			loadList: ->
				@list = []
				@exec()


			exec: (obj = {}) ->
				return if @loading

				@loading = true

				params = angular.copy obj
				params.filtro = vm.filtro.params

				Grupo.list params,
					(data)=>
						@loading = false

						@list.addOrExtend item for item in data.grupos

				Cargo.list params,
					(data)=>
						vm.cargosCtrl.list.addOrExtend item for item in data.cargos

		vm.funcionariosCtrl =
			list: []
			params: {}

			newUser: (grupo) ->
				grupo.creatingNewUser = true

			cancelarCadastro: (grupo)->
				grupo.creatingNewUser = false

			init: (funcionario)->
				funcionario.menu = new scToggle()
				funcionario.edit = new scToggle()
				funcionario.ferias_modal = new scModal()
				funcionario.ferias = funcionario.ferias || []
				expedientes = funcionario.expedientes
				vm.showCtrl.diasInit(funcionario)

			open_ferias_modal: (funcionario)->
				funcionario.ferias_modal.open()
				return if funcionario.ferias.loaded

				funcionario.ferias.loading = true

				params = { funcionario_id: funcionario.id }

				Recesso.list params,
					(data)=>
						funcionario.ferias.loading = false
						funcionario.ferias.loaded = true

						funcionario.ferias.addOrExtend item for item in data.recessos

			edit: (funcionario)->
				funcionario.edit.opened = true
				vm.formFact.init(funcionario)
				return if funcionario.loaded || @loading
				params = angular.copy funcionario

				@loading = true

				Funcionario.show params,
					(data)=>
						@loading = false

						grupo = vm.listCtrl.list.find (obj)-> obj.id == data.funcionario.grupo_id
						funcionario = grupo.funcionarios.find (obj)-> obj.id == data.funcionario.id
						funcionario.loaded = true
						angular.extend funcionario, data.funcionario
					(response)=>
						@loading = false
						funcionario.loaded = false
						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)


			rmv: (funcionario)->
				scAlert.open
					title: 'Tem certeza que deseja excluir o usuário?'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.funcionariosCtrl.destroy(funcionario) },
						{ label: 'Não', color: 'gray' },
					]

			destroy: (funcionario)->
				grupo_id = funcionario.grupo.id
				return if @loading
				@loading = true
				funcionario.excluindo = true
				params = angular.copy funcionario

				Funcionario.destroy params,
					(data)=>
						@loading = false

						grupo = vm.listCtrl.list.find (obj)-> obj.id == grupo_id
						funcionario = grupo.funcionarios.find (obj)-> obj.id == funcionario.id
						funcionario.excluindo = false
						grupo.funcionarios.remove(funcionario)

						scTopMessages.openSuccess 'Registro excluído com sucesso!'
					(response)->
						@loading = false
						funcionario.excluindo = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			inativar: (funcionario)->
				label = if funcionario.inativado_em then 'reativar' else 'inativar'
				scAlert.open
					title: 'Tem certeza de que deseja ' + label + ' o usuário?'
					buttons: [
						{ label: label.capitalize(), color: 'yellow', action: -> vm.funcionariosCtrl.micro_update(funcionario, label) },
						{ label: 'Não', color: 'gray' },
					]

			micro_update: (funcionario, label)->
				return if @loading

				params = {
					id: funcionario.id,
					grupo_id: funcionario.grupo_id
					micro_update_type: label,
					inativado_em: funcionario.inativado_em
				}

				@loading = true

				Funcionario.micro_update params,
					(data)=>
						@loading = false

						grupo = vm.listCtrl.list.find (obj)-> obj.id == params.grupo_id
						funcionario = grupo.funcionarios.find (obj)-> obj.id == data.funcionario.id
						angular.extend funcionario, data.funcionario

						msg = data.message
						scTopMessages.openSuccess msg unless Object.blank(msg)
					(response)=>
						@loading = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

		vm.gruposCtrl =
			newRecord: false
			creatingModeOn: false
			params: {}

			init: (grupo)->
				grupo.options = new scToggle()

			formInit: (grupo)->
				return if !@newRecord && !@creatingModeOn
				@params = angular.copy grupo || { nome: '' }

			edit: (grupo) ->
				if @creatingModeOn
					scAlert.open
						title: 'Termine a edição atual antes de editar/criar outro grupo!'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
				else
					@creatingModeOn = true

			new: ->
				if @creatingModeOn
					scAlert.open
						title: 'Termine a edição atual antes de criar um novo grupo!'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
				else
					@newRecord = true

			cancelar: (grupo)->
				if @newRecord
					scAlert.open
						title: 'Deseja mesmo cancelar sem salvar?'
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> vm.gruposCtrl.newRecord = false },
							{ label: 'Não', color: 'gray' }
						]
				else
					grupo.edit.toggle()

			rmv: (grupo)->
				scAlert.open
					title: "Atenção! Deseja mesmo excluir o grupo selecionado?"
					message: [
						{ msg: 'Os dados não poderão ser recuperados, uma vez que sejam excluídos.'},
						{ msg: 'Os usuários participantes desse grupo serão realocados no grupo "Sem Grupo".'}
						{ msg: 'Confirma a operação?'}
					]
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> vm.gruposCtrl.destroy(grupo) },
						{ label: 'Cancelar', color: 'gray' }
					]

			destroy: (grupo)->
				return if @loading

				@loading = true
				grupo.excluindo = true

				params = angular.copy grupo

				Grupo.destroy params,
					(data)=>
						@loading = false

						vm.listCtrl.list.remove(grupo)
						scTopMessages.openSuccess 'Registro excluído com sucesso!'
					(response)=>
						@loading = false
						grupo.excluindo = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

			submit: (grupo) ->
				return if @loading
				@loading = true
				grupo.carregando = true
				Grupo.submit @params,
					(data)=>
						@loading = false

						grupo = data.grupo
						if @newRecord
							vm.listCtrl.list.push(grupo)
							message = 'Registro cadastrado com sucesso!'
						else
							grupo = vm.listCtrl.list.find (obj)-> obj.id == data.grupo.id
							grupo.edit.opened = false
							grupo.carregando = false
							angular.extend grupo, data.grupo
							message = 'Registro atualizado com sucesso!'
							if grupo.modal_edit
								grupo.modal_edit.opened = false

						scTopMessages.openSuccess message
						@resetForm(grupo)
					(response)=>
						@loading = false
						grupo.carregando = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			micro_update: (grupo, label)->
				return if @loading

				params = {
					id: grupo.id,
					micro_update_type: label,
					inativado_em: grupo.inativado_em,
				}

				@loading = true
				grupo.carregando = true

				Grupo.micro_update params,
					(data)=>
						@loading = false

						grupo.carregando = false
						angular.extend grupo, data.grupo

						scTopMessages.openSuccess 'Registro atualizado com sucesso!'
					(response)=>
						@loading = false
						grupo.carregando = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			resetForm: (grupo)->
				if grupo && grupo.edit
					grupo.edit.opened = false
				@newRecord = false
				@creatingModeOn = false

		vm.feriasCtrl =
			newRecord: false
			params: {}
			loading: false
			creatingModeOn: false

			novoCadastro: (funcionario)->
				@creatingModeOn = true
				@newRecord = true
				@params = { funcionario_id: funcionario.id}

			init: (ferias)->
				ferias.acc = new scToggle()
				ferias.menu = new scToggle()

			editar: (ferias, funcionario)->
				@creatingModeOn = true
				@params = angular.copy ferias
				@params.funcionario_id = funcionario.id
				@formInit()

			formInit: ->
				@params.data_inicio = new Date(@params.data_inicio)
				@params.data_fim = new Date(@params.data_fim)

			rmv: (ferias, funcionario)->
				scAlert.open
					title: 'Tem certeza de que deseja excluir esse registro?'
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> vm.feriasCtrl.excluir(ferias, funcionario) },
						{ label: 'Cancelar', color: 'gray' }
					]

			excluir: (ferias, funcionario)->
				return if @loading

				@loading = true
				ferias.excluindo = true
				params = angular.copy ferias

				Recesso.destroy params,
					(data)=>
						@loading = false
						ferias.excluindo = false

						funcionario.ferias.remove(ferias)

						scTopMessages.openSuccess 'Registro excluído com sucesso!'
					(response)=>
						@loading = false
						ferias.excluindo = false
						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			show: (ferias) ->
				ferias.acc.toggle()
				return if ferias.loading || ferias.loaded

				ferias.loading = true

				Recesso.show ferias,
					(data)=>
						recesso = data.recesso
						angular.extend ferias, data.recesso
						ferias.loading = false
						ferias.loaded = true
					(response)=>
						ferias.loading = false
						ferias.loaded = false
						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			cancelar: (funcionario) ->
				if @creatingModeOn
					scAlert.open
						title: 'Tem certeza que deseja cancelar? Dados não salvos serão perdidos.'
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> vm.feriasCtrl.resetModal(funcionario) },
							{ label: 'Não', color: 'gray' }
						]
				else
					funcionario.ferias_modal.close()

			submit: (funcionario)->
				return if @loading

				@loading = true

				Recesso.submit @params,
					(data)=>
						@loading = false

						ferias = data.recesso

						if @newRecord
							funcionario.ferias.push(ferias)
							message = 'Registro cadastrado com sucesso!'
						else
							recesso = funcionario.ferias.find (obj)-> obj.id == data.recesso.id
							angular.extend recesso, data.recesso
							message = 'Registro atualizado com sucesso!'

						@resetForm()

						scTopMessages.openSuccess message
					(response)=>
						@loading = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			resetModal: (funcionario)->
				@creatingModeOn = false
				@newRecord = false

			resetForm: ->
				@creatingModeOn = false
				@newRecord = false

		vm.cargosCtrl =
			creatingMode: false
			loading: false
			menuOpened: false
			list: []
			modal: new scModal()
			params: {}

			formInit: (cargo)->
				if @newRecord
					@params = { nome: '' }
				else
					@params = angular.copy cargo || {}

			openMenu: ->
				@menuOpened = !@menuOpened

			toggleCreatingMode: ->
				@creatingMode = !@creatingMode

			edit: (cargo) ->
				@menuOpened = false
				if Object.blank(cargo)
					scAlert.open
						title: 'Selecione um cargo para poder editar!'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
				else
					@toggleCreatingMode()

			new: ->
				@menuOpened = false
				@newRecord = true
				@toggleCreatingMode()

			submit: (cargo) ->
				@menuOpened = false
				return if @loading

				@loading = true

				Cargo.submit @params,
					(data)=>
						@loading = false

						if @newRecord
							@list.push(data.cargo)
							message = 'Registro cadastrado com sucesso!'
						else
							cargo = @list.find (obj)-> obj.id == data.cargo.id
							angular.extend cargo, data.cargo
							message = 'Registro atualizado com sucesso!'

						scTopMessages.openSuccess message
						@resetForm()
					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

			rmv: (cargo)->
				scAlert.open
					title: 'Tem certeza de que deseja excluir este registro?'
					buttons: [
						{ label: 'Excluir', 	color: 'red', action: -> vm.cargosCtrl.destroy(cargo) },
						{ label: 'Cancelar', 	color: 'gray' }
					]

			destroy: (cargo) ->
				@menuOpened = false
				return if @loading

				@loading = true
				params = angular.copy cargo

				Cargo.destroy params,
					(data)=>
						@loading = false
						@resetForm()

						@list.remove(cargo)
						scTopMessages.openSuccess 'Registro excluído com sucesso!'
					(response)=>
						@loading = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			inativar_reativar: (cargo)->
				@menuOpened = false
				label = if cargo.inativado_em then 'reativar' else 'inativar'
				scAlert.open
					title: "Deseja mesmo " + label + ' o cargo?'
					buttons: [
						{ label: label.capitalize(), color: 'yellow', action: -> vm.cargosCtrl.micro_update(cargo, label) },
						{ label: 'Cancelar', color: 'gray' }
					]

			micro_update: (cargo, label)->
				return if @loading

				params = {
					id: cargo.id,
					micro_update_type: label,
					inativado_em: cargo.inativado_em,
				}

				@loading = false

				Cargo.micro_update params,
					(data)=>
						@loading = false

						cargo = vm.cargosCtrl.list.find (obj)-> obj.id == data.cargo.id
						angular.extend cargo, data.cargo

						scTopMessages.openSuccess 'Registro atualizado com sucesso!'
					(response)=>
						@loading = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			resetForm: ->
				@newRecord = false
				@creatingMode = false

		vm.newUserCtrl =
			newRecord: false
			modal: new scModal()

			cadastrarFuncionario: (funcionario, grupo) ->
				@newRecord = true
				@modal.active = !@modal.active

		vm.itemCtrl =
			newRecord: false

			rmv: (grupo)->
				scAlert.open
					title: 'Tem certeza de que deseja excluir esse grupo?'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.gruposCtrl.destroy(grupo) },
						{ label: 'Não', color: 'gray' },
					]

			inativar: (grupo)->
				label = if grupo.inativado_em then 'reativar' else 'inativar'
				scAlert.open
					title: 'Tem certeza que deseja ' + label + ' o grupo?'
					buttons: [
						{ label: label.capitalize(), color: 'yellow', action: -> vm.gruposCtrl.micro_update(grupo, label) },
						{ label: 'Não', color: 'gray' },
					]

			edit: (grupo)->
				return unless !grupo.edit.opened
				vm.gruposCtrl.creatingModeOn = true
				grupo.show.opened = false
				grupo.edit.toggle()

			new: (grupo)->
				grupo.newUser.opened = true
				@newRecord = true
				vm.newUserCtrl.modal.active = true

		vm.topbarCtrl =
			menu_IsOn: false

			showMenu: ->
				@menu_IsOn = !@menu_IsOn

		vm.configuracoesCtrl =
			list: [
				{ label: 'Ocultar funcionários de férias?', value: true },
				{ label: 'Mostrar apenas os que estão em jornada de trabalho?', value: false },
			]
			modal: new scModal()

			openModal: ->
				@modal.active = !@modal.active

		vm.formCtrl =
			cancelar: (funcionario) ->
				scAlert.open
					title: 'Deseja mesmo cancelar a edição? Dados não salvos serão perdidos'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.formCtrl.closeForm(funcionario) },
						{ label: 'Não', color: 'gray' }
					]

			closeForm: (funcionario)->
				vm.newUserCtrl.modal.close()
				vm.newUserCtrl.newRecord = false
				return if funcionario == undefined
				funcionario.edit.opened = false

		vm
]