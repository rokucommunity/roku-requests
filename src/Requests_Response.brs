function Requests_response(urlTransfer as Object, responseEvent as Object, requestDetails as Object)

    rr = {}

    rr.ok = function()
            if m.responseCode > 0 and m.responseCode < 400
                return true
            else
                return false
            end if
        end function

    rr.timesTried = requestDetails.timesTried

    rr.url = urlTransfer.GetUrl()

    if responseEvent <> invalid
        rr.statusCode = responseEvent.GetResponseCode()
        rr.text = responseEvent.GetString()
        rr.headers = responseEvent.GetResponseHeaders()
        rr.headersArray = responseEvent.GetResponseHeadersArray()

        rr.GetSourceIdentity = responseEvent.GetSourceIdentity()
        rr.GetFailureReason = responseEvent.GetFailureReason()
        rr.target_ip = responseEvent.GetTargetIpAddress()

    end if

    if rr.text <> invalid
        rr.json = parseJson(rr.text)
        rr.body = rr.text
    end if

    return rr

end function

