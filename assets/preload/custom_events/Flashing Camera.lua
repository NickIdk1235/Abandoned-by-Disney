local dynamicFlash = true -- event decides what camera to flash on
local camToFlash = 'camGame'
local useLuaSprite = false
local function convertToHex(target)
	local rgb = ''
	local healthColorArray = {
		bf = {nil, nil, nil},
		dad = {nil, nil, nil}
	}

	if target == 'dad' or target == 'Dad' or target == '1' then
		rgb = getProperty('dad.healthColorArray')
		for i = 1, 3 do
			healthColorArray.dad[i] = getProperty('dad.healthColorArray')[i]
		end
	elseif target == 'boyfriend' or target == 'bf' or target == 'BF' or target == '0' then
		rgb = getProperty('boyfriend.healthColorArray')
		for i = 1, 3 do
			healthColorArray.bf[i] = getProperty('boyfriend.healthColorArray')[i]
		end
	end

	local hexadecimal = ''
	for key, value in pairs(rgb) do
		local hex = ''

		while (value > 0) do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex
		end

		if (string.len(hex) == 0) then
			hex = '00'
		elseif (string.len(hex) == 1) then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end
	return hexadecimal
end
local time = 0.5
local color = 'FFFFFF'
local function makeFlashSprite()
	local tag = 'flashingSprite'
	if useLuaSprite and luaSpriteExists('flashingSprite') == false then
		makeLuaSprite(tag, '', 0, 0)
		makeGraphic(tag, screenWidth * 2, screenHeight * 2, 'FFFFFF')
		setScrollFactor(tag, 0, 0)
		screenCenter(tag, 'XY')
		setProperty(tag .. '.alpha', 0.000001)
		setObjectCamera(tag, camToFlash)
		addLuaSprite(tag, true)
	end
end

function onCreate()
	makeFlashSprite()
end

function onCreatePost()
	makeFlashSprite()
end

function onSongStart()
	makeFlashSprite()
end

function onUpdate(elapsed)
	if luaSpriteExists('flashingSprite') == false then
		makeFlashSprite()
	end
end

function onEvent(n, v1, v2)
	if n == 'Flashing Camera' then
		if tonumber(v1) == nil or v1 == '' then
			time = 0.5
		else
			time = tonumber(v1)
		end

		if dynamicFlash then
			if getProperty('camGame.alpha') == 0 or getProperty('camGame.visible') == false then
				camToFlash = 'camHUD'
			elseif (getProperty('camHUD.alpha') == 0 or getProperty('camHUD.visible') == false) and
							(getProperty('camGame.alpha') == 0 or getProperty('camGame.visible') == false) then
				camToFlash = 'camOther'
			elseif getProperty('camHUD.alpha') == 0 or getProperty('camHUD.visible') == false and getProperty('camOther.alpha') ==
							0 or getProperty('camOther.visible') == false then
				camToFlash = 'camGame'
			else
				camToFlash = 'camGame'
			end
		end

		if v2 == 'red' then
			color = 'FF0000'
		elseif v2 == 'yellow' then
			color = 'FFF400'
		elseif v2 == 'green' then
			color = '2BFF00'
		elseif v2 == 'cyan' then
			color = '00FFEB'
		elseif v2 == 'blue' then
			color = '0C00FF'
		elseif v2 == 'purple' then
			color = '9400FF'
		elseif v2 == 'pink' then
			color = 'ff00bb'
		elseif v2 == 'black' then
			color = '000000'
		elseif v2 == 'grey' then
			color = '525252'
		elseif v2 == 'orange' then
			color = 'ff6600'
		elseif v2 == 'dad' then
			color = convertToHex('dad')
		elseif v2 == 'bf' then
			color = convertToHex('boyfriend')
		elseif v2 == '' or v2 == nil then
			color = 'ffffff'
		else
			color = v2
		end

		if getPropertyFromClass('ClientPrefs', 'flashing') then
			if useLuaSprite == false then
				cameraFlash(camToFlash, color, time, true)
			elseif useLuaSprite == true then
				cancelTween('Flashing Camera Sprite Tween!')
				setObjectCamera('flashingSprite', camToFlash)
				setProperty('flashingSprite.alpha', 1)
				setProperty('flashingSprite.color', getColorFromHex(color))
				doTweenAlpha('Flashing Camera Sprite Tween!', 'flashingSprite', 0, time, 'linear')
			end
		end
	end
end
