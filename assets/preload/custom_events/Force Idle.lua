local isPaused = false
function onEvent(name, value1, value2)
	if name == 'Force Idle' then
		-- ChartingMode = getPropertyFromClass('PlayState', 'chartingMode')
		local char = tonumber(value1)

		if char == '1' then
			char = 'dad'
		elseif char == '2' then
			char = 'gf'
		elseif char == '0' then
			char = 'boyfriend'
		end

		characterDance(char)

		--[[
		if ChartingMode then
			debugPrint('Event Triggered; Force Idle ', 'Target: ', char)
		end
		]]
	end
end
--[[
function onCreatePost()
	isPaused = true
	runTimer('skipTimeGuard', 0.5, 1)
end
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
]]
