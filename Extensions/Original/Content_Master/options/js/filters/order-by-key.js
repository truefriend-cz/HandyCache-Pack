angular.module('CMOptionsApp').filter('orderByKey', [function () {
	return function (input) {
		if (!angular.isUndefined(input)) {
			var tmpInput = [];
			angular.forEach(input, function(value, key){
				tmpInput.push(key);
			});
			tmpInput.sort();

			var tmpOutput = {};
			angular.forEach(tmpInput, function(key){
				tmpOutput[key] = input[key];
			});
			return tmpOutput;
		} else {
			return input;
		}
	};
}]); 