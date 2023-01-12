*** Settings ***
Documentation    Customized Yodapp actions

*** Keywords ***
Go To Home Page
    Go To    ${BASE_URL}

    # Checkpoint (confirming that we're inside the home page)
    Wait For Elements State    css=.carousel    visible    5

Go To User Form

# Given that the resistration form was acessed
    # Selecting the button to move to the register page
    Click    text=Novo

    # Checkpoint (confirming that we're inside the register page)
    Wait For Elements State    css=.card-header-title >> text=Cadastrar novo usuário
    ...                        visible                                                  5

# Filling user forms dinamically
Fill User Form
    [Arguments]    ${user}

# When filling in those forms with Master Yoda's data
    # Filling in the input fields
    Fill Text    css=input[name="nome"]     ${user}[name]
    Fill Text    css=input[name="email"]    ${user}[email]

    # Entering a option in the selection field
    Select Options By    css=.ordem select    text    ${user}[ordem]

    # Entering datepicker information
    Select Birth Date    ${user}[bdate]

    # Filling in the input fields, moved down here to follow the fields entering order
    Fill Text    id=insta    ${user}[instagram]    

# Selecting radio buttons dinamically
Select Jedi
    [Arguments]    ${tpjedi}

    # Selecting the radio buttom
    Click    xpath=//input[@value="${tpjedi}"]/..//span[@class="check"]

# Selecting checkboxes dinamically
Check Accept comunications
    # Selecting the checkbox
    Click    xpath=//input[@name="comunications"]/../span[@class="check"]

Select Birth Date
    # Defining entry arguments whom will be used inside the function instead of having to manually add each one of them
    [Arguments]    ${text_date}

    @{date}    Split String    ${text_date}    -

    Click    css=input[name="Data de nascimento"]

    Select Options By    xpath=(//header[@class="datepicker-header"]//select)[1]
    ...                  text                                                       ${date}[0]

    Select Options By    xpath=(//header[@class="datepicker-header"]//select)[2]
    ...                  value                                                      ${date}[1]

    Click    xpath=//a[contains(@class, "datepicker-cell")]//span[text()="${date}[2]"]

Submit User Form
# And submit this form
    # Selecting the submition button
    Click    css=button >> text="Cadastrar"

Toaster Message Should Be
    [Arguments]    ${expected_message}

# Then I should see the success message
    # Accessing html code source to create a proper locator for the toaster
    # Sleep    1
    # ${html}    Get Page Source
    # Log    ${html}

    ${element}    Set Variable    css=.toast div 

    # Checkpoint (validating toaster)
    Wait For Elements State    ${element}    visible    5                      
    Get Text                   ${element}    equal      ${expected_message}

User Should Be Visible
    [Arguments]    ${user}

    ${element}    Set Variable    xpath=//td[contains(text(),"${user}[email]")]/..

    # Adding a checkpoint to validate other elements as well
    Wait For Elements State    ${element}    visible     5
    Get Text                   ${element}    contains    ${user}[name]
    Get Text                   ${element}    contains    ${user}[instagram]


