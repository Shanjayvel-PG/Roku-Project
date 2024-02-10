function isNonEmptyAssociativeArray(value as dynamic) as boolean
	return isValid(value) and GetInterface(value, "ifAssociativeArray") <> invalid and value.Count() > 0
end function

function isNonEmptyString(value as dynamic) as boolean
	return isValid(value) and GetInterface(value, "ifString") <> invalid and value <> ""
end function

function isValid(value as dynamic) as boolean
	return Type(value) <> "<uninitialized>" and value <> invalid
end function

function isAssociativeArray(value as dynamic) as boolean
	return isValid(value) and GetInterface(value, "ifAssociativeArray") <> invalid
end function

function isNonEmptyArray(value as dynamic) as boolean
	return isValid(value) and GetInterface(value, "ifArray") <> invalid and value.Count() > 0
end function

sub ApiRequest(params as object)
	requestParams = {
		"uri": "",
		"requestFor": "",
		"requestBody": "",
		"forceToken": "",
		"requestMethod": "GET",
		"misc": invalid,
		"callbackFunc": "onRequestResponse",
		"errorCallback": "onErrorResponse",
		"responseHandler": "ResponseHandler"
	}
	requestParams.append(params)

	requestName = "ApiRequest_" + requestParams.requestFor.replace(" ", "")
	requestParams.requestName = requestName
	if not isValid(m[requestName])
		m[requestName] = CreateObject("roSGNode", "ApiRequest")
		if m[requestName] = invalid
			return
		end if
		responseHandler = CreateObject("roSGNode", requestParams.responseHandler)
		m[requestName].responseHandler = responseHandler
	end if
	httpRequestObj = m[requestName]
	if httpRequestObj = invalid
		return
	end if
	httpRequestObj.params = requestParams

	httpRequestObj.observeField("json", requestParams.callbackFunc)
	httpRequestObj.observeField("errorObj", requestParams.errorCallback)
	httpRequestObj.control = "RUN"
end sub

sub invalidateHttpRequest(requestName as string)
	if m[requestName] = invalid
		return
	end if
	m[requestName].UnobserveField("json")
	m[requestName].UnobserveField("errorObj")
	m[requestName].UnobserveField("state")
	m[requestName] = invalid
end sub