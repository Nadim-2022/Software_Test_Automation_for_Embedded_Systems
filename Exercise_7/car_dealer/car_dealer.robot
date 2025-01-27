*** Settings ***
Documentation       Car dealer website test

Library             SeleniumLibrary
Library             Dialogs
Library             Process

Test Setup          Start Container
Test Teardown       Stop Container


*** Variables ***
${LOGIN URL}      http://localhost:3000
${BROWSER}        Chrome


*** Test Cases ***



*** Keywords ***



Start Container
    Log     Starting container
    Run Process     docker-compose    up    --detach

Stop Container
    Pause Execution
    Close Browser
    Run Process     docker-compose    down
