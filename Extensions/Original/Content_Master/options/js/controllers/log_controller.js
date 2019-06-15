angular.module('CMOptionsApp')
.controller('logController', ['$scope', '$rootScope', '$http',
		function ($scope, $rootScope, $http) {
			$scope.logOptions = {
				"selectedLogUser" : "",
				"selectedLogURL" : ""
			};
			$scope.getData = function () {
				return $http.get('ContentMasterLog.txt')
				.success(function (data) {
					$scope.log = data=='' ? [] : angular.fromJson(data.replace(/^,/, '[') + ']').reverse();
				})
				.error(function (data, status) {
					console.info(status)
				});
			};
			$scope.logOn = function () {
				$http.get('cmd_ToggleLog')
				.success(function (data) {
					$rootScope.options.fromUsersALL.Log.On = !$rootScope.options.fromUsersALL.Log.On;
				})
				.error(function (data, status) {
					console.info(status)
				});
			};
			$scope.emptyLog = function () {
				$http.get('cmd_ClearLog')
				.success(function (data) {
					$scope.log = [];
				})
				.error(function (data, status) {
					console.info(status)
				});
			};
			$scope.compareUser = function (actual, expected) {
				if (expected == "") {
					return true
				};
				return angular.equals(expected, actual);
			};
			
			$scope.editRule = function (hit) {
				// rule = getRule(hit.Parser, hit.FileNumber, hit.StrNumber);
				// $scope.record.UserName
				if (hit.Parser=='ContentMaster') {
					$rootScope.$broadcast('selectEditorFile', $rootScope.getSourceByURL($rootScope.users[0].Parsers[hit.Parser].Files[hit.FileNumber-1].URL).Name);
					$rootScope.$broadcast('setEditorSearchWord', hit.RuleText);
					$rootScope.gotoPage('editor', hit.RuleText);
				};
			};
			
			$scope.getBackgroundColor = function (record) {
				if (record.LogData && record.LogData.length==1 && record.LogData[0].RuleType=='block') {
					return '#fff0f0';
				} else if (record.LogData && record.LogData.length==1 && record.LogData[0].RuleType=='bypass') {
					return '#f0f0ff';
				};
				return '#f0fff0';
			};
			
			$scope.getData();
		}
	]);
