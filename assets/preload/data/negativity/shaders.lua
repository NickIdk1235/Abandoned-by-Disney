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
		if b then
			return false
		else
			return true
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
			setProperty(obj .. '.x', x)
			setProperty(obj .. '.y', y)
		end
	end,

	setOfs = function(obj, x, y)
		if luaSpriteExists(obj) then
			setProperty(obj .. '.offset.x', x)
			setProperty(obj .. '.offset.y', y)
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
	end
}
local rtxValues = {0.52, 0.42, 0.39, 0.235, 0, 0, 0, 0.335, 0.795, 0.615, 0.29, 0.605, 288, 18.75}
local char = {'boyfriend', 'gf', 'dad'}
function onCreate()
	initLuaShader('Chromatic Aberration Filter')
	initLuaShader('RTXLighting')

	for i = 1, #char do
		setSpriteShader(char[i], 'RTXLighting')
	end

	for i = 1, #char do
		setShaderFloatArray(char[i], 'overlayColor', {rtxValues[1], rtxValues[2], rtxValues[3], rtxValues[4]})
		setShaderFloatArray(char[i], 'satinColor', {rtxValues[5], rtxValues[6], rtxValues[7], rtxValues[8]})
		setShaderFloatArray(char[i], 'innerShadowColor', {rtxValues[9], rtxValues[10], rtxValues[11], rtxValues[12]})
		setShaderFloat(char[i], 'innerShadowAngle', rtxValues[13] * (math.pi / 180))
		setShaderFloat(char[i], 'innerShadowDistance', rtxValues[14])
	end

	makeLuaSprite('camFilter')
	makeGraphic('camFilter', screenWidth, screenHeight)
	setSpriteShader('camFilter', 'Chromatic Aberration Filter')

	runHaxeCode([[
        var camFilterObj = game.getLuaObject('camFilter').shader;
        var camFilter = new ShaderFilter(camFilterObj);
        game.camGame.setFilters([camFilter]);
        game.camHUD.setFilters([]);
    ]])

	setShaderProperty('camFilter', 'shouldUpdateTime', false)
end
local iTime = 0
function onUpdate(elapsed)
	iTime = iTime + elapsed
	setShaderFloat('camFilter', 'total_time', iTime)
end

function onEvent(n, v1, v2)
	if n == '' then
		if v1 == 'revealed' then
			-- removeSpriteShader('boyfriend')
		elseif v1 == 'revealbf' then

		end
	end
end
