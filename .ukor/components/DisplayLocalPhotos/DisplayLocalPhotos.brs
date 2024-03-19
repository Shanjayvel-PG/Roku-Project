sub init()
    m.photoGrid = m.top.findNode("photoGrid")
    m.photoGrid.observeField("itemSelected", "onItemSelected")
    m.btnSave = m.top.findNode("btnSave")
    m.top.observeField("focusedChild", "onFocusedChild")
    m.btnText = m.top.findNode("btnText")
end sub

sub build(params as object)
    initSettingsPage()
    photoList = params
    parentNode = buildContentNode(photoList)
    m.photoGrid.content = parentNode
    m.photoGrid.setFocus(true)
end sub

sub initSettingsPage()
    m.photoGrid.numColumns = 3
    m.photoGrid.numRows = 2
    m.photoGrid.itemSize = [480, 400]
    m.photoGrid.itemSpacing = [48, 48]
    m.photoGrid.itemComponentName = "PhotoItemLayout"
    m.photoGrid.vertFocusAnimationStyle = "floatingFocus"
    m.photoGrid.drawFocusFeedback = true
end sub

function buildContentNode(settingList as object)
    parentNode = CreateObject("roSGNode", "ContentNode")
    for each item in settingList
        rowNode = parentNode.CreateChild("GridItemData")
        rowNode.title = item.title
        rowNode.id = item.id
        rowNode.uri = item.uri
        parentNode.appendChild(rowNode)
    end for
    return parentNode
end function

sub onItemSelected(event as object)
    selectedNode = event.getRoSGnode()
    selectedIndex = event.getData()
    selectedItem = selectedNode.content.getChild(selectedIndex)
    state = selectedItem.selected
    selectedItem.selected = not state
end sub

sub saveLocalPhotos()
    savedPhotosList = []
    childCount = m.photoGrid.content.getChildCount()
    for i = 0 to (childCount - 1)
        innerContent = m.photoGrid.content.getChild(i)
        if innerContent.selected = true
            savedPhotosList.push({
                uri: innerContent.uri,
            })
        end if
    end for
    globalDataUpdate("localPhotos", savedPhotosList)
    registryLocalPhotos = RegistryServiceRead("screensaver", "localPhotos")
    if registryLocalPhotos <> invalid
        registryServiceDelete("screensaver", "localPhotos")
    end if
    RegistryServiceWrite("screensaver", "localPhotos", savedPhotosList)
end sub

sub onFocusedChild(event as object)
    child = event.getData()
    if child <> invalid and child.id = "btnSave"
        m.btnSave.color = "#662D91"
    else
        m.btnSave.color = "#cf0a2c"
        m.btnText.text = "Save Photos"
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = true
    if press
        if key = "back"
            handled = false
        else if key = "down"
            m.btnSave.setFocus(true)
        else if key = "OK"
            if m.btnSave.hasFocus()
                saveLocalPhotos()
                m.btnText.text = "Saved"
            end if
        else
            m.photoGrid.setFocus(true)
        end if
    end if
    return handled
end function

