--[[
function onCreatePost()
	makeLuaSprite("Distorted TV")
	makeGraphic("shaderImage", screenWidth, screenHeight)

	removeLuaSprite('static')
   setSpriteShader("shaderImage", "Distorted TV")
	--initLuaShader('tvshader')]]--
 --   runHaxeCode([[

 --       game.initLuaShader('Distorted TV');

 --       var shader0 = game.createRuntimeShader('Distorted TV');
 --       game.camGame.setFilters([new ShaderFilter(shader0)]);
 --       game.getLuaObject('Distorted TV').shader = shader0;
 --       game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('Distorted TV').shader)]);
 --       return;
 --   ]]);
 --  end
--[[
function onUpdate(elapsed)
	setShaderFloat("Distorted TV", "iTime", os.clock())
 end
]]--