function RequestsUrlTransfer(EnableEncodings as Boolean, retainBodyOnError as Boolean, verify as String)

    _urlTransfer = CreateObject("roUrlTransfer")
    _urlTransfer.SetPort(CreateObject("roMessagePort"))

     _urlTransfer.EnableEncodings(enableEncodings)
     _urlTransfer.RetainBodyOnError(retainBodyOnError)
    if verify <> ""
        _urlTransfer.SetCertificatesFile(verify)
        _urlTransfer.InitClientCertificates()
    end if

    return _urlTransfer

end function