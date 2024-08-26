local cam = {
	x = 641,
	y = 423
}

local curX = cam.x
local curY = cam.y
local ofsX, ofsY = 30, 30
function onUpdate(elapsed)
	setProperty('camFollow.x', curX)
	setProperty('camFollow.y', curY)
end

function goodNoteHit(id, dir, nt, sus)
	if mustHitSection then
		if dir == 0 then
			curX = cam.x - ofsX
			curY = cam.y
		elseif dir == 1 then
			curX = cam.x
			curY = cam.y + ofsY
		elseif dir == 2 then
			curX = cam.x
			curY = cam.y - ofsY
		elseif dir == 3 then
			curX = cam.x + ofsX
			curY = cam.y
		end
	end
end

function opponentNoteHit(id, dir, nt, sus)
	if not mustHitSection then
		if dir == 0 then
			curX = cam.x - ofsX
			curY = cam.y
		elseif dir == 1 then
			curX = cam.x
			curY = cam.y + ofsY
		elseif dir == 2 then
			curX = cam.x
			curY = cam.y - ofsY
		elseif dir == 3 then
			curX = cam.x + ofsX
			curY = cam.y
		end
	end
end
