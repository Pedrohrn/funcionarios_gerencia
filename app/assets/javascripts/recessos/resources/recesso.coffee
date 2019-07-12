angular.module('scApp').lazy
.factory 'Recesso', [
	'$resource'
	($resource)->
		encapsulateData = (data) -> JSON.stringify { recesso: data }

		$resource 'http://localhost:3000/recessos/:id.json', { id: '@id' },
			list:
				method: 'GET'

			show:
				method: 'GET'

			create:
				method: 'POST'
				transformRequest: encapsulateData

			update:
				method: 'PUT'
				transformRequest: encapsulateData

			destroy:
				method: 'DELETE'

]