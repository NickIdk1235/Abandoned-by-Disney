local fakeHitSection = mustHitSection
local turn = 'boyfriend'
local curSection = 1
function onCreate()

end

function onStepHit()
    if curStep % 16 == 0 then
        curSection = curSection + 1
        callOnLuas('onSectionHit', {curSection})
    end
end

function onSectionHit()
    if fakeHitSection ~= mustHitSection then
        if mustHitSection then
            turn = 'boyfriend'
        elseif not mustHitSection then
            turn = 'dad'
        end
        
        callOnLuas('onTurnSwap')
        fakeHitSection = mustHitSection
    end
end