'@TestSuite [ATST] Requests Query String tests

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It QueryString
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test addString
'@Params["test=123", [["test", "123"]]]
'@Params["test=123&foo=bar", [["test", "123"], ["foo", "bar"]]]
'@Params["test", [["test", ""]]]
'@Params["=123", [["", "123"]]]
'@Params["", []]
function Atst__Test_Requests_QueryString_addString(addString, qs_array) as void

    qs = Requests_queryString()
    qs.addString(addString)
    'TODO: fix AssertArrayContainsOnly
    'm.AssertArrayContainsOnly(qs._qs_array, "Array")
    m.EqArrays([qs._qs_array], qs_array)

end function

'@Test addParamKeyValue
'@Params["test", "123", [["test", "123"]]]
'@Params["test", "", [["test", ""]]]
'@Params["", "123", [["", "123"]]]
'@Params["", "", [["", ""]]]
function Atst__Test_Requests_QueryString_addParamKeyValue(param, key, qs_array) as void

    qs = Requests_queryString()
    qs.addParamKeyValue(param, key)
    'TODO: fix AssertArrayContainsOnly
    'm.AssertArrayContainsOnly(qs._qs_array, "Array")
    m.EqArrays([qs._qs_array], qs_array)

end function

'@Test addParamsAA
'@Params[{"test": "123"}, [["test", "123"]]]
'@Params[{"test": "123", "foo": "bar"}, [["test", "123"], ["foo", "bar"]]]
'@Params[{"test": ""}, [["test", ""]]]
'@Params[{"": "123"}, [["", "123"]]]
'@Params[{"": ""}, [["", ""]]]
function Atst__Test_Requests_QueryString_addParamsAA(params, qs_array) as void

    qs = Requests_queryString()
    qs.addParamsAA(params)
    'TODO: fix AssertArrayContainsOnly
    'm.AssertArrayContainsOnly(qs._qs_array, "Array")
    m.EqArrays([qs._qs_array], qs_array)

end function

'@Test addParamsArray
'@Params[[["test", "123"]], [["test", "123"]]]
'@Params[[["test", "123"], ["foo", "bar"]], [["test", "123"], ["foo", "bar"]]]
'@Params[[["test", ""]], [["test", ""]]]
'@Params[[["", "123"]], [["", "123"]]]
'@Params[[["", ""]], [["", ""]]]
'@Params[[["test"]], [["test", ""]]]
'@Params[[[""]], [["", ""]]]
'@Params[[], []]
function Atst__Test_Requests_QueryString_addParamsArray(params, qs_array) as void

    qs = Requests_queryString()
    qs.addParamsArray(params)
    'TODO: fix AssertArrayContainsOnly
    'm.AssertArrayContainsOnly(qs._qs_array, "Array")
    m.EqArrays([qs._qs_array], qs_array)

end function

'@Test build
function Atst__Test_Requests_QueryString_build() as void

    qs = Requests_queryString()
    qs.addString("test=123&foo=bar")
    qs.addParamKeyValue("name", "jim")
    qs.addParamsAA({"forcast": "sunny"})
    qs.addParamsArray([["chocolate", "yummy"]])
    'm.AssertArrayContainsOnly(qs._qs_array, "Array")
    built = qs.build()
    m.AssertEqual(built, "test=123&foo=bar&name=jim&forcast=sunny&chocolate=yummy")

end function

'@Test build
function Atst__Test_Requests_QueryString_append() as void

    qs = Requests_queryString()
    qs.addString("test=123&foo=bar")
    qs.addParamKeyValue("name", "jim")
    qs.addParamsAA({"forcast": "sunny"})
    qs.addParamsArray([["chocolate", "yummy"]])
    'm.AssertArrayContainsOnly(qs._qs_array, "Array")
    append = qs.append("google.com")
    m.AssertEqual(append, "google.com?test=123&foo=bar&name=jim&forcast=sunny&chocolate=yummy")

    append = qs.append("google.com?")
    m.AssertEqual(append, "google.com?test=123&foo=bar&name=jim&forcast=sunny&chocolate=yummy")

    append = qs.append("google.com?id=555")
    m.AssertEqual(append, "google.com?id=555&test=123&foo=bar&name=jim&forcast=sunny&chocolate=yummy")

end function

'@Test build empty
function Atst__Test_Requests_QueryString_append_empty() as void

    qs = Requests_queryString()
    append = qs.append("google.com")
    m.AssertEqual(append, "google.com")

end function