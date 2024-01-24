angular.module('beamng.apps')
.directive('crazycontraptionsRemasteredAngelo234', [function () {
return {
templateUrl: '/ui/modules/apps/crazycontraptions_remastered_angelo234/app.html',
replace: true,
restrict: 'EA',
link: function (scope, element, attrs) {
	// The current overlay screen the user is on (default: null)
	scope.overlayScreen = null;
	scope.powertrainPartsIncludesEmptyPart = false;
	scope.bodyPartsIncludesEmptyPart = false;

	// Init get settings
	bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.getSettings()', (res) => {
		scope.powertrainPartsIncludesEmptyPart = res.powertrainPartsIncludesEmptyPart;
		scope.bodyPartsIncludesEmptyPart = res.bodyPartsIncludesEmptyPart;
	})

	scope.randomizeEverything = function () {
		bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.randomizeEverything()');
	};

	scope.randomizeOnlyPowertrainParts = function () {
		bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.randomizeOnlyPowertrainParts()');
	};

	scope.randomizeOnlyBodyParts = function () {
		bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.randomizeOnlyBodyParts()');
	};

	scope.randomizeParts = function () {
		bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.randomizeParts()');
	};

	scope.randomizeTuning = function () {
		bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.randomizeTuning()');
	};

	scope.randomizePaint = function () {
		bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.randomizePaint()');
	};

	scope.setSettings = function () {
		bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.setSettings(' + scope.powertrainPartsIncludesEmptyPart + ',' + scope.bodyPartsIncludesEmptyPart + ')');
	}
},
};
}]);