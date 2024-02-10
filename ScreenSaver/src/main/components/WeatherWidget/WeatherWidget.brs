sub init()
    m.bgRectangle = m.top.findNode("bgRectangle")
    m.wrapper = m.top.findNode("wrapper")
    m.cloudImage = m.top.findNode("cloudImage")
    m.temperatureText = m.top.findNode("temperatureText")
    m.location = m.top.findNode("location")
    m.humidityImage = m.top.findNode("humidityImage")
    m.humidityText = m.top.findNode("humidityText")
    m.bottomWrapper = m.top.findNode("bottomWrapper")
    m.windSpeedImage = m.top.findNode("windSpeedImage")
    m.windSpeedText = m.top.findNode("windSpeedText")
end sub

sub build(params as object)
    m.cloudImage.uri = getAssocArrayValue(params, "cloudImage", "")
    m.temperatureText.text = getAssocArrayValue(params, "temperatureText", "").toStr() + " °C"
    m.location.text = getAssocArrayValue(params, "location", "")
    bgRectangleWidth = m.bgRectangle.boundingRect().width
    m.location.width = bgRectangleWidth
    m.temperatureText.width = bgRectangleWidth
    m.location.font = "font:MediumSystemFont"
    m.temperatureText.font = "font:LargeSystemFont"
    m.humidityImage.uri = getAssocArrayValue(params, "humidityImage", "")
    m.windSpeedImage.uri = getAssocArrayValue(params, "windSpeedImage", "")
    m.humidityText.text = getAssocArrayValue(params, "humidityText", "").toStr() + "%"
    m.windSpeedText.text = getAssocArrayValue(params, "windSpeedText", "").toStr() + " km/h"
    adjustChildPosition()
    adjustWrapperPosition()
end sub

sub adjustWrapperPosition()
    bgRectangleBounds = m.bgRectangle.boundingRect()
    wrapperBounds = m.wrapper.boundingRect()
    YPos = (bgRectangleBounds.height - wrapperBounds.height) / 2
    m.wrapper.translation = [0, yPos]
end sub

sub adjustChildPosition()
    cloudImageBounds = m.cloudImage.boundingRect()
    cloudImageWidth = cloudImageBounds.width
    bgRectangleBounds = m.bgRectangle.boundingRect()
    imageXPos = (bgRectangleBounds.width - cloudImageWidth) / 2
    m.cloudImage.translation = [imageXPos, 0]

    tempTextYPos = cloudImageBounds.height + 48
    m.temperatureText.translation = [0, tempTextYPos]
    
    temperatureText = m.temperatureText.boundingRect()
    locationYpos = temperatureText.height + temperatureText.y + 16
    m.location.translation = [0, locationYPos]
    
    locationBounds = m.location.boundingRect()
    bottomWrapperWidth = m.bottomWrapper.boundingRect().width
    bottomWrapperYpos = locationBounds.height + locationBounds.y + 32
    bottomWrapperXpos = (bgRectangleBounds.width - bottomWrapperWidth) / 2
    m.bottomWrapper.translation = [bottomWrapperXpos, bottomWrapperYpos]
end sub