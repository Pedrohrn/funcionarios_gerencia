angular.module('scApp').lazy
.factory 'Usuario', [
	'$resource'
	($resource)->

		$resource 'http://localhost:3000/usuarios/:id.json', { id: '@id' },
			list:
				method: 'GET'

]