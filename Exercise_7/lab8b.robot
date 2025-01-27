*** Settings ***
Documentation       Lab 8 Part 2: Car dealer website test
Library             SeleniumLibrary
Library             Dialogs
Library             Process

*** Variables ***
${URL}      http://localhost:3000
${BROWSER}  Chrome
@{CAR_MAKES}        Toyota    Skoda    Audi
@{CAR_MODELS}       Corolla    Octavia    A3    Camry    Superb    Q5   RAV4    A4    Yaris    A6  Land Cruiser    Fabia

*** Test Cases ***
Lab 8 Part 2: Remove Skodas
    Start Container
#    [Setup]    Set Selenium Speed   0.1
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Car store

    Add Cars With Specific Makes    10
    Capture Page Screenshot    car_store_after_add_skodas.png

    Remove All Cars By Make    Skoda
    Verify No Cars Of Make Exist    Skoda

    Capture Page Screenshot    car_store_after_remove_skodas.png

    [Teardown]    Close Browser
    Stop Container

*** Keywords ***
Add Cars With Specific Makes
    [Arguments]    ${count}
    FOR    ${i}    IN RANGE    ${count}
        ${make}    Evaluate    random.choice(["Toyota", "Skoda", "Audi"])
        ${model}    Evaluate    random.choice(${CAR_MODELS})
        ${mileage}  Evaluate    random.randint(1000, 30000)
        ${year}     Evaluate    random.randint(2015, 2022)
        ${plate}    Generate Plate Number
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
    Wait Until Page Contains Element    xpath=//div[@id='car-container']

Remove All Cars By Make
    [Arguments]    ${make}
    ${car_locator}    Set Variable    xpath=//*[@id="car-container"]//span[text()='${make}']
    ${car_list} =   Get WebElements    ${car_locator}
    WHILE    ${car_list}
        #${car_element}    Get WebElement    ${car_locator}
        #Open Context Menu    ${car_element}
        Open Context Menu    ${car_list}[0]
        Handle Alert    ACCEPT
        Sleep    0.5
        ${car_list} =   Get WebElements    ${car_locator}
    END

Verify No Cars Of Make Exist
    [Arguments]    ${make}
    ${car_locator}    Set Variable    xpath=//*[@id="car-container"]//span[text()='${make}']
    Page Should Not Contain Element    ${car_locator}
    Log    No cars of make ${make} exist on the page    console=True

Generate Plate Number
    ${plate}    Evaluate    ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=3)) + '-' + ''.join(random.choices('0123456789', k=3))
    RETURN    ${plate}

Start Container
    Log     Starting container
    Run Process     docker-compose    up    --detach
    Sleep    5s

Stop Container
    Log     Stopping container
    Run Process     docker-compose    down
