function onCreate()
	initLuaShader('bloom')
	setProperty('camGame.zoom', 1.1)
	setProperty('defaultCamZoom', 1.1)
	setProperty('camGame.alpha', 0.000001)
	setProperty('camHUD.alpha', 0.0000001)
	setProperty('introSoundsSuffix', 'BLANK') -- instead of using skipCountdown we do this so that way the song doesn't start before it's actually loaded

	-- setProperty('gf.alpha', 0.00001)
	setProperty('camZooming', true)
	setCharacterX('dad', getCharacterX('dad') - 100)
	setCharacterX('boyfriend', getCharacterX('boyfriend') + 100)
	scaleObject("boyfriend", 1.3, 1.3)
	scaleObject('gf', 0.75, 0.75)

	makeLuaSprite('bg', 'Stage Assets/Abandoned/Negativity_BG', nil, nil)
	setScrollFactor('bg', 1, 1)
	scaleObject('bg', 1.1, 0.9)
	screenCenter('bg', 'XY')
	setProperty('bg.color', getColorFromHex('565550'))

	makeLuaSprite('fg', 'Stage Assets/Abandoned/Negativity_BG_FG', nil, nil)
	setScrollFactor('fg', 1.05, 1)
	scaleObject('fg', 1.3, 1.3)
	screenCenter('fg', 'XY')

	makeLuaSprite('dark', nil, nil, nil) -- for the fading in and out effect
	makeGraphic('dark', screenWidth + 50, screenHeight + 50, '000000')
	setScrollFactor('dark', 0, 0)
	scaleObject('dark', 1.5, 1.5)
	screenCenter('dark', 'XY')
	setProperty('dark.visible', false)

	makeLuaSprite('backboard', 'NotebackboardAbandoned', 0, 10) -- gets tweened too be at y level (10)
	setObjectCamera('backboard', 'camHUD')

	makeAnimatedLuaSprite('static', 'vintage M', 0, 0)
	addAnimationByPrefix('static', 'idle', 'idle', 24, true)
	setGraphicSize('static', screenWidth + 50, screenHeight + 50)
	screenCenter('static', 'XY')
	setObjectCamera('static', 'camOther')
	setProperty('static.alpha', 0.35)

	makeLuaSprite('spotlight', 'Stage Assets/Abandoned/Lights_requires_flickering', nil, 0)
	setScrollFactor('spotlight', 1.05, 1)
	-- setProperty('spotlight.color', getColorFromHex('D8C34C'))
	setSpriteShader('spotlight', 'bloom')
	scaleObject('spotlight', 1.7, 1.3)
	setProperty('spotlight.offset.y', 420)
	setProperty('spotlight.offset.x', 700)
	setBlendMode('spotlight', 'hardlight')
	setProperty('spotlight.visible', false) --for some reason these show up despite the camera being invisible???

	addLuaSprite('bg', false)
	addLuaSprite('spotlight', true)
	addLuaSprite('fg', true)
	addLuaSprite('dark', true)
	addLuaSprite('static', true)
	addLuaSprite('backboard', false)

	setProperty('fg.alpha', 0.4)

	runHaxeCode([[
        game.timeBarBG.kill();
        //game.timeBar.kill();
    ]])

	close()
end