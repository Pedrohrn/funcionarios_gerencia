angular.module('scApp').lazy
.controller 'CorpoDiretivo::FormCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'Usuario', 'Grupo', 'Cargo'
	(scModal, scAlert, scToggle, scTopMessages, Templates, Usuario, Grupo, Cargo)->
		vm = this
		vm.params = {}
		vm.usuario = null
		vm.loading = false

		vm.init = (usuario, grupo)->
			vm.params = angular.copy usuario || {}
			console.log grupo
			if !vm.params.id
				console.log 'novo'
				vm.params.telefones = []
				vm.params.expedientes = []
				vm.params.grupo = grupo
			else
				console.log 'edição'
				vm.params.vigencia_inicio = new Date(vm.params.vigencia_inicio)
				vm.params.vigencia_fim = new Date(vm.params.vigencia_fim)
				vm.params.nascimento = new Date(vm.params.data_nascimento)
			console.log vm.params

		vm.expedientesCtrl =
			toggleDay: (dia, expediente)->
				if expediente.dias.include(dia.value)
					expediente.dias.remove(dia.value)
				else
					expediente.dias.push(dia.value)
				console.log expediente.dias

		vm.formCtrl =
			novoTelefone: ''

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
				console.log '1'
				console.log vm.params
				vm.params.expedientes.unshift({ dias: [], horario_fim: '', horario_inicio: '' })

			addTelefone: ->
				return if @novoTelefone == ''
				if vm.params.telefones.include(@novoTelefone)
					scAlert.open
						title: 'Este telefone já existe na lista e não será adicionado novamente.'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
				else
					vm.params.telefones.push(@novoTelefone)
					@novoTelefone = ''

			updateTelefone: (telefone)->
				console.log 'oioi nada por aqui ainda'

			rmvTelefone: (telefone)->
				vm.params.telefones.remove(telefone)

		vm.salvar = (usuario) ->
			if usuario == undefined
				vm.create(usuario)
			else
				vm.update(usuario)

		vm.update = (usuario) ->
			return if vm.loading

			vm.loading = true

			Usuario.update vm.params,
				(data)=>
					vm.loading = false

					angular.extend usuario, data.usuario
					msg = data.message
					scTopMessages.openSuccess msg unless Object.blank(msg)
				(response)=>
					vm.loading = false

					errors = response.data?.errors

					scTopMessages.openDanger errors unless Object.blank(errors)


		vm.create = (usuario) ->
			return if vm.loading

			vm.loading = true

			Usuario.create vm.params,
				(data)=>
					vm.loading = false

					usuario = data.usuario
					msg = data.message

					scTopMessages.openSuccess msg unless Object.blank(msg)
				(response)=>
					vm.loading = false

					errors = response.data?.errors
					scTopMessages.openDanger errors unless Object.blank(errors)


		vm

]