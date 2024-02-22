sub init()
    execScreensaver()
end sub

sub execScreensaver()
    m.screenActive = createObject("roSGNode", "DisplayScreenSaverPhotos")
    m.top.appendChild(m.screenActive)
    m.screenActive.setFocus(true)
end sub
