'@TestSuite [ATST] Requests Headers tests

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It Headers
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test addHeader
function Atst__Test_Requests_headers_addHeader() as void

    headers = rr_Requests_headers()
    headers.addHeader("foo", "bar")
    headers.addHeader("x-api-key", "123")
    m.AssertAAHasKeys(headers._headers, ["foo", "x-api-key"])
    m.AssertEqual(headers._headers["foo"], "bar")
    m.AssertEqual(headers._headers["x-api-key"], "123")

end function

'@Test addHeadersAA
function Atst__Test_Requests_headers_addHeadersAA() as void

    headers = rr_Requests_headers()
    headers.addHeadersAA({"foo":"bar", "x-api-key":"123"})
    m.AssertAAHasKeys(headers._headers, ["foo", "x-api-key"])
    m.AssertEqual(headers._headers["foo"], "bar")
    m.AssertEqual(headers._headers["x-api-key"], "123")

end function