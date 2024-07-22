
local port = 100001
local receiver = 100002
local playerPeripheal = peripheral.find("")
local modem = peripheral.find("modem").open(port)


local function detectPlayer(player)
    player["pos"] = playerPeripheal.getPlayerPos(player["name"])
    modem.transmit(receiver,port,player)
end

local function getPlayers()
    local players = playerPeripheal.getOnlinePlayers()
    modem.transmit(receiver, port, players)
end

local function transportPlayer(player,target)
    
end



while true do
    local event, side, channel, replyChannel, message, distance
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == port
    
    if message["command"] == "detectPlayer" then
        detectPlayer(message["player"])
    elseif message["command"] == "getPlayers" then
        players()
    elseif message["command"] == "transportPlayer" then
        local player = detectPlayer(message["player"]) 
        local target = detectPlayer(message["target"])
        transportPlayer(player,target)
    end
    sleep(1)
end
