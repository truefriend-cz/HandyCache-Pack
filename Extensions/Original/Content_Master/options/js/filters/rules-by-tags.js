
angular.module('CMOptionsApp').filter('rulesByTags', [function() {
	return function(rules, tags) {
		if (!rules) { return; };
		var filteredRules = [], anyActivated;
		angular.forEach(tags, function (activated, globalTag) {
			if (activated) { anyActivated = true; }
			else { return; };
			angular.forEach(rules, function (rule, i) {
				if (!rule.Tags) { return; };
				var hasActiveTag;
				angular.forEach(rule.Tags, function (n, tag) {
					if (tag==globalTag) { hasActiveTag = true; };
				});
				if (hasActiveTag) { filteredRules.push(rule); };
			});
		});
		return anyActivated ? filteredRules : rules;
	};
}]); 