*** Settings ***
Documentation       Car dealer website test
Library             SeleniumLibrary
Library             Dialogs
Library             Process

#Test Setup          Start Container
#Test Teardown       Stop Container
*** Variables ***
${URL}      http://localhost:3000
${BROWSER}  Chrome

@{CARS}
...    Toyota    Corolla    10000    2020    ABC-123
...    Honda     Civic      15000    2021    XYZ-456
...    Ford      Focus      20000    2022    DEF-789

*** Test Cases ***
Test Adding Three Cars
    Start Container
    [Setup]    Set Selenium Speed   0.3
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Car store
    Capture Page Screenshot    car_store_empty.png
    Add Multiple Cars
    Capture Page Screenshot    car_store_with_3_cars.png
    #[Teardown]    Close Browser
    Stop Container

*** Keywords ***
Add Multiple Cars
    FOR    ${make}    ${model}    ${mileage}    ${year}    ${plate}    IN    @{CARS}
        Log To Console    Adding car: ${make} ${model} ${mileage} ${year} ${plate}
        Add Single Car    ${make}    ${model}    ${mileage}    ${year}    ${plate}
    END

Add Single Car
    [Arguments]    ${make}    ${model}    ${mileage}    ${year}    ${plate}
    Click Element    xpath://a[@href='/add']
    Title Should Be    Add a new car
    Input Text    id:make-input    ${make}
    Input Text    id:model-input    ${model}
    Input Text    id:mileage-input    ${mileage}
    Input Text    id:year-input    ${year}
    Input Text    id:plate-input    ${plate}
    Click Element    xpath=//input[@value='Add a new car']


Start Container
    Log     Starting container
    Run Process     docker-compose    up    --detach
    Sleep    5s

Stop Container
    Pause Execution
    Close Browser
    Run Process     docker-compose    down