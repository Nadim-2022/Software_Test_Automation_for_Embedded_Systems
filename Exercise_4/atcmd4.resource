***Settings***
Library    AtCommandLibrary.py     ${COM_PORT}

*** Variables ***
${response}    ${EMPTY}
${response2}    ${EMPTY}

***Keywords***
Test Suite Setup
    Send cmd    AT
    Check response    OK
    Send cmd                      ATE0
    Check response                OK
    Send cmd                      ATE
    Response should be            OFF
    ${response}=   Run Keyword And Return Status    Response should be            OK
    IF  ${response}
        Log     Local echo off
    END


Test Suite Teardown
    Send cmd                        ATE1
    Response should be              OK
    Send cmd                      ATE
    Response should be            ATE
    Response should be            ON
    ${response}=   Run Keyword And Return Status    Response should be            OK
    IF  ${response}
        Log     Local echo ON
    END
    

Send and Verify Text
    [Arguments]    ${input_text}    ${expected_response}    ${expected_status}=OK
    Send text    ${input_text}
	IF  $expected_status == "INVALID"
        Response should be    ${expected_status}
	ELSE
	    Response should be    SENT="${expected_response}"
		Response should be    ${expected_status}
	END
 
