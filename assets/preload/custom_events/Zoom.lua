local reset = nil

-- local isPaused = false;
function onCreatePost()
	reset = getProperty('camera.zoom')
	-- ChartingMode = getPropertyFromClass('PlayState', 'chartingMode')
	-- isPaused = true
	-- runTimer('skipTimeGuard', 0.5, 1)
end
function onEvent(n, v1, v2)

	if n == 'Zoom' then
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
