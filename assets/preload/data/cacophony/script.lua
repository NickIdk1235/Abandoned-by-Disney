local allowCountdown = false;
function onStartCountdown()
	if not allowCountdown and not seenCutscene and getPropertyFromClass('PlayState', 'deathCounter') == 0 then
		allowCountdown = true;
		setProperty('camGame.visible', false)
		setProperty('camOther.visible', false)
		startVideo('CacoCutscene');
		return Function_Stop;
	end
	return Function_Continue;
end

function onVideoCompleted(tags)
	if tags == 'CacoCutscene' then
		print('Yippee this function works I beleive')
		setProperty('camGame.visible', true)
		setProperty('camOther.visible', true)
	end

end

local lua = {
	lerp = function(from, limit, rate) -- math.lerp
		return (limit - from) * rate + from
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

	getBeatDur = function()
		return getPropertyFromClass('Conductor', 'crochet') / 1000
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

	setVars = function(script, vars, val)
		local path = ''
		if script ~= 'camFollow' or script:find('/') == false then
			path = 'Workshop/'
		else
			path = ''
		end
		if script ~= nil then
			for i = 1, #vars do
				setGlobalFromScript(path .. script, vars[i], val[i])
			end
		elseif script == nil then
			for i = 1, #vars do
				setProperty(vars[i], val[i])
			end
		end
	end,
}

local notePos = {
	middle_scroll = {
		player = {
			x = {412, 524, 636, 748}
		},
		opponent = {
			x = {82, 194, 971, 1083}
		},
		both = {
			x = {82, -- notePos.middle_scroll.opponent.x[1]
			194, -- notePos.middle_scroll.opponent.x[2]
			971, -- notePos.middle_scroll.opponent.x[3]
			1083, -- notePos.middle_scroll.opponent.x[4]
			412, -- notePos.middle_scroll.player.x[1]
			524, -- notePos.middle_scroll.player.x[2]
			636, -- notePos.middle_scroll.player.x[3]
			748 -- notePos.middle_scroll.player.x[4]
			}
		}
	},
	up_scroll = {
		player = {
			x = {732, 844, 956, 1068},
			y = {50, 50, 50, 50}
		},
		opponent = {
			x = {92, 204, 316, 428},
			y = {50, 50, 50, 50}
		}
	},
	down_scroll = {
		player = {
			x = {732, 844, 956, 1068},
			y = {570, 570, 570, 570}
		},
		opponent = {
			x = {92, 204, 316, 428},
			y = {570, 570, 570, 570}
		}
	}
}

local defaultNotePos = {}
local doneIntro = false
local frenzy = false
local group = {'dad', 'lady', 'boy'}
local function getNotePoses()
	for i = 0, 7 do
		table.insert(defaultNotePos,
						{getPropertyFromGroup('strumLineNotes', i, 'x'), getPropertyFromGroup('strumLineNotes', i, 'y')})
	end
end

local function revealScreen()
	setProperty('camGame.visible', true)
	setProperty('camHUD.visible', true)
	if curBeat <= 47 then
		runHaxeCode([[
            game.camGame.fade(0xff000000, 24.96, true);
            game.camHUD.fade(0xff000000, 24.96 / 3, true);
        ]])
	end
	doneIntro = true
end

function onCreate()
	lua.setVars(nil, {'boyfriendGroup.visible', 'gfGroup.visible', 'boyfriendGroup.alpha', 'gfGroup.alpha'},
					{false, false, 0, 0}) -- NO CHANCE of them accidently becoming visible in any way

	setProperty('introSoundsSuffix', 'BLANK')

	makeLuaText('gascot_subtitle', '', 300, nil, nil)
	setTextFont('gascot_subtitle', 'BebasNeue.ttf')
	setTextAlignment('gascot_subtitle', 'center')
	setTextSize('gascot_subtitle', 35)
	setTextColor('gascot_subtitle', '000000')
	setTextBorder('gascot_subtitle', 2.5, 'FFFFFF')
	screenCenter('gascot_subtitle', 'XY')
	setProperty('gascot_subtitle' .. '.alpha', 0.0000000000001) -- if you set it too "0", then it won't load it, leaving it like this will help reduce lag
	setObjectCamera('gascot_subtitle', 'camOther')
	addLuaText('gascot_subtitle')
end

function onCreatePost()
end

function onSongStart()
	for i = 0, 3 do
		setPropertyFromGroup('strumLineNotes', i, 'x', -2000)
	end
	for i = 4, 7 do
		setPropertyFromGroup('strumLineNotes', i, 'x', notePos.middle_scroll.player.x[i - 3])
	end
	getNotePoses()

	for i = 4, 7 do
		local Y_COORD = defaultNotePos[i + 1][2] - 50 -- this is what it is if it player doesn't have donscroll enabled
		if downscroll then
			Y_COORD = defaultNotePos[i + 1][2] + 50 -- changes to plus 50 since when downscroll is enabled the notes are at the bottom instead of the top and shit
		end
		setPropertyFromGroup('strumLineNotes', i, 'y', Y_COORD)
		setPropertyFromGroup('strumLineNotes', i, 'alpha', 0.0001)
	end
	if luaSpriteExists('backboard') then
		setProperty('backboard.alpha', 0.001)
	end
end

local dialogueOptions = {"Its so cold...", "It's still here...", "Please forgive us..."}
function onEvent(n, v1, v2)
	if n == 'AlphaTween' then
		if v1 == 'b' and not doneIntro then
			revealScreen()
		end
	elseif n == '' then
		if v1 == 'notesin' then
			local dur = 1.2
			if curStep > 311 then
				dur = 0.01
			end
			for i = 4, 7 do
				noteTweenY('notes come inraHHHHHHHHH_' .. i, i, defaultNotePos[i + 1][2], dur, 'sineIn')
				noteTweenAlpha('notes become visible_' .. i, i, 1, dur, 'sineIn')
			end
			if luaSpriteExists('backboard') then
				doTweenAlpha('backboard in', 'backboard', 0.6, dur, 'sineInOut')
				--debugPrint('backboard is become real')
				setObjectOrder('backboard', 20)
				scaleObject('backboard', 1.02, 1.02)
				setObjectCamera('backboard', 'camHUD')
			end
		elseif v1 == 'flicker' then
			runTimer('flickerLights', 0.05, getRandomInt(12, 24))
		elseif v1 == 'speak' then
			doTweenAlpha('gascot_subtitle_inAlpha', 'gascot_subtitle', 1, lua.getBeatDur(), 'sineInOut')
			setTextString('gascot_subtitle', dialogueOptions[getRandomInt(1, 3)])
		elseif v1 == 'boom!' then
			cameraFlash('camGame', 'ff0000', 1, true)
			setTextString('gascot_subtitle', '')
			removeLuaText('gascot_subtitle')
			for i = 1, #group do
				setProperty(group[i] .. '.color', getColorFromHex('FF0000'))
			end
			setProperty('bg.color', getColorFromHex('FF0000'))
			runHaxeCode([[
                var blur = new ShaderFilter(game.getLuaObject('blurspr').shader);
                var chrome = new ShaderFilter(game.getLuaObject('chromspr').shader);
                var pixel = new ShaderFilter(game.getLuaObject('pixelspr').shader);
                var rumble = new ShaderFilter(game.getLuaObject('rumble').shader);
                game.camGame.setFilters([chrome, blur, pixel, rumble]);
                game.camHUD.setFilters([blur, pixel]);
            ]])
			frenzy = true
		elseif v1 == 'buff' then
			setShaderFloat('rumble', 'AMTBuff', 0.050)
			setShaderFloat('rumble', 'speedBuff', 0.1)
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'flickerLights' then
		if loopsLeft > 0 then
			setProperty('spotlight.visible', lua.reverseBool(getProperty('spotlight.visible')))
			if getProperty('spotlight.visible') == false then
				setProperty('dad.color', getColorFromHex('000000'))
				setProperty('lady.color', getColorFromHex('000000'))
				setProperty('boy.color', getColorFromHex('000000'))
			else
				setProperty('dad.color', getColorFromHex('FFFFFF'))
				setProperty('lady.color', getColorFromHex('FFFFFF'))
				setProperty('boy.color', getColorFromHex('FFFFFF'))
			end
		elseif loopsLeft == 0 then
			setProperty('spotlight.visible', false)
			setProperty('dad.color', getColorFromHex('000000'))
			setProperty('lady.color', getColorFromHex('000000'))
			setProperty('boy.color', getColorFromHex('000000'))
		end
	end
end
local iTime = 0

function onUpdate(elapsed)
	iTime = iTime + elapsed
	local songPos = getSongPosition()
	if luaSpriteExists('backboard') then
		local daX = getPropertyFromGroup('playerStrums', 0, 'x') - 415 --the notes are going to sway and stuff, so i made it constantly track the note positions
		local daY = getPropertyFromGroup('playerStrums', 0, 'y') - 30 --hopefully these knew offsets are actually centered i'm not entirely sure they are
		lua.setPos('backboard', daX, daY)
	end
	if luaSpriteExists('rumble') then
		setShaderProperty('rumble', 'shouldUpdateTime', false)
		setShaderFloat('rumble', 'total_time', iTime)
	end

	local speed = 0.05
	if not frenzy then
		local formula = math.sin((songPos / 2000) * (bpm / 60) * 1.8) * 22.5
		setProperty('camGame.x', lua.lerp(getProperty('camGame.x'), formula, speed))
		setProperty('camHUD.x', lua.lerp(getProperty('camHUD.x'), formula, speed))

		for i = 4, 7 do
			setPropertyFromGroup('strumLineNotes', i, 'x', notePos.middle_scroll.player.x[i - 3] + -formula)
		end
	else
		setProperty('camGame.x', lua.lerp(getProperty('camGame.x'), 0, speed))
		setProperty('camHUD.x', lua.lerp(getProperty('camHUD.x'), 0, speed))

		for i = 4, 7 do
			setPropertyFromGroup('strumLineNotes', i, 'x', lua.lerp(getPropertyFromGroup('strumLineNotes', i, 'x'),
							notePos.middle_scroll.player.x[i - 3], speed))
		end
	end
end
