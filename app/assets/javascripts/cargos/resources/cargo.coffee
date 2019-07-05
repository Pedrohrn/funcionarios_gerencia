angular.module('scApp').lazy
.factory 'Cargo', [
	'$resource'
	($resource)->

		$resource 'http://localhost:3000/cargos/:id.json', { id: '@id' },
			list:
				method: 'GET'
]