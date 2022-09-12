sub Main()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    
    rootScene = screen.CreateScene("TestScene")
    rootScene.id = "ROOT"
    
    screen.show()

    ' vscode_rdb_on_device_component_entry
    
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
      
        if (msgType = "roSGScreenEvent")
            if (msg.isScreenClosed())
                return
            end if
        end if
    end while
end sub
