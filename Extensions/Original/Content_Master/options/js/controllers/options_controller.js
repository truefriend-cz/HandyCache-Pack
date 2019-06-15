angular.module('CMOptionsApp').controller('optionsController', ['$scope', '$http', '$rootScope',
	function ($scope, $http, $rootScope) {
		$scope.selectEditor = function () {
			return $http.get('cmd_SelectEditor')
				.success(function (data) {
					$rootScope.options.fromUsersALL.Editor = data;
				})
				.error(function (data, status) {
					console.info(status)
				});
		};
	}
]);
