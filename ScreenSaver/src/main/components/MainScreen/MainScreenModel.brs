sub init()
end sub

sub getLocationData(url as string)
  ApiRequest({
    uri: url,
    requestFor: "getLocation",
    requestMethod: "GET"
  })
end sub

sub getWeatherData(url as string)
  ApiRequest({
    uri: url,
    requestFor: "getWeather",
    requestMethod: "GET"
  })
end sub

sub onErrorResponse(event as object)
  onRequestResponse(event)
end sub

sub onRequestResponse(event as object)
  json = event.getData()
  requestFor = json.requestFor
  requestName = json.requestName
  invalidateHttpRequest(requestName)

  if "getLocation" = requestFor
    m.top.locationInfo = json
  else if "getWeather" = requestFor
    m.top.weatherInfo = json
  end if
end sub
