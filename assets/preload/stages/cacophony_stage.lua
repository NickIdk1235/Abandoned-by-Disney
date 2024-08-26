local path = 'Stage Assets/Abandoned/Cacophony/'
local function createLuaSprite(tag, image, scroll, scale, axes, ofs, isForeground)
	local imagePath = ''
	if path ~= nil then
		imagePath = path .. image
	else
		imagePath = image
	end
	makeLuaSprite(tag, imagePath)
	if type(scroll) == 'table' then
		setScrollFactor(tag, scroll[1], scroll[2])
	else
		setScrollFactor(tag, scroll, scroll)
	end

	if type(scale) == 'table' then
		scaleObject(tag, scale[1], scale[2])
	else
		scaleObject(tag, scale, scale)
	end
	if axes ~= '' then
		screenCenter(tag, axes)
	end
	if ofs[1] ~= nil then
		setProperty(tag .. '.x', getProperty(tag .. '.x') + ofs[1])
	end
	if ofs[2] ~= nil then
		setProperty(tag .. '.y', getProperty(tag .. '.y') + ofs[2])
	end
	addLuaSprite(tag, isForeground)
end

local function createAnimatedLuaSprite(tag, image, prefix, xml, scroll, scale, axes, ofs, isForeground)
	local imagePath = ''
	if path ~= nil then
		imagePath = path .. image
	else
		imagePath = image
	end
	makeAnimatedLuaSprite(tag, imagePath)
	if #xml >= 1 then
		for i = 1, #xml do
			addAnimationByPrefix(tag, prefix[i], xml[i], 24, false)
		end
	end
	if type(scroll) == 'table' then
		setScrollFactor(tag, scroll[1], scroll[2])
	else
		setScrollFactor(tag, scroll, scroll)
	end

	if type(scale) == 'table' then
		scaleObject(tag, scale[1], scale[2])
	else
		scaleObject(tag, scale, scale)
	end

	if axes ~= '' then
		screenCenter(tag, axes)
	end
	if ofs[1] ~= nil then
		setProperty(tag .. '.x', getProperty(tag .. '.x') + ofs[1])
	end
	if ofs[2] ~= nil then
		setProperty(tag .. '.y', getProperty(tag .. '.y') + ofs[2])
	end
	addLuaSprite(tag, isForeground)
end

local function makeV1Stage()
	local s = { -- s is short for sprites
		tag = {'mom', 'kid'},
		image = 'characters/Gascots_Sprites',
		pos = {
			x = nil,
			y = nil
		},
		prefix = 'idle',
		xml = {'IDLE WOMAN', 'IDLE KID0'},
		scrollFactor = {
			x = 0.9,
			y = 1
		},
		scale = {
			x = {1, --[[<- mom | kid ->]] 1},
			y = {1, --[[<- mom | kid ->]] 1}
		},
		ofs = {
			x = {-250, --[[<- mom | kid ->]] 150},
			y = {0, --[[<- mom | kid ->]] -240}
		},
		color = '303030'
	}
	runHaxeCode([[
		var shader = 'vcr';
		game.initLuaShader(shader);
		game.initLuaShader('bloom');
		game.initLuaShader('radchr');
	]])

	makeLuaSprite('bg', path .. 'RoomZero', -600, -300)
	setScrollFactor('bg', 1, 1)
	scaleObject('bg', 1, 1)

	if not lowQuality then
		makeLuaSprite('spotlight', 'spotlight', nil, nil)
		setScrollFactor('spotlight', 1.05, 1)
		setSpriteShader('spotlight', 'bloom')
		scaleObject('spotlight', 0.9, 0.9)
		setProperty('spotlight.offset.y', 180)
		setProperty('spotlight.offset.x', 35)
		setProperty('spotlight.alpha', 0.5)
		--setProperty('spotlight.color', getColorFromHex('676700'))
		--setBlendMode('spotlight', 'hardlight')

		makeAnimatedLuaSprite('b', 'vintage M', nil, nil)
		addAnimationByPrefix('b', 'static', 'idle', 24, true)
		setGraphicSize('b', screenWidth, screenHeight)
		setObjectCamera('b', 'camOther')

		makeLuaSprite('d', nil, nil, nil)
		makeGraphic('d', screenWidth, screenHeight, '000000')
		setScrollFactor('d', 0, 0)
		scaleObject('d', 2, 2)
		screenCenter('d', 'XY')
		setProperty('d.alpha', 0)
	end

	setProperty('gfGroup.visible', false)
	-- setProperty('boyfriendGroup.visible', false)

	s.pos.x = getCharacterX('dad')
	s.pos.y = getCharacterY('dad')

	for i = 1, 2 do
		makeAnimatedLuaSprite(s.tag[i], s.image, s.pos.x, s.pos.y)
		addAnimationByPrefix(s.tag[i], s.prefix, s.xml[i], 24, true)
		setScrollFactor(s.tag[i], s.scrollFactor.x, s.scrollFactor.y)
		setProperty(s.tag[i] .. '.offset.x', s.ofs.x[i])
		setProperty(s.tag[i] .. '.offset.y', s.ofs.y[i])
		setProperty(s.tag[i] .. '.color', getColorFromHex('000000'))
	end

	screenCenter('bg', 'XY')
	screenCenter('spotlight', 'XY')

	addLuaSprite('bg', false)
	for i = 1, 2 do
		addLuaSprite(s.tag[i], false)
	end
	addLuaSprite('spotlight', true)
	addLuaText('text')
	addLuaSprite('d', true) -- d for darkness
	addLuaSprite('b', false) -- b for idfk lmfao-
