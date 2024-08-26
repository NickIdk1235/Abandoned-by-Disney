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

	reverseBool = function(b)
		if b ~= nil then
			if b then
				return false
			else
				return true
			end
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
local rewindToggled = false
local pixels = 1
local targetPixels = 1

function onCreate()
	if isTesting then
		lua.createDebugText('debugTextShit')
	end
end

function onEvent(n, v1, v2)
	if n == '' then
		if v1 == 'rewind' then
			pixels = pixels + 5
			-- rewindDuration = rewindDuration + 0.5
			if v2 == 'toggle' then
				rewindToggled = lua.reverseBool(rewindToggled)
			end
		elseif v1 == 'pixel' then
			pixels = tonumber(v2) or 0 --incase v2 is nil
		end
	end
end

function onUpdate(elapsed)
	local dareals = targetPixels / 4
	pixels = lua.lerp(pixels, targetPixels, lua.boundTo((2 + (dareals)) * elapsed, 0.001, 10))

	if rewindToggled then
		targetPixels = targetPixels + elapsed
	else
		targetPixels = 1
	end

	if luaTextExists('debugTextShit') then
		setTextString('debugTextShit',
						'real = ' .. tostring(pixels) .. '\n_____________\nFormula = ' .. tostring(dareals) .. '\n rewindToggled = ' ..
										tostring(rewindToggled))
	end

	pixels = lua.round(pixels, 3)
	setShaderFloat('pixelspr', 'PIXELATION_FACTOR', pixels)
end
