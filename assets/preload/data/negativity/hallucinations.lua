--Coded by NickIdk
ranNum = 3
ranImage = 0
timeRun = 0

function onCreate()
	for i = 1, 6 do
		precacheImage('schizo_' .. i)
		makeLuaSprite('schizo_' .. i, 'Hallucinations/Hallucinations' .. i, nil, nil)
		setObjectCamera('schizo_' .. i, 'camOther')
		setGraphicSize('schizo_' .. i, screenWidth, screenHeight)
		setProperty('schizo_' .. i .. '.alpha', 0)
		screenCenter('schizo_' .. i, 'XY')
		addLuaSprite('schizo_' .. i, true)
		setProperty('schizo_' .. i .. '.visible', true)
	end
end

function onSongStart()
	runTimer('Hallucination1', 10)
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'Hallucination1' then
		ranNum = math.random(1, 100)
		timeRun = 20
		if ranNum <= 10 then
			ranImage = math.random(1, 6)
			doTweenAlpha('hallucinationShow', 'schizo_' .. ranImage, 0.5, 1, 'linear')
			runTimer('flickerHallucination', 0.05,20)
		else
			runTimer('Hallucination1', 10)
		end
	end

	if tag == 'flickerHallucination' then
		timeRun = timeRun - 1
		if timeRun > 0 then
			if getProperty('schizo_' .. ranImage .. '.visible') == false then
			setProperty('schizo_' .. ranImage .. '.visible', true)
		else
			setProperty('schizo_' .. ranImage .. '.visible', false)
		end
		elseif timeRun == 0 then
			setProperty('schizo_' .. ranImage .. '.visible', true)
			setProperty('schizo_' .. ranImage .. '.alpha', 0)
			runTimer('Hallucination1', 10)
		end
	end
end
