addEventHandler('onClientResourceStart', resourceRoot,
    function()
 
        local txd = engineLoadTXD('sign.txd',true)
        engineImportTXD(txd, 3262)
 
        local dff = engineLoadDFF('sign.dff', 0)
        engineReplaceModel(dff, 3262)
 
        local col = engineLoadCOL('sign.col')
        engineReplaceCOL(col, 3262)
        engineSetModelLODDistance(3262, 500)
	
	end
)

function createTexture(sign, texture)

	if not texture then return false end

	local shader = dxCreateShader( "texRep.fx" ) 
	local normal = dxCreateTexture("tex/"..texture) 
	dxSetShaderValue(shader,"gTexture",normal) 
	engineApplyShaderToWorldTexture(shader, "DoNotEnterSign", sign)

end
addEvent( "createTexture", true )
addEventHandler( "createTexture", localPlayer, createTexture )

local signsdb = {}

function createSign(id, texture, posx, posy, posz)
	assert(type(id) == 'number', 'Script failure line:7, id is not a number')
	
	local self = {}

	self.shader = dxCreateShader( "texRep.fx" ) 
	local normal = dxCreateTexture("tex/"..texture) 
	dxSetShaderValue(self.shader,"gTexture",normal) 
	self.obj = createObject ( 3262, posx, posy, posz, 0, 0, 0 )
	local swt = engineApplyShaderToWorldTexture(self.shader, "DoNotEnterSign", self.obj)
	self.id = id
	
	table.insert(signsdb, self)
	return self	
end
addEvent( "createSign", true )
addEventHandler( "createSign", localPlayer, createSign )

function deleteSign(id)
	id = tonumber(id)
	if id then
		engineRemoveShaderFromWorldTexture ( signsdb[id].shader, "DoNotEnterSign", signsdb[id].obj )
		destroyElement(signsdb[id].obj)
		table.remove(signsdb, id)
	end
end
addEvent( "delSign", true )
addEventHandler( "delSign", localPlayer, deleteSign )

addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ()
        if getElementType ( source ) == "object" and getElementModel ( source ) == 3262 then
            triggerServerEvent ( "streamTex", resourceRoot, localPlayer )
        end
    end
);


function drawIds(text, x, y, z)
	dxDraw3DText( text, x, y, z, 1, "pricedown", 255, 255, 255, 25 )
end
addEvent("drawIds", true)
addEventHandler("drawIds", localPlayer, drawIds)

-------------------------------------------------------------------------


-- making a table with allowed fonts' names
local fonts = { [ "default" ] = true, [ "default-bold" ] = true,[ "clear" ] = true,[ "arial" ] = true,[ "sans" ] = true,
	  [ "pricedown" ] = true, [ "bankgothic" ] = true,[ "diploma" ] = true,[ "beckett" ] = true
};

function dxDraw3DText( text, x, y, z, scale, font, r, g, b, maxDistance )
	-- checking required arguments
	assert( type( text ) == "string", "Bad argument @ dxDraw3DText" );
	assert( type( x ) == "number", "Bad argument @ dxDraw3DText" );
	assert( type( y ) == "number", "Bad argument @ dxDraw3DText" );
	assert( type( z ) == "number", "Bad argument @ dxDraw3DText" );
	-- checking optional arguments
	if not scale or type( scale ) ~= "number" or scale <= 0 then
		scale = 2
	end
	if not font or type( font ) ~= "string" or not fonts[ font ] then
		font = "default"
	end
	if not r or type( r ) ~= "number" or r < 0 or r > 255 then
		r = 255
	end
	if not g or type( g ) ~= "number" or g < 0 or g > 255 then
		g = 255
	end
	if not b or type( b ) ~= "number" or b < 0 or b > 255 then
		b = 255
	end
	if not maxDistance or type( maxDistance ) ~= "number" or maxDistance <= 1 then
		maxDistance = 12
	end
	local textElement = createElement( "text" );
	-- checking if the element was created
	if textElement then 
		-- setting the element datas
		setElementData( textElement, "text", text );
		setElementData( textElement, "x", x );
		setElementData( textElement, "y", y );
		setElementData( textElement, "z", z );
		setElementData( textElement, "scale", scale );
		setElementData( textElement, "font", font );
		setElementData( textElement, "rgba", { r, g, b, 255 } );
		setElementData( textElement, "maxDistance", maxDistance );
		-- returning the text element
		return textElement
	end
	-- returning false in case of errors
	return false
end

function removeText()
	local texts = getElementsByType( "text" )
	if #texts > 0 then
		for i = 1, #texts do
		destroyElement ( texts[i] )
		end
	else return false
	end
end
addEvent("removeText", true)
addEventHandler("removeText", localPlayer, removeText)

addEventHandler( "onClientRender", root,
	function( )
		local texts = getElementsByType( "text" );
		if #texts > 0 then
			local pX, pY, pZ = getElementPosition( localPlayer );
			for i = 1, #texts do
				local text = getElementData( texts[i], "text" );
				local tX, tY, tZ = getElementData( texts[i], "x" ), getElementData( texts[i], "y" ), getElementData( texts[i], "z" );
				local font = getElementData( texts[i], "font" );
				local scale = getElementData( texts[i], "scale" );
				local color = getElementData( texts[i], "rgba" );
				local maxDistance = getElementData( texts[i], "maxDistance" );
				if not text or not tX or not tY or not tZ then
					return
				end
				if not font then font = "default" end
				if not scale then scale = 2 end
				if not color or type( color ) ~= "table" then
					color = { 255, 255, 255, 255 };
				end
				if not maxDistance then maxDistance = 12 end
				local distance = getDistanceBetweenPoints3D( pX, pY, pZ, tX, tY, tZ );
				if distance <= maxDistance then
					local x, y = getScreenFromWorldPosition( tX, tY, tZ );
					if x and y then
						dxDrawText( text, x, y, _, _, tocolor( color[1], color[2], color[3], color[4] ), scale, font, "center", "center" );
					end
				end
			end
		end
	end
);