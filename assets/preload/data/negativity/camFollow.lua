local xx = nil -- 540
local yy = nil -- 550
local xx2 = nil -- 820
local yy2 = nil -- 550
local xx3 = nil -- 670
local yy3 = nil -- 450
local ofsX, ofsY = 30, 30
local dynamicCamera = true
local locked = false
local followchars = false
local sectionUpdate = false
local liveZoomFix = false
local charOfs = {
	bf = {0, 0},
	dad = {0, 0},
	gf = {0, 0}
}
local stageOfs = {
	bf = {0, 0},
	dad = {0, 0},
	gf = {0, 0}
}
local bfJsonArray = {0, 0}
local dadJsonArray = {0, 0}
local gfJsonArray = {0, 0}
local target = 'bf'
local isCenteredOnChar = false
local lerpMethod = false
local velocityMethod = false
local velocity = 3
local rate = 0.55
local angleSlider = false -- does the camera slightly tilt to the side?
local luaObj_x = 0
local luaObj_y = 0

local direction = 0 -- angle the camera will tilt too
local frameDrawRate = 0.1 -- basically the time that is elasped before the next frame is drawn
local in_progress = false
local anim = nil
local wlC = '-_,. '
local index = 0
local debugging = false
local gfExists = nil
local dadEqualsGf = false
local songStarted = false
local targetUpdated = false
local whiteListedCharacters = '-_, '
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

	clamp = function(x, min, max)
		return math.max(min, math.min(x, max))
	end,

	split = function(string)
		local characters = '-_, '
		for word in string.gmatch(string, '([^' .. characters .. ']+)') do -- Difficult yet neccessary motherfucker.
			return word
		end
	end,

	splitValue = function(string, toReturn)
		for word in string.gmatch(string, '([^' .. wlC .. ']+)') do -- Difficult yet neccessary motherfucker.
			index = index + 1

			if index == toReturn then
				index = 0
				return word
			end
		end
	end,

	anim_startsWith = function(string, toReturn)
		local grah = 0
		for word in string.gmatch(string, '([^' .. wlC .. ']+)') do -- Difficult yet neccessary motherfucker.
			grah = 1

			if grah == 1 then
				grah = 0
				return word
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

	updateCurPos = function(dynamic, chr)
		if dynamic then
			if mustHitSection and not gfSection then
				target = 'bf'
			elseif not mustHitSection and not gfSection then
				target = 'dad'
			elseif gfExists and gfSection then
				target = 'gf'
			end
		else
			target = tostring(chr)
			-- if curSec < 2 then
			-- end
		end

		if targetUpdated then
			onTargetUpdate()
		end

		if dynamic then
			if curSec == 1 then
				targetUpdated = false
			else
				targetUpdated = true
			end
		elseif not dynamic then
			targetUpdated = true
		end
	end
}

local easing = {
	-- linear
	linear = function(t, b, c, d)
		return c * t / d + b
	end,

	-- quad
	inQuad = function(t, b, c, d)
		return c * math.pow(t / d, 2) + b
	end,
	outQuad = function(t, b, c, d)
		t = t / d
		return -c * t * (t - 2) + b
	end,
	inOutQuad = function(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return c / 2 * math.pow(t, 2) + b
		end
		return -c / 2 * ((t - 1) * (t - 3) - 1) + b
	end,
	outInQuad = function(t, b, c, d)
		if t < d / 2 then
			return easing.outQuad(t * 2, b, c / 2, d)
		end
		return easing.inQuad((t * 2) - d, b + c / 2, c / 2, d)
	end,

	-- cubic
	inCubic = function(t, b, c, d)
		return c * math.pow(t / d, 3) + b
	end,
	outCubic = function(t, b, c, d)
		return c * (math.pow(t / d - 1, 3) + 1) + b
	end,
	inOutCubic = function(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return c / 2 * t * t * t + b
		end
		t = t - 2
		return c / 2 * (t * t * t + 2) + b
	end,
	outInCubic = function(t, b, c, d)
		if t < d / 2 then
			return easing.outCubic(t * 2, b, c / 2, d)
		end
		return easing.inCubic((t * 2) - d, b + c / 2, c / 2, d)
	end,

	-- quint
	inQuint = function(t, b, c, d)
		return c * math.pow(t / d, 5) + b
	end,
	outQuint = function(t, b, c, d)
		return c * (math.pow(t / d - 1, 5) + 1) + b
	end,
	inOutQuint = function(t, b, c, d)
		t = t / d * 2
		if t < 1 then
			return c / 2 * math.pow(t, 5) + b
		end
		return c / 2 * (math.pow(t - 2, 5) + 2) + b
	end,
	outInQuint = function(t, b, c, d)
		if t < d / 2 then
			return easing.outQuint(t * 2, b, c / 2, d)
		end
		return easing.inQuint((t * 2) - d, b + c / 2, c / 2, d)
	end,

	-- elastics
	outElastic = function(t, b, c, d, a, p)
		a = a or 3
		p = p or 1
		if t == 0 then
			return b
		end
		t = t / d
		if t == 1 then
			return b + c
		end
		if not p then
			p = d * 0.3
		end
		local s
		if not a or a < math.abs(c) then
			a = c
			s = p / 4
		else
			s = p / (2 * math.pi) * math.asin(c / a)
		end
		return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p) + c + b
	end
}

local camPointX = 0
local camPointY = 0
local camlock = false

local function checkOnGf()
	if getProperty('gf.curCharacter') == 'gf.curCharacter' then
		return false -- gf doesn't exist!
	else
		return true -- yayyy! gf exists!
	end
end

local function valueToChar(value)
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

function cacluate_shit(var, charToConsider)
	if not (gfExists) or (getProperty('gf.curCharacter') == 'gf.curCharacter') then -- failsafe for if gf does not exist
		xx3 = 0
		yy3 = 0
	end
	if gfExists then
		if getProperty('gf.curCharacter') == getProperty('dad.curCharacter') then
			dadEqualsGf = false
		else
			dadEqualsGf = true
		end
	end

	if charToConsider == 'dad' then
		if not isCenteredOnChar then
			if var == 'x' then
				return xx
			elseif var == 'y' then
				return yy
			end
		else
			if var == 'x' then
				if dadEqualsGf then
					return getMidpointX('dad')
				else
					if gfExists then
						return getMidpointX('gf')
					end
				end
			elseif var == 'y' then
				if dadEqualsGf then
					return yy
				else
					if gfExists then
						return getMidpointX('gf')
					end
				end
			end
		end
		if var == 'anim' then
			return getProperty('dad.animation.curAnim.name')
		end

	elseif charToConsider == 'bf' then
		if not isCenteredOnChar then
			if var == 'x' then
				return xx2
			elseif var == 'y' then
				return yy2
			end
		else
			if var == 'x' then
				return getMidpointX('boyfriend')
			elseif var == 'y' then
				return yy2
			end
		end
		if var == 'anim' then
			return getProperty('boyfriend.animation.curAnim.name')
		end
	end
	if charToConsider == 'gf' then
		if gfExists then
			if not isCenteredOnChar then
				if var == 'x' then
					return xx3
				elseif var == 'y' then
					return yy3
				end
			else
				if var == 'x' then
					return getMidpointX('gf')
				elseif var == 'y' then
					return getMidpointY('gf')
				end
			end
			if var == 'anim' then
				return getProperty('gf.animation.curAnim.name')
			end
		end
	end
	if charToConsider == 'duet' then
		if mustHitSection and not gfSection then
			anim = getProperty('boyfriend.animation.curAnim.name')
		elseif not mustHitSection and not gfSection then
			anim = getProperty('dad.animation.curAnim.name')
		elseif gfSection then
			if gfExists then
				anim = getProperty('gf.animation.curAnim.name')
			end
		end
		if var == 'x' then
			return lua.centerNumbers(xx, xx2)
		elseif var == 'y' then
			return lua.centerNumbers(yy, yy2)
		elseif var == 'anim' then
			return anim
		end
	else -- if char to consider isn't bf, dad, or gf
		if var == 'x' then
			return luaObj_x
		elseif var == 'y' then
			return luaObj_y
		elseif var == 'anim' then
			return getProperty(charToConsider .. '.animation.curAnim.name')
		end
	end
end

function getCameraPos(char)
	if gfExists == nil then
		gfExists = checkOnGf()
	end

	local propTarget = 'bf'
	char = string.lower(char)
	if char == 'bf' or char == '0' then
		propTarget = 'bf'
	elseif char == 'dad' or char == '1' then
		propTarget = 'dad'
	elseif char == 'gf' or char == '2' then
		propTarget = 'gf'
	else
		propTarget = 'all'
	end

	in_progress = true
	bfJsonArray = getProperty('boyfriend.cameraPosition')
	dadJsonArray = getProperty('dad.cameraPosition')
	if getProperty('gf.curCharacter') ~= 'gf.curCharacter' then
		gfJsonArray = getProperty('gf.cameraPosition')
	end

	for i = 1, 2 do
		stageOfs.bf[i] = getProperty('boyfriendCameraOffset')[i]
		stageOfs.dad[i] = getProperty('opponentCameraOffset')[i]
		if gfExists then
			stageOfs.gf[i] = getProperty('girlfriendCameraOffset')[i]
		end
	end

	if propTarget == 'bf' then
		for i = 1, 2 do
			charOfs.bf[i] = bfJsonArray[i]
		end
	end

	if propTarget == 'dad' then
		for i = 1, 2 do
			charOfs.dad[i] = dadJsonArray[i]
		end
	end

	if gfExists then
		if propTarget == 'gf' then
			for i = 1, 2 do
				if gfJsonArray[i] ~= nil then
					charOfs.gf[i] = gfJsonArray[i]
				end
			end
		end
	end

	if propTarget == 'all' or propTarget == nil then
		for i = 1, 2 do
			charOfs.bf[i] = bfJsonArray[i]
			charOfs.dad[i] = dadJsonArray[i]
			if gfExists then
				if gfJsonArray[i] ~= nil then
					charOfs.gf[i] = gfJsonArray[i]
				end
			end
		end
	end
	if not lowQuality then
		callOnLuas('onCameraPosGet')
	end

	--[[if (propTarget == 'all') then
        setCameraPos('all', 'setGlobals')
    
    elseif (char == 'all' or char == '' or char == nil) and not gfExists then --whenever gf isn't made the script just fucking hangs itself man and i really wish it fucking didn't
        setCameraPos('BF', 'setGlobals')
        setCameraPos('Dad', 'setGlobals')
    end]]

	if (propTarget == 'all') then
		setCameraPos('all', 'setGlobals')
	elseif propTarget == 'bf' then
		setCameraPos('bf', 'setGlobals')
	elseif propTarget == 'dad' then
		setCameraPos('dad', 'setGlobals')
	elseif gfExists and propTarget == 'gf' then
		setCameraPos('gf', 'setGlobals')
	end

	if debugging then
		debugPrint('getCameraPos Function Finished! | char = ' .. tostring(char))
	end
end
function setCameraPos(char, mode, toreturn)
	if gfExists == nil then
		gfExists = checkOnGf()
	end
	local propTarget = 'all'
	char = string.lower(char)
	if gfExists then
		if getProperty('gf.curCharacter') == getProperty('dad.curCharacter') then
			dadEqualsGf = true
		else
			dadEqualsGf = false
		end
	end

	if char == 'bf' or char == '0' then
		propTarget = 'bf'
	elseif char == 'dad' or char == '1' then
		propTarget = 'dad'
	elseif char == 'gf' or char == '2' then
		propTarget = 'gf'
	else
		propTarget = 'all'
	end

	if mode == 'setGlobals' then
		if propTarget == 'all' or propTarget == nil then
			if dadEqualsGf then
				xx = getMidpointX('gf') + charOfs.gf[1] + stageOfs.gf[1]
				yy = getMidpointY('gf') + charOfs.gf[2] + stageOfs.gf[2]
				xx3 = getMidpointX('gf') + charOfs.gf[1] + stageOfs.gf[1]
				yy3 = getMidpointY('gf') + charOfs.gf[2] + stageOfs.gf[2]
			elseif dadEqualsGf == false then
				xx = getMidpointX('dad') + 150 + charOfs.dad[1] - stageOfs.dad[1]
				yy = getMidpointY('dad') - 100 + charOfs.dad[2] + stageOfs.dad[2]
			end

			xx2 = getMidpointX('boyfriend') - 100 - charOfs.bf[1] + stageOfs.bf[1]
			yy2 = getMidpointY('boyfriend') - 100 + charOfs.bf[2] + stageOfs.bf[2]

			if gfExists and not dadEqualsGf then
				xx3 = getMidpointX('gf') + charOfs.gf[1] + stageOfs.gf[1]
				yy3 = getMidpointY('gf') + charOfs.gf[2] + stageOfs.gf[2]
			end

			if debugging then
				debugPrint('dad equals gf = ' .. tostring(dadEqualsGf))
			end

		elseif propTarget == 'bf' then
			xx2 = getMidpointX('boyfriend') - 100 - charOfs.bf[1] + stageOfs.bf[1]
			yy2 = getMidpointY('boyfriend') - 100 + charOfs.bf[2] + stageOfs.bf[2]
		elseif propTarget == 'dad' then
			xx = getMidpointX('dad') + 150 + charOfs.dad[1] - stageOfs.dad[1]
			yy = getMidpointY('dad') - 100 + charOfs.dad[2] + stageOfs.dad[2]
		elseif gfExists and propTarget == 'gf' then
			xx3 = getMidpointX('gf') + charOfs.gf[1] + stageOfs.gf[1]
			yy3 = getMidpointY('gf') + charOfs.gf[2] + stageOfs.gf[2]
		end

		if not lowQuality then
			callOnLuas('onCameraPosSet')
		end

		if not songStarted then
			followchars = true
		end

	elseif mode == 'return' then
		if propTarget == 'bf' then
			if toreturn == 'x' then
				return getMidpointX('boyfriend') - 100 - charOfs.bf[1] + stageOfs.bf[1]
			elseif toreturn == 'y' then
				return getMidpointY('boyfriend') - 100 + charOfs.bf[2] + stageOfs.bf[2]
			end
		end

		if propTarget == 'dad' then
			if toreturn == 'x' then
				return getMidpointX('dad') + 150 + charOfs.dad[1] - stageOfs.dad[1]
			elseif toreturn == 'y' then
				return getMidpointY('dad') - 100 + charOfs.dad[2] + stageOfs.dad[2]
			end
		end

		if gfExists then
			if propTarget == 'gf' then
				if toreturn == 'x' then
					return getMidpointX('gf') + charOfs.gf[1] - stageOfs.gf[1]
				elseif toreturn == 'y' then
					return getMidpointY('gf') + charOfs.gf[2] + stageOfs.gf[2]
				end
			end
		else
			if toreturn == 'x' then
				return 0
			elseif toreturn == 'y' then
				return 0
			end
		end
	end
	in_progress = false
	if debugging then
		debugPrint('setCameraPos function finished! | char = ' .. tostring(char) .. ' | mode = ' .. tostring(mode))
	end
end

local arrows = {
	player = {
		false, -- left note
		false, -- down note
		false, -- up note
		false -- right note
	},
	opponent = {
		false, -- left note
		false, -- down note
		false, -- up note
		false -- right note
	}
}
local luaDir = {
	player = 0,
	opponent = 0
}
local function noteTracker()
	local p_note = arrows.player
	local o_note = arrows.opponent

	for i = 1, 4 do
		if p_note[i] == true then
			p_note[i] = false
			break
		end

		if o_note[i] == true then
			o_note[i] = false
			break
		end
	end
end

function onTargetUpdate()
	-- debugPrint('TARGET UPDATE FUNCTION CALLED!!')

	if velocityMethod then
		camlock = false
		setProperty('cameraSpeed', getProperty('resetSpeed'))
	end
end

local function onNoteHit(pressedBy, dir, id)
	if (pressedBy == 'player') then
		luaDir.player = dir
		arrows.player[dir + 1] = true
	elseif (pressedBy == 'opponent') then
		luaDir.opponent = dir
		arrows.opponent[dir + 1] = true
	end

	if not targetUpdated then
		if pressedBy == 'player' then
			lua.updateCurPos(false, 'bf')
		elseif pressedBy == 'opponent' then
			lua.updateCurPos(false, 'dad')
		end
	end
	if (pressedBy == 'player' and mustHitSection) or (pressedBy == 'opponent' and not mustHitSection) then
		local strumTime = getPropertyFromGroup('notes', id, 'strumTime')
		local songPos = getSongPosition()
		if angleSlider then
			if dir == 1 or dir == 2 then
				direction = 0
			elseif dir == 0 then
				-- direction = -3 * (strumTime / songPos)
				direction = lua.boundTo((strumTime / songPos), -3, -10)
			elseif dir == 3 then
				-- direction = 3 * (strumTime / songPos)
				direction = lua.boundTo((strumTime / songPos), 3, 10)
			end
		end
	end

	if velocityMethod then
		camlock = true
		if (pressedBy == 'player' and target == 'bf') then
			if dir == 0 then -- singLEFT
				camPointX = cacluate_shit('x', 'bf') - ofsX
				camPointY = cacluate_shit('y', 'bf')
			elseif dir == 1 then -- singDOWN
				camPointX = cacluate_shit('x', 'bf')
				camPointY = cacluate_shit('y', 'bf') + ofsY
			elseif dir == 2 then -- singUP
				camPointX = cacluate_shit('x', 'bf')
				camPointY = cacluate_shit('y', 'bf') - ofsY
			elseif dir == 3 then -- singRIGHT
				camPointX = cacluate_shit('x', 'bf') + ofsX
				camPointY = cacluate_shit('y', 'bf')
			end
		elseif (pressedBy == 'opponent' and target == 'dad') then
			if dir == 0 then
				camPointX = cacluate_shit('x', 'dad') - ofsX
				camPointY = cacluate_shit('y', 'dad')
			elseif dir == 1 then
				camPointX = cacluate_shit('x', 'dad')
				camPointY = cacluate_shit('y', 'dad') + ofsY
			elseif dir == 2 then
				camPointX = cacluate_shit('x', 'dad')
				camPointY = cacluate_shit('y', 'dad') - ofsY
			elseif dir == 3 then
				camPointX = cacluate_shit('x', 'dad') + ofsX
				camPointY = cacluate_shit('y', 'dad')
			end
		elseif (target == 'duet') then
			if dir == 0 then
				camPointX = cacluate_shit('x', target) - ofsX
				camPointY = cacluate_shit('y', target)
			elseif dir == 1 then
				camPointX = cacluate_shit('x', target)
				camPointY = cacluate_shit('y', target) + ofsY
			elseif dir == 2 then
				camPointX = cacluate_shit('x', target)
				camPointY = cacluate_shit('y', target) - ofsY
			elseif dir == 3 then
				camPointX = cacluate_shit('x', target) + ofsX
				camPointY = cacluate_shit('y', target)
			end
		else
			if dir == 0 then
				camPointX = cacluate_shit('x', target) - ofsX
				camPointY = cacluate_shit('y', target)
			elseif dir == 1 then
				camPointX = cacluate_shit('x', target)
				camPointY = cacluate_shit('y', target) + ofsY
			elseif dir == 2 then
				camPointX = cacluate_shit('x', target)
				camPointY = cacluate_shit('y', target) - ofsY
			elseif dir == 3 then
				camPointX = cacluate_shit('x', target) + ofsX
				camPointY = cacluate_shit('y', target)
			end
		end

		setProperty('camFollow.x', camPointX)
		setProperty('camFollow.y', camPointY)
		setProperty('cameraSpeed', getProperty('resetSpeed') + velocity)
		runTimer('camreset', 0.25)
	end
end

function goodNoteHit(id, dir, nt, sus)
	local gfNote = getPropertyFromGroup('notes', id, 'gfNote')
	if not gfNote then
		onNoteHit('player', dir, id)
	elseif gfNote then
		onNoteHit('gf')
	end
end

function opponentNoteHit(id, dir, nt, sus)
	local gfNote = getPropertyFromGroup('notes', id, 'gfNote')
	if not gfNote and not gfSection then
		onNoteHit('opponent', dir)
	elseif gfNote or gfSection then
		onNoteHit('gf', dir)
	end
end

function onCreate()
	if debugging then
		luaDebugMode = true
		makeLuaText('d_txt', '', 300, 300, 300)
		setTextFont('d_txt', 'vcr.ttf')
		setTextSize('d_txt', 30)
		addLuaText('d_txt')
	end
	getCameraPos('all')
end

function onCreatePost()
	if getProperty('gf.curCharacter') == 'gf.curCharacter' then
		gfExists = false
	else
		gfExists = true
	end
	if not in_progress then
		getCameraPos('all')
	end

	if dynamicCamera then
		if gfExists then
			-- updateCurPos(false, 'gf')
		else
			-- updateCurPos(false, 'bf')
		end
	end
	--[[
        if mustHitSection and not gfSection then
            target = 'bf'
        elseif not mustHitSection and not gfSection then
            target = 'dad'
        elseif gfExists and gfSection then
            target = 'gf'
        end
    ]]
end

function onScriptAdd()
	getCameraPos('all')
end

function onStepHit()
	noteTracker()
end

function onStartCountdown()
	if not getProperty('skipCountdown') then
		getCameraPos('all')
	end

	return Function_Continue
end

function onSongStart()
	if getProperty('skipCountdown') == true then
		getCameraPos('all')
		if dynamicCamera then
			-- updateCurPos(true, nil)
		end
	end

	songStarted = true
end

function onSectionHit()
	if sectionUpdate then
		if not mustHitSection then
			getCameraPos('dad')
		elseif mustHitSection then
			getCameraPos('boyfriend')
		end
	end

	if dynamicCamera then
		lua.updateCurPos(true, nil)
	end
end

function onEvent(n, v1, v2)
	local script = lua.splitValue(string.lower(v1), 1)
	local global = lua.splitValue(string.lower(v1), 2)
	local lV1 = tostring(string.lower(v1))
	local lV2 = tostring(string.lower(v2))
	if n == 'Change Character' then
		if (gfExists) and v1 == 'GF' or v1 == '2' then
			getCameraPos('GF')
		elseif v1 == 'BF' or v1 == '0' or v1 == 'bf' then
			getCameraPos('BF')
		elseif v1 == 'Dad' or v1 == '1' or v1 == 'dad' then
			getCameraPos('Dad')
		end
	end

	if n == 'Appoint' then
		if v1 == 'gf.x' or v1 == 'gf.y' then
			if gfExists then
				getCameraPos('GF')
			end
		elseif v1 == 'boyfriend.x' or v1 == 'boyfriend.y' then
			getCameraPos('BF')
		elseif v1 == 'dad.x' or v1 == 'dad.y' then
			getCameraPos('Dad')
		end
	end

	if n == 'Camera Follow Pos' or n == 'CameraSetTarget' then
		if v1 ~= '' and v2 ~= '' then
			followchars = false
		else
			followchars = true
		end
	end

	if n == 'camFollow Event' then
		if lV1 == 'iscenteredonchar' then
			isCenteredOnChar = lua.tobool(lV2)
		elseif lV1 == 'sectionupdate' then
			sectionUpdate = lua.tobool(lV2)
		elseif lV1 == 'lerpmethod' then
			lerpMethod = lua.tobool(lV2)
		elseif lV1 == 'rate' then
			rate = tonumber(v2)
		elseif lV1 == 'ofsx' then
			ofsX = tonumber(v2)
		elseif lV1 == 'ofsy' then
			ofsY = tonumber(v2)
		elseif lV1 == 'ofs' then
			ofsX, ofsY = tonumber(v2), tonumber(v2)
		elseif lV1 == 'velocitymethod' then
			velocityMethod = lua.tobool(lV2)
		elseif lV1 == 'velocity' or lV1 == 'vel' then
			velocity = tonumber(v2)
		elseif lV1 == 'xx' then
			if v2 == nil or v2 == '' then
				getCameraPos('dad')
			else
				xx = tonumber(v2)
			end
		elseif lV1 == 'yy' then
			if v2 == nil or v2 == '' then
				getCameraPos('dad')
			else
				yy = tonumber(v2)
			end
		elseif lV1 == 'xx2' then
			if v2 == nil or v2 == '' then
				getCameraPos('boyfriend')
			else
				xx2 = tonumber(v2)
			end
		elseif lV1 == 'yy2' then
			if v2 == nil or v2 == '' then
				getCameraPos('boyfriend')
			else
				yy2 = tonumber(v2)
			end
		elseif lV1 == 'xx+' then
			if v2 == nil or v2 == '' then
				xx = xx + tonumber(v2)
			end
		elseif lV1 == 'yy+' then
			if v2 == nil or v2 == '' then
				yy = yy + tonumber(v2)
			end
		elseif lV1 == 'xx2+' then
			if v2 == nil or v2 == '' then
				xx2 = xx2 + tonumber(v2)
			end
		elseif lV1 == 'yy2+' then
			if v2 == nil or v2 == '' then
				yy2 = yy2 + tonumber(v2)
			end
		end
	end

	if n == '' or n == 'camFollow Event' then
		if script == 'camfollow' then
			if global == 'xx' then
				xx = v2
			elseif global == 'yy' then
				yy = v2
			elseif global == 'xx+' then
				xx = xx + v2
			elseif global == 'yy+' then
				yy = yy + v2
			elseif global == 'xx2' then
				xx2 = v2
			elseif global == 'yy2' then
				yy2 = v2
			elseif global == 'xx2+' then
				xx2 = xx2 + v2
			elseif global == 'yy2+' then
				yy2 = yy2 + v2
			elseif global == 'xx3' then
				xx3 = v2
			elseif global == 'yy3' then
				yy3 = v2
			elseif global == 'xx3+' then
				xx3 = xx3 + v2
			elseif global == 'yy3+' then
				yy3 = yy3 + v2
			end
		end
		if lV1 == 'camfollow.set' or lV1 == 'cf.set' then
			if v2 ~= nil or v2 ~= '' then
				dynamicCamera = false
				if valueToChar(lV2) == 'bf' then
					lua.updateCurPos(false, 'bf')
				elseif valueToChar(lV2) == 'dad' then
					lua.updateCurPos(false, 'dad')
				elseif valueToChar(lV2) == 'gf' then
					lua.updateCurPos(false, 'gf')
				elseif lV2 == 'duet' then
					target = 'duet'
					lua.updateCurPos(false, 'duet')
				elseif lV2 == 'def' or lV2 == 'default' or lV2 == '' then
					dynamicCamera = true
					lua.updateCurPos(true, nil)
				else
					target = tostring(v2)
				end
			elseif v2 == nil or v2 == '' or lV2 == '' or lV2 == nil then
				dynamicCamera = true
			end
		end

	end
end

function toggleLock(staionary)
	if staionary then
		locked = true
		followchars = false
		setProperty('isCameraOnForcedPos', false)
	elseif not staionary then
		locked = false
		followchars = true
		setProperty('isCameraOnForcedPos', true)
	end
end

function onMoveCamera(focus)
	if dynamicCamera then
		if focus == 'dad' then
			lua.updateCurPos(false, 'dad')
			doTweenAlpha('vruh', 'fg', 1, 1.2)

		elseif focus == 'boyfriend' then
			lua.updateCurPos(false, 'bf')
			doTweenAlpha('vruh', 'fg', 0.4, 1.2)
		end
		followchars = true
	end
end

-- Modified version of Washo789's follow script.
function migrateCamera(forceToIdle)
	local fps = getPropertyFromClass('ClientPrefs', 'framerate')
	local x
	local y

	x = cacluate_shit('x', target)
	y = cacluate_shit('y', target)
	if forceToIdle then
		anim = 'idle'
	else
		anim = cacluate_shit('anim', target)
	end

	local singPos = lua.anim_startsWith(anim, 1)
	if velocityMethod == false then
		if singPos == 'singLEFT' then
			x = x - ofsX
			y = y
		elseif singPos == 'singDOWN' then
			x = x
			y = y + ofsY
		elseif singPos == 'singUP' then
			x = x
			y = y - ofsY
		elseif singPos == 'singRIGHT' then
			x = x + ofsX
			y = y
		else
			x = x
			y = y
		end
	end

	if angleSlider then
		setProperty('camGame.angle', lua.lerp(getProperty('camGame.angle'), direction,
						lua.boundTo((rate + 1) * getProperty('cameraSpeed') * frameDrawRate, 0, fps)))
		setProperty('camHUD.angle', lua.lerp(getProperty('camHUD.angle'), direction / 2,
						lua.boundTo((rate) * getProperty('cameraSpeed') * frameDrawRate, 0, fps)))
	end

	if followchars then
		if lerpMethod == true and velocityMethod == false then
			setProperty('isCameraOnForcedPos', true)
			local testVar = 15
			-- rate * (elapsed * testVar) * getProperty('cameraSpeed'))
			if not getProperty('disableCamera') then
				setProperty('camFollow.x',
								lua.lerp(getProperty('camFollow.x'), x, rate * (frameDrawRate * testVar) * getProperty('cameraSpeed')))
				setProperty('camFollow.y',
								lua.lerp(getProperty('camFollow.y'), y, rate * (frameDrawRate * testVar) * getProperty('cameraSpeed')))
			else
				setProperty('camFollow.x',
								lua.lerp(getProperty('camFollow.x'), x, rate * (frameDrawRate * testVar) * getProperty('cameraSpeed')))
				setProperty('camFollow.y',
								lua.lerp(getProperty('camFollow.y'), y, rate * (frameDrawRate * testVar) * getProperty('cameraSpeed')))
				setProperty('camFollowPos.x', lua.lerp(getProperty('camFollowPos.x'), x,
								rate * (frameDrawRate * testVar) * getProperty('cameraSpeed')))
				setProperty('camFollowPos.y', lua.lerp(getProperty('camFollowPos.y'), y,
								rate * (frameDrawRate * testVar) * getProperty('cameraSpeed')))
			end
		elseif velocityMethod == true and lerpMethod == false then
			if camlock then
				setProperty('camFollow.x', camPointX)
				setProperty('camFollow.y', camPointY)
			else
				setProperty('camFollow.x', cacluate_shit('x', target))
				setProperty('camFollow.y', cacluate_shit('y', target))
			end
		elseif velocityMethod == false and lerpMethod == false then
			setProperty('camFollow.x', x)
			setProperty('camFollow.y', y)
		end
	end

	if liveZoomFix then
		if target == 'dad' then
			if x > getMidpointX('dad') then
				x = xx / getProperty('defaultCamZoom')
			elseif x < getMidpointX('dad') then
				x = xx * getProperty('defaultCamZoom')
			end

			if y > getMidpointY('dad') then
				y = yy / getProperty('defaultCamZoom')
			elseif y < getMidpointY('dad') then
				y = yy * getProperty('defaultCamZoom')
			end
		elseif target == 'bf' then
			if x > getMidpointX('boyfriend') then
				x = xx2 * getProperty('defaultCamZoom')
			elseif x < getMidpointX('boyfriend') then
				x = xx2 / getProperty('defaultCamZoom')
			end

			if y > getMidpointY('boyfriend') then
				y = yy2 / getProperty('defaultCamZoom')
			elseif y < getMidpointY('boyfriend') then
				y = yy2 * getProperty('defaultCamZoom')
			end
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'camFollow_idleCamMove' then
		migrateCamera(true)
	end

	if tag == 'camreset' then
		camlock = false
		setProperty('camFollow.x', cacluate_shit('x', target))
		setProperty('camFollow.y', cacluate_shit('y', target))
		setProperty('cameraSpeed', getProperty('resetSpeed'))
	end
end

function onUpdate(elapsed)
	frameDrawRate = elapsed
	if targetUpdated then
		migrateCamera()
	end

	if debugging then
		setTextString('d_txt',
						"x = " .. setCameraPos('dad', 'return', 'x') .. "\ny = " .. setCameraPos('dad', 'return', 'y') ..
										'\n IS TARGET UPDATED? = ' .. tostring(targetUpdated) .. '\nfollowchars = ' .. tostring(followchars))
	end

	if getProperty('dad.curCharacter') == 'floatyCharacter' or getProperty('dad.curCharacter') ==
					'floatyCharacter_Playable' then
		if mustHitSection == false then
			toggleLock(true) -- cameraSetTarget Shit works and it's not gonna follow movements
		elseif mustHitSection == true then
			toggleLock(false)
		end
	end

	if getProperty('boyfriend.curCharacter') == 'floatyCharacter_Playable' then
		if mustHitSection == true then
			toggleLock()
		elseif mustHitSection == false then
			toggleLock(false)
		end
	end
end
