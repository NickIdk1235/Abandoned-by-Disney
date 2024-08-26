function onCreate()
	-- addHaxeLibrary('ShaderFliter', 'openfl.filters')
	runHaxeCode([[
		var vcr = new ShaderFilter(game.createRuntimeShader('vcr'));

		//game.camGame.setFilters([vcr]);
		//game.camHUD.setFilters([vcr]);
		var shader0 = new ShaderFilter(game.createRuntimeShader('Distorted TV'));
    	game.camGame.setFilters([shader0]);
		trace('hi!');
	]])
end

function onStepHit()
	if curStep == 1357 then
		runHaxeCode([[
			var vcr = new ShaderFilter(game.createRuntimeShader('vcr'));
			var radchr = new ShaderFilter(game.createRuntimeShader('radchr'));
			//game.camGame.setFilters([vcr, radchr]);
			//game.camHUD.setFilters([vcr, radchr]);
			//game.camOther.setFilters([vcr, radchr]);
		]])
	end
end
