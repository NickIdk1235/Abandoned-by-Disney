function onCreate()
	makeAnimatedLuaSprite('Stage3', 'Stage3', x, y)
	setObjectCamera('Stage3', 'other');
	addLuaSprite('Stage3')
	addAnimationByPrefix('Stage3', 'Stage3', 'Stage3 idle', 12, true);
	curHealth = getProperty('health');
end

function onUpdate(elapsed)
	setProperty('healthBar.alpha', 0)
	setProperty('iconP1.alpha', 0)
	setProperty('iconP2.alpha', 0)
	if curHealth <= 1 then
		setProperty('Stage3.alpha', 1 - getProperty('health'))
	end
end
