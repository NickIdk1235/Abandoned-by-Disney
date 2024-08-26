function onEvent(n, v1, v2)
	if n == 'Set CharBop Speed' then
		local char = str.lower(v1)

		if char == nil or char == 'bf' or char == 'boyfriend' or char == '0' then
			char = 'boyfriend'
		elseif char == 'gf' or char == 'girlfriend' or char == '2' then
			char = 'gf'
		elseif char == 'dad' or char == '1' then
			char = 'dad'
		end

		local bopSpeed = tonumber(v2)

		if bopSpeed == nil then
			bopSpeed = 2
		else
			bopSpeed = bopSpeed
		end
		setProperty(char .. '.danceEveryNumBeats', bopSpeed)
	end
end
