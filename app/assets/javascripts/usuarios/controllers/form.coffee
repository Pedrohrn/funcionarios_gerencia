angular.module('scApp').lazy
.controller 'CorpoDiretivo::FormCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'Usuario', 'Grupo', 'Cargo'
	(scModal, scAlert, scToggle, scTopMessages, Templates, Usuario, Grupo, Cargo)->
		vm = this
		vm.params = {}
		vm.usuario = null

		vm.init = (usuario)->
			vm.usuario = usuario || { expedientes: [] }
			vm.params = angular.copy vm.usuario
			delete vm.params.vigencia_inicio
			delete vm.params.vigencia_fim
			delete vm.params.ferias_fim
			delete vm.params.ferias_inicio
			#vm.params.vigencia = new Date()

		vm.formCtrl =
			teste: 'oi'

			rmvExpediente: (expediente)->
				vm.params.expedientes.remove expediente

			addExpediente: ->
				vm.params.expedientes.unshift({ dias: [], horario_fim: '', horario_inicio: '' })

		vm
]