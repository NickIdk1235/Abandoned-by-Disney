local songStarted = false
local middle_scroll = {412, 524, 636, 748}
local defaultNotePos = {}
local targets = {'mom', 'kid'}
local path = ''
local beatDur = nil
local bfY = nil
local losingSignal = false
local inter = 8 -- interference
local dialogueOptions = {"Its so cold...", "It's still here...", "Please forgive us..."}

local function setVars(script, vars, val)
	if script ~= 'camFollow' then
		path = 'Workshop/'
	else
		path = ''
	end
	if script ~= nil then
		for i = 1, #vars do
			setGlobalFromScript(path .. script, vars[i], val[i])
		end
	else
		for i = 1, #vars do
			setProperty(vars[i], val[i])
		end
	end
end

local function getNotePoses()
	for i = 0, 7 do
		table.insert(defaultNotePos,
						{getPropertyFromGroup('strumLineNotes', i, 'x'), getPropertyFromGroup('strumLineNotes', i, 'y')})
	end
end

local function pullHud(dir, cam, dur, ease)
	dir = string.lower(dir)
	if dir == 'left' then
		doTweenX('camHUDShiftX', cam, -40, dur, ease)
		doTweenAngle('camHUDShiftangle', cam, -1.4, dur, ease)
		if getProperty('camHUD.y') ~= 0 then
			doTweenY('camHUDShiftY', cam, 0, dur, ease)
		end
	elseif dir == 'down' then
		doTweenX('camHUDShiftX', cam, 0, dur, ease)
		doTweenY('camHUDShiftY', cam, 30, dur, ease)
		doTweenAngle('camHUDShiftangle', cam, 0, dur, ease)
	elseif dir == 'up' then
		doTweenX('camHUDShiftX', cam, 0, dur, ease)
		doTweenY('camHUDShiftY', cam, -30, dur, ease)
		doTweenAngle('camHUDShiftangle', cam, 0, dur, ease)
	elseif dir == 'right' then
		doTweenX('camHUDShiftX', cam, 40, dur, ease)
		doTweenAngle('camHUDShiftangle', cam, 1.4, dur, ease)
		if getProperty('camHUD.y') ~= 0 then
			doTweenY('camHUDShiftY', cam, 0, dur, ease)
		end
	elseif dir == 'center' then
		doTweenX('camHUDShiftX', cam, 0, dur, ease)
		doTweenAngle('camHUDShiftangle', cam, 0, dur, ease)
		doTweenY('camHUDShiftY', cam, 0, dur, ease)
	end
end

local function speak(index)
	local alpha

	if index ~= nil then
		alpha = 1
		setTextString('gascot_subtitle', dialogueOptions[index])
		doTweenAlpha('textShit', 'gascot_subtitle', alpha, beatDur, 'quadOut')
	elseif index == nil then
		alpha = 0
		setTextString('gascot_subtitle', "")
		doTweenAlpha('textShit', 'gascot_subtitle', alpha, beatDur, 'quadOut')
	end
end

function onCreate()
	setProperty('camGame.angle', -65)
	setProperty('camGame.zoom', 1.56)
	setProperty('skipCountdown', true)

	if isRunning('custom_events/Flashing Camera') then
		setGlobalFromScript('custom_events/Flashing Camera', 'useLuaSprite', true)
	end
end

function onCreatePost()
	setProperty('camHUD.alpha', 0)
	setProperty('cameraSpeed', 99)

	for i = 0, 3 do
		noteTweenX('optNotes_' .. i, i, -2000, 0.1, 'expoOut')
	end
	bfY = getProperty('boyfriend.y')
	setProperty('boyfriend.y', getProperty('boyfriend.y') + 600)
	for i = 4, 7 do
		noteTweenX('playerNotes_' .. i, i, middle_scroll[i - 3], 0.0001, 'expoOut')
	end
	setVars(nil, {'iconP1.visible', 'iconP2.visible', 'healthBar.visible', 'healthBarBG.visible'},
					{false, false, false, false})
	setProperty('dadGroup.color', getColorFromHex('000000'))
	for i = 1, 2 do
		if luaSpriteExists(targets[i]) then
			playAnim(targets[i], 'idle', true)
		end
	end
	local ofs = 20

	setTextBorder('scoreTxt', 2, 'BCBCBC')
	setTextBorder('timeTxt', 2, 'FFFFFF')
	setTextColor('timeTxt', '000000')
	setTextFont('scoreTxt', 'Rubik.ttf')
	setTextFont('timeTxt', 'Rubik.ttf')

	if isRunning('custom_events/RumbleFunk') then
		setGlobalFromScript('custom_events/RumbleFunk', 'filtersEnabled', false)
	end
	setProperty('boyfriend.visible', false)
end

