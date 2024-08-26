local lua = {
    reverseBool = function(b)
        if b then return false else return true end
    end
}

filtersEnabled = true
shakeGame = true
shakeHud = true
local shakingIsOn = false --is it gonna rumble your funk?
local rumbleShadersExist = false --do shaders added by RumbleFunk exist?
local minStrength = -30 --basically the offset that the hud get's moved in.
local maxStrength = 30 --basically the offset that the hud get's moved in.

local function setFilters(isOn, dynamic)
    if isOn == true then
        runHaxeCode([[
            var gamefilters = game.camGame.filters;
            var hudfilters = game.camGame.filters;
            var shader = new ShaderFilter(game.getLuaObject('rumbleFunk_shake').shader);

            gamefilters.push(shader);
            hudfilters.push(shader);

        ]])
    else
        runHaxeCode([[
            var gamefilters = game.camGame.filters;
            var hudfilters = game.camGame.filters;
            var shader = new ShaderFilter(game.getLuaObject('rumbleFunk_shake').shader);
            
            gamefilters.pop();
            hudfilters.pop();
        ]])
    end
    rumbleShadersExist = isOn
end

function onCreate()

    initLuaShader('camShake')

    makeLuaSprite('rumbleFunk_shake')
    makeGraphic('rumbleFunk_shake', screenWidth, screenHeight)
    setSpriteShader('rumbleFunk_shake', 'camShake')
end
local iTime = 0
function onUpdate(elapsed)
    if luaSpriteExists('rumbleFunk_shake') and rumbleShadersExist then
        iTime = iTime + elapsed
        setShaderFloat('rumbleFunk_shake', 'iTime', iTime)
    end
end

function onEvent(n, v1, v2)
    if n == 'RumbleFunk' then
        if tonumber(v1) ~= nil then --sets the strength here in value1
            maxStrength = tonumber(v1)
            minStrength = -tonumber(v1)
        end
        shakingIsOn = lua.reverseBool(shakingIsOn) --sets the local variable to "true" or "false", triggering the shaking shit

        if filtersEnabled then
            setFilters(shakingIsOn, songHasShaders) -- if dynamic is false it means there is no shaders applied to the cameras, so we can just apply whatever without trying to add onto shaders there, if dynamic is on, then try to add onto the shaders already applied to the cameras
        end
    end
end

function onStepHit()
    if shakingIsOn then
        runTimer('glitchDaWorld', 0.01, 10) --the timer that actually makes the shaking happen
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'glitchDaWorld' then
        if loopsLeft > 0 then --if the loops left are greater than 0, then it'll keep shaking, once it reaches 0, it'll reset the x and y values of the cameras
            if shakeGame then setProperty('camGame.y', getRandomFloat(minStrength, maxStrength)) end
            if shakeHud then setProperty('camHUD.y', getRandomFloat(minStrength, maxStrength)) end
        elseif loopsLeft == 0 then
            if shakeGame then setProperty('camGame.y', 0) end
            if shakeHud then setProperty('camHUD.y', 0) end
        end
    end
end