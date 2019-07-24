angular.module('scApp').lazy
.factory 'CorpoDiretivo::FormFactory', [
 'scAlert', '$scModal'
	(scAlert, scModal)->
		->
			baseObj =
				modal: new scModal()

				init: (usuario, grupo)->
					@usuario = usuario || { grupo: @grupo }
					@modal.active = true
					console.log @modal.active

				close: ->
					@usuario = {}
					@modal.active = false
					console.log @modal.active

				cancelar: ->
					scAlert.open
						title: 'Deseja mesmo fechar o formulário? Dados não salvos serão perdidos.'
						buttons: [
							{ label: 'Fechar', color: 'yellow', action: => @close() },
							{ label: 'Cancelar', color: 'gray' },
						]

			baseObj
]