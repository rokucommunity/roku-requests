function Requests_response(urlTransfer as Object, responseEvent as Object, requestDetails as Object)

    rr = {}

    rr.timesTried = requestDetails.timesTried
    rr.url = urlTransfer.GetUrl()
    rr.ok = false

    if responseEvent <> invalid
        rr.statusCode = responseEvent.GetResponseCode()
        rr.text = responseEvent.GetString()
        rr.headers = responseEvent.GetResponseHeaders()
        rr.headersArray = responseEvent.GetResponseHeadersArray()

        rr.GetSourceIdentity = responseEvent.GetSourceIdentity()
        rr.GetFailureReason = responseEvent.GetFailureReason()
        rr.target_ip = responseEvent.GetTargetIpAddress()
        if rr.statusCode > 0 and rr.statusCode < 400
            rr.ok = true
        end if
    end if



    if rr.text <> invalid
        rr.json = parseJson(rr.text)
        rr.body = rr.text
    end if

    return rr

end function

