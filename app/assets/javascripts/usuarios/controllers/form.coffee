angular.module('scApp').lazy
.controller 'CorpoDiretivo::FormCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'Usuario', 'Grupo', 'Cargo'
	(scModal, scAlert, scToggle, scTopMessages, Templates, Usuario, Grupo, Cargo)->
		vm = this
		vm.params = {}
		vm.usuario = null

		vm.init = (usuario)->
			vm.params = angular.copy usuario || {}
			return if Object.blank(vm.params)
			vm.params.ferias_inicio = new Date(vm.params.ferias_inicio)
			vm.params.ferias_fim = new Date(vm.params.ferias_fim)
			vm.params.vigencia_inicio = new Date(vm.params.vigencia_inicio)
			vm.params.vigencia_fim = new Date(vm.params.vigencia_fim)
			vm.params.nascimento = new Date(vm.params.nascimento)
			vm.params.telefones = [
				{ label: 111111111 },
				{ label: 222222222 },
				{ label: 333333333 },
			]

		vm.formCtrl =
			novoTelefone: { label: '' }

			init: (grupo) ->
				grupo.visualizacoes = new scToggle()
				grupo.checked = 0

			toggleVisualizacoesOption: (option, grupo) ->
				option.checked = !option.checked
				if option.checked
					grupo.checked++
				else
					grupo.checked--

			rmvExpediente: (expediente)->
				vm.params.expedientes.remove expediente

			addExpediente: ->
				vm.params.expedientes.unshift({ dias: [], horario_fim: '', horario_inicio: '' })

			addTelefone: ->
				return if @novoTelefone.label == ''
				vm.params.telefones.push(@novoTelefone)
				@novoTelefone.label = ''

			updateTelefone: (telefone)->
				console.log 'oioi nada por aqui ainda'

			rmvTelefone: (telefone)->
				vm.params.telefones.remove(telefone)

		vm.cargosCtrl =
			creatingMode: false
			loading: false
			menuOpened: false
			list: []
			modal: new scModal()
			params: {}

			init: (obj={})->
				return if @loading

				@loading = true

				params = angular.copy obj

				Cargo.list params,
					(data)=>
						@loading = false

						@list.addOrExtend item for item in data.cargos

			formInit: (cargo)->
				if @newRecord
					@params = { nome: '' }
				else
					@params = angular.copy cargo || {}

			openMenu: ->
				@menuOpened = !@menuOpened

			toggleCreatingMode: ->
				@creatingMode = !@creatingMode

			edit: ->
				if Object.blank(vm.params.cargo)
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
		vm
]