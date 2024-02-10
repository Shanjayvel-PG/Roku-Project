sub init()
	prepHome()
end sub

sub prepHome()
	m.mainScreen = CreateObject("roSGNode", "MainScreen")
	m.mainScreen.observeField("closeScreen", "onCloseScreen")
	m.top.appendChild(m.mainScreen)
	m.top.signalBeacon("AppLaunchComplete")
	m.mainScreen.setFocus(true)
end sub

sub onCloseScreen()
end sub
