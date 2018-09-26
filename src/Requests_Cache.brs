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
                            if fileTimeastamp + expireSeconds >= nowTimestamp
                                parsedJson = ParseJson(dataSplit[1])
                                if parsedJson <> invalid
                                    return parsedJson
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
