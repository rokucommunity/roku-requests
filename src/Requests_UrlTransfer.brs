function RequestsUrlTransfer(args)

    _urlTransfer = CreateObject("roUrlTransfer")
    _urlTransfer.SetPort(CreateObject("roMessagePort"))

    ' Setup Defaults
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