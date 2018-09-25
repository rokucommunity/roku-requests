function Requests_queryString()

    return {
        _qs_array: []
        addString: function(params as String)
                if Requests_Utils_inString("&", params)
                    split_params = params.split("&")
                    for each param in split_params
                        if Requests_Utils_inString("=", param)
                            split_param = param.split("=")
                            m.addParamKeyValue(split_param[0], split_param[1])
                        else
                            m.addParamKeyValue(param, "")
                        end if
                    end for
                else if Requests_Utils_inString("=", params)
                    split_params = params.split("=")
                    m.addParamKeyValue(split_params[0], split_params[1])
                else
                    m.addParamKeyValue(params, "")
                end if
            end function
        addParamKeyValue: function(param as String, key as String)
                m._qs_array.push([param, key])
            end function
        addParamsAA: function(params as Object)
                for each item in params.Items()
                    m.addParamKeyValue(item.key, item.value)
                end for
            end function
        addParamsArray: function(params as Object)
                if params.Count() > 0
                    for each item in params
                        if item.Count() > 1
                            m.addParamKeyValue(item[0], item[1])
                        else if item.Count() > 0
                            m.addParamKeyValue(item[0], "")
                        end if
                    end for
                end if
            end function

        build: function() as String
            ' "build the QS output from the added params"
                output = ""
                c = 0
                for each qs in m._qs_array
                    if c = 0
                        output = qs[0] + "=" + qs[1]
                    else
                        output = output + "&" + qs[0] + "=" + qs[1]
                    end if
                    c += 1
                end for
                return output
            end function

        append: function(url as String) as String
            ' "append the QS on a provided URL"
                if m._qs_array.Count() > 0
                    if Requests_Utils_inString("?", url)
                        if url.right(1) = "?"
                            return url + m.build()
                        else
                            return url + "&" + m.build()
                        end if
                    else
                        return url + "?" + m.build()
                    end if
                end if
                return url
            end function
    }

end function
