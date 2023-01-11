*** Settings ***
Documentation    Test suite to see if yodapp is online

# Importing sources from the base file
Resource    ${EXECDIR}/resources/base.robot

Test Setup       Start Session
Test Teardown    End Session

*** Test Cases ***
Yodapp should be online

    # New Browser    chromium    headless=False    slowMo=00:00:01
    # New Page    https://yodapp.vercel.app

    Get Title    equal    Yodapp | QAninja

    # Take Screenshot

Should display welcome message

    # New Browser    chromium    headless=False    slowMo=00:00:01
    # New Page    https://yodapp.vercel.app

    # Sleep    5

    # Checkpoint (confirming that we're inside the welcome page)
    Wait For Elements State
    ...                        css=.navbar-item >> text=Que a Força (qualidade) esteja com você!    
    ...                        visible                                                              5

    # Take Screenshot