*** Settings ***
Documentation    Test suite for character creation

Resource    ${EXECDIR}/resources/base.robot

Test Setup    Start Session
Test Teardown    End Session
Library    String

*** Test Cases ***
Should register a new character
    [Tags]    happy

# Given that the resistration form was acessed
    # Selecting the button to move to the register page
    Click    text=Novo

    # Checkpoint (confirming that we're inside the register page)
    Wait For Elements State    css=.card-header-title >> text=Cadastrar novo usuário
    ...    visible    5

# When filling in those forms with Master Yoda's data
    # Filling in the input fields
    Fill Text    css=input[placeholder^="Nome"]    Mestre Yoda
    Fill Text    css=input[placeholder="Email"]    yoda@gmail.com

    # Entering a option in the selection field
    Select Options By    css=.ordem select    value    1 

    # Selecting the radio buttom
    Click    xpath=//input[@value="Cavaleiro Jedi"]/..//span[@class="check"]
    
    # Entering datepicker information
    Select Birth Date    fevereiro-1970-20
    
    # Filling in the input fields, moved down here to follow the fields entering order
    Fill Text    id=insta    @yoda   

    # Selecting the checkbox
    Click    xpath=//input[@name="comunications"]/../span[@class="check"]

# And submit this form
    # Selecting the submition button
    Click    css=button >> text="Cadastrar"

# Then I should see the success message
    # Accessing html code source to create a proper locator for the toaster
    # Sleep    1
    # ${html}    Get Page Source
    # Log    ${html}

    # Checkpoint (validating toaster)
    Wait For Elements State    css=.toast div >> text="Usuário cadastrado com sucesso!"    visible     5    

    # Temporary
    # Sleep    5  

Invalid Email
    [Tags]    inv_email

# Given that the resistration form was acessed
    # Selecting the button to move to the register page
    Click    text=Novo

    # Checkpoint (confirming that we're inside the register page)
    Wait For Elements State    css=.card-header-title >> text=Cadastrar novo usuário
    ...    visible    5

# When filling in those forms with an invalid email
    # Filling in the input fields
    Fill Text    css=input[placeholder^="Nome"]    Darth Vader
    Fill Text    css=input[placeholder="Email"]    vader&gmail.com

    # Entering a option in the selection field
    Select Options By    css=.ordem select    value    2 
    
    # Entering datepicker information
    Select Birth Date    dezembro-1980-15
    
    # Filling in the input fields, moved down here to follow the fields entering order
    Fill Text    id=insta    @vader   

    # Selecting the checkbox
    Click    xpath=//input[@name="comunications"]/../span[@class="check"]

# And submit this form
    # Selecting the submition button
    Click    css=button >> text="Cadastrar"

# Then I should see the success message
    # Accessing html code source to create a proper locator for the toaster
    # Sleep    1
    # ${html}    Get Page Source
    # Log    ${html}

    # Checkpoint (validating toaster)
    Wait For Elements State    css=.toast div >> text="Oops! O email é incorreto."    visible     5    

*** Keywords ***
Select Birth Date
    # Defining entry arguments whom will be used inside the function instead of having to manually add each one of them
    [Arguments]    ${text_date}

    @{date}    Split String    ${text_date}    -

    Click    css=input[placeholder="Data de nascimento"]

    Select Options By    xpath=(//header[@class="datepicker-header"]//select)[1]
    ...    text    ${date}[0]

    Select Options By    xpath=(//header[@class="datepicker-header"]//select)[2]
    ...    value    ${date}[1]

    Click    xpath=//a[contains(@class, "datepicker-cell")]//span[text()="${date}[2]"]