local lua = {
    getSectionDur = function() --returns duration between section hits
        return getPropertyFromClass('Conductor', 'crochet')
    end,

    getBeatDur = function() --returns duration between beat hits
        return (getPropertyFromClass('Conductor', 'crochet') / 1000)
    end,

    getStepDur = function() --returns duration betweem step hits
        return (getPropertyFromClass('Conductor', 'stepCrochet') / 1000)
    end,

    split = function(string, seperator)
        local index = 0
        for word in string.gmatch(string, '([^'..seperator..']+)') do --Difficult yet neccessary motherfucker.
            index = index + 1
            return {word, index} --returns an array, [1] = word found, and [2] = index or current number
        end
    end,

    splitValue = function(string, seperator, toReturn) --string is the entire string you give it, seperator is the "speration" or what to split it from, and toReturn is the place of the word to return EX: "a,b,c", if toReturn is 2 then it'll return "b", or if it's 3 it'll return "c". EX OF IT BEING USED: strTools.splitValue("A,B,C,D,F", ",", 4) --returns "D"
		if seperator == nil or seperator == '' then
			seperator = '-_,.'
		end
        local index = 0
        for word in string.gmatch(tostring(string), '([^'..seperator..']+)') do --Difficult yet neccessary motherfucker.
            index = index + 1

            if index == toReturn then
                index = 0
				if word == '' or word == nil then
					if luaDebugMode then
                        print('NO WORD FOUND IN SPLITVALUE FUNCTION!!!')
                        print('arguments are: string = '..tostring(string).. ' | seperator = '..tostring(seperator)..' | toReturn = '..tostring(toReturn))

                        debugPrint('NO WORD FOUND IN SPLITVALUE FUNCTION!!!')
                        debugPrint('arguments are: string = '..tostring(string).. ' | seperator = '..tostring(seperator)..' | toReturn = '..tostring(toReturn))
                    end
                    
                    return nil
				else
					return word
				end
			end
        end
    end,
    findInString = function(str, target) --str = the string you give it, the target is what you are looking for in the string ex:
        if string.match(str, target) then
            return true
        else
            return false
        end
    end
}

local daStep = 0
function onEvent(n,v1,v2)
    if n == 'AlphaTween' then
        daStep = curStep

        local target = tostring(v1)
        local alpha = '1'
        local time = '0.5' --we start this variable off as a string so that way if the event has something like [1,beatDur] we can read it as "beatDur" and use the funtion lua.getBeatDur() 
        local value2 = tostring(v2)
        local daAmountOfCommas = #lua.split(value2, ',')

        if luaDebugMode then debugPrint('commas = '..tostring(daAmountOfCommas)) end

        if lua.findInString(value2, ',') then
            if (daAmountOfCommas) == 2 then
                local firstArg = lua.splitValue(value2, ',', 1)
                local secondArg = lua.splitValue(value2, ',', 2)
                
                if firstArg ~= nil then
                    alpha = firstArg
                end
                
                if secondArg ~= nil then
                    time = secondArg
                end
            end
        end

        if string.lower(time) == 'beatdur' then
            time = lua.getBeatDur()
        elseif string.lower(time) == 'stepdur' then
            time = lua.getStepDur()
        elseif (string.lower(time) == 'sectiondur') or (string.lower(time) == 'secdur') then
            time = lua.getSectionDur()
        end

        if luaDebugMode then
            debugPrint('alpha = '..tostring(alpha))
            debugPrint('time = '..tostring(time))
        end

        if daStep == curStep then
            doTweenAlpha(target, target, tonumber(alpha), tonumber(time), 'linear')
        end
    end
end