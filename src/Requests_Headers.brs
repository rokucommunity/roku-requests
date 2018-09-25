function Requests_headers()

    return {
        _headers: {}
        addHeader: function(key as String, value as String)
                m._headers[key] = value
            end function

        addHeadersAA: function(headers as Object)
                m._headers.Append(headers)
            end function

        build: m.get
        get: m._headers
    }

end function
