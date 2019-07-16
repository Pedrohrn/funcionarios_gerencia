angular.module('scApp').lazy
.factory 'Usuario', [
	'$resource'
	($resource)->
		encapsulateData = (data) => JSON.stringify { usuario: data }

		$resource 'http://localhost:3000/usuarios/:id.json', { id: '@id' },
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

			micro_update:
				method: 'PUT'
				url: 'http://localhost:3000/usuarios/micro_update'
				transformRequest: encapsulateData

]