sub init()
	m.top.functionName = "requestTask"
end sub

sub requestTask()
	m.requestParams = m.top.params
	responseHandler = m.top.responseHandler
	responseHandler.ObserveField("interuptedResponse", "onInteruptedResponse")
	makeApiRequest()
end sub

sub makeApiRequest()
	topParams = m.top.params
	requestMethod = topParams.requestMethod

	if topParams.uri <> invalid
		requestUri = topParams.uri.EncodeUri()
		port = CreateObject("roMessagePort")
		request = CreateObject("roUrlTransfer")
		request.RetainBodyOnError(true)
		request.SetMessagePort(port)
		request.EnableEncodings(true)

		tokens = globalDataGet("tokens")
		if tokens <> invalid and tokens.authorizationToken <> invalid
			request.AddHeader("Authorization", tokens.authorizationToken)
		end if

		if isAssociativeArray(topParams.headers)
			headerEntries = topParams.headers.Items()
			for each header in headerEntries
				request.AddHeader(header.key, header.value)
			end for
		end if

		print "ApiRequest", "Request Uri: " + requestUri
		m.requestParams.requestUri = requestUri

		if requestUri.instr("https") >= 0:
			request.SetCertificatesFile("common:/certs/ca-bundle.crt")
			request.InitClientCertificates()
		end if
		m.request = request

		m.requestParams.requestUri = requestUri
		request.SetUrl(requestUri)
		request.SetRequest(requestMethod)
		if requestMethod = "POST" or requestMethod = "PUT"

			if isAssociativeArray(topParams.headers) and "application/x-www-form-urlencoded" = topParams.headers["Content-Type"]
				requestBodyJson = topParams.requestBody
			else
				request.AddHeader("Content-Type", "application/json")
				requestBodyJson = FormatJson(topParams.requestBody)
			end if

			if requestBodyJson = invalid then
				requestBodyJson = ""
			end if
			requestState = request.AsyncPostFromString(requestBodyJson)
		else
			requestState = request.AsyncGetToString()
		end if

		while requestState:
			msg = wait(0, port)
			if type(msg) = "roUrlEvent" then
				responseCode = msg.GetResponseCode()
				response = msg.GetString()
				responseType = msg.GetResponseHeaders()["content-type"]
				if responseCode = 200 or responseCode = 201 or responseCode = 204
					responseParams = {
						"response": response,
						"responseCode": responseCode,
						"responseType": responseType,
					}

					m.requestParams.responseType = responseType
					parsedResponse = m.top.responseHandler.CallFunc("handleSuccessResponse", responseParams, m.requestParams)

					errors = getAssocArrayValue(parsedResponse, "errors", [])
					if isNonEmptyArray(errors)
						setErrorJsonValue(responseCode, response)
					else
						m.top.params = m.requestParams
						setJsonValue(parsedResponse)
					end if
				else if responseCode = -28:
					' Failure Reason: Connection timed out
					print "Response handler - Request timed out"
					if topParams <> invalid
						errorObj = {
							error: true,
							requestFor: topParams.requestFor,
							requestName: topParams.requestName,
							code: responseCode,
							msg: "Request Timed Out"
						}
						m.top.errorObj = errorObj
					else
						m.top.errorObj = {
							code: responseCode,
							msg: "Request Timed Out"
						}
					end if
				else
					failureReason = msg.GetFailureReason()

					print"Startup", Substitute("Startup: Response handler - failure reason: {0}. Code: {1}", failureReason, responseCode.ToStr())
					m.requestParams.responseType = responseType
					if (responseCode = 404) and (false = m.top.responseHandler.CallFunc("isRetryException", requestUri))
						setErrorJsonValue(responseCode, response)
					else
						setErrorJsonValue(responseCode, response)
					end if
				end if
				exit while
			end if
		end while
	end if
end sub

sub onInteruptedResponse(event as object)
	json = event.getData()
	if json <> invalid
		setJsonValue(json)
	else
		setErrorJsonValue(401, "{}")
	end if
end sub

sub setJsonValue(json as object)
	topParams = m.top.params
	json.requestFor = topParams.requestFor
	json.requestName = topParams.requestName
	json.misc = topParams.misc
	m.top.json = json
end sub

sub setErrorJsonValue(responseCode as integer, response as string)
	json = {}
	json.responseCode = responseCode

	responseJson = {}
	if response.instr("{") = 0
		responseJson = ParseJson(response)
		json.Append(responseJson)
	end if
	json.response = responseJson
	if not responseJson.DoesExist("error")
		json.error = true
	end if
	setJsonValue(json)
end sub