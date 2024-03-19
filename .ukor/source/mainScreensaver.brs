sub RunScreensaver()
    showScreensaver()
end sub

sub showScreensaver()
    screen = CreateObject("roSGScreen")
    port = CreateObject("roMessagePort")
    cecstatus = CreateObject("roCECStatus")

    scene = screen.CreateScene("Screensaver")
    cecstatus.SetMessagePort(port)
    screen.setMessagePort(port)
    screen.show()

    while(true)
        msg = wait(0, port)
        msgType = type(msg)

        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

