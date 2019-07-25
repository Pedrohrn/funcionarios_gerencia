angular.module('scApp').lazy
.factory 'CorpoDiretivo::FormFactory', [
 'scAlert', '$scModal'
	(scAlert, scModal)->
		->
			baseObj =
				modal: new scModal()

				init: (usuario, grupo)->
					@grupo = grupo
					@usuario = usuario || { grupo: @grupo }
					@modal.active = true

				close: ->
					@usuario = {}
					@modal.active = false

				cancelar: ->
					scAlert.open
						title: 'Deseja mesmo fechar o formulário? Dados não salvos serão perdidos.'
						buttons: [
							{ label: 'Fechar', color: 'yellow', action: => @close() },
							{ label: 'Cancelar', color: 'gray' },
						]

			baseObj
]