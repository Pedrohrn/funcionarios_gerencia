angular.module('scApp').lazy
.controller 'CorpoDiretivo::ShowCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'Grupo', 'CorpoDiretivo::FormFactory'
	(scModal, scAlert, scToggle, scTopMessages, Templates, Grupo, FormFactory)->
		vm = this
		vm.templates = Templates
		vm.formFact = new FormFactory

		vm.grupo = null

		vm.init = (grupo)->
			vm.grupo = grupo
			vm.grupo.show = new scToggle()
			vm.grupo.menu = new scToggle()
			vm.grupo.edit = new scToggle()
			vm.grupo.newUser = new scToggle()

		vm.accToggle = ->
			unless vm.grupo.show.opened
				vm.grupo.show.open()
				carregarGrupo()
				return

			return vm.formFact.cancelar() if vm.formFact.opened
			vm.grupo.show.toggle()

		vm.formCtrl =
			open: ->
				return vm.FormFact.cancelar() if vm.formFact.opened
				vm.grupo.show.open()

				carregarGrupo ->
					vm.formFact.init(vm.grupo)

		carregarGrupo = (callback)->
			return callback?() if vm.grupo.carregado || vm.grupo.carregando
			vm.grupo.carregando = true

			Grupo.show vm.grupo,
				(data)=>
					vm.grupo.carregado = true
					vm.grupo.carregando = false

					angular.extend vm.grupo, data.grupo

					callback?()
		vm
]