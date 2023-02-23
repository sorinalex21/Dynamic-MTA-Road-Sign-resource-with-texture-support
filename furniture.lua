local mysql = exports.mysql


function saveFurniture(p, c, model, interior, world, x, y, z, rx, ry, rz)
    mysql:query("INSERT INTO `furniture` (`model`, `interior`, `world`, `x`, `y`, `z`, `rx`, `ry`, `rz`) VALUES ("..world..",".. interior ..", ".. world ..", ".. x ..", ".. y ..", ".. z ..", "..rx..", "..ry..", "..rz..")")
end
addCommandHandler("bagafafurniture", saveFurniture)

furnitureDB = {}

addEventHandler('onResourceStart', resourceRoot, function()

    local result = mysql:query("SELECT * FROM `furniture`")
    if (result) then
        while true do
            local row = mysql:fetch_assoc(result)
            if not row then break end
            local tzt = createFurniture(tonumber(row["id"]), tonumber(row["model"]), tonumber(row["interior"]), tonumber(row["world"]), tonumber(row["x"]), tonumber(row["y"]), tonumber(row["z"]))
            table.insert(furnitureDB, tzt)
        end
    end
    iprint(furnitureDB)
end)

function createFurniture(id, model, interior, world, x, y, z, rx, ry, rz)
    local obj = createObject(model, x, y, z)
    local int = setElementInterior(obj, interior)
    local dim = setElementDimension(obj, world)
	
	table.insert(signsdb, {obj, int, dim})
end