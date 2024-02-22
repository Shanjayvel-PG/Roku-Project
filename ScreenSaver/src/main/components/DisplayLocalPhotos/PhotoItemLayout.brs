sub init()
	m.thumbnail = m.top.findNode("thumbnail")
	m.title = m.top.findNode("title")
	m.checkBox = m.top.findNode("checkBox")
end sub

sub itemContentChanged(event as object)
	itemContent = event.getData()
	m.title.text = itemcontent.title
	m.thumbnail.uri = itemContent.uri
	m.thumbnail.width = 480
	m.thumbnail.height = 350
	m.title.width = 480
	if itemContent.selected
		m.checkBox.visible = true
		return
	end if
	m.checkBox.visible = false
end sub

