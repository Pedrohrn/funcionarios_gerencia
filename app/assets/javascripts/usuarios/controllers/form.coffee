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
			if !vm.params.id
				vm.params.telefones = []
				vm.params.expedientes = []
				vm.params.grupo = grupo
			else
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

			rmvTelefone: (telefone)->
				vm.params.telefones.remove(telefone)

		vm.submit = (usuario) ->
			return if vm.loading

			vm.loading = true

			Usuario.submit vm.params,
				(data)=>
					vm.loading = false

					if vm.params.id
						angular.extend usuario, data.usuario
						message = 'Registro atualizado com sucesso!'
					else
						message = 'Registro cadastrado com sucesso!'

					scTopMessages.openSuccess message
				(response)=>
					vm.loading = false

					errors = response.data?.errors

					scTopMessages.openDanger errors unless Object.blank(errors)

		vm

]