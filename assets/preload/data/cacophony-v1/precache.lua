local tag = 'gascot_subtitle'
function onCreate()
    --[[
        makeLuaSprite('black', nil, 0, 0)
        makeGraphic('black', screenWidth * 2, screenHeight * 2, '000000')
        setScrollFactor('black', 0, 0)
        setObjectCamera('black', 'camOther')
        addLuaSprite('black', true)
        screenCenter('black', 'XY')
    ]]
    makeLuaSprite('backboard', 'NotebackboardAbandoned', 0, -150)
    setObjectCamera('backboard', 'camHUD')
    addLuaSprite('backboard', false)

    makeLuaText(tag, '', 300, nil, nil)
    setTextFont(tag, 'BebasNeue.ttf')
    setTextAlignment(tag, 'center')
    setTextSize(tag, 35)
    setTextColor(tag, '000000')
    setTextBorder(tag, 2.5, 'FFFFFF')
    screenCenter(tag, 'XY')
    setProperty(tag..'.alpha', 0.0000000000001) --if you set it too "0", then it won't load it, leaving it like this will help reduce lag
    setObjectCamera(tag, 'camOther')
    addLuaText(tag)

    close()
end