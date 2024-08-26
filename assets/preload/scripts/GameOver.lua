function onGameOver()

	if (curStage == 'negativity_stage') then

		setPropertyFromClass("GameOverSubstate", "characterName", 'Negativity_game_over');
		-- setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx');
		-- setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd');
		setPropertyFromClass("GameOverSubstate", "loopSoundName", 'AbDGameOver');
		runHaxeCode("Conductor.changeBPM(134); FlxG.camera.zoom = 0.6;");
		--runHaxeCode("updateCamera = false; trace('funni text');");
		--runHaxeCode("FlxG.camera.setScale(0.6, 0.6); trace('the code has been run 2')");
	elseif curStage == 'cacophony_stage' then
		setPropertyFromClass("GameOverSubstate", "characterName", 'GASCOT_BF_GAME_OVER');
		setPropertyFromClass("GameOverSubstate", "loopSoundName", 'AbDGameOver');
		runHaxeCode("Conductor.changeBPM(134); FlxG.camera.zoom = 1;");
		--runHaxeCode("FlxG.camera.setScale(1, 1); updateCamera = true; trace('the code has been run')");

	end
end
