sub Main()
    'this will be where you setup your typical roku app
    'it will not be launched when running unit tests
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    
    rootScene = screen.CreateScene("TestScene")
    rootScene.id = "ROOT"
    
    screen.show()
    
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
      
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() 
                return
            end if
        end if
    end while
end sub
