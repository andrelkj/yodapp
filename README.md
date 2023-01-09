# Notes

Robot is a automation testing tool

---
## Structure

To create a robot file you first need to create de file structure:

* Here we enter all information needed to run the test;

```
*** Settings ***

Documentation    Test suit to verify with app is online

Library    Browser
```

* Then you define all your test cases with all their desired running steps;


```
*** Test Cases ***

Yodapp should be online
    
New Browser    chromium    headless=False    slowMo=00:00:01 
New Page    https://yodapp.vercel.app

Get Title    equal    Yodapp | QAninja

Take Screenshot
```
Following BDD techniques from Gherking all Test Cases we'll consider all those 3 keypoints:

* <u>Preparation</u> - here you'll set all your conditions
**<p>For example:</p>**
```
# Given that the resistration form was acessed
    # Selecting the button to move to the register page
    Click    text=Novo

    # Checkpoint (confirming that we're inside the register page)
    Wait For Elements State    css=.card-header-title >> text=Cadastrar novo usuário
    ...    visible    5

```

* <u>Action</u> - here's where you'll define what actions should happen for the previous conditions, data should be entered, ...
**<p>For example:</p>**
```
# When filling in those forms with Master Yoda's data
    # Filling in the input fields
    Fill Text    css=input[placeholder^="Nome"]    Mestre Yoda
    Fill Text    css=input[placeholder="Email"]    yoda@gmail.com

    # Entering a option in the selection field
    Select Options By    css=.ordem select    value    1 

    # Selecting the radio buttom
    Click    xpath=//input[@value="Cavaleiro Jedi"]/..//span[@class="check"]
    
    # Entering datepicker information
    Select Birth Date    fevereiro    1970    20
    
    # Filling in the input fields, moved down here to follow the fields entering order
    Fill Text    id=insta    @yoda   

    # Selecting the checkbox
    Click    xpath=//input[@name="comunications"]/../span[@class="check"]

# And submit this form
    # Selecting the submition button
    Click    css=button >> text="Cadastrar"
```

* <u>Result</u> - here's where the results of all defined actions will be shown
**<p>For example:</p>**
```
# Then I should see the success message
    # Checkpoint (validating toaster)
    Wait For Elements State    text="Usuário cadastrado com sucesso!"    visible    5     
```

**OBS.:** Using only the text from the toaster as selector isn't the better option. To create a better selector follow the "dealing with toarters steps" down below.

---
## Toasters - dealing with toasters

Toasters are temporary messages displayed inside the page after an action or validation. As they're temporary it's hard to inspect them and sometimes it makes impossible to find those elements while running the application.

To deal with those elements use the following steps:
1. Add a break/sleep while getting the html code used for this page and show this code;
```
Sleep       1
${html}     Get Page Source
Log         ${html}
```

2. Create a temporary file to copy/paste this html code, for example: temp.html;
**OBS.:** you'll need to run the test first in order to show the log

3. Find the displayed text/message/toast element inside the previous file containing the html code;

![Element toaster inside html code](./Screenshots/Screenshot%202023-01-07%20at%2019.08.38.png)

4. Create the necessary selectors in order to find this element inside the page.
```
Wait For Elements State     css=.toast div >> text="Usuário cadastrado com sucesso!"    visible     5
```

---
## Locators - Finding elements

Locators are used to find elements inside the page

```
css=.navbar-item
```

In robot framework it's possible to combine different selector types in order to find a specific element.

**Ex.:** using css element selector and text locator as well
```
css=.navbar-item >> text=Que a Força (qualidade) esteja com você!
```

It is recommended to prioritize using CSS selector first and then using XPath only if there's no other option.

---
## Hooks and Encapsulation

Personalised keywords can be defined inside robot to decrease repeated code

To use this function first you need to create the keywords:

```
*** Keywords ***
Start Sessions
    New Browser    chromium    headless=False    slowMo=00:00:01 
    New Page    https://yodapp.vercel.app

End Section
    Take Screenshot
```

And then define them inside *** Setting *** tab to define where they'll be calledduring a defined step of the test:

```
*** Settings ***

Test Setup  Start Session
Test Teardown   End Session
```

These keywords can be reused by putting it inside a new file that will contain only those global functions (in this case the file _base.robot_)

---
## base.robot

Here we're going to define all primary characteristics, and then we're going to import those functions to all the other files and test cases. This is usefull to reduce repetitive elements.

For example:

Defining a library from where the functions will come and them defining what should be done while start and end session should do when called during the test cases.

```
*** Settings ***
Documentation    This isn't a test suite, but the primary file of the project

Library    Browser

*** Keywords ***
Start Session
    New Browser    chromium    headless=True   slowMo=00:00:01 
    New Page    https://yodapp.vercel.app

End Session
    Take Screenshot
```

By doing this we don't need to add those same keywords again individually into all the other files, instead we just need to reference the file that contains this information (in this case the file base.robot) inside the files that will use it.

```
Resource    base.robot
```

---
## register.robot

Everytime you change to a new page it's nice to define a checkpoint to make sure you're in the right path

```
# Checkpoint (confirming that we're inside the register's page)
Wait For Elements State    css=.card-header-title >> text=Cadastrar novo usuário
...    visible    5
```

