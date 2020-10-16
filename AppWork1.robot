*** Settings ***
Library           SeleniumLibrary
Library           String
Library           OperatingSystem
Library           Collections

*** Variables ***
${varPart1}       //*[@id="hz-page-content-wrapper"]/div/main/div[2]/ul/li[    # parte uno de busqueda dinamica nombres
${varPart2}       ]/div[1]/div[2]/div[1]/div[1]/div[2]/a/span    # parte dos de busqueda dinamica nombres
${iteracionPag}    10    # paginacion
${indicePag}      20    # indice de paginador inicial a este se suma 1

*** Test Cases ***
Work1
    Keyword 1
    Open Browser    https://www.houzz.com/professionals/architect/c/Miami--FL/p/150    chrome
    Sleep    5s
    Input Text    xpath=(//input[@class="hz-header__search-bar__input"])[2]    architects miami
    Sleep    3s
    Click Element    //button[@class="hz-header__search-bar__submit hz-header__search-icon icon-font icon-magnifying_glass"]
    Sleep    3s
    Get title for loop    1    2
    [Teardown]    Close Browser

WorkFindGoogle
    [Tags]    test text
    FileUrl
    ${TextFileContent}=    Get File    C:/temp/robot_test/test1.txt
    Log    ${TextFileContent}
    @{account}=    Split to lines    ${TextFileContent}
    : FOR    ${line}    IN ZIP    ${account}
    \    Find in google    ${line}
    \    log    account: ${line}

*** Keywords ***
Keyword with for loop
    [Arguments]    ${textCabecera}    ${z}
    Log    ${textCabecera}
    Log    ${z}
    : FOR    ${y}    IN RANGE    1    10
    \    Comment    Another keyword with loop    ${textCabecera}    ${y}

Another keyword with loop
    [Arguments]    ${x}    ${y}
    : FOR    ${z}    IN    1    2    3
    Log    ${x}

Change page for loop
    [Arguments]    ${a}    ${b}
    Log    ${a}
    Log    ${b}
    Sleep    5s
    Log    Esprando 3 segundos para pasar a otra pagina
    : FOR    ${y}    IN RANGE    4    100
    \    ${STRING_PAGE}=    Catenate    //*[@id="hz-page-content-wrapper"]/div/main/div[2]/div[2]/div/div/a[${y}]
    \    Log    ${STRING_PAGE}
    \    Log    ${y}
    \    Click Element    //*[@id="hz-page-content-wrapper"]/div/main/div[2]/div[2]/div/div/a[10]

Get title for loop
    [Arguments]    ${a}    ${b}
    ${count}    Get Element Count    //span[@class=" btn__label "]
    Log    ${count}
    ${setCount}=    Evaluate    ${count}+1
    : FOR    ${Counter}    IN RANGE    1    ${setCount}
    \    ${RANDOM_STRING}=    Catenate    ${varPart1}${Counter}${varPart2}
    \    ${textCabecera}    Get Text    ${RANDOM_STRING}
    \    @{items}=    Create List    ${textCabecera}
    \    Append To File    C:/temp/robot_test/test1.txt    ${textCabecera}\n
    \    Keyword with for loop    ${textCabecera}    2
    \    Exit For Loop If    ${Counter} == ${setCount}
    \    Log    ${Counter}
    Log    Exited

Keyword 1
    ${now}    Evaluate    '{dt.day}/{dt.month}/{dt.year}'.format(dt=datetime.datetime.now())    modules=datetime
    Create File    C:/temp/robot_test/title.txt    ${now}\n    encoding=UTF-8

FileUrl
    ${now}    Evaluate    '{dt.day}/{dt.month}/{dt.year}'.format(dt=datetime.datetime.now())    modules=datetime
    Create File    C:/temp/robot_test/url.txt    ${now}\n    encoding=UTF-8

Split to Lines and Remove Header
    [Arguments]    ${FILE_CONTENT}
    @{LINES}=    Split To Lines    ${FILE_CONTENT}
    Remove From List    ${LINES}    0
    [Return]    @{LINES}

Find in google
    [Arguments]    ${a}
    Sleep    3s
    Comment    Input Text    //*[@id="tsf"]/div[2]/div[1]/div[1]/div/div[2]/input    ${a}
    Comment    Click Element    //*[@id="tsf"]/div[2]/div[1]/div[3]/center/input[1]
    Open Browser    https://www.google.com/search?q=${a}    chrome
    Sleep    2s
    ${textUrl}    Get Text    //*[@id="rso"]/div[1]/div/div/div/div/div[1]/a[1]/div/cite
    Append To File    C:/temp/robot_test/url.txt    ${textUrl}\n
    Sleep    2s
    [Teardown]    Close Browser
