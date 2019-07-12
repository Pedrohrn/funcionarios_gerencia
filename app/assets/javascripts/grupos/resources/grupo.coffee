angular.module('scApp').lazy
.factory 'Grupo', [
	'$resource'
	($resource)->
		encapsulateData = (data) -> JSON.stringify { grupo: data }

		$resource 'http://localhost:3000/grupos/:id.json', { id: '@id' },
			list:
				method: 'GET'

			create:
				method: 'POST'
				transformRequest: encapsulateData

			update:
				method: 'PUT'
				transformRequest: encapsulateData

			micro_update:
				method: 'PUT'
				url: 'http://localhost:3000/grupos/micro_update'
				transformRequest: encapsulateData

			destroy:
				method: 'DELETE'

			show:
				method: 'GET'

]