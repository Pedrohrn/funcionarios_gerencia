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

			submit:
				method: 'POST'
				url: 'http://localhost:3000/recessos/submit'
				transformRequest: encapsulateData

			destroy:
				method: 'DELETE'

]