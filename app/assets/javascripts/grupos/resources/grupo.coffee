angular.module('scApp').lazy
.factory 'Grupo', [
	'$resource'
	($resource)->
		encapsulateData = (data) -> JSON.stringify { grupo: data }

		$resource 'http://localhost:3000/funcionario_grupos/:id.json', { id: '@id' },
			list:
				method: 'GET'

			submit:
				method: 'POST'
				url: 'http://localhost:3000/funcionario_grupos/submit'
				transformRequest: encapsulateData

			micro_update:
				method: 'PUT'
				url: 'http://localhost:3000/funcionario_grupos/micro_update'
				transformRequest: encapsulateData

			destroy:
				method: 'DELETE'

			show:
				method: 'GET'

]