*** Settings ***
Documentation    Test suite for character creation

Library     ${EXECDIR}/resources/factories/users.py

Resource    ${EXECDIR}/resources/base.robot

Test Setup       Start Session
Test Teardown    End Session
Library          String

*** Test Cases ***
Should register a new character
    [Tags]    happy

    # user here isn't a super variable anymore so we need to change the & to a $, once all test mass is now containing inside the keywork Factory Yoda which is now our new super variable
    &{user}     Factory Yoda

    Go To User Form
    Fill User Form                ${user}
    Select Jedi                   ${user}[tpjedi]
    Check Accept comunications
    Submit User Form
    Toaster Message Should Be     Usuário Cadastrado com sucesso! 

    # Temporary
    # Sleep    5

Invalid Email
    [Tags]    inv_email

    # user here isn't a super variable anymore so we need to change the & to a $, once all test mass is now containing inside the keywork Factory Darth Vader which is now our new super variable
    ${user}     Factory Darth Vader

    Go To User Form
    Fill User Form                ${user}
    Check Accept comunications
    Submit User Form
    Toaster Message Should Be     Oops! O email é inválido.
