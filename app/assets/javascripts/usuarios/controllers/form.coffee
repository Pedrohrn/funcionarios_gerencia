console.log 'aiaiaiaiai'
angular.module('scApp').lazy
.controller 'CorpoDiretivo::FormCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'Usuario', 'Grupo', 'Cargo'
	(scModal, scAlert, scToggle, scTopMessages, Templates, Usuario, Grupo, Cargo)->
		vm = this
		vm.params = {}
		vm.usuario = null
		vm.aux = {}

		vm.init = (usuario)->
			console.log 'oioioioi'
			vm.usuario = usuario || {}
			vm.params = angular.copy vm.usuario
			delete vm.params.vigencia_inicio
			delete vm.params.vigencia_fim
			delete vm.params.ferias_fim
			delete vm.params.ferias_inicio

		vm.formCtrl =
			teste: 'oi'

			addExpediente: ->
				console.log @teste
				vm.params.expedientes.push({ horario_fim: '', horario_inicio: '' })
]