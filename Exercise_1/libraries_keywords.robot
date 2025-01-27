*** Settings ***
Library    OperatingSystem
Library    Collections
Library    String
Library    Dialogs
Library    FakerLibrary    locale=fi_FI

*** Variables ***
${Address_file}    test.txt

*** Keywords ***
Get Random Names
    [Arguments]    ${number of random names}
    Log   Got argument ${number of random names}
    @{names}=    Create List
    FOR    ${i}    IN RANGE    ${number of random names}
        ${name}=    FakerLibrary.Name
        Append To List    ${names}    ${name}
    END
    RETURN    @{names}

Remove Existing File
    [Arguments]    ${file}
    ${file_exist}=    Run Keyword And Return Status   File Should Exist    ${file}
    IF    ${file_exist}
        ${file_text}=    Get File    ${file}
        ${first_line}=    Get Line    ${file_text}    0
        Log    First line is ${first_line}
        Remove File    ${file}
    ELSE
        Log    File does not exist
    END

*** Test Cases ***
Remove Existing File Test
    Remove Existing File    ${Address_file}

Create New Address File
    ${names}=    Get Random Names   5
    ${selected_name}=    Get Selection From User    Select from these names:   @{names}
    Log    Selected name is ${selected_name}
    ${address}=    FakerLibrary.StreetAddress
    ${postcode}=    FakerLibrary.Postcode
    ${city}=    FakerLibrary.City
    Create File    ${Address_file}
    Append To File    ${Address_file}    ${selected_name}\n
    Append To File    ${Address_file}    ${address}\n
    Append To File    ${Address_file}    ${postcode} ${city}

Checks Address File
    ${file_exist}=    Run Keyword And Return Status   File Should Exist    ${Address_file}
    IF  ${file_exist}
        ${file_text}=    Get File    ${Address_file}
        ${count}=    Get Line Count    ${file_text}
        Log    File has ${count} lines
        IF  ${count} != 3
            Log    File does not have 3 lines      
        END
    ELSE
        Log    File does not exist
    END
        
    