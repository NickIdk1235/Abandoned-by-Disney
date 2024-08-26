local reset = nil
local ChartingMode = nil

function onCreatePost()
	reset = getProperty('camera.zoom')
	-- ChartingMode = getPropertyFromClass('PlayState', 'chartingMode')
end

function onEvent(n, v1, v2)
	-- Zoom.lua Shit
	local davalue = tonumber(v1)

	if davalue == nil then
		davalue = reset
	else
		davalue = davalue
	end

	if lowQuality then -- cause if it's zoomed out to much it lags or something
		if davalue < 0.3 then
			davalue = 0.4
		else
			davalue = davalue
		end
	end
	-------

	-- daTweenZoom.lua Shit
	local ease = 'expoOut'
	local camera = 'camGame'

	local tweenTime = tonumber(v2)

	if tweenTime == nil then
		tweenTime = 0.5
	else
		tweenTime = tweenTime
	end

	if tweenTime < 1 then
		ease = 'expoOut'
	elseif tweenTime > 1 then
		ease = 'linear'
	end

	-------

	if n == 'daTweenZoom' then
		doTweenZoom('tweenZoomTag', camera, davalue, tweenTime, ease)
	end

	if n == 'Set Cam Zoom' then
		doTweenZoom('SetCamZoomTag', camera, davalue, tweenTime, ease)
		setProperty('defaultCamZoom', davalue)
	end

end

--[[
function onPause()
	isPaused = true
end
function onResume()
	runTimer('skipTimeGuard', 0.5, 1)
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'skipTimeGuard' then
		isPaused = false
	end
end

			if ChartingMode then	
				if isPaused == false then		
					debugPrint('Event Triggered; Zoom Set to',' ', davalue)
				end
			end

]]
