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

		vm
]