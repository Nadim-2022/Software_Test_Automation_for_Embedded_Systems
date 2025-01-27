*** Settings ***
Documentation       Car dealer website test
Library             SeleniumLibrary


*** Variables ***
${URL}      http://localhost:3000
${BROWSER}        Chrome



*** Test Cases ***
Open Browser
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Car store
    #take screenshot
    Capture Page Screenshot    car_store_Empty.png
    Sleep    2
    Add Car



Close Browser
    Sleep    10
    Capture Page Screenshot    3_cars_added.png
    Close Browser

*** Keywords ***

Add Car
    Click Element    xpath://a[@href='/add']
    Title Should Be    Add a new car
    Input Text    id:make-input    Toyota
    Input Text    id:model-input    Corolla
    Input Text    id:mileage-input    10000
    Input Text    id:year-input    2020
    Input Text    id:plate-input    ABC-123
    Click Element    xpath=//input[@value='Add a new car']
    Title Should Be    Car store
    