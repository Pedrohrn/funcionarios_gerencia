angular.module('scApp').lazy
.controller 'CorpoDiretivo::FormCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'Funcionario', 'Grupo', 'Cargo'
	(scModal, scAlert, scToggle, scTopMessages, Templates, Funcionario, Grupo, Cargo)->
		vm = this
		vm.params = {}
		vm.funcionario = null
		vm.loading = false

		vm.baseFact = null

		vm.init = (funcionario, baseFact)->
			vm.baseFact = baseFact
			vm.params = angular.copy funcionario || {}
			if !vm.params.id
				vm.params = { pessoa: { telefones: [], emails_alternativos: [] }, expedientes: [], grupo: vm.baseFact.grupo }
			else
				vm.params.vigencia_inicio = new Date(vm.params.vigencia_inicio)
				vm.params.vigencia_fim = new Date(vm.params.vigencia_fim)
				vm.params.pessoa.nascimento = new Date(vm.params.pessoa.nascimento)

		vm.expedientesCtrl =
			toggleDay: (dia, expediente)->
				if expediente.dias.include(dia.value)
					expediente.dias.remove(dia.value)
				else
					expediente.dias.push(dia.value)

		vm.formCtrl =
			novoTelefone: ''
			novoEmail: ''

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
				vm.params.expedientes.unshift({ dias: [], hora_fim: '', hora_inicio: '' })

			addTelefone: ->
				return if @novoTelefone == ''
				if vm.params.pessoa.telefones.include(@novoTelefone)
					scAlert.open
						title: 'Este telefone já existe na lista e não será adicionado novamente.'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
				else
					vm.params.pessoa.telefones.push(@novoTelefone)
					@novoTelefone = ''

			updateTelefone: (telefone)->
				@novoTelefone = angular.copy telefone
				vm.params.pessoa.telefones.remove(telefone)

			rmvTelefone: (telefone)->
				vm.params.pessoa.telefones.remove(telefone)

			addEmail: ->
				return if @novoEmail == ''
				if vm.params.pessoa.emails_alternativos.include(@novoEmail)
					scAlert.open
						title: 'Esse e-mail já existe na lista de emails e não será adicionado novamente!'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
				else if vm.params.pessoa.email == @novoEmail
					scAlert.open
						title: 'Este já é o email principal!'
						buttons: [
							{ label: 'Ok', color: 'gray' }
						]
				else
					vm.params.pessoa.emails_alternativos.push(@novoEmail)
					@novoEmail = ''

			updateEmail: (email)->
				@novoEmail = angular.copy email
				vm.params.pessoa.emails_alternativos.remove(email)

			rmvEmail: (email)->
				vm.params.pessoa.emails_alternativos.remove(email)

		vm.submit = (funcionario) ->
			return if vm.loading

			vm.loading = true

			Funcionario.submit vm.params,
				(data)=>
					vm.loading = false

					if vm.params.id
						angular.extend funcionario, data.funcionario
						message = 'Registro atualizado com sucesso!'
					else
						funcionario = angular.copy vm.params
						message = 'Registro cadastrado com sucesso!'
						vm.baseFact.load(funcionario)

					scTopMessages.openSuccess message

					vm.baseFact.close()
				(response)=>
					vm.loading = false

					errors = response.data?.errors

					scTopMessages.openDanger errors unless Object.blank(errors)

		vm

]