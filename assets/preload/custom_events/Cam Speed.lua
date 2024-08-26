local setSpeed = 1
local resetSpeed = 1
local reseted = false
function onCreatePost()
	resetSpeed = getProperty('cameraSpeed')
	setSpeed = resetSpeed
end

function onEvent(n, v1, v2)
	local speed = tonumber(v1)
	if speed == nil then
		setProperty('cameraSpeed', resetSpeed)
		reseted = true
	else
		reseted = false
	end

	if n == 'Cam Speed' then
		setProperty('cameraSpeed', speed)
		setSpeed = speed
	end
end

function onUpdatePost(elapsed)
	if not reseted and getProperty('cameraSpeed') ~= setSpeed then
		setProperty('cameraSpeed', setSpeed)
	end
end