* If a specific element don't have any other properties outside for the element itself it's possible to use the father element
- Example:
    - The select element have no additional properties for selection so we'll look for the father elements (div data-v-e59530da class="control ordem is-expanded has-icons-left") for a better element selection.

![Element without properties](./Screenshots/Screenshot%202023-01-06%20at%2001.08.03.png)

**OBS.:** span element only have the class property so it isn't the better option as well.

* How to use the father element to increase specificity:
    1. Find a father element - div data-v-e59530da class="control ordem is-expanded has-icons-left"
    2. Select this element - .ordem
    3. Inform the specific desired element inside of it - .ordem select

Now you have a better selector, and need to inform which option to select:

* index - the first option is by using the property index and giving the item position stating from 0 to the first one
```
index   0
```
* label - when present you can also use the property label giving it's defined label
* value - here you give the direct defined item value 
```
value   1
```
* text - here you give the direct defined item text
```
text    Jedi
```

**OBS.:** consider prioritizing the usage of value and text properties.

---
## Datepicker

For the date picker we'll need four steps:

1. Click field
2. Select month
3. Select year
4. Select day

**OBS.:** this datepicker don't accept you to enter any information inside of it by typing so the function Fill Text won't work.

Again the month dropdown element don't have any useful property so we're going to use it's father element header class="datepicker-header". In this case selecting it with Xpath instead of CSS selector.

To start the Xpath first we use // and then the following path, for example:

```
(//header[@class="datepicker-header"]//select)[1]
```

**OBS.:** (xpath)[1] is used to make the selector consider the first xpath found with those properties. This can be used to filter elements with the same name per order of apperance, starting with 1, 2, 3 and so on

---
## Radio button and Checkbox

While trying to select or find Radio button elements it's important to keep in mind if the button is visible or hidded. Some times this elements are set as hidden in order to apply style to it. 
* For example:
    - input type="radio" name="tipo-jedi" value="Cavaleiro Jedi" is being hidded behind the label data-v-e59530da="" class="b-radio radio" although the clicking action is defined in the element span class="check"

![Hidded element to apply style](./Screenshots//Screenshot%202023-01-07%20at%2002.37.17.png)

To solve this will proceed with the following steps:
1. Look for a possible xpath to replace the CSS selector;
2. Find the element responsible for the click action;
3. Write the xpath that'll lead to it

```
xpath=//input[@value="Cavaleiro Jedi"]/..//span[@class="check"]
```

4. Test and adjust your path until it's unique;
5. Add it to the click function.

```
Click    xpath=//input[@value="Cavaleiro Jedi"]/..//span[@class="check"]
```

**OBS.:** note that you can use ../ to go up some layers inside parent elements and // to go down again.

---
## Practicing

Submitting register information.

There's many options to select this button:

* My response was using xpath to find the button, using only it's tag:
```
xpath=//button
```

It works but isn't the best option to use because there can be added new buttons to the code and it'll broke.

* A better option is to combine selectors using the element tag and also the displayed button text:

```
css=button >> text="Cadastrar"
```

This is a better option because it's format uses more properties, making the element search more specific.

---
## Keywords

* **_headless_** - receive <u>"true" or "false"</u> to show the page while running the test
* **_slowMoo_** - receice a <u>time - hh:mm:ss</u> to slow down the run
* **_visible_** - consider that the element should be visible
* **_timeout_** - defines the maximum time to find the element 
* **_>>_** - informs combinations of selectors
* **_sleep_** - makes the script sleep/stop for defined time (5 seconds in this case)
* **_wait_** - wait some time until the element is present
* **_Test Setup_** - Used to apply a defined behavior before the test case 
* **_Test Teardown_** - Used to apply a defined behavior after the test case
* **_css=_** - used as css selector to find a css elements
* **_text=_** - used to find defined texts inside elements from css
* **_..._** - make possible to break arguments in different lines inside the same function
* **_index_** - follow a defined ordem (indexation)
* **_click_** - select the defined element


**OBS.:** using wait instead of sleep is the best practice once the element can be found before 5 seconds, giving you time gains in comparison with the sleep function.

---
## Terminal commands

* **_robot -d ./logs online.robot_** - will tell robot to run the described file and them save the retuned outputs inside a new directory, in this case named logs (./ is used to create the directory inside the actual directory - Yodapp)

---
## Devtools regular expressions

* **_.classname_** - search for a class
* **_*_** - used while searching for elements to filter for all the elements that contains this variable instead of those exactly equal to it. 
<br>**<u>Ex.:</u>** 
    - a[href=/new] - here we're looking for an element 'a' that contains a 'href' with the exact content of '/new'
    - a[href*=new] - here we'll look for a element 'a' with a 'href' that contains the argument 'new' inside of it
* **_^_** - filter for all elements that starts with the defined argument

---
## Important links

* [Course pathway](https://app.qacademy.io/area/produto/item/148964)
* [App used for testing](https://yodapp.vercel.app/)
* [Xpath cheatsheed](https://devhints.io/xpath)
* [Robot Browser Library Guide](https://marketsquare.github.io/robotframework-browser/Browser.html?_gl%3D1%2A15e6l3s%2A_ga%2AMTU1ODkzMjgxMi4xNjcyNzE4Njcy%2A_ga_37GXT4VGQK%2AMTY3MjkzODQyOC41LjEuMTY3MjkzODQ4Ni4wLjAuMA..)
