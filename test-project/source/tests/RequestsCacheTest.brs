'@TestSuite [ATST] Requests Cache tests

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It Cache Sanity Checks
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test Requests cache method miss
'@Params["POST"]
'@Params["PUT"]
'@Params["PATCH"]
'@Params["DELETE"]
function Atst__Test_Requests_cache_post(method) as void

    m.cache = Requests_cache(method, "", {})
    m.AssertInvalid(m.cache)

end function


'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It Cache File Manipulations
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@BeforeEach
function Atst__Test_Requests_cache_BeforeEach() as void
    m.cache = Requests_cache("GET", "google.com", {"foo": "bar"})
end function

'@AfterEach
function Atst__Test_Requests_cache_AfterEach() as void
	'TODO: this is not ran
    m.cache.delete()
end function

'@Test Requests Cache check key and md5
function Atst__Test_Requests_cache_key_md5() as void

    m.assertEqual(m.cache._cacheKey, "google.com{" + Chr(34) + "foo" + Chr(34) + ":" + Chr(34) + "bar" + Chr(34) + "}")
    m.assertEqual(m.cache._md5Key, "9445e3daf9d959fee3e82b72c1e1d7f3")

end function

'@Test Requests Cache write, read, delete happy path
function Atst__Test_Requests_cache_put() as void

    m.assertTrue(m.cache.put({"test":"ing"}))
    m.AssertAAContainsSubset(m.cache.get(60), {"test":"ing"})
    m.assertTrue(m.cache.delete())

end function

'@Test Requests Cache read does not exits
function Atst__Test_Requests_cache_does_not_exist() as void

    m.assertInvalid(m.cache.get(60))
    m.assertFalse(m.cache.exists())

end function

'@Test Requests Cache read exists but file is empty
function Atst__Test_Requests_cache_file_empty() as void

    m.assertTrue(WriteAsciiFile(m.cache.location, ""))
    m.assertInvalid(m.cache.get(60))
    m.assertTrue(m.cache.delete())

end function

'@Test Requests Cache read file no breaks
function Atst__Test_Requests_cache_file_no_breaks() as void

    m.assertTrue(WriteAsciiFile(m.cache.location, "bad file data"))
    m.assertInvalid(m.cache.get(60))
    m.assertTrue(m.cache.delete())

end function

'@Test Requests Cache read bad file data
function Atst__Test_Requests_cache_file_three_breaks() as void

    m.assertTrue(WriteAsciiFile(m.cache.location, "bad file data" + chr(10) + chr(10)))
    m.assertInvalid(m.cache.get(60))
    m.assertTrue(m.cache.delete())

end function

'@Test Requests Cache read bad timestamp
function Atst__Test_Requests_cache_file_bad_timestamp() as void

    m.assertTrue(WriteAsciiFile(m.cache.location, "not a timestamp" + chr(10) + "more bad data"))
    m.assertInvalid(m.cache.get(60))
    m.assertTrue(m.cache.delete())

end function

'@Test Requests Cache read bad json
function Atst__Test_Requests_cache_file_bad_json() as void
    date = CreateObject("roDateTime")
    timestamp = date.AsSeconds()
    m.assertTrue(WriteAsciiFile(m.cache.location,  stri(timestamp) + chr(10) + "not json data"))
    m.assertInvalid(m.cache.get(60))
    m.cache.delete()

end function

'@Test Requests Cache write, read with expired time
function Atst__Test_Requests_cache_expired() as void

    m.assertTrue(m.cache.put({"test":"ing"}))
    m.assertInvalid(m.cache.get(-1))
    m.cache.delete()

end function

'@Test Requests Cache write, hit, sleep, miss
function Atst__Test_Requests_cache_sleep() as void

    m.assertTrue(m.cache.put({"test":"ing"}))
    m.assertNotInvalid(m.cache.get(2))
    sleep(3000)
    m.assertInvalid(m.cache.get(2))
    m.cache.delete()

end function