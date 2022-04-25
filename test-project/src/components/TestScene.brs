sub init()
    m.sgf = m.top.findNode("sgFlex")
    m.sgf.width = 1790
    m.sgf.height = 596
    m.childrenButtons = m.top.findNode("childrenButtons")
    m.directionOptions = m.top.findNode("directionOptions")
    m.justifyContentOptions = m.top.findNode("justifyContentOptions")
    m.alignItemsOptions = m.top.findNode("alignItemsOptions")

    m.directionOptions.observeField("itemSelected", "handleDirectionSelected")
    m.justifyContentOptions.observeField("itemSelected", "handleJustifyContentSelected")
    m.alignItemsOptions.observeField("itemSelected", "handleAlignItemsSelected")

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
    m.initialChildrenButtons = [
        "Add child",
        "Remove child",
        "Child Width: invalid",
        "Child Height: invalid"
    ]

    m.directionValues = ["row", "column"]

    m.justifyContentValues = [
        "flexStart",
        "flexEnd",
        "center",
        "spaceBetween",
        "spaceAround",
        "spaceEvenly"
    ]

    m.alignItemsValues = [
        "flexStart",
        "flexEnd",
        "center"
    ]

    ' Initialize children buttons
    m.childrenButtons.buttons = m.initialChildrenButtons

    ' Initialize values
    m.top.observeField("childWidth", "handleChildWidthChange")
    m.top.observeField("childHeight", "handleChildHeightChange")
    m.top.childWidth = 170
    m.top.childHeight = 170

    ' Initialize direction options
    setupRadioButtonListValues("direction", m.directionOptions, m.directionValues)
    ' Start with "row" selected
    m.directionOptions.checkedItem = 0
    m.directionOptions.jumpToitem = 0

    ' Initialize justifyContent options
    setupRadioButtonListValues("justifyContent", m.justifyContentOptions, m.justifyContentValues)
    ' Start with "spaceBetween" selected
    m.justifyContentOptions.checkedItem = 3
    m.justifyContentOptions.jumpToitem = 3

    ' Initialize alignItems options
    setupRadioButtonListValues("alignItems", m.alignItemsOptions, m.alignItemsValues)
    ' Start with "center" selected
    m.alignItemsOptions.checkedItem = 2
    m.alignItemsOptions.jumpToitem = 2
end sub

sub setupRadioButtonListValues(title as string, node as object, values as object)
    contentNode = CreateObject("roSGNode", "ContentNode")
    contentNode.contentType = "section"
    contentNode.title = title
    for each option in values
        optionNode = contentNode.CreateChild("ContentNode")
        optionNode.title = option
    end for
    node.content = contentNode
end sub

sub handleDirectionSelected()
    ? "new direction selected", m.directionValues[m.directionOptions.itemSelected]
    m.sgf.direction = m.directionValues[m.directionOptions.itemSelected]
end sub

sub handleJustifyContentSelected()
    ? "new justifyContent selected", m.justifyContentValues[m.justifyContentOptions.itemSelected]
    m.sgf.justifyContent = m.justifyContentValues[m.justifyContentOptions.itemSelected]
end sub

sub handleAlignItemsSelected()
    ? "new alignItems selected", m.alignItemsValues[m.alignItemsOptions.itemSelected]
    m.sgf.alignItems = m.alignItemsValues[m.alignItemsOptions.itemSelected]
end sub

sub handleChildWidthChange()
    ? "new childWidth", m.top.childWidth.toStr()
    newButtons = m.childrenButtons.buttons
    newButtons[2] = "Child Width: " + m.top.childWidth.ToStr() + "px"
    m.childrenButtons.buttons = newButtons
end sub

sub handleChildHeightChange()
    ? "new childHeight", m.top.childHeight.toStr()
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
