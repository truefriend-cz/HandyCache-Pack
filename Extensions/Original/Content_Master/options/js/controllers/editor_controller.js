
angular.module('CMOptionsApp').controller('editorController', ['$scope', '$http', '$interval', '$rootScope', '$filter', '$timeout', 'rulesByTagsFilter',
		function ($scope, $http, $interval, $rootScope, $filter, $timeout, rulesByTagsFilter) {

			var recalcTags = function (file, type, word) {
				// $scope.filteredRules = $scope.rules; return;
				var tmp = $filter('filter')($scope.rules, function (value, index) {
					return (file=="" || file==value.File) && (type=="" || type==value.Type)
				});
				tmp = word ? $filter('filter')(tmp, $scope.editorOptions.searchWord) : tmp;
				$scope.filteredRules = rulesByTagsFilter(tmp, $scope.editorOptions.tags );
			};
			
			$scope.isFileLocal = function (fname) {
				if (!fname) { return; };
				for (var i=0; i<$scope.editorOptions.sources.length; i++) {
					if ($scope.editorOptions.sources[i].Name == fname) {
						return /^https?:\/\/local\.cm\//.test($scope.editorOptions.sources[i].URL);
					};
				};
			};
			
			$scope.isTagPresent = function (tag) {
				var rules = $scope.filteredRules;
				for (var i=0; i<rules.length; i++) {
					if (rules[i].Tags && rules[i].Tags[tag]) { return true; };
				};
			};
			
			$scope.switchTag = function (tag) {
				$scope.editorOptions.tags[tag] = !$scope.editorOptions.tags[tag];
				recalcTags($scope.editorOptions.selectedFile, $scope.editorOptions.selectedType, $scope.editorOptions.searchWord);
			};
			
			$scope.$on('selectEditorFile', function (event, fname, ruleText) {
				$scope.editorOptions.selectedFile = $rootScope.pages.editor.targetFile;
			});
			
			$scope.$on('setEditorSearchWord', function (event, word) {
				$scope.editorOptions.searchWord = word;
			});
			
			$scope.getData = function () {
				return $http.get('load_editor_options.json')
				.success(function (data) {
					$scope.rules = data.rules;

					var getFileNameFromURL = function (url) {
						for (var i=0; i<$scope.editorOptions.sources.length; i++) {
							if ($scope.editorOptions.sources[i].URL == url) {
								return $scope.editorOptions.sources[i].Name;
							};
						};
						return "";
					};

					$scope.editorOptions = {
						"selectedLogUser" : "",
						"selectedLogURL" : "",
						
						"sources": data.sources,
						"types": data.types,
						"fullTypes": {
							"CLASS/ID": "Remove by class/id",
							"EXCEPTIONS": "No filtering on URL",
							"REPLACEMENTS": "Replace text",
							"SIZE": "Remove by size",
							"SCRIPT": "Remove scripts with text",
							"COMMENTS": "Remove by comment",
							"STYLES": "Insert CSS",
							"JS": "Insert JS",
							"TAG": "Remove by start tag",
							"BLACK": "Remove elements and blocking by URL",
							"BLACK_IP": "Block request by IP"
						},
						
						"files": data.files,
						"hits": data.hits,
						"now": data.now
					};
					
					$scope.editorOptions.selectedFile = $rootScope.pages.editor.targetFile;	// текущий выбранный файл
					$scope.editorOptions.searchWord = $rootScope.pages.editor.targetSearchWord;	// начальное значение фильтра по слову
					$scope.editorOptions.selectedType = "";	// текущий выбранный тип правил
					recalcTags($scope.editorOptions.selectedFile, $scope.editorOptions.selectedType, $scope.editorOptions.searchWord);
					
					$scope.editorOptions.localFiles = [];
					for (var i=0; i<data.files.length; i++) {
						if ($scope.isFileLocal(data.files[i])) {
							$scope.editorOptions.localFiles.push(data.files[i]);
						};
					};
					
					$scope.editorOptions.tags = {};
					for (var i=0; i<data.rules.length; i++) {
						if (!data.rules[i].Tags) { continue; };
						for (var tag in data.rules[i].Tags) {
							$scope.editorOptions.tags[tag] = false;
						};
					};
				
					// if (/^127\.0\./.test($rootScope.options.UserIP)) {
						// $rootScope.isAuthenticated = true;
						// $rootScope.isLocalUser = true;
					// };
					
					$scope.$watch('editorOptions.selectedFile', function (newObj, oldObj) {
						if (newObj===oldObj) { return; };
						recalcTags(newObj, $scope.editorOptions.selectedType, $scope.editorOptions.searchWord);
						$scope.newRule.File = (newObj=='') ? $scope.editorOptions.localFiles[0] : newObj;
					});

					$scope.$watch('editorOptions.searchWord', function (newObj, oldObj) {
						if (newObj===oldObj) { return; };
						recalcTags($scope.editorOptions.selectedFile, $scope.editorOptions.selectedType, newObj);
					});

					$scope.$watch('editorOptions.selectedType', function (newObj, oldObj) {
						if (newObj===oldObj) { return; };
						recalcTags($scope.editorOptions.selectedFile, newObj, $scope.editorOptions.searchWord);
					});

					$scope.newRule = $scope.initNewRule($scope.editorOptions.selectedFile, $scope.editorOptions.selectedType);
				})
				.error(function (data, status) {
					console.info(status)
				});
			};

			$scope.saveData = function (fname) {	// если fname не задан, то надо сохранить все файлы
				var files = fname ? [ fname ] : $scope.editorOptions.files;
				var output_files = {};
				angular.forEach(files, function (file, i) {
					var fl = $filter('filter')($scope.rules, { "File": file }, true);
					var copied_fl = angular.copy(fl);
					angular.forEach(copied_fl, function (rule, i) {
						delete rule.File;
						if (rule.URL=='') { delete rule.URL; };
						if ($scope.getObjectLength(rule.Tags)<0) { delete rule.Tags; };
					});
					output_files[file] = copied_fl;
				});
				$http.post('save_files', output_files);
			};
			
			$scope.createFile = function (fname) {
				if (!fname || fname=="") { return; };
				for (var i=0; i<$scope.editorOptions.localFiles.length; i++) {
					if ($scope.editorOptions.localFiles[i]==fname) { return; };
				};
				$scope.editorOptions.files.push(fname);
				$scope.editorOptions.localFiles.push(fname);
				$scope.editorOptions.sources.push({
					"URL": "http://local.cm/rules/ContentMaster/" + fname,
					"Name": fname,
					"Parser": "ContentMaster",
					"On": true
				});
				$scope.newRule.File = fname;
			};
			
			$scope.addNewRule = function (rule) {
				$scope.rules.push(rule);
				if (rule.Tags) {
					angular.forEach(rule.Tags, function (value, tag) {
						$scope.editorOptions.tags[tag] = true;
					});
				};
				$scope.newRule = $scope.initNewRule(rule.File, rule.Type);
				recalcTags($scope.editorOptions.selectedFile, $scope.editorOptions.selectedType, $scope.editorOptions.searchWord);
			};

			$scope.removeRule = function (rule) {
				var index = $scope.rules.indexOf(rule);
				if (index != -1) {
					$scope.rules.splice(index, 1);
					recalcTags($scope.editorOptions.selectedFile, $scope.editorOptions.selectedType, $scope.editorOptions.searchWord);
				};
			};

			$scope.initNewRule = function (file, type) {
				if (file=="") { file = $scope.editorOptions.localFiles[0] };
				if (type=="") { type = $scope.editorOptions.types[0] };
				return { "File": file, "Type": type }
			};
			
			$scope.addNewTag = function (tag, filt, noGlobalTagsDataUpdate) {
				if (tag=='') { return; };
				if (!filt.Tags) { filt.Tags = {}; };
				if (!filt.Tags[tag]) {
					filt.Tags[tag] = true;
					if (!noGlobalTagsDataUpdate) { $scope.editorOptions.tags[tag] = false; };
				};
			};
			
			$scope.removeNewTag = function (tag, rule) {
				delete newRule.Tags[tag];
			};
			
			$scope.removeTagGlobally = function (tag) {
				angular.forEach($scope.rules, function (rule, i) {
					if (rule.Tags) { delete rule.Tags[tag]; };
				});
				delete $scope.editorOptions.tags[tag];
			};
			
			$scope.removeTagLocally = function (tag, filt) {
				delete filt.Tags[tag];
				var count = 0;
				angular.forEach($scope.rules, function (rule, i) {
					if (rule.Tags && rule.Tags[tag]) { count++; };
				});
				if (count<1) { delete $scope.editorOptions.tags[tag]; };
			};
			
			$scope.clearNewRuleData = function () {
				this.newRuleName = "";
				this.newRuleURL = "";
				this.newRuleComment = "";
			};
			
			$scope.getObjectLength = function (obj) {
				var e = -1;
				angular.forEach(obj, function (prop, propName) { e++; });
				return e;
			};

			$scope.getData().success(function () {
				$rootScope.bodyIsVisible = true;
			}); // для предотвращения "бликанья" страницы во время подгрузки данных
		}
	])
