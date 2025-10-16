local modem = peripheral.find("modem")
if not modem or not modem.isWireless() then error("No wireless modem") end
rednet.open(peripheral.getName(modem))

local packages = {}

local function loadPackages()
    if not fs.exists("/PKGServer/packages") then return end
    for _, pkgName in ipairs(fs.list("/PKGServer/packages")) do
        local pkgPath = "/PKGServer/packages/" .. pkgName
        if fs.isDir(pkgPath) then
            packages[pkgName] = {}
            if fs.exists(pkgPath.."/files") then
                for _, file in ipairs(fs.list(pkgPath.."/files")) do
                    local f = fs.open(pkgPath.."/files/"..file,"r")
                    local content = f.readAll()
                    f.close()
                    packages[pkgName]["/bin/"..file] = content
                end
            end
            if fs.exists(pkgPath.."/configs") then
                for _, file in ipairs(fs.list(pkgPath.."/configs")) do
                    local f = fs.open(pkgPath.."/configs/"..file,"r")
                    local content = f.readAll()
                    f.close()
                    packages[pkgName]["/etc/"..pkgName.."/"..file] = content
                end
            end
        end
    end
end

loadPackages()

while true do
    local senderId, message, protocol = rednet.receive()
    if message then
        local pkg = message.pkg
        if message.type == "PKG_REQUEST" then
            if packages[pkg] then
                rednet.send(senderId, {type="PKG_DATA", files=packages[pkg]})
            else
                rednet.send(senderId, {type="PKG_ERROR", message="Package not found"})
            end
        elseif message.type == "PKG_INFO" then
            if packages[pkg] then
                local meta = {}
                for path,_ in pairs(packages[pkg]) do table.insert(meta, path) end
                rednet.send(senderId, {type="PKG_INFO_DATA", meta=table.concat(meta,", ")})
            else
                rednet.send(senderId, {type="PKG_ERROR", message="Package not found"})
            end
        end
    end
end
