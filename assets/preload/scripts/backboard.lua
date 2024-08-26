function onCreatePost()

	makeLuaSprite('backboard', 'NotebackboardAbandoned')

	scaleObject("backboard", 1.018, 1.02)
	updateHitbox('backboard')
	screenCenter('backboard')
	setProperty("backboard.y", getPropertyFromGroup('playerStrums', 0, 'y') - 35)
	setProperty("backboard.x", getPropertyFromGroup('playerStrums', 0, 'x') - 735)

	setObjectCamera('backboard', 'camHUD')

	addLuaSprite('backboard')

	close()

end
