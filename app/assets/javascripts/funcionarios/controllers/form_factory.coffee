angular.module('scApp').lazy
.factory 'CorpoDiretivo::FormFactory', [
 'scAlert', '$scModal'
	(scAlert, scModal)->
		->
			baseObj =
				modal: new scModal()

				init: (funcionario, grupo)->
					@grupo = grupo
					@funcionario = funcionario || { grupo: @grupo }
					@modal.active = true

				close: ->
					@funcionario = {}
					@modal.active = false

				load: (funcionario) ->
					@grupo.funcionarios.push(funcionario)

				cancelar: ->
					scAlert.open
						title: 'Deseja mesmo fechar o formulário? Dados não salvos serão perdidos.'
						buttons: [
							{ label: 'Fechar', color: 'yellow', action: => @close() },
							{ label: 'Cancelar', color: 'gray' },
						]

			baseObj
]