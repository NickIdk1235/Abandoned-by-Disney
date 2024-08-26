local lua = {
	lerp = function(from, limit, rate) -- math.lerp
		return (limit - from) * rate + from
	end,
	boundTo = function(value, min, max)
		return math.max(min, math.min(max, value))
	end,
	
	round = function(number, decimals)
		local power = 10 ^ decimals
		return math.floor(number * power) / power
	end,

	tobool = function(s)
		-- local stringtoboolean={["t"]=t, ["f"]=f, ["t"] = t, ["f"] = f}
		if s == 't' or s == 'true' then
			return true
		elseif s == 'f' or s == 'false' then
			return false
		end
	end,
	createDebugText = function(tag)
		makeLuaText(tag, '', 300, 300, 300)
		setTextFont(tag, 'vcr.ttf')
		setTextSize(tag, 30)
		setObjectCamera(tag, 'camOther')
		addLuaText(tag)
	end
}
local isTesting = false
local iTime = 0
local curBlurWidth = 0
local targetBlurWidth = 0
local breathing = true
local shaderTracker = {
	blur = {},
	chrome = {}
}
local rtxValues = {0, 0, 0, 0, 0.07, 0.08, 0, 0.5, 0.26, 0.265, 0, 0.465, 268.2, 38.25}
local function rtx(spr)
	local to_rad = math.pi / 180

	if type(spr) == 'table' then
		for i = 1, #spr do
			setSpriteShader(spr[i], 'RTXLighting')

			setShaderFloatArray(spr[i], 'overlayColor', {rtxValues[1], rtxValues[2], rtxValues[3], rtxValues[4]})
			setShaderFloatArray(spr[i], 'satinColor', {rtxValues[5], rtxValues[6], rtxValues[7], rtxValues[8]})
			setShaderFloatArray(spr[i], 'innerShadowColor', {rtxValues[9], rtxValues[10], rtxValues[11], rtxValues[12]})
			setShaderFloat(spr[i], 'innerShadowAngle', rtxValues[13] * to_rad)
			setShaderFloat(spr[i], 'innerShadowDistance', rtxValues[14])
		end
	elseif type(spr) == 'string' then
		setSpriteShader(spr, 'RTXLighting')

		setShaderFloatArray(spr, 'overlayColor', {rtxValues[1], rtxValues[2], rtxValues[3], rtxValues[4]})
		setShaderFloatArray(spr, 'satinColor', {rtxValues[5], rtxValues[6], rtxValues[7], rtxValues[8]})
		setShaderFloatArray(spr, 'innerShadowColor', {rtxValues[9], rtxValues[10], rtxValues[11], rtxValues[12]})
		setShaderFloat(spr, 'innerShadowAngle', rtxValues[13] * to_rad)
		setShaderFloat(spr, 'innerShadowDistance', rtxValues[14])
	end
end
function onCreate()
	initLuaShader('RTXLighting')
	initLuaShader('blur')
	initLuaShader('Chromatic Aberration Filter')
	initLuaShader('pixelate')
	initLuaShader('camShake')

	makeLuaSprite('pixelspr')
	makeGraphic('pixelspr', screenWidth, screenHeight)
	setSpriteShader('pixelspr', 'pixelate')
	setShaderFloat('pixelspr', 'PIXELATION_FACTOR', 1)

	makeLuaSprite('rumble')
	makeGraphic('rumble', screenWidth, screenHeight)
	setSpriteShader('rumble', 'camShake')

	makeLuaSprite('blurspr')
	makeGraphic('blurspr', screenWidth, screenHeight)
	setSpriteShader('blurspr', 'blur')
	setShaderFloat('blurspr', 'cx', 0.5)
	setShaderFloat('blurspr', 'cy', 0.5)

	makeLuaSprite('chromspr')
	makeGraphic('chromspr', screenWidth, screenHeight)
	setSpriteShader('chromspr', 'Chromatic Aberration Filter')

	rtx({'boyfriend', 'gf', 'dad', 'lady', 'boy'})

	runHaxeCode([[
        var blur = new ShaderFilter(game.getLuaObject('blurspr').shader);
        var chrome = new ShaderFilter(game.getLuaObject('chromspr').shader);
        var pixel = new ShaderFilter(game.getLuaObject('pixelspr').shader);
        var rumble = new ShaderFilter(game.getLuaObject('rumble').shader);
        game.camGame.setFilters([chrome, blur, pixel]);
        game.camHUD.setFilters([blur, pixel]);
    ]])
	table.insert(shaderTracker.chrome, 'chromspr')
	table.insert(shaderTracker.blur, 'blurspr')
end

function onCreatePost()
	if isTesting then
		lua.createDebugText('blurWidthText')
		setProperty('blurWidthText.y', getProperty('blurWidthText.y') + 175)
	end
end

function onEvent(n, v1, v2)
	if n == '' then
		if v1 == 'breathing' then
			breathing = lua.tobool(tostring(v2))
		end
	end
end

function onBeatHit()
	if curBeat % 2 == 0 and breathing then
		-- curBlurWidth = 0.1
	end
end

function onUpdate(elapsed)
	local songPos = getSongPosition()
	iTime = iTime + elapsed
	setShaderProperty('chromspr', 'shouldUpdateTime', false)
	setShaderFloat('chromspr', 'total_time', iTime)
	local formula = math.sin((songPos / 2000) * (bpm / 60) * 1.8) * 0.1
	if breathing then
		-- targetBlurWidth = formula
		if curBeat % 8 == 0 then
			targetBlurWidth = 0.1
		else
			targetBlurWidth = 0
		end

		targetBlurWidth = lua.boundTo(targetBlurWidth, 0, 0.5)
		targetBlurWidth = lua.round(targetBlurWidth, 3)
	else
		targetBlurWidth = 0
	end

	curBlurWidth = lua.lerp(curBlurWidth, targetBlurWidth, 1 * elapsed)
	curBlurWidth = lua.boundTo(curBlurWidth, 0, 0.2)
	-- curBlurWidth = lua.round(curBlurWidth, 3)
	if luaTextExists('blurWidthText') then
		setTextString('blurWidthText',
						'target blur width = ' .. tostring(targetBlurWidth) .. '\n ________________\n curBlurWidth = ' ..
										tostring(curBlurWidth))
	end

	for i = 1, #shaderTracker.blur do
		if shaderTracker.blur ~= nil then
			setShaderFloat(shaderTracker.blur[i], 'blurWidth', curBlurWidth)
		end
	end
end
