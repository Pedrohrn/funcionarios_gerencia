angular.module('scApp').lazy
.factory 'Funcionario', [
	'$resource'
	($resource)->
		encapsulateData = (data) => JSON.stringify { funcionario: data }

		$resource 'http://localhost:3000/funcionarios/:id.json', { id: '@id' },
			list:
				method: 'GET'

			show:
				method: 'GET'

			submit:
				method: 'POST'
				url: 'http://localhost:3000/funcionarios/submit'
				transformRequest: encapsulateData

			destroy:
				method: 'DELETE'

			micro_update:
				method: 'PUT'
				url: 'http://localhost:3000/funcionarios/micro_update'
				transformRequest: encapsulateData

]