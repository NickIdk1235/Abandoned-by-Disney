local isTesting = false
local songStarted = false
local middle_scroll = {412, 524, 636, 748}
local defaultNotePos = {}
local notesIn = false
local beatDur = 0.1
local dadReal = false
local gfReal = false
local jumpscaring = false

local function setVars(script, vars, val)
	local path = ''
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

function onCreate()
	addLuaScript('camFollow')
	setVars('camFollow', {'isCenteredOnChar'}, {true})
end

function onCreatePost()
	getNotePoses()
	for i = 0, 3 do
		noteTweenX('optNotes_' .. i, i, -2000, 0.1, 'expoOut')
	end
	for i = 4, 7 do
		noteTweenX('playerNotes_' .. i, i, middle_scroll[i - 3], 0.0001, 'expoOut')
	end
	setProperty('scoreTxt.visible', false)
	setProperty('cpuControlled', isTesting)

	setProperty('iconP1.visible', false)
	setProperty('iconP2.visible', false)
	setProperty('healthBar.visible', false)
	setProperty('healthBarBG.visible', false)

end

function onSongStart()
	songStarted = true
	setProperty('camGame.alpha', 1)
	if curStep < 5 then
		runHaxeCode([[
            game.camGame.fade(0xff000000, 10, true);
            game.camHUD.fade(0xff000000, 10 / 3, true);
        ]])
	else
		runHaxeCode([[
            game.camGame.fade(0xff000000, 0.1, true);
            game.camHUD.fade(0xff000000, 0.1, true);
        ]])
	end

end

function onUpdate(elapsed)
	if songStarted == false then
		setProperty('camFollowPos.x', 1091)
		setProperty('camFollowPos.y', 504)
		setProperty('camFollow.x', 1091)
		setProperty('camFollow.y', 504)
	end
end
