local port = 10002
local receiver = 10001
local modem = peripheral.find("modem")
modem.open(port)

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
        write("x:"..player["pos"]["x"].." y:"..player["pos"]["y"].." z:"..player["pos"]["z"].."\n")
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
    until channel == port
    return message
end

function GetPlayers()
    modem.transmit(receiver, port, {
        command = "getPlayers",
    })
    local event, side, channel, replyChannel, message, distance
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == port
    return message
end

function SelectPlayer(players)
    for k, v in pairs(players) do
        print(k .. ": " .. v)
    end
    write("\nPlease select Player>")
    local io = read()
    local player = getPlayerModel()
    player["name"] = players[tonumber(io)]
    return player
end


local function transportPlayer(player, target)
    modem.transmit(receiver, port, {
        command = "transportPlayer",
        player = player,
        target = target
    })
end
    
write("Remote Drone Controll>>")
write("Available Commands:\n0:TrackPlayer | 1:TransportPlayer \n")
write("Command>\n")
local command = read()

if command == "trackPlayer" or command == "0"  then
    write("Player Tracker>>\n")
    trackPlayer()
elseif command == "transportPlayer" or command == "1"   then
    write("Player Transporter Started>>")
    write("< Please Select Player To Transport >")
    local players = GetPlayers()
    local player = SelectPlayer(players)
    write("< Please Select Target >")
    local target SelectPlayer(players)
    transportPlayer(player,target)
    write("< Transport Dispatched, please stand still>")
end
