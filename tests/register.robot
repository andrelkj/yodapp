*** Settings ***
Documentation    Test suite for character creation

Resource    ${EXECDIR}/resources/base.robot

Test Setup       Start Session
Test Teardown    End Session
Library          String

*** Test Cases ***
Should register a new character
    [Tags]    happy

    &{user}     Create Dictionary
    ...         name=Mestre Yoda
    ...         email=yoda@jedi.com
    ...         ordem=Jedi
    ...         tpjedi=Cavaleiro Jedi
    ...         bdate=fevereiro-1970-20
    ...         instagram=@yoda

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

    &{user}     Create Dictionary
    ...         name=Dath Vader
    ...         email=vader&hotmail.com
    ...         ordem=Sith
    ...         bdate=dezembro-1980-15
    ...         instagram=@vader

    Go To User Form
    Fill User Form                ${user}
    Check Accept comunications
    Submit User Form
    Toaster Message Should Be     Oops! O email é incorreto.
