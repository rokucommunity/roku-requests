' /**
'  * @module requests
'  */

' /**
'  * @memberof module:requests
'  * @name Requests
'  * @function
'  * @description Main Class for Requests
'  * @param {Dynamic} args - Associative array of args to pass into Alacrity

function Requests(args=invalid) as Object
    return {
        _urlTransfer : RequestsUrlTransfer(args)
        _run : RequestsRun

        get: function (url, params=invalid) as Object
            m._urlTransfer.SetUrl(url)
             _response_event = m._run(m._urlTransfer)
            return RequestsResponse(m._urlTransfer, _response_event)
        end function
    }
end function

function RequestsRun(urlTransfer as Object)

    ? "[http] ------ START HTTP REQUEST ------"

    ? "[http] URL:", urlTransfer.GetURL()

    timeout = 4000
    ? "[http] Timeout= ", timeout

    retry_times = 3
    method = "GET"
    cancel_and_return = false

    event_response = invalid

    'while we still have try times
    while retry_times > 0
        ? "[http] Retry Times= ", retry_times

        'deincrement the number of retries
        retry_times = retry_times - 1

        ? "[http] Method: " +  method
        if method="POST"
            sent = urlTransfer.AsyncPostFromString(data)
        else
            sent = urlTransfer.AsyncGetToString()
        end if

        if sent = true
            clock = CreateObject("roTimespan")
            timeout_call = clock.TotalMilliseconds() + timeout

            while true and cancel_and_return = false

                if m.top <> invalid
                    if m.top.quit <> invalid
                        cancel_and_return = m.top.quit
                    end if
                end if

                event = urlTransfer.GetPort().GetMessage()

                if type(event) = "roUrlEvent"
                    exit while
                end if

                if clock.TotalMilliseconds() > timeout_call
                    event = invalid
                    exit while
                end if
            end while

            if type(event) = "roUrlEvent"
                event_response = event
                ? "[http] Response Code= ", event.GetResponseCode()
                if (event.GetResponseCode() >= 200 and event.GetResponseCode() < 300) or event.GetResponseCode() = 403
                    'Response was good, so we break the while
                    exit while
                else
                    'We have a bad response, so log it if we are on the last retry
                    ? "[http] Bad response"
                end if
            else
                if m.cancel_and_return = true
                    ? "[http] Killing the Task"
                    exit while
                else
                    'We timed out so we should cancel the request
                    ? "[http] Event Timed Out"
                    m.urlTransfer.AsyncCancel()
                    'Exponential backoff timeouts
                    timeout = timeout * 2
                    ? "[http] Timeout=", timeout
                end if
            end if
        end if
    end while
    ? "[http] ------ END HTTP REQUEST ------"

    return event_response


end function


