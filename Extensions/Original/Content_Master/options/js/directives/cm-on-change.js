angular.module('CMOptionsApp').directive('cmOnChange', function() {
	return function(scope, element) {
		element.bind('change', function() {
			if (scope.filt.Off) { delete scope.filt.Off; }else { scope.filt.Off = true; };
			if (element.next().hasClass('RuleOff')) { element.next().removeClass('RuleOff'); }
			else { element.next().addClass('RuleOff'); };
		});
	};
});