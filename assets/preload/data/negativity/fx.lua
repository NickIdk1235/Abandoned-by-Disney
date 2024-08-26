local lua = {
	lerp = function(from, limit, rate) -- math.lerp
		return (limit - from) * rate + from
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
	end
}

local isVisible = false
local darkAlpha
local flickerOut = false
local lightDead = false
local char = {'boyfriend', 'gf', 'dad'}
local songStarted = false

function onCreatePost()
	setProperty('spotlight.x', lua.centerNumbers(getProperty('dad.x'), getProperty('boyfriend.x')) - 1200)
end

function goodNoteHit(id, dir, nt, sus)
	if isVisible and luaSpriteExists('dark') and (curStep > 316 and curStep < 416) then
		local formula = 0.055 * (darkAlpha / 3.5)
		setProperty('dark.alpha', darkAlpha - formula)
	end
end

function onUpdate(elapsed)
	darkAlpha = getProperty('dark.alpha')
	if isVisible then
		setProperty('dark.alpha', lua.lerp(darkAlpha, 1, 0.01 + elapsed))
	end
end

function onEvent(n, v1, v2)
	if n == '' then
		if v1 == 'isVisible' then
			if lua.tobool(v2) == false then
				doTweenAlpha('darkOut', 'dark', 0, 2, 'sineOut')
			elseif lua.tobool(v2) == true then
				doTweenAlpha('darkIn', 'dark', 1, 2, 'sineIn')
			end
		elseif v1 == 'flickerout' then
			flickerOut = lua.tobool(tostring(v2))
		end
	end
end

function onTweenCompleted(tag)
	if tag == 'darkIn' then
		isVisible = true
	elseif tag == 'darkOut' then
		isVisible = false
	end
end

function onSongStart()
	songStarted = true
end

function onBeatHit()
	if songStarted then --lights kept appearing before the screen was visible
		if curBeat % 4 == 0 then
			if not lightDead then
				runTimer('light flicker', 0.1, getRandomInt(6, 12))
			end
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'light flicker' then
		if loopsLeft > 1 then
			setProperty('spotlight.visible', lua.reverseBool(getProperty('spotlight.visible')))
			if getProperty('spotlight.visible') then
				for i = 1, #char do
					setShaderFloat(char[i], 'innerShadowDistance', 18.75)
				end
			else
				for i = 1, #char do
					setShaderFloat(char[i], 'innerShadowDistance', 0)
				end
			end
		elseif loopsLeft == 0 then
			if not flickerOut then
				if getProperty('spotlight.visible') == false then
					setProperty('spotlight.visible', true)
				end
				for i = 1, #char do
					setShaderFloat(char[i], 'innerShadowDistance', 18.75)
				end
			else
				if getProperty('spotlight.visible') == true then
					setProperty('spotlight.visible', false)
				end
				for i = 1, #char do
					setShaderFloat(char[i], 'innerShadowDistance', 0)
				end
				lightDead = true
			end
		end
	end
end