end

local function makeV2Stage()
	initLuaShader('bloom')
	setProperty('defaultCamZoom', 0.75)
	setCharacterX('dad', getCharacterX('dad') - 75)
	setCharacterY('dad', getCharacterY('dad') + 75)
	createLuaSprite('bg', 'RoomZero', {0.95, 1}, {1, 1}, 'XY', {0, 0}, false)
	setProperty('bg.color', getColorFromHex('4C4559'))
	createAnimatedLuaSprite('lady', 'FemGasmask', {'idle'}, {'FemGas instance 1'}, {0.92, 1}, {1, 1}, 'XY', {300, 100},
					false)
	createAnimatedLuaSprite('boy', 'BoyGasmask', {'idle'}, {'BoyGas instance 1'}, {0.92, 1}, {1, 1}, 'XY', {-300, 250},
					false)
	setProperty('lady.animation.curAnim.looped', true)
	setProperty('boy.animation.curAnim.looped', true)

	makeLuaSprite('spotlight', 'spotlight', nil, nil)
	setScrollFactor('spotlight', 1.05, 1)
	setSpriteShader('spotlight', 'bloom')
	scaleObject('spotlight', 0.6, 1.2)
	setProperty('spotlight.offset.y', 180)
	setProperty('spotlight.offset.x', 330)
	setProperty('spotlight.alpha', 0.001)
	--setProperty('spotlight.color', getColorFromHex('676700'))
	setBlendMode('spotlight', 'hardlight')
	screenCenter('spotlight', 'X')

	makeAnimatedLuaSprite('b', 'vintage M', nil, nil)
	addAnimationByPrefix('b', 'static', 'idle', 24, true)
	setGraphicSize('b', screenWidth + 50, screenHeight + 50)
	setObjectCamera('b', 'camOther')
	screenCenter('b', 'XY')

	addLuaSprite('spotlight', true)
	addLuaSprite('b', true)
end

function onCreate()

	if songName:lower() == 'cacophony' then -- new cacophony v2 is just now cacophony
		makeV2Stage()
	elseif songName:lower() == 'cacophony v1' then
		makeV1Stage()
	end

	makeLuaText('text', '', 300, nil, nil)
	setTextAlignment('text', 'center')
	setTextFont('text', 'Rubik.ttf')
	setTextSize('text', 30)
	setTextColor('text', 'FF0000')
	setTextBorder('text', 3, '000000')
	screenCenter('text', 'XY')

	close()
end
