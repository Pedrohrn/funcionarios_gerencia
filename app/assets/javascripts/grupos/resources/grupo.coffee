angular.module('scApp').lazy
.factory 'Grupo', [
	'$resource'
	($resource)->

		$resource 'http://localhost:3000/grupos/:id.json', { id: '@id' },
			list:
				method: 'GET'

]