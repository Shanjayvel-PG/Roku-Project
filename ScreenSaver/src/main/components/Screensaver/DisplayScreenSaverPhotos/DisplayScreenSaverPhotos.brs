sub init()
    m.primaryImage = m.top.findNode("primaryImage")
    m.imageTimer = m.top.findNode("imageTimer")
    m.imageTimer.observeField("fire", "onTimerFired")
    m.localPhotosList = RegistryServiceRead("screensaver", "localPhotos")
    if m.localPhotosList <> invalid and m.localPhotosList.count() > 0
        m.primaryImage.uri = m.localPhotosList[0].uri
        m.imageTimer.control = "start"
    else
        m.primaryImage.uri = "pkg:/images/icon_hd.jpg"
    end if
    m.imageIndex = 0
end sub

sub onTimerFired()
    displayScreenSaverPhotos()
end sub

sub displayScreenSaverPhotos()
    photosCount = m.localPhotosList.Count() - 1
    m.imageIndex++
    if m.imageIndex > photosCount
        m.imageIndex = 0
    end if
    m.primaryImage.uri = m.localPhotosList[m.imageIndex].uri
end sub
