local dead = false
local function shaderCoordFix(onFunction)
    if not dead then
        if onFunction == 'create' then
            runHaxeCode([[
                resetCamCache = function(?spr) {
                    if (spr == null || spr._filters == null) return;
                    spr.__cacheBitmap = null;
                    spr.__cacheBitmapData = null;
                }
                
                fixShaderCoordFix = function(?_) {
                    resetCamCache(game.camGame.flashSprite);
                    resetCamCache(game.camHUD.flashSprite);
                    resetCamCache(game.camOther.flashSprite);
                }
            
                FlxG.signals.gameResized.add(fixShaderCoordFix);
                fixShaderCoordFix();
            ]])
        elseif onFunction == 'destroy' then
            runHaxeCode([[
                FlxG.signals.gameResized.remove(fixShaderCoordFix);
            ]])
        end
    end
end


function onCreate()
    if not dead then
        shaderCoordFix('create')
    end
end

function onDestroy()
    if not dead then
        shaderCoordFix('destroy')
    end
end

function onGameOver()
    dead = true
    return Function_Continue
end