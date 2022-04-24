sub init()
    m.sgf = m.top.findNode("sgFlex")
    m.childrenButtons = m.top.findNode("childrenButtons")
    m.directionOptions = m.top.findNode("directionOptions")
    m.justifyContentOptions = m.top.findNode("justifyContentOptions")
    m.alignItemsOptions = m.top.findNode("alignItemsOptions")

    ' This array represents which column is focused. The index
    ' will be changed by onKeyEvent() when the user presses left or right.
    m.optionColumns = [
        m.childrenButtons,
        m.directionOptions,
        m.justifyContentOptions,
        m.alignItemsOptions
    ]
    m.top.observeField("currentOptionColumnIndex", "handleCurrentOptionColumnIndexChange")
    m.top.currentOptionColumnIndex = 0

    ' Initial values
    initialChildrenButtons = [
        "Add child",
        "Remove child",
        "Child Width: invalid",
        "Child Height: invalid"
    ]

    directionOptions = ["row", "column"]

    justifyContentValues = [
        "flexStart",
        "flexEnd",
        "center",
        "spaceBetween",
        "spaceAround",
        "spaceEvenly"
    ]

    alignItemsValues = [
        "flexStart",
        "flexEnd",
        "center"
    ]

    ' Initialize children buttons
    m.childrenButtons.buttons = initialChildrenButtons

    ' Initialize values
    m.top.observeField("childWidth", "handleChildWidthChange")
    m.top.observeField("childHeight", "handleChildHeightChange")
    m.top.childWidth = 170
    m.top.childHeight = 170

    ' Initialize direction options
    setupCheckListValues("direction",m.directionOptions, directionOptions)

    ' Initialize justifyContent options
    setupCheckListValues("justifyContent", m.justifyContentOptions, justifyContentValues)

    ' Initialize alignItems options
    setupCheckListValues("alignItems", m.alignItemsOptions, alignItemsValues)

    m.sgf.callFunc("flexify")
end sub

sub setupCheckListValues(title as string, node as object, values as object)
    contentNode = CreateObject("roSGNode", "ContentNode")
    contentNode.contentType = "section"
    contentNode.title = title
    for each option in values
        optionNode = contentNode.CreateChild("ContentNode")
        optionNode.title = option
    end for
    node.content = contentNode
end sub

sub handleChildWidthChange()
    newButtons = m.childrenButtons.buttons
    newButtons[2] = "Child Width: " + m.top.childWidth.ToStr() + "px"
    m.childrenButtons.buttons = newButtons
end sub

sub handleChildHeightChange()
    newButtons = m.childrenButtons.buttons
    newButtons[3] = "Child Height: " + m.top.childHeight.ToStr() + "px"
    m.childrenButtons.buttons = newButtons
end sub

sub handleCurrentOptionColumnIndexChange()
    m.optionColumns[m.top.currentOptionColumnIndex].setFocus(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if (press)
        if (key = "left")
            newIndex = m.top.currentOptionColumnIndex - 1
            if (newIndex < 0)
                newIndex = m.optionColumns.count() - 1
            end if
            m.top.currentOptionColumnIndex = newIndex
            return true
        else if (key = "right")
            newIndex = m.top.currentOptionColumnIndex + 1
            if (newIndex >= m.optionColumns.count())
                newIndex = 0
            end if
            m.top.currentOptionColumnIndex = newIndex
            return true
        end if
    end if

    return false
end function
