local lua = {
	lerp = function(from, limit, rate) -- math.lerp
		return (limit - from) * rate + from
	end,

	invlerp = function(from, limit, rate) -- math.invlerp
		return (rate - from) / (limit - from)
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

	centerNumbers = function(min, max)
		return math.floor((max + min) / 2)
	end,

	tobool = function(s)
		-- local stringtoboolean={["t"]=t, ["f"]=f, ["t"] = t, ["f"] = f}
		if s == 't' or s == 'true' then
			return true
		elseif s == 'f' or s == 'false' then
			return false
		end
	end,

	getSectionDur = function()
		return getPropertyFromClass('Conductor', 'crochet')
	end,

	getBeatDur = function()
		return getPropertyFromClass('Conductor', 'crochet') / 1000
	end,

	getStepDur = function()
		return getPropertyFromClass('Conductor', 'stepCrochet') / 1000
	end,

	setPos = function(obj, x, y)
		if luaSpriteExists(obj) then
			if x ~= nil then
				setProperty(obj .. '.x', x)
			end
			if y ~= nil then
				setProperty(obj .. '.y', y)
			end
		end
	end,

	setOfs = function(obj, x, y)
		if luaSpriteExists(obj) then
			if x ~= nil then
				setProperty(obj .. '.offset.x', x)
			end
			if x ~= nil then
				setProperty(obj .. '.offset.y', y)
			end
		end
	end,
	coinflip = function()
		if math.random(1, 2) == 1 then
			print('got heads!')
			return 'heads'
		else
			print('got tails!')
			return 'tails'
		end
	end,
	split = function(string, seperator)
		if seperator == nil or seperator == '' then
			seperator = '-_,.'
		end
		local index = 0
		for word in string.gmatch(string, '([^' .. seperator .. ']+)') do -- Difficult yet neccessary motherfucker.
			index = index + 1
			return {word, index} -- returns an array, [1] = word found, and [2] = index or current number
		end
	end,
	splitValue = function(string, seperator, toReturn) -- string is the entire string you give it, seperator is the "speration" or what to split it from, and toReturn is the place of the word to return EX: "a,b,c", if toReturn is 2 then it'll return "b", or if it's 3 it'll return "c". EX OF IT BEING USED: strTools.splitValue("A,B,C,D,F", ",", 4) --returns "D"
		if seperator == nil or seperator == '' then
			seperator = '-_,.'
		end
		local index = 0
		for word in string.gmatch(tostring(string), '([^' .. seperator .. ']+)') do -- Difficult yet neccessary motherfucker.
			index = index + 1

			if index == toReturn then
				index = 0
				if word == '' or word == nil then
					return false
				else
					return word
				end
			end
		end
	end,
	findInString = function(str, target) -- str = the string you give it, the target is what you are looking for in the string ex:
		if string.match(str, target) then
			return true
		else
			return false
		end
	end,
	roundUpTo = function(number, roundToWhat)
		if number % 2 == 0 and roundToWhat == 'odd' then -- isOdd
			return number + 1
		elseif number > 1 and number % 3 == 0 and roundToWhat == 'even' then
			return number + 1
		end
	end,
	valueToChar = function(value)
		local isBF = false
		local isGF = false
		local isDad = false
		local bfs = {'boyfriend', 'bf', 'player', '0'}
		local gfs = {'girlfriend', 'gf', 'girl', '2'}
		local dads = {'dad', 'opponent', 'oppt', 'opp', '1'}
		local v = tostring(value)
		v = string.lower(v)
		-- time to check if it's boyfriend
		for i = 1, #bfs do
			if v == bfs[i] then
				isBF = true
				return 'boyfriend'
			end
			if isBF then
				break
			end
		end

		for i = 1, #gfs do
			if v == gfs[i] then
				isGF = true
				return 'gf'
			end

			if isGF then
				break
			end
		end

		for i = 1, #dads do
			if v == dads[i] then
				isDad = true
				return 'dad'
			end

			if isDad then
				break
			end
		end
	end
}

