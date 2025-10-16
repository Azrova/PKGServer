local modem = peripheral.find("modem")
if not modem or not modem.isWireless() then error("No wireless modem") end
rednet.open(peripheral.getName(modem))

local packages = {}
if fs.exists("/PKGServer/packages") then
    for _, file in ipairs(fs.list("/PKGServer/packages")) do
        if file:match("%.lua$") then
            local name = file:gsub("%.lua$", "")
            local f = fs.open("/PKGServer/packages/"..file, "r")
            local content = f.readAll()
            f.close()
            packages[name] = {["/bin/"..file] = content}
        end
    end
end

while true do
    local senderId, message, protocol = rednet.receive()
    if message then
        if message.type == "PKG_REQUEST" then
            local pkg = message.pkg
            if packages[pkg] then
                rednet.send(senderId, {type="PKG_DATA", files=packages[pkg]})
            else
                rednet.send(senderId, {type="PKG_ERROR", message="Package not found"})
            end
        elseif message.type == "PKG_INFO" then
            local pkg = message.pkg
            if packages[pkg] then
                rednet.send(senderId, {type="PKG_INFO_DATA", meta="Package " .. pkg})
            else
                rednet.send(senderId, {type="PKG_ERROR", message="Package not found"})
            end
        end
    end
end
