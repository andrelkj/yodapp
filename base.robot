*** Settings ***
Documentation    This isn't a test suite, but the primary file of the project

Library    Browser

*** Keywords ***
Start Session
    New Browser    chromium    headless=False   slowMo=00:00:01 
    New Page    https://yodapp.vercel.app

End Session
    Take Screenshot