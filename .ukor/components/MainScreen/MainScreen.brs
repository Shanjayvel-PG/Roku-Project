sub init()
    m.top.setFocus(true)
    m.itemHeader = m.top.findNode("itemHeader")
    m.LayoutGroup = m.top.findNode("LayoutGroup")
    m.btnRect1 = m.top.findNode("btnRect1")
    m.btnRect2 = m.top.findNode("btnRect2")
    m.btnRect3 = m.top.findNode("btnRect3")
    m.btnText1 = m.top.findNode("btnText1")
    m.btnText2 = m.top.findNode("btnText2")
    m.btnText2 = m.top.findNode("btnText3")
    m.Trip = m.top.findNode("Trip")
    m.Contact = m.top.findNode("Contact")
    m.photoGrid = m.top.findNode("photoGrid")
    m.weatherWidget = m.top.findNode("weatherWidget")
    m.itemHeader.text = "Customizable ScreenSaver!"
    m.top.observeField("focusedChild", "onFocusChange")
    m.top.focusable = true
    m.btnRect1.setFocus(true)
    m.btnRect2.setFocus(true)
    m.btnRect1.color = "#0000ff"
    m.viewModel = CreateObject("roSGNode", "MainScreenViewModel")
    m.viewModel.observeField("locationInfo", "onLocationInfo")
    m.viewModel.observeField("weatherInfo", "onWeatherInfo")
    callLocationApi()
end sub

sub callLocationApi()
    ip = getIpAddress()
    url = "http://ipinfo.io/" + ip + "/json"
    m.viewModel.callFunc("getLocationData", url)
end sub

sub onLocationInfo(event as object)
    locationInfo = event.getData()
    print "locationInfo" locationInfo
    loc = locationInfo.loc.Split(",")
    url = "https://api.openweathermap.org/data/2.5/weather?lat=" + loc[0] + "&lon=" + loc[1].trim() + "&appid=395b322efeaee3dc1bd609180d55069c&units=metric"
    m.viewModel.callFunc("getWeatherData", url)
end sub

sub onWeatherInfo(event as object)
    weatherInfo = event.getData()
    cloudImage = getCloudImage(weatherInfo)
    params = {
        location: weatherInfo.name
        temperatureText: weatherInfo.main.temp
        cloudImage: cloudImage
        windSpeedImage: "pkg:/images/windspeed.png"
        humidityImage: "pkg:/images/humidty.png"
        humidityText: weatherInfo.main.humidity
        windSpeedText: weatherInfo.wind.speed
    }
    m.weatherWidget.callFunc("build", params)
    m.weatherWidget.visible = true
end sub

function getCloudImage(weatherInfo as object)
    weatherType = weatherInfo.weather[0].main
    cloudImage = ""
    if LCase(weatherType) = "mist"
        cloudImage = "pkg:/images/snow.png"
    else if LCase(weatherType) = "clear"
        cloudImage = "pkg:/images/clearSun.png"
    else if LCase(weatherType) = "rain"
        cloudImage = "pkg:/images/rain.png"
    else if LCase(weatherType) = "clouds"
        cloudImage = "pkg:/images/cloud.png"
    else if LCase(weatherType) = "drizzle"
        cloudImage = "pkg:/images/rainCloud.png"
    end if
    return cloudImage
end function

function getIpAddress()
    di = CreateObject("roDeviceInfo")
    ipAddr = di.GetExternalIp()
    return ipAddr
end function

sub chooseLocalPhotos()
    maxCount = 5
    photoList = []
    for index = 1 to maxCount
        photoItem = {
            id: "id" + index.toStr()
            title: "Image " + index.toStr()
            uri: "pkg:/images/ss_image_" + index.toStr() + ".jpg"
        }
        photoList.push(photoItem)
    end for
    m.photoGrid.callFunc("build", photoList)
    m.photoGrid.visible = "true"
end sub

sub tripadvisordetails()
    ' m.top.setFocus(true)
    m.Trip.visible = "true"
end sub

sub contactinfodetails()
    ' m.top.setFocus(true)
    m.Contact.visible = "true"
end sub

sub setFocusToDefault()
    m.btnRect1.setFocus(true)
    m.btnRect1.color = "#0000ff"
    m.btnRect2.color = "#000000"
    m.btnRect3.color = "#000000"
    m.photoGrid.visible = "false"
    m.Trip.visible = "false"
    m.Contact.visible = "false"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = true
    if press
        if key = "OK"
            if m.btnRect1.hasFocus()
                chooseLocalPhotos()
            else if m.btnRect2.hasFocus()
                tripadvisordetails()
            else if m.btnRect3.hasFocus()
                contactinfodetails()
            end if
        else if key = "down"
            if m.btnRect1.hasFocus()
                m.btnRect2.setFocus(true)
                m.btnRect1.setFocus(false)
                m.btnRect2.color = "#0000ff"
                m.btnRect1.color = "#000000"
            else if m.btnRect2.hasFocus()
                    m.btnRect3.setFocus(true)
                    m.btnRect3.color = "#0000ff"
                    m.btnRect2.color = "#000000"
            end if
        else if key = "up"
            if m.btnRect2.hasFocus()
                m.btnRect1.setFocus(true)
                m.btnRect1.color = "#0000ff"
                m.btnRect2.color = "#000000"

            else if m.btnRect3.hasFocus()
                m.btnRect2.setFocus(true)
                m.btnRect3.color = "#000000"
                m.btnRect2.color = "#0000ff"
            end if
        else
            if key = "back"
                setFocusToDefault()
            end if
        end if
    end if
    return handled
end function