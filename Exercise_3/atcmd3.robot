*** Settings ***
Documentation	 This is a test suite for the AT Command Library

Resource	lab3.resource

Test Setup	Test Suite Setup
Test Teardown	Test Suite Teardown
Test Template	Send and Verify Text

*** Test Cases ***            Input Text                   Expected Response        Expected Status
Only letters                  This is a test               THIS IS A TEST            OK
Only numbers                  1234567890                   1234567890
#Letters and numbers           Test123                      TEST123
#ith whitespace               This${SPACE * 4}spaced       THIS${SPACE * 4}SPACED
#Special characters            @#$%^&*()                    XXXXXXXXX
#Mixed input                   Hello 123 !                  HELLO 123 X
#Upper and lower case mix      hElLo WoRlD                  HELLO WORLD
#Empty string                  ""                           ${EMPTY}
#Tab character                 Tabbed\ttext                 TABBED TEXT
#Non-ASCII characters          ÅÄÖ                          XXX
#Control characters            \x01\x02\x03                 XXX 
#Some thing else               \r\n                         ${EMPTY}                  INVALID                       

