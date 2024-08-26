local reset = nil

function onCreatePost()
	reset = getProperty('camera.zoom')
end
function onEvent(n, v1, v2)

	local ease = 'linear'
	local camera = 'camGame'

	local zoom = tonumber(v1)
	local tweenTime = tonumber(v2)

	if zoom == nil then
		zoom = reset
	else
		zoom = zoom
	end

	if tweenTime == nil then
		tweenTime = 0.5
	else
		tweenTime = tweenTime
	end

	if n == 'daTweenZoom' then
		doTweenZoom('tweenZoomTag', camera, zoom, tweenTime, ease);
	end
end

--[[

List of Tween Eases:

	backIn;
	backInOut;
	backOut;
	bounceIn;
	bounceInOut;
	bounceOut;
	circIn;
	circInOut;
	circOut;
	cubeIn;
	cubeInOut;
	cubeOut;
	elasticIn;
	elasticInOut;
	elasticOut;
	expoIn;
	expoInOut;
	expoOut;
	linear;
	quadIn;
	quadInOut;
	quadOut;
	quartIn;
	quartInOut;
	quartOut;
	quintIn;
	quintInOut;
	quintOut;
	sineIn;
	sineInOut;
	sineOut;
	smoothStepIn;
	smoothStepInOut;
	smoothStepOut;
	smootherStepIn;
	smootherStepInOut;
	smootherStepOut;








--]]
