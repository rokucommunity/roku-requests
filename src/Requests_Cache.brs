function Requests_cache(method as String, url as String, headers as Object)

    if method <> "GET"
        return invalid
    end if

    cacheKey = url
    headersString = FormatJson(headers)
    if headersString <> invalid
        cacheKey = cacheKey + headersString
    end if

    ba = CreateObject("roByteArray")
    ba.FromAsciiString(cacheKey)
    digest = CreateObject("roEVPDigest")
    digest.Setup("md5")
    md5Key = digest.Process(ba)

    fileLocation = "cachefs:/" + md5Key

    return {
        _cacheKey: cacheKey
        _md5Key: md5Key

        location: fileLocation

        exists: function() as Boolean
                fs = CreateObject("roFileSystem")
                return fs.Exists(m.location)
            end function

        get: function(expireSeconds) as Object
                if m.exists()
                    fileData = ReadAsciiFile(m.location)
                    if fileData <> ""
                        dataSplit = fileData.Split(chr(10))
                        if dataSplit.count() = 2
                            fileTimeastamp = dataSplit[0].toInt()
                            date = CreateObject("roDateTime")
                            nowTimestamp = date.AsSeconds()
                            response = ParseJson(dataSplit[1])
                            if response <> invalid
                                if expireSeconds = invalid and response.headers <> invalid
                                    cacheControl = response.headers["cache-control"]
                                    if cacheControl <> invalid
                                        cacheControlSplit = cacheControl.split(",")
                                        if cacheControlSplit.count() > 1
                                            cacheControlMaxAgeSplit = cacheControlSplit[1].split("=")
                                            if cacheControlMaxAgeSplit.count() > 1
                                                expireSeconds = val(cacheControlMaxAgeSplit[1])
                                            end if
                                        end if
                                    end if
                                end if
                                if expireSeconds <> invalid
                                    if fileTimeastamp + expireSeconds >= nowTimestamp
                                        response.cacheHit = true
                                        return response
                                    end if
                                end if
                            end if
                        end if
                    end if
                end if
                return invalid
            end function

        put: function(response) as Boolean
                date = CreateObject("roDateTime")
                timestamp = date.AsSeconds()
                putString = stri(timestamp) + chr(10)
                jsonResponse = FormatJson(response)

                if jsonResponse <> invalid
                    putString = putString + jsonResponse
                    return WriteAsciiFile(m.location, putString)
                end if
                return false
            end function

        delete: function() as Boolean
            fs = CreateObject("roFileSystem")
                return fs.Delete(m.location)
            end function

    }

end function