local color = {
	blue = '31a2fd', -- 0x31a2fd
	green = '31fd8c', -- 0x31fd8c
	pink = 'fb33f5', -- 0xfb33f5
	red = 'ff0000', -- 0xff0000
	orange = 'fba633', -- 0xfba633
	purple = 'A34BFF', -- 0xA34BFF
	black = '000000', -- 0x000000
	white = 'FFFFFF', -- 0xFFFFFF
	gray = '393943', -- 0x393943
	lightgray = 'd3d3d3', -- 0xd3d3d3
	darkgray = '2c2c2c', -- 0x2c2c2c
	crimson = 'dd0046', -- 0xdd0046
	brown = '964B00', -- 0x964B00
	brownOrange = '996600' -- 0x996600
}

local function isCharacter(tag)
	local isDad = false
	local isBF = false
	local isGF = false
	if lua.valueToChar(tag) == 'dad' then
		isDad = true
	end

	if lua.valueToChar(tag) == 'boyfriend' then
		isBF = true
	end

	if lua.valueToChar(tag) == 'gf' then
		isGF = true
	end

	if isDad == false and isBF == false and isGF == false then
		return false
	else
		return true
	end
end

local function checkOnGf()
	if getProperty('gf.curCharacter') == 'gf.curCharacter' then
		return false -- gf doesn't exist!
	else
		return true -- yayyy! gf exists!
	end
end

local eventTarget
local eventColor = color.white
local eventTime = 0.5
local stopEvent = false -- guard to make sure it doesn't try to tween something that doesn't exist
local eventEase = 'linear'
function onEvent(n, v1, v2)
	if n == 'ColorTween' then
		if luaDebugMode then
			debugPrint('ColorTween Event: commans detected = ' .. tostring(#lua.split(tostring(v2))))
		end
		eventTarget = tostring(v1)
		if #lua.split(tostring(v2)) == 2 then
			eventColor = lua.splitValue(tostring(v2), ',', 1)
			eventTime = lua.splitValue(tostring(v2), ',', 2)
			eventEase = 'linear'
		elseif #lua.split(tostring(v2)) == 3 then
			eventColor = lua.splitValue(tostring(v2), ',', 1)
			eventTime = lua.splitValue(tostring(v2), ',', 2)
			eventEase = lua.splitValue(tostring(v2), ',', 3)
		end

		if eventColor ~= nil then
			eventColor = string.lower(eventColor)
		end

		if tostring(v2) == '' or v2 == nil then
			eventColor = 'white'
			eventTime = 0.5
			eventEase = 'linear'
		end

		if isCharacter(eventTarget) == false then
			if luaSpriteExists(eventTarget) == false then
				if luaDebugMode then
					debugPrint('event target does not exist!')
					stopEvent = true
				end
			end
		else
			if lua.valueToChar(eventTarget) == 'gf' then
				if checkOnGf() == false then
					if luaDebugMode then
						debugPrint('gf does not exist on this stage!')
						stopEvent = true
					end
				end
			end
		end

		local daColor = 'FFFFFF'
		if eventColor == 'blue' then
			daColor = color.blue
		elseif eventColor == 'green' then
			daColor = color.green
		elseif eventColor == 'pink' then
			daColor = color.pink
		elseif eventColor == 'red' then
			daColor = color.red
		elseif eventColor == 'orange' then
			daColor = color.orange
		elseif eventColor == 'purple' then
			daColor = color.purple
		elseif eventColor == 'black' then
			daColor = color.black
		elseif eventColor == 'white' then
			daColor = color.white
		elseif eventColor == 'gray' then
			daColor = color.gray
		elseif eventColor == 'lightgray' then
			daColor = color.lightgray
		elseif eventColor == 'darkgray' then
			daColor = color.darkgray
		elseif eventColor == 'crimson' then
			daColor = color.crimson
		elseif eventColor == 'brown' then
			daColor = color.brown
		elseif eventColor == 'brownorange' then
			daColor = color.brownorange
		else
			daColor = eventColor
		end

		if stopEvent == false then
			doTweenColor('_ColorTweenEvent.' .. eventTarget, eventTarget, daColor, eventTime, eventEase)
		end

		if stopEvent then
			stopEvent = false
		end -- reset the guard at the end of the event
	end
end
