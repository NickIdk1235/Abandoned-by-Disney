local prop = ''
local value = ''
local strTools = { -- group for string related functions
	splitValue = function(string, seperator, toReturn) -- string is the entire string you give it, seperator is the "speration" or what to split it from, and toReturn is the place of the word to return EX: "a,b,c", if toReturn is 2 then it'll return "b", or if it's 3 it'll return "c". EX OF IT BEING USED: strTools.splitValue("A,B,C,D,F", ",", 4) --returns "D"
		if seperator == nil or seperator == '' then
			seperator = '-_,.'
		end
		local index = 0
		for word in string.gmatch(tostring(string), '([^' .. seperator .. ']+)') do -- Difficult yet neccessary motherfucker.
			index = index + 1

			if index == toReturn then
				index = 0
				if word == '' or word == nil then
					return false
				else
					return word
				end
			end
		end
	end,
	findInString = function(str, target) -- str = the string you give it, the target is what you are looking for in the string ex:
		if string.match(str, target) then
			return true
		else
			return false
		end
	end,
	findMultipleInString = function(str, maxNum, targets)
		local foundMatch = false
		if foundMatch == false then
			for i = 1, maxNum do
				--print("str = " .. str)
				--print("i = " .. tostring(i) .. " | target = " .. tostring(targets[i]))
				if string.match(str, targets[i]) then
					--print("found a match!")
					foundMatch = true
					return true
				else
					--print("found no matches")
					foundMatch = false
					if i == maxNum then
						return false
					end
				end

				if foundMatch then
					break
				end
			end
		end
	end
}
local lua = {
	tobool = function(s)
		if strTools.findMultipleInString(s, 4, {"f", "false", "t", "true"}) then
			if s == 't' or s == 'true' then
				return true
			elseif s == 'f' or s == 'false' then
				return false
			end
		else
			--print('NOT INTENED TO BE A BOOLEAN')
			return s
		end
	end,
	luatostring = function(str)
		if str ~= nil then
			return tostring(str)
		else
			return nil
		end
	end
}
-- function setProperty(prop, value)
-- does yo momma
-- end
function onEvent(n, v1, v2)

	prop = tostring(v1)
	value = lua.tobool(lua.luatostring(v2))

	--[[if prop == 'cam_bop' then --removed cam_bop value and replaced it with camZoomingMult from psych engine 0.7.3, since i couldn't replace all the events with this variable, i'll make it so that the appoint event does it automatically.
        prop = 'camZoomingMult'
        if value == false then
            value = 0
        elseif value == true then
            value = 1
        end
    end]]

	if n == 'Appoint' then
		setProperty(prop, value)
		--print("prop = " .. prop)
		--print("value = " .. tostring(value))
	end
end
-- onEvent("Appoint", "camGame.visible", "t")
