'@TestSuite [ATST] Requests tests

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It Some Basic Integration Testing
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test URL Match
'@Params["http://httpbin.org/get"]
function Atst__url_match(url) as void

    response = Requests().get(url)
    m.AssertEqual(response.url, url)

end function

'@Test Status Code Match
'@Params["http://httpbin.org/status/200", 200]
'@Params["http://httpbin.org/status/201", 201]
'@Params["http://httpbin.org/status/204", 204]
'@Params["http://httpbin.org/status/304", 304]
'@Params["http://httpbin.org/status/400", 400]
'@Params["http://httpbin.org/status/404", 404]
function Atst__status_code_match(url, statusCode) as void

    response = Requests().get(url, {retryCount:0})
    m.AssertEqual(response.statusCode, statusCode)

end function

'@Test Retry Count
'@Params["http://httpbin.org/status/400", 0]
'@Params["http://httpbin.org/status/404", 3]
'@Params["http://httpbin.org/status/401", 4]
function Atst__status_code_fail(url, retryCount) as void

    response = Requests().get(url, {retryCount:retryCount})
    m.AssertEqual(response.timesTried, retryCount + 1)

end function

'@Test Negative Retry (don't get response)
'@Params["http://httpbin.org/status/400", -1]
function Atst__negative_retry(url, retryCount) as void

    response = Requests().get(url, {retryCount:retryCount})
    m.AssertEqual(response.timesTried, retryCount + 1)
    m.AssertEqual(response.statusCode, invalid)

end function

'@Test JSON response
'@Params["http://httpbin.org/json"]
function Atst__json_response(url) as void

    response = Requests().get(url)
    m.AssertNotInvalid(response.json)
    m.AssertAAHasKey(response.json, "slideshow")

end function

'@Test Query String
'@Params["http://httpbin.org/get", {"a": "test", "this": "is"}, "http://httpbin.org/get?a=test&this=is"]
function Atst__json_qs(url, params, finalUrl) as void

    response = Requests().get(url, {"params": params})
    m.AssertNotInvalid(response.json)
    m.AssertAAContainsSubset(response.json.args, params)
    m.AssertEqual(response.url, finalUrl)

end function

'@Test Headers
'@Params["http://httpbin.org/get", {"testHeaderKey": "testHeaderValue"}]
function Atst__json_Headers(url, headers) as void

    response = Requests().get(url, {"headers": headers})
    m.AssertNotInvalid(response.json)
    m.AssertAAContainsSubset(response.json.headers, params)

end function

'@Test Follows Redirects
'@Params["http://httpbin.org/absolute-redirect/5"]
function Atst___Redirects(url) as void

    response = Requests().get(url)
    m.AssertNotInvalid(response.json)
    m.AssertEqual(response.json.url, "http://httpbin.org/get")

end function

'@Test POST form data
function Atst__post_form_data() as void

    response = Requests().post("http://httpbin.org/post", {"data": "test=data"})
    m.AssertNotInvalid(response.json)
    m.AssertAAContainsSubset(response.json.form, {"test": "data"})

end function

'@Test POST json data
'@Params[{"test":1}]
'@Params[{"test":1, "foo":"bar"}]
function Atst__post_json_data(jsonData) as void

    response = Requests().post("http://httpbin.org/post", {"json": jsonData})
    m.AssertNotInvalid(response.json)
    m.AssertAAContainsSubset(response.json.json, jsonData)

end function

'@Only
'@Test Requests Cache write, read with Cache-Contol headers
function Atst__Test_Requests_cache_read_headers() as void
    url = "http://httpbin.org/cache/100"

    cache = Requests_cache("GET", url, {})
    cache.delete()

    response = Requests().get(url, {useCache: true})
    m.AssertNotInvalid(response.json)
    m.AssertFalse(response.cacheHit)

    response = Requests().get("http://httpbin.org/cache/100", {useCache: true})
    m.AssertNotInvalid(response.json)
    m.AssertTrue(response.cacheHit)

end function