function onSongStart()
	songStarted = true
	if curStep < 5 then
		-- cameraFlash('camOther', '000000', 15, true)
	else
		-- cameraFlash('camOther', '000000', 0.1, true)
	end
	doTweenAngle('camGameTurn', 'camGame', 0, 15, 'sineInOut')
	doTweenZoom('camGameZoom', 'camGame', getProperty('defaultCamZoom'), 20, 'sineInOut')
	doTweenAlpha('darknessAlpha', 'd', 0, 5, 'quadOut')
	doTweenAlpha('bAlpha', 'b', 0.4, 8, 'sineInOut')
	getNotePoses()
	if downscroll then
		for i = 4, 7 do
			noteTweenY('playerNotesY_' .. i, i, defaultNotePos[i - 3][2] - 30, 0.1, 'expoOut')
		end
	else
		for i = 4, 7 do
			noteTweenY('playerNotesY_' .. i, i, defaultNotePos[i - 3][2] + 30, 0.1, 'expoOut')
		end
	end

	for i = 1, #targets do
		doTweenColor('colorChars_' .. i, targets[i], '060606', 10, 'quadOut')
	end
	doTweenColor('colorDad', 'dadGroup', 'FFFFFF', 15, 'expoOut')
end

function onBeatHit()
	--[[
		if curBeat % getProperty('dad.danceEveryNumBeats') == 0 then
			for i = 1, 2 do
				if luaSpriteExists(s.tag[i]) then
					playAnim(s.tag[i], s.prefix, true)
				end
			end
		end
	--]]

	if curBeat % getProperty('boyfriend.danceEveryNumOfBeats') == 0 then
		-- playAnim('boyfriend', 'idle', true)
	end

	if losingSignal then
		if curBeat % inter == 0 then
			doTweenAlpha('staticAlphaIn', 'b', beatDur * (inter / 4), 1, 'elasticInOut')
		end
	end

	if curBeat % 6 == 0 then
		doTweenAlpha('spotlightTween', 'spotlight', 0.25, 1, 'cubeIn')
	end

	if curBeat % 10 == 0 then
		doTweenAlpha('spotlightTween', 'spotlight', 1, 0.75, 'elasticInOut')
	end
end

function onTweenCompleted(tag)
	if tag == 'staticAlphaIn' then
		doTweenAlpha('staticAlphaOut', 'b', 0.4, 1, 'quadOut')
	end
end

function onStepHit()
	beatDur = getPropertyFromClass('Conductor', 'crochet') / 1000
	if curStep == 151 then
		setProperty('cameraSpeed', 1)
	end
	if curStep == 330 then
		doTweenAlpha('camHUDAlpha', 'camHUD', 1, beatDur, 'sineIn')
		if downscroll == true then
			doTweenY('backboardGRAHHH', 'backboard', 535, beatDur, 'sineIn')
		else
			doTweenY('backboardGRAHHH', 'backboard', 10, beatDur, 'sineIn')
		end
		for i = 4, 7 do
			noteTweenY('playerNotes_' .. i, i, defaultNotePos[i - 3][2], beatDur, 'sineIn')
		end
		doTweenY('bfRiseee', 'boyfriend', bfY, 3, 'expoOut')
	elseif curStep == 528 then
		losingSignal = true
	elseif curStep == 625 then
		losingSignal = false
	elseif curStep == 640 then
		doTweenAlpha('staticOhNoes', 'b', 0.9, 1.72, 'quadOut')
	elseif curStep == 656 then
		cancelTween('staticOhNoes')
		doTweenAlpha('staticOhNoes', 'b', 0.4, beatDur, 'sineInOut')
	elseif curStep == 736 then -- right note
		pullHud('right', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 740 then -- down note
		pullHud('down', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 744 then -- left note
		pullHud('left', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 748 then -- down note again
		pullHud('down', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 752 then
		pullHud('center', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 1039 then
		losingSignal = false
		doTweenZoom('camGameZoomIn', 'camGame', 1.75, 1.71, 'quadOut')
		doTweenAngle('camGameAngle', 'camGame', 3.5, 1.71, 'quadOut')
		doTweenAlpha('b', 1, 1.71, 'quadOut')
		speak(3)
	elseif curStep == 1057 then
		cancelTween('camGameZoomIn')
		cancelTween('camGameAngle')
		doTweenAngle('camGameAngleReset', 'camGame', 0, beatDur, 'quadOut')
		setTextString('gascot_subtitle', "")
		for i = 1, #targets do
			doTweenColor('colorChars_' .. i, targets[i], '828282', beatDur, 'expoOut')
		end
		setProperty('spotlight.color', getColorFromHex('FF0000'))
		-- speak(nil)
		losingSignal = true
		setTextBorder('scoreTxt', 2, 'FF0000')
		setTextBorder('timeTxt', 2, 'FF0000')
		setProperty('timeBar.visible', false)
		setProperty('timeBarBG.visible', false)
	elseif curStep == 1259 then
		pullHud('left', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 1263 then
		pullHud('up', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 1267 then
		pullHud('right', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 1271 then
		pullHud('down', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 1275 then
		pullHud('center', 'camHUD', 2.8, 'expoOut')
	elseif curStep == 1590 then
		for i = 1, #targets do
			setProperty(targets[i] .. '.visible', false)
		end
		setProperty('spotlight.color', getColorFromHex('676700'))
		doTweenAlpha('grah1', 'timeTxt', 0, 0.5, 'quadOut')
		doTweenAlpha('grah4', 'scoreTxt', 0, 0.5, 'quadOut')

	elseif curStep == 1855 then
		doTweenAlpha('camGameAlpha', 'camGame', 0, 1.2, 'quadOut')
		doTweenAngle('camGameAlpha', 'camGame', 15, 1.2, 'expoIn')
		doTweenZoom('camGameZoom', 'camGame', 1.5, 1.2, 'expoIn')
	end
end

function onCameraPosSet()
end
