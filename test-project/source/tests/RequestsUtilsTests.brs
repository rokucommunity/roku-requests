'@TestSuite [ATST] Requests Utils tests

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It Utils
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test inString true
'@Params["\", "\n"]
'@Params["=", "test=123"]
'@Params[".", "."]
'@Params[".", "19.99"]
'@Params["4", "12345"]
function Atst__Test_Requests_Utils_inString_true(char, strValue) as void

    rtn = rr_Requests_Utils_inString(char, strValue)
    m.AssertTrue(rtn)

end function


'@Test inString false
'@Params["test=123", "="]
'@Params[".", ""]
'@Params["a", "12345"]
function Atst__Test_Requests_Utils_inString_false(char, strValue) as void

    rtn = rr_Requests_Utils_inString(char, strValue)
    m.AssertFalse(rtn)

end function