*** Settings ***
Documentation     Example of morse transmitter test
...
...               Change this example to use data driven style 
...               Test with different texts and speeds

Library           AtCommandLibrary.py
Test Template    Send and Verify Text


*** Test Cases ***            Input Text                   Expected Response        Expected Status
Only letters                  This is a test               THIS IS A TEST
Only numbers                  1234567890                   1234567890
Letters and numbers           Test123                      TEST123
With whitespace               This${SPACE * 4}spaced       THIS${SPACE * 4}SPACED
Special characters            @#$%^&*()                    XXXXXXXXX
Mixed input                   Hello 123 !                  HELLO 123 X
Upper and lower case mix      hElLo WoRlD                  HELLO WORLD
Empty string                  ""                           ${EMPTY}
Tab character                 Tabbed\ttext                 TABBED TEXT
Non-ASCII characters          ÅÄÖ                          XXX
Control characters            \x01\x02\x03                 XXX 
Some thing else               \r\n                         ${EMPTY}                  INVALID                       

*** Keywords ***
Send and Verify Text
    [Arguments]    ${input_text}    ${expected_response}    ${expected_status}=OK
    Send text    ${input_text}
	IF  $expected_status == "INVALID"
	    Response should be    ${expected_status}
	ELSE
	    Response should be    SENT="${expected_response}"
		Response should be    ${expected_status}
	END
 
   