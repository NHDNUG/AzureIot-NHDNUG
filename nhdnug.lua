function getConn( )
    local conn = net.createConnection(net.TCP, 1)
    print("Getting conn")
    eventHub.Connected = true
    conn:on("receive", function(sck, c)
        print("Response from Event Hub:")
        print(c)
        sck:close()
    end)
    conn:on("sent", function(sck) print ("Srv req sent") end)
    conn:on("connection", function (sck,c)       
        sck:send("POST /nhdnug/publishers/" .. node.chipid() .. "/messages" .. eventHub.Headers .. eventHub.Body)
    end)
    conn:on("disconnection", function(sck) eventHub.Connected = false end)       
    return conn
end

eventHub = {}
file.open("token.lua", "r")
eventHub.Token = file.readline()
file.close()
eventHub.IP = "40.84.185.67"
eventHub.Port = "443"


eventHub.Connected = false


tmr.alarm(0, 2000, tmr.ALARM_AUTO, function()
    ldr_value = adc.read(0)
    print(string.format("Current LDR value: %d", ldr_value))
	if node.heap() < 10000 then
		collectgarbage("collect")
    end
    if eventHub.Connected == false then
        eventHub.Connection = getConn()
        eventHub.Body = "{'LDR': '" .. ldr_value .. "'}"
        eventHub.ContentLength = string.len(eventHub.Body)
        eventHub.Headers = " HTTP/1.1\r\nHost: nhdnugiot.servicebus.windows.net\r\nConnection: Keep-Alive\r\n"
        eventHub.Headers = eventHub.Headers .. "Content-Type: application/json; charset=utf-8\r\n"
        eventHub.Headers = eventHub.Headers .. "Content-Length: " .. eventHub.ContentLength .. "\r\n"
        eventHub.Headers = eventHub.Headers .. "Authorization: " .. eventHub.Token .. "\r\n"
        eventHub.Headers = eventHub.Headers .. "Accept: */*\r\n\r\n"
        eventHub.Connection:connect(eventHub.Port, eventHub.IP)
    end

end)