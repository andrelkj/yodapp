*** Settings ***
Documentation    Test suite for character creation

Resource    ${EXECDIR}/resources/base.robot

Test Setup       Start Session
Test Teardown    End Session
Library          String

*** Test Cases ***
Should register a new character
    [Tags]    happy

    Go To User Form
    Fill User Form                Mestre Yoda                         yoda@jedi.com    Jedi    fevereiro-1970-20    @yoda
    Select Jedi                   Cavaleiro Jedi
    Check Accept comunications
    Submit User Form
    Toaster Message Should Be     Usuário Cadastrado com sucesso! 

    # Temporary
    # Sleep    5

Invalid Email
    [Tags]    inv_email

    Go To User Form
    Fill User Form                Darth Vader                   vader&hotmail.com    Sith    dezembro-1980-15    @vader
    Check Accept comunications
    Submit User Form
    Toaster Message Should Be     Oops! O email é incorreto.
