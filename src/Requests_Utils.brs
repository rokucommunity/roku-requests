function Requests_Utils_inString(char as String, strValue as String)

    for each single_char in strValue.split("")
        if single_char = char
            return true
        end if
    end for

    return false

end function