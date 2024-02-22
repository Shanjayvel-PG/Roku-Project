sub init()
end sub

function handleSuccessResponse(responseParams as object, requestParams as object) as object
	response = getAssocArrayValue(responseParams, "response", "{}")
	responseCode = responseParams.responseCode

	json = {}
	if type(response) = "roAssociativeArray"
		json = response
	else if type(response) = "roArray"
		json = { response: response }
	else if response.instr("{") = 0 or response.instr("[") = 0
		json = ParseJson(response)
		if type(json) = "roArray"
			json = { response: json }
		end if
	else
		print "ApiRequest", Substitute("Error code: {0}. Response {1}", responseCode.ToStr(), response)
	end if

	json.responseCode = responseCode
	return json
end function

sub onRequestResponse(event as object)
	json = event.getData()
	requestFor = json.requestFor
	requestName = json.requestName
	invalidateHttpRequest(requestName)

	response = json.response
	if response = invalid
		response = json
	end if
	responsetype = event.getRoSgNode().params.responsetype
	responseParams = {
		"response": response,
		"responseCode": json.responseCode,
		"responseType": responsetype
	}
	m.top.interuptedResponse = handleSuccessResponse(responseParams, event.getRoSgNode().params)
end sub

