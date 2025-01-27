*** Settings ***
Documentation       Lab 8: Car dealer website test
Library             SeleniumLibrary
Library             Dialogs
Library             Process

*** Variables ***
${URL}      http://localhost:3000
${BROWSER}  Chrome
${PLATE_TO_REMOVE}  ABC-123
@{CAR_MAKES}        Toyota    Honda    Ford    Mazda    Nissan
@{CAR_MODELS}       Corolla    Civic    Focus    Passat    Altima

*** Test Cases ***
Lab 8: Car Dealer Test
    Start Container
    [Setup]    Set Selenium Speed   0.1
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Car store

    Add Random Cars    3
    Add Random Cars    1    ${PLATE_TO_REMOVE}
    Add Random Cars    2

    Capture Page Screenshot    car_store_after_add.png

    Remove Car With Specific Plate    ${PLATE_TO_REMOVE}
    Verify Car Does Not Exist    ${PLATE_TO_REMOVE}

    Capture Page Screenshot    car_store_after_removal.png

    [Teardown]    Close Browser
    Stop Container

*** Keywords ***
Add Random Cars
    [Arguments]    ${count}    ${plate}=None
    FOR    ${i}    IN RANGE    ${count}
        ${make}    Evaluate    random.choice(${CAR_MAKES})
        ${model}    Evaluate    random.choice(${CAR_MODELS})
        ${mileage}  Evaluate    random.randint(1000, 30000)
        ${year}     Evaluate    random.randint(2015, 2022)
        IF    '${plate}' == 'None'
            ${plate}    Generate Plate Number
        END
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

Remove Car With Specific Plate
    [Arguments]    ${plate}
    ${car_locator}    Set Variable    xpath=//*[@id="car-container"]//span[text()='${plate}']
    Wait Until Element Is Visible    ${car_locator}
    Open Context Menu    ${car_locator}
    Handle Alert    ACCEPT
    Wait Until Page Does Not Contain Element    ${car_locator}

Verify Car Does Not Exist
    [Arguments]    ${plate}
    Page Should Not Contain Element    xpath=//*[@id="car-container"]//span[text()='${plate}']
    Log    Car with plate ${plate} does not exist on the page    console=True

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
