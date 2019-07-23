angular.module('scApp').lazy
.factory 'CorpoDiretivo::FormFactory', [
 'scAlert', '$scModal'
	(scAlert, scModal)->
		->
			baseObj =
				opened: false
				active: false
				modal: new scModal()

				init: (usuario)->
					@usuario = usuario
					@modal.active = true
					@opened = true

				close: ->
					@usuario = {}
					@opened = false
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