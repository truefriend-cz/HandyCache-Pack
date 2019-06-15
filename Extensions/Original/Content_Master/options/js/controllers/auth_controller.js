
angular.module('CMOptionsApp').controller('authController', ['$scope', '$http', '$rootScope',
	function ($scope, $http, $rootScope) {
		$scope.submit = function() {
			if ($rootScope.isAuthenticated) {
				$rootScope.isAuthenticated = false;
			} else {
				$http.get('auth', { headers: { "CM-Auth": crc32(AuthForm.pass.value) } })
					.success(function (data) {
						$rootScope.isAuthenticated = true;
						$rootScope.gotoPage('filters');
					})
					.error(function (data, status) {
						console.info(status)
					});
				AuthForm.pass.value = "";
			};
		};
	}
]);