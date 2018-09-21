' VERSION: Requests 0.1.0
' LICENSE: MIT License
' LICENSE: 
' LICENSE: Copyright (c) 2018 Blake Visin
' LICENSE: 
' LICENSE: Permission is hereby granted, free of charge, to any person obtaining a copy
' LICENSE: of this software and associated documentation files (the "Software"), to deal
' LICENSE: in the Software without restriction, including without limitation the rights
' LICENSE: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' LICENSE: copies of the Software, and to permit persons to whom the Software is
' LICENSE: furnished to do so, subject to the following conditions:
' LICENSE: 
' LICENSE: The above copyright notice and this permission notice shall be included in all
' LICENSE: copies or substantial portions of the Software.
' LICENSE: 
' LICENSE: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' LICENSE: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' LICENSE: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' LICENSE: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LICENSE: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' LICENSE: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' LICENSE: SOFTWARE.
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
    while retry_times > 0
        ? "[http] Retry Times= ", retry_times
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
                    exit while
                else
                    ? "[http] Bad response"
                end if
            else
                if m.cancel_and_return = true
                    ? "[http] Killing the Task"
                    exit while
                else
                    ? "[http] Event Timed Out"
                    m.urlTransfer.AsyncCancel()
                    timeout = timeout * 2
                    ? "[http] Timeout=", timeout
                end if
            end if
        end if
    end while
    ? "[http] ------ END HTTP REQUEST ------"
    return event_response
end function
function RequestsResponse(urlTransfer as Object, responseEvent)
    return {
        url: urlTransfer.GetUrl()
    }
end function
function RequestsUrlTransfer(args)
    _urlTransfer = CreateObject("roUrlTransfer")
    _urlTransfer.SetPort(CreateObject("roMessagePort"))
    _EnableEncodings = true
    _RetainBodyOnError = true
    _CertBundle = "common:/certs/ca-bundle.crt"
    if args <> invalid
        if args.EnableEncodings <> invalid and type(args.EnableEncodings) = "Boolean"
            _EnableEncodings = args.EnableEncodings
        end if
        if args.RetainBodyOnError <> invalid and type(args.RetainBodyOnError) = "Boolean"
            _RetainBodyOnError = args.RetainBodyOnError
        end if
        if args.CertBundle <> invalid and type(args.CertBundle) = "String"
            _certBundle = "common:/certs/ca-bundle.crt"
        end if
    end if
     _urlTransfer.EnableEncodings(_EnableEncodings)
     _urlTransfer.RetainBodyOnError(_RetainBodyOnError)
    _urlTransfer.SetCertificatesFile(_certBundle)
    _urlTransfer.InitClientCertificates()
    return _urlTransfer
end function
