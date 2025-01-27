*** Settings ***
Library    OperatingSystem
Library    Collections
Library    String
Library    Dialogs
Library    FakerLibrary    locale=fi_FI
Library    SSHLibrary

*** Variables ***
${SSH_HOST}         shell.metropolia.fi
${SSH_USER}         nadima
${SSH_KEY_PATH}     nadima-447.pem
${Address_file}     test.txt
${REMOTE_PATH}      /home2-2/n/nadima/

*** Keywords ***
Establish SSH Connection
    Open Connection    ${SSH_HOST}
    Login With Public Key    ${SSH_USER}    ${SSH_KEY_PATH}

Close SSH Connection
    Close Connection

Get Remote Random Names
    [Arguments]    ${number of random names}
    Log   Got argument ${number of random names}
    @{names}=    Create List
    FOR    ${i}    IN RANGE    ${number of random names}
        ${name}=    FakerLibrary.Name
        Append To List    ${names}    ${name}
    END
    RETURN    @{names}

Remove Existing Remote File
    [Arguments]    ${file}
    ${remote_file} =    Set Variable    ${REMOTE_PATH}${file}
    Establish SSH Connection
    ${file_exist}=    Run Keyword And Return Status    Execute Command    test -f ${remote_file}
    IF    ${file_exist}
        ${first_line}=    Execute Command    head -n 1 ${remote_file}
        Log    First line is ${first_line}
        Execute Command    rm ${remote_file}
        Log    File removed: ${remote_file}
    ELSE
        Log    File does not exist
    END
    Close SSH Connection

Create New Remote Address File
    [Arguments]    ${file}
    ${remote_file} =    Set Variable    ${REMOTE_PATH}${file}
    ${names}=    Get Remote Random Names   5
    ${selected_name}=    Get Selection From User    Select from these names:   @{names}
    Log    Selected name is ${selected_name}
    ${address}=    FakerLibrary.StreetAddress
    ${postcode}=    FakerLibrary.Postcode
    ${city}=    FakerLibrary.City
    Establish SSH Connection
    Execute Command    echo "${selected_name}" > ${remote_file}
    Execute Command    echo "${address}" >> ${remote_file}
    Execute Command    echo "${postcode} ${city}" >> ${remote_file}
    Log    File created: ${remote_file}
    Close SSH Connection

Check Remote Address File
    [Arguments]    ${file}
    ${remote_file} =    Set Variable    ${REMOTE_PATH}${file}
    Establish SSH Connection
    ${file_exist}=    Run Keyword And Return Status    Execute Command    test -f ${remote_file}
    IF  ${file_exist}
        ${line_count}=    Execute Command    wc -l < ${remote_file}
        Log    File has ${line_count} lines
        IF  ${line_count} != 3
            Log    File does not have 3 lines
        END
    ELSE
        Log    File does not exist
    END
    Close SSH Connection

*** Test Cases ***
Remove Existing Remote File Test
    Remove Existing Remote File    ${Address_file}

Create New Remote Address File Test
    Create New Remote Address File    ${Address_file}

Check Remote Address File Test
    Check Remote Address File    ${Address_file}
