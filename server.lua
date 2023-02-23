--[[local signs = {
{-1937.84766, 102.05974, 25.27344, "spd30.png", 0, 0, 0},
{-1940.78979, 99.35397, 25.27344, "DoNotEnterSign.png", 0, 0, 0},
{-1938.42102, 95.48917, 25.27344, "restricted.png", 0, 0, 0},
{-1940.89233, 92.77975, 25.27344, "respark.png", 0, 0, 0},
{-1938.59143, 90.04494, 25.27344, "spd60.png", 0, 0, 0},
{-1940.59082, 87.81111, 25.27344, "radar.png", 0, 0, 0},
{-1938.93152, 84.88006, 25.27344, "stoppol.png", 0, 0, 0},
{-1940.72656, 82.96767, 25.27344, "stop.png", 0, 0, 0}
}]]

local signs = {
--x, y, z, tex, rx, ry, rz
}

local signsdb = {}

--------------------------COMMANDS COMMANDS COMMANDS COMMANDS COMMANDS COMMANDS COMMANDS COMMANDS COMMANDS COMMANDS COMMANDS COMMANDS 

addCommandHandler('rshelp', function(player, _)

	outputChatBox("/createSign [textura cu .png la sfarsit(literele trebuie sa fie exacte)]", player, 255, 255, 255)
	outputChatBox("/deletesign [id]", player, 255, 255, 255)
	outputChatBox("/signsid arata detalii despre semne.", player, 255, 255, 255)
	outputChatBox("/editsignpos [id] [x] [y] [z]", player, 255, 255, 255)
	outputChatBox("/editsignrot [id] [rx] [ry] [rz]", player, 255, 255, 255)
	

end)

addCommandHandler('createsign', function(player, _, obj)
	local obj = tostring(obj)
	if obj then
		local pos = player:getPosition()
		local rot = player:getRotation()
		local rot = Vector3(rot.x, rot.y, rot.z - 180)
		local id = #signs+1
		signs[id] = {pos.x, pos.y, pos.z-1, obj, rot.x, rot.y, rot.z}
		createSign(id)
	else outputChatBox('ERROR: Syntax: [/addsign] (texture name)', player, 255, 255, 255)
	return false
	end
end)

addCommandHandler('deletesign', function(player, _, id)

	local id = tonumber(id)
	
	local count = table.maxn(signs)
	if id and id <= count then
		table.remove(signs, id)
		destroyElement(signsdb[id].obj)
		table.remove(signsdb, tex)
		table.remove(signsdb, id)
		triggerClientEvent ("removeText", player )
	else outputChatBox('ERROR: Syntax: [/deletesign] (sign id)', player, 255, 255, 255)
	return false
	end
end)

addCommandHandler('signsid', function(player)

	local showdata = player:getData( "signsid.show" )
	outputChatBox(tostring(showdata))
	
	if (showdata == false ) then
		player:setData( "signsid.show", true )
			for i, v in pairs(signsdb) do
				local x, y, z = getElementPosition(v.obj)
				local rx, ry, rz = getElementRotation(v.obj)
				triggerClientEvent ("drawIds", player, tostring(v.id).."\n"..tostring(x).."  "..tostring(y).."  "..tostring(z).."\n"..tostring(rx).."  "..tostring(ry).."  "..tostring(rz).."\n"..tostring(v.tex), x, y, z+1 )
			end
	
	elseif (showdata == true) then
		triggerClientEvent ("removeText", player )
		player:setData("signsid.show", false)
	end
end)

addCommandHandler('editsignpos', function(player, _, id, posx, posy, posz)

	id = tonumber(id)
	posx = tonumber(posx)
	posy = tonumber(posy)
	posz = tonumber(posz)
	local count = table.maxn(signs)
	if id and id <= count and posx and posy and posz then
		--setElementPosition(signsdb[id].obj, posx, posy, posz)
		signsdb[id].obj:setPosition(posx, posy, posz)
		signs[id][1] = posx
		signs[id][2] = posy
		signs[id][3] = posz
		triggerClientEvent ("removeText", player )
	else outputChatBox('ERROR: Syntax: [/editsignpos] (id) (X) (Y) (Z)', player, 255, 255, 255)
	return false
	end

end)

addCommandHandler('editsignrot', function(player, _, id, rotx, roty, rotz)

	id = tonumber(id)
	rotx = tonumber(rotx)
	roty = tonumber(roty)
	rotz = tonumber(rotz)
	local count = table.maxn(signs)
	if id and id <= count and rotx and roty and rotz then
		--setElementRotation(signsdb[id].obj, rotx, roty, rotz)
		signsdb[id].obj:setRotation(rotx, roty, rotz)
		signs[id][5] = rotx
		signs[id][6] = roty
		signs[id][7] = rotz
		triggerClientEvent ("removeText", player )
	else outputChatBox('ERROR: Syntax: [/editsignrot] (id) (RX) (RY) (RZ)', player, 255, 255, 255)
		return false
	end

end)

--[[ WIP
addCommandHandler('editsign', function(player, cmd, status, id, arg1, arg2, arg3)

	id = tonumber(id)
	status = tostring(status)
	arg1 = tonumber(arg1)
	arg2 = tonumber(arg2)
	arg3 = tonumber(arg3)
	local count = table.maxn(signs)
	
	if status == 'pos' then
	
			if id and id <= count and arg1 and arg2 and arg3 then
			--setElementPosition(signsdb[id].obj, posx, posy, posz)
			signsdb[id].obj:setPosition(arg1, arg2, arg3)
			signs[id][1] = arg1
			signs[id][2] = arg2
			signs[id][3] = arg3
			triggerClientEvent ("removeText", player )
			else outputChatBox('ERROR: Syntax: [/editsignpos] (id) (X) (Y) (Z)', player, 255, 255, 255)
			return false
			end
		
	
	elseif status == 'rot' then
	
		if id and id <= count and arg1 and arg2 and arg3 then
		--setElementRotation(signsdb[id].obj, rotx, roty, rotz)
		signsdb[id].obj:setRotation(arg1, arg2, arg3)
		signs[id][5] = arg1
		signs[id][6] = arg2
		signs[id][7] = arg3
		triggerClientEvent ("removeText", player )
		else outputChatBox('ERROR: Syntax: [/editsignrot] (id) (RX) (RY) (RZ)', player, 255, 255, 255)
		return false
		end
		
	elseif status == 'create' then
		id = tostring(id)
		if id then
			local pos = player:getPosition()
		local rot = player:getRotation()
		local rot = Vector3(rot.x, rot.y, rot.z - 180)
		local id = #signs+1
		signs[id] = {pos.x, pos.y, pos.z-1, obj, rot.x, rot.y, rot.z}
		createSign(id)
		else outputChatBox('ERROR: Syntax: [/addsign] (texture name)', player, 255, 255, 255)
		return false
		end
	
	else outputChatBox("SYNTAX: [/editsign] [pos/rot] [id] [arguments (x y z)]")
		return false
	end

end)]]

----------------------FUNCTIONS AND EVENTS FUNCTIONS AND EVENTS FUNCTIONS AND EVENTS FUNCTIONS AND EVENTS FUNCTIONS AND EVENTS 

addEventHandler('onResourceStop', resourceRoot, function()
    local f = fileCreate('signs.json')
    f:write(toJSON(signs))
    f:close()
end)

addEventHandler('onResourceStart', resourceRoot, function()
    local f = fileOpen('signs.json')
    if f then
        signs = fromJSON(f:read(f.size))
        f:close()
    end

    for i=1, #signs do
        createSign(i)
    end
	
end)

function createSign(id)
    assert(type(id) == 'number', 'Script failure line:7, id is not a number')
    local self = {}
    self.obj = Object(3262, signs[id][1], signs[id][2], signs[id][3], signs[id][5], signs[id][6], signs[id][7])
    self.id = id
	self.tex = signs[id][4]
    
    table.insert(signsdb, self)
    return self
end

function streamTex(player)
	for i, v in pairs(signsdb) do
		triggerClientEvent ("createTexture", player, v.obj, v.tex )
	end
end
addEvent( "streamTex", true )
addEventHandler( "streamTex", resourceRoot, streamTex )