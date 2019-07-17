angular.module('scApp').lazy
.controller 'CorpoDiretivo::IndexCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'Usuario', 'Grupo', 'Cargo', 'Recesso'
	(scModal, scAlert, scToggle, scTopMessages, Templates, Usuario, Grupo, Cargo, Recesso)->
		vm = this
		vm.templates = Templates

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

				Usuario.list params,
					(data)=>
						vm.usuariosCtrl.list.addOrExtend item for item in data.usuarios

				Cargo.list params,
					(data)=>
						vm.cargosCtrl.list.addOrExtend item for item in data.cargos

		vm.usuariosCtrl =
			list: []

			init: (usuario)->
				usuario.menu = new scToggle()
				usuario.edit = new scToggle()
				usuario.ferias_modal = new scModal()
				usuario.ferias = usuario.ferias || []
				expedientes = usuario.expedientes

			open_ferias_modal: (usuario)->
				usuario.ferias_modal.open()
				return if usuario.ferias.loaded

				usuario.ferias.loading = true

				params = { usuario_id: usuario.id }

				Recesso.list params,
					(data)=>
						usuario.ferias.loading = false
						usuario.ferias.loaded = true

						usuario.ferias.addOrExtend item for item in data.recessos

			edit: (usuario)->
				usuario.edit.opened = true
				vm.newUserCtrl.modal.open()
				return if usuario.loaded || @loading

				@loading = true

				Usuario.show usuario,
					(data)=>
						@loading = false

						grupo = vm.listCtrl.list.find (obj)-> obj.id == data.usuario.grupo_id
						usuario = grupo.usuarios.find (obj)-> obj.id == data.usuario.id
						usuario.loaded = true
						angular.extend usuario, data.usuario
					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

			rmv: (usuario)->
				scAlert.open
					title: 'Tem certeza que deseja excluir o usuário?'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.usuariosCtrl.destroy(usuario) },
						{ label: 'Não', color: 'gray' },
					]

			inativar: (usuario)->
				label = if usuario.inativado_em then 'reativar' else 'desativar'
				scAlert.open
					title: 'Tem certeza de que deseja ' + label + ' o usuário?'
					buttons: [
						{ label: label.capitalize(), color: 'yellow', action: -> vm.usuariosCtrl.micro_update(usuario) },
						{ label: 'Não', color: 'gray' },
					]

		vm.gruposCtrl =
			modal: new scModal()
			newRecord: false
			creatingModeOn: false
			params: {}

			init: (grupo)->
				grupo.options = new scToggle()
				grupo.modal_edit = new scToggle()

			formInit: (grupo)->
				@params = angular.copy grupo || {}

			openModal: ->
				@modal.open()

			edit: (grupo) ->
				if @creatingModeOn
					scAlert.open
						title: 'Termine a edição atual antes de editar/criar outro grupo!'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
				else
					@creatingModeOn = true
					grupo.modal_edit.toggle()

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
					@newRecord = false
				else
					grupo.edit.toggle()

			cancelar_modal: (grupo)->
				grupo.modal_edit.toggle()
				@creatingModeOn = false

			salvar: (grupo)->
				if @newRecord
					@create()
				else
					@update(grupo)

			rmv: (grupo)->
				scAlert.open
					title: "Atenção! Deseja mesmo excluir o grupo selecionado?"
					message: [
						{ msg: 'Os dados não poderão ser recuperados, uma vez que sejam excluídos.'},
						{ msg: 'Os usuários participantes desse grupo serão realocados no grupo "Sem Grupo".'}
						{ msg: 'Confirma a operação?'}
					]
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> vm.gruposCtrl.excluir(grupo) },
						{ label: 'Cancelar', color: 'gray' }
					]

			excluir: (grupo)->
				return if @loading

				@loading = true

				Grupo.destroy grupo,
					(data)=>
						@loading = false

						msg = data.message

						scTopMessages.openSuccess msg unless Object.blank(msg)
					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

			create: ->
				return if @loading

				@loading = true

				Grupo.create @params,
					(data)=>
						@loading = false

						grupo = data.grupo

						vm.listCtrl.list.push(grupo)

						scTopMessages.openSuccess data.message
						@resetForm()
					(response)=>
						@loading = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			update: (grupo)->
				return if @loading

				@loading = true

				Grupo.update @params,
					(data)=>
						@loading = false

						grupo = vm.listCtrl.list.find (obj)-> obj.id == grupo.id
						grupo.edit.opened = false
						angular.extend grupo, data.grupo
						@resetForm()
						scTopMessages.openSuccess data.message
					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

			resetForm: (grupo)->
				if grupo && grupo.edit
					grupo.edit.opened = false
				@newRecord = false
				@creatingModeOn = false

			destroy: (grupo)->
				return if @loading

				@loading = true

				Grupo.destroy grupo,
					(data)=>
						@loading = false

						vm.listCtrl.list.remove(grupo)
						scTopMessages.openSuccess data.message
					(response)=>
						@loading = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			inativar: (grupo)->
				@params = { id: grupo.id, inativado_em: grupo.inativado_em, micro_update_type: 'inativar'}

				@micro_update_submit()

			micro_update_submit: ->
				return if @loading

				@loading = true

				Grupo.micro_update @params,
					(data)=>
						@loading = false

						grupo = vm.listCtrl.list.find (obj)-> obj.id == data.grupo.id
						angular.extend grupo, data.grupo
						@resetForm()
						scTopMessages.openSuccess data.message
					(response)=>
						@loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

		vm.feriasCtrl =
			newRecord: false
			params: {}
			loading: false
			creatingModeOn: false

			novoCadastro: (usuario)->
				@creatingModeOn = true
				@newRecord = true
				@params = { usuario_id: usuario.id}

			init: (ferias)->
				ferias.acc = new scToggle()
				ferias.menu = new scToggle()

			editar: (ferias, usuario)->
				@creatingModeOn = true
				@params = angular.copy ferias
				@params.usuario_id = usuario.id
				@formInit()

			formInit: ->
				@params.data_inicio = new Date(@params.data_inicio)
				@params.data_fim = new Date(@params.data_fim)

			rmv: (ferias, usuario)->
				scAlert.open
					title: 'Tem certeza de que deseja excluir esse registro?'
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> vm.feriasCtrl.excluir(ferias, usuario) },
						{ label: 'Cancelar', color: 'gray' }
					]

			excluir: (ferias, usuario)->
				return if @loading

				@loading = true

				Recesso.destroy ferias,
					(data)=>
						@loading = false
						usuario.ferias.remove(ferias)
						message = data.message

						scTopMessages.openSuccess message unless Object.blank(message)
					(response)=>
						@loading = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			show: (ferias) ->
				ferias.acc.toggle()

			cancelar: (usuario) ->
				if @creatingModeOn
					scAlert.open
						title: 'Tem certeza que deseja cancelar? Dados não salvos serão perdidos.'
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> vm.feriasCtrl.resetModal(usuario) },
							{ label: 'Não', color: 'gray' }
						]
				else
					usuario.ferias_modal.close()

			salvar: (usuario)->
				if @newRecord
					@create(usuario)
				else
					@update(usuario)

			create: (usuario)->
				return if @loading

				@loading = true

				Recesso.create @params,
					(data)=>
						@loading = false

						ferias = data.recesso

						usuario.ferias.push(ferias)
						@resetForm()

						scTopMessages.openSuccess data.message
					(response)=>
						@loading = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			update: (usuario)->
				return if @loading

				@loading = true

				Recesso.update @params,
					(data)=>
						@loading = false

						ferias = usuario.ferias.find (obj)-> obj.id == data.recesso.id
						angular.extend ferias, data.recesso

						@resetForm()

						scTopMessages.openSuccess data.message
					(response)=>
						@loading = false
						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			resetModal: (usuario)->
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
				if Object.blank(cargo)
					scAlert.open
						title: 'Selecione um cargo para poder editar!'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
				else
					@toggleCreatingMode()

			new: ->
				@newRecord = true
				@toggleCreatingMode()

			salvar: (cargo)->
				if @newRecord
					@create()
				else
					@update(cargo)

				@menuOpened = false

			update: (cargo) ->
				return if @loading

				@loading = true

				Cargo.update @params,
					(data)=>
						@loading = false

						cargo = @list.find (obj)-> obj.id == cargo.id
						angular.extend cargo, data.cargo
						scTopMessages.openSuccess data.message
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
				return if @loading

				@loading = true

				Cargo.destroy cargo,
					(data)=>
						@loading = false

						msg = data.message
						vm.params.cargo = {}
						@init({})
						@resetForm()

						scTopMessages.openSuccess msg unless Object.blank(msg)
					(response)=>
						@loading = false

						errors = response.data?.errors

						scTopMessages.openDanger errors unless Object.blank(errors)

			create: ->
				return if @loading

				@loading = true

				Cargo.create @params,
					(data)=>
						@loading = false
						@list.push(data.cargo)
						scTopMessages.openSuccess data.message
						@resetForm()
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

			cadastrarUsuario: (usuario, grupo) ->
				@newRecord = true
				@modal.active = !@modal.active

		vm.itemCtrl =
			newRecord: false
			init: (grupo)->
				grupo.show = new scToggle()
				grupo.menu = new scToggle()
				grupo.edit = new scToggle()
				grupo.newUser = new scToggle()

			accToggle: (grupo)->
				return if grupo.edit.opened
				grupo.loading = false
				grupo.show.toggle()
				@show(grupo)

			show: (grupo)->
				return if grupo.loaded

				Grupo.show grupo,
					(data)=>
						grupo.loaded = true
						grupo.loading = false

						grupo = vm.listCtrl.list.find (obj)-> obj.id == data.grupo.id
						angular.extend grupo, data.grupo
					(response)=>
						grupo.loaded = true
						grupo.loading = false

						errors = response.data?.errors
						scTopMessages.openDanger errors unless Object.blank(errors)

			rmv: (grupo)->
				scAlert.open
					title: 'Tem certeza de que deseja excluir esse grupo?'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.itemCtrl.destroy(grupo) },
						{ label: 'Não', color: 'gray' },
					]

			inativar: (grupo)->
				label = if grupo.inativado_em? then 'reativar' else 'desativar'
				scAlert.open
					title: 'Tem certeza que deseja ' + label + ' o grupo?'
					buttons: [
						{ label: label.capitalize(), color: 'yellow', action: -> vm.gruposCtrl.micro_update(grupo) },
						{ label: 'Não', color: 'gray' },
					]

			edit: (grupo)->
				return unless !grupo.edit.opened
				vm.gruposCtrl.creatingModeOn = true
				grupo.show.opened = false
				grupo.edit.toggle()

			new: (grupo)->
				console.log grupo
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
			cancelar: (usuario) ->
				scAlert.open
					title: 'Deseja mesmo cancelar a edição? Dados não salvos serão perdidos'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.formCtrl.closeForm(usuario) },
						{ label: 'Não', color: 'gray' }
					]

			closeForm: (usuario)->
				vm.newUserCtrl.modal.close()
				vm.newUserCtrl.newRecord = false
				return if usuario == undefined
				console.log 'oi'
				usuario.edit.opened = false

		vm
]