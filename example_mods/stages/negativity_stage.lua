function onCreate()
    initLuaShader('bloom')
    setProperty('camGame.zoom', 1.1)
    setProperty('defaultCamZoom', 1.1)
    setProperty('camGame.alpha', 0.000001)
    setProperty('camHUD.alpha', 0.0000001)
    setProperty('introSoundsSuffix', 'BLANK') --instead of using skipCountdown we do this so that way the song doesn't start before it's actually loaded

    --setProperty('gf.alpha', 0.00001)
    setProperty('camZooming', true)
    setCharacterX('dad', getCharacterX('dad') - 100)
    setCharacterX('boyfriend', getCharacterX('boyfriend') + 100)

    makeLuaSprite('bg', 'Stage Assets/Abandoned/Negativity_BG', nil, nil)
    setScrollFactor('bg', 1, 1)
    scaleObject('bg', 1.3, 1.3)
    screenCenter('bg', 'XY')
    setProperty('bg.color', getColorFromHex('565550'))

    makeLuaSprite('fg', 'Stage Assets/Abandoned/Negativity_BG_FG', nil, nil)
    setScrollFactor('fg', 1.05, 1)
    scaleObject('fg', 1.3, 1.3)
    screenCenter('fg', 'XY')

    makeLuaSprite('dark', nil, nil, nil) --for the fading in and out effect
    makeGraphic('dark', screenWidth + 50, screenHeight + 50, '000000')
    setScrollFactor('dark', 0, 0)
    scaleObject('dark', 1.5, 1.5)
    screenCenter('dark', 'XY')
    setProperty('dark.visible', false)

    makeLuaSprite('backboard', 'NotebackboardAbandoned', 0, 10) --gets tweened too be at y level (10)
    setObjectCamera('backboard', 'camHUD')

    makeAnimatedLuaSprite('static', 'vintage M', 0, 0)
    addAnimationByPrefix('static', 'idle', 'idle', 24, true)
    setGraphicSize('static', screenWidth + 50, screenHeight + 50)
    screenCenter('static', 'XY')
    setObjectCamera('static', 'camOther')
    setProperty('static.alpha', 0.35)

    makeLuaSprite('spotlight', 'Stage Assets/Abandoned/Lights_requires_flickering', nil, 0)
    setScrollFactor('spotlight', 1.05, 1)
    --setProperty('spotlight.color', getColorFromHex('D8C34C'))
    setSpriteShader('spotlight', 'bloom')
    scaleObject('spotlight', 1.3, 1.3)
    setProperty('spotlight.offset.y', 420)
    setProperty('spotlight.offset.x', 700)
    setBlendMode('spotlight', 'hardlight')

    addLuaSprite('bg', false)
    addLuaSprite('fg', true)
    addLuaSprite('dark', true)
    addLuaSprite('spotlight', true)
    addLuaSprite('static', true)
    addLuaSprite('backboard', false)

    for i = 1, 6 do
        precacheImage('Hallucinations/Hallucinations'..i)
        makeLuaSprite('schizo_'..i, 'Hallucinations/Hallucinations'..i, nil, nil)
        setObjectCamera('schizo_'..i, 'camOther')
        setGraphicSize('schizo_'..i, screenWidth, screenHeight)
        setProperty('schizo_'..i..'.visible', false)
        screenCenter('schizo_'..i, 'XY')
        addLuaSprite('schizo_'..i, true)
    end

    runHaxeCode([[
        game.timeBarBG.kill();
    ]])

    ---debugPrint('done precaching!')

    close()
end