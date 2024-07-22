local port = 100002
local receiver = 100001
local playerPeripheal = peripheral.find("")
local modem = peripheral.find("modem").open(port)

local function getPlayerModel()
    return {
        name = nil,
        position = {
            x = nil,
            y = nil,
            z = nil
        },
        health = nil
    }
end

local function trackPlayer()
    local player = SelectPlayer(GetPlayers())
    while true do
        player = DetectPlayer(player)
        -- print cords
        sleep(1)
    end
end

function DetectPlayer(player)
    modem.transmit(receiver, port, {
        command = "detectPlayer",
        player = player
    })
    local event, side, channel, replyChannel, message, distance
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 43
    return message
end

function GetPlayers()
    modem.transmit(receiver, port, {
        command = "getPlayers",
    })
    local event, side, channel, replyChannel, message, distance
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 43
end

function SelectPlayer(players)
    for k, v in pairs(players) do
        print(k .. ": " .. v)
    end
    write("Please select Player>")
    local player = read()
    player = getPlayerModel()
    player["name"] = players[player]
    return player
end


local function transportPlayer(player, target)
    modem.transmit(receiver, port, {
        command = "transportPlayer",
        player = player,
        target = target
    })
end
    
write("<<Remote Drone Controll>>")
write("Available Commands: 0:TrackPlayer | 1:TransportPlayer")
write("Command>")
local command = read()

if command == "trackPlayer" or command == "0"  then
    write("<< Player Tracker >>")
    
    trackPlayer()
elseif command == "transportPlayer" or command == "1"   then
    write("<< Player Transporter Started >>")
    write("< Please Select Player To Transport >")
    local players = GetPlayers()
    local player = SelectPlayer(players)
    write("< Please Select Target >")
    local target SelectPlayer(players)
    transportPlayer(player,target)
    write("< Transport Dispatched, please stand still>")
end
