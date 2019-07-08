angular.module('scApp').lazy
.controller 'CorpoDiretivo::IndexCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'Usuario', 'Grupo', 'Cargo'
	(scModal, scAlert, scToggle, scTopMessages, Templates, Usuario, Grupo, Cargo)->
		vm = this
		vm.templates = Templates

		vm.settings =
			diasSemana: [
				{ key: 'DOM', label: 'domingo', checked: false },
				{ key: 'SEG', label: 'segunda', checked: false },
				{ key: 'TER', label: 'terça', 	checked: false },
				{ key: 'QUA', label: 'quarta', 	checked: false },
				{ key: 'QUI', label: 'quinta', 	checked: false },
				{ key: 'SEX', label: 'sexta', 	checked: false },
				{ key: 'SAB', label: 'sábado', 	checked: false },
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

		vm.init = ->
			vm.filtro.exec()

		vm.getData = (data) ->
			dia = data.getDate() #??????

		vm.filtro =
			filtro_avancado: false
			options_are_visible: false
			days_are_visible: false

			showOptions: ->
				@options_are_visible = !@options_are_visible

			toggleOption: (option)->
				option.checked = !option.checked

			showDays: ->
				@days_are_visible = !@days_are_visible

			dayToggle: (day)->
				day.checked = !day.checked

			exec: ->
				vm.listCtrl.loadList()

			showFiltro: ->
				@filtro_avancado = !@filtro_avancado

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

			open_ferias_modal: (usuario)->
				usuario.ferias_modal.open()

			edit: (usuario)->
				usuario.edit.opened = true
				vm.newUserCtrl.modal.open()

			rmv: (usuario)->
				scAlert.open
					title: 'Tem certeza que deseja excluir o usuário?'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.usuariosCtrl.destroy(usuario) },
						{ label: 'Não', color: 'gray' },
					]

			inativar: (usuario)->
				label = if usuario.inativado_em? then 'reativar' else 'desativar'
				scAlert.open
					title: 'Tem certeza de que deseja ' + label + ' o usuário?'
					buttons: [
						{ label: label.capitalize(), color: 'yellow', action: -> vm.usuariosCtrl.micro_update(usuario) },
						{ label: 'Não', color: 'gray' },
					]

		vm.gruposCtrl =
			grupos_list: [
				{ label: 'Proprietários' },
				{ label: 'Moradores' },
				{ label: 'Moradores responsáveis' },
				{ label: 'Imobiliárias' },
				{ label: 'Porteiros' },
			]
			modal: new scModal()

			openModal: ->
				@modal.open()

			cancelar: (grupo)->
				scAlert.open
					title: 'Tem certeza de que deseja cancelar?'
					messages: [
						{ msg: 'Dados não salvos serão perdidos' }
					]
					buttons: [
						{ label: 'Fechar', color: 'yellow', action: -> vm.gruposCtrl.modal.close() },
						{ label: 'Voltar', color: 'gray' }
					]

			formInit: (grupo)->
				console.log 'oi formInit grupos'

		vm.feriasCtrl =
			form: new scToggle()
			newRecord: false
			params: {}
			loading: false

			novoCadastro: ->
				@form.opened = !@form.opened

			init: (ferias)->
				vm.feriasCtrl.form.opened = false
				ferias.acc = new scToggle()
				ferias.menu = new scToggle()

			formInit: (usuario, ferias)->
				@params = angular.copy usuario.ferias || {}

			closeModal: (usuario)->
				if @form.opened
					scAlert.open
						title: 'Existem formulários abertos nesta tela. Deseja mesmo fechar?'
						messages: [
							{ msg: 'Dados não salvos serão perdidos' },
						]
						buttons: [
							{ label: 'Fechar', color: 'yellow', action: -> usuario.ferias_modal.close() },
							{ label: 'Cancelar', color: 'gray' }
						]
				else
					usuario.ferias_modal.close()

			cancelar: (usuario) ->
				scAlert.open
					title: 'Tem certeza que deseja cancelar? Dados não salvos serão perdidos.'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.feriasCtrl.resetModal(usuario) },
						{ label: 'Não', color: 'gray' }
					]

			resetModal: (usuario)->
				@form.opened = false
				usuario.ferias_modal.close()

		vm.cargosCtrl =
			creatingMode: false
			menuOpened: false
			list: []
			modal: new scModal()

			openMenu: ->
				@menuOpened = !@menuOpened

			toggleCreatingMode: ->
				@creatingMode = !@creatingMode

			formInit: (cargo)->
				@params = angular.copy cargo || {}

			cancelar: ->
				scAlert.open
					title: 'Tem certeza de que deseja fechar'
					messages: [
						{ msg: 'Dados não salvos serão perdidos' },
					]
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.cargosCtrl.toggleCreatingMode() },
						{ label: 'Não', color: 'gray' },
					]

			edit: (cargo)->
				@toggleCreatingMode()
				@params.nome = angular.copy cargo.nome

		vm.newUserCtrl =
			newRecord: false
			modal: new scModal()

			cadastrarUsuario: (usuario) ->
				@modal.active = !@modal.active

		vm.itemCtrl =
			init: (grupo)->
				grupo.show = new scToggle()
				grupo.menu = new scToggle()

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

			edit: ->
				vm.gruposCtrl.modal.open()

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
			cancelar: ->
				scAlert.open
					title: 'Deseja mesmo cancelar a edição? Dados não salvos serão perdidos'
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.formCtrl.closeForm() },
						{ label: 'Não', color: 'gray' }
					]

			closeForm: ->
				vm.newUserCtrl.modal.close()

		vm
]