sub init()
    ? "init"
    m.sgf = m.top.findNode("sgFlex")
    m.top.observeField("visible", "handleVisibleChange")
    m.sgf.callFunc("flexify")
end sub
