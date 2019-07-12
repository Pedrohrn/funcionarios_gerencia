angular.module('scApp').lazy
.factory 'Cargo', [
	'$resource'
	($resource)->
		encapsulateData = (data)-> JSON.stringify { cargo: data }

		$resource 'http://localhost:3000/cargos/:id.json', { id: '@id' },
			list:
				method: 'GET'

			micro_update:
				method: 'PUT'
				url: 'http://localhost:3000/cargos/micro_update'
				transformRequest: encapsulateData

			destroy:
				method: 'DELETE'

			update:
				method: 'PUT'
				transformRequest: encapsulateData

			create:
				method: 'POST'
				transformRequest: encapsulateData
]