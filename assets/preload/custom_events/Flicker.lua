local cams = {'camGame'}
local isOn = false
local dur = nil
function onEvent(n, v1, v2)
	if n == 'Flicker' then
		if tonumber(v1) == nil and dur == nil then
			dur = 0.05
		elseif dur == nil and tonumber(v1) ~= nil then
			dur = tonumber(v1)
		elseif dur ~= nil and tonumber(v1) ~= nil then
			dur = tonumber(v1)
		end
		if not isOn then
			runTimer('FlickerLuaEventTimer', tonumber(dur), 0)
			isOn = true
		elseif isOn then
			cancelTimer('FlickerLuaEventTimer')
			for i = 1, #cams do
				setProperty(cams[i] .. '.visible', true)
			end
			isOn = false
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'FlickerLuaEventTimer' then
		for i = 1, #cams do
			if getProperty(cams[i] .. '.visible') then
				setProperty(cams[i] .. '.visible', false)
			else
				setProperty(cams[i] .. '.visible', true)
			end
		end
	end
end
