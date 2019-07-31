angular.module('scApp').lazy
.factory 'Cargo', [
	'$resource'
	($resource)->
		encapsulateData = (data)-> JSON.stringify { cargo: data }

		$resource 'http://localhost:3000/funcionario_cargos/:id.json', { id: '@id' },
			list:
				method: 'GET'

			micro_update:
				method: 'PUT'
				url: 'http://localhost:3000/funcionario_cargos/micro_update'
				transformRequest: encapsulateData

			destroy:
				method: 'DELETE'

			submit:
				method: 'POST'
				url: 'http://localhost:3000/funcionario_cargos/submit'
				transformRequest: encapsulateData

]