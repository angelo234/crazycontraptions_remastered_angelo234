angular.module('beamng.apps')
.directive('crazycontraptionsRemasteredAngelo234', [function () {
return {
templateUrl: '/ui/modules/apps/crazycontraptions_remastered_angelo234/app.html',
replace: true,
restrict: 'EA',
link: function (scope, element, attrs) {
	// The current overlay screen the user is on (default: null)
	scope.overlayScreen = null;	

	scope.randomizeEverything = function () {
		bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.randomizeEverything()');
	};
	
	scope.randomizeOnlyDrivetrainParts = function () {
		bngApi.engineLua('scripts_crazycontraptions__remastered__angelo234_extension.randomizeOnlyDrivetrainParts()');
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
},
};
}]);