sub init()
	m.model = CreateObject("roSGNode", "MainScreenModel")
	m.model.observeField("locationInfo", "onLocationInfo")
	m.model.observeField("weatherInfo", "onWeatherInfo")
end sub

sub getLocationData(url as string)
	m.model.callFunc("getLocationData", url)
end sub

sub onLocationInfo(event as object)
	m.top.locationInfo = event.getData()
end sub

sub getWeatherData(url as string)
	m.model.callFunc("getWeatherData", url)
end sub

sub onWeatherInfo(event as object)
	m.top.weatherInfo = event.getData()
end sub