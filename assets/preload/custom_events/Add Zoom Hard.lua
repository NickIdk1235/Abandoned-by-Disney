local reset = nil
local ChartingMode = nil

-- local isPaused = false
function onCreatePost()
	reset = getProperty('camera.zoom')
	-- isPaused = true
	-- runTimer('skipTimeGuard', 0.5, 1)
	-- ChartingMode = getPropertyFromClass('PlayState', 'chartingMode')
end

function onEvent(name, value1, value2)
	if name == "Add Zoom Hard" then
		local targetZoom = tonumber(value1)
		if targetZoom == nil then
			targetZoom = reset
		else
			targetZoom = targetZoom
		end

		local time = tonumber(value2);
		if time == nil then
			time = 0.5
		else
			time = time
		end

		-- setProperty('camGame.zoom', targetZoom);
		doTweenZoom('daTween', 'camGame', targetZoom, time, 'elasticOut');
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
					debugPrint('Event Triggered; Add Zoom Hard. ',targetZoom,', ',time);
				end
			end


]]
