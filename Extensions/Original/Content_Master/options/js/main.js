
angular.module('CMOptionsApp', ['pascalprecht.translate', 'once', 'ngAnimate', 'angular.filter', 'ngDragDrop', 'ui.bootstrap'])

.config(['$translateProvider',
	function ($translateProvider) {
		$translateProvider.useStaticFilesLoader({
			prefix : 'language/',
			suffix : '.json'
		});
		// $translateProvider.use('russian');
	}
])

.controller('MainController', ['$translate', '$rootScope', '$scope', '$http',
	function ($translate, $rootScope, $scope, $http) {
		
		$rootScope.gotoPage = function (page, arg) {
			$rootScope.selectedPage = page;
			if (page=='editor') { $rootScope.pages.editor.targetSearchWord = arg; };
		};

		$scope.$on('selectEditorFile', function (event, fname, arg) {
			$rootScope.pages.editor.targetFile = fname;
		});
			
		$scope.getCommonData = function () {
			var selectedUserName = angular.isDefined($scope.selectedUser) ? $scope.selectedUser.Name : '';
			return $http.get('load_common_options.json')
			.success(function (data) {
				var emptyObject = function (obj) {
					for (var i in obj) { return false; }
					return true;
				}
				var ff = function (obj) {
					if (angular.isObject(obj)) {
						if (emptyObject(obj)) {
							return true;
						} else {
							angular.forEach(obj, function (value, key) {
								if (ff(value)==true && key=='Files') { obj[key] = []; };
							});
						};
					} else {
						if (angular.isArray(obj)) {
							angular.forEach(obj, function (value, key) {
								ff(value);
							});
						};
					};
				};
				ff(data);
				$rootScope.options = data;
				var lng_table = [];
				lng_table[1049] = 'russian';
				$translate.use(lng_table[$rootScope.options.LanguageID]);
				
				$rootScope.Pass = { "p": "" };
				if (/^127\.0\./.test($rootScope.options.UserIP)) {
					$rootScope.isAuthenticated = true;
					$rootScope.isLocalUser = true;
				};
				$rootScope.users = $rootScope.options.users;
				// var newUser = $rootScope.users[0];
				// if (selectedUserName != '') {
					// angular.forEach($rootScope.users, function (user, i) {
						// if (user.Name == selectedUserName) {
							// newUser = user;
						// };
					// });
				// };
				// $scope.selectUser(newUser);
				
				$rootScope.pages = {
					auth: { on: false, url: '' },
					filters: { on: false, url: '' },
					options: { on: false, url: '' },
					log: { on: false, url: '' },
					editor: { on: false, url: '' }
				}
				$rootScope.$watch('selectedPage', function (newPage, oldPage) {
					$rootScope.pages[oldPage].on = false;
					$rootScope.pages[newPage].url = 'html/' + newPage + '.html';
					$rootScope.pages[newPage].on = true;
				});
				
				$rootScope.$broadcast('selectEditorFile', '');
				$rootScope.gotoPage($rootScope.isAuthenticated ? 'filters' : 'auth');
			})
			.error(function (data, status) {
				console.info(status)
			});
		};
		
		$scope.logout = function () {
			$rootScope.isAuthenticated = false;
			$rootScope.gotoPage('auth');
		};
		
		$scope.saveOptions = function () {
			if ($rootScope.Pass.p!="") {
				$rootScope.options.fromUsersALL.Pass = crc32($rootScope.Pass.p);
			};
			$http.post('save_all_options.json', $rootScope.options);
		};

		$rootScope.getSourceByURL = function (url) {
			var source;
			angular.forEach($rootScope.options.fromUsersALL.Sources, function (value, key) {
				if (value.URL == url) {
					source = value;
				};
			});
			return source;
		};
		
		
		$scope.getCommonData();

	}
]);

var makeCRCTable = function(){
	var c;
	var crcTable = [];
	for(var n =0; n < 256; n++){
		c = n;
		for(var k =0; k < 8; k++){
			c = ((c&1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1));
		}
		crcTable[n] = c;
	}
	return crcTable;
}

var crc32 = function(str) {
	var crcTable = makeCRCTable();
	var crc = 0 ^ (-1);
	for (var i = 0; i < str.length; i++ ) {
		crc = (crc >>> 8) ^ crcTable[(crc ^ str.charCodeAt(i)) & 0xFF];
	}
	return (crc ^ (-1)) >>> 0;
};
