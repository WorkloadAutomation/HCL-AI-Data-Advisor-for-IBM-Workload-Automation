<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false showAnotherWayIfPresent=true>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="${properties.kcHtmlClass!}">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body class="${properties.kcBodyClass!}">
<div class="${properties.kcLoginClass!}">
    <div id="kc-header">
        <header class="hcl-header" data-withsidenav="true">
            <span class="hcl-header-brand" tabindex="0">
                <img style="width:200px"
                    src="data:image/svg+xml;base64,
                        PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48c3ZnIGlkPSJMYXllcl8xIiB4
                        bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA4NDEuODUgMTgz
                        LjIiPjxkZWZzPjxzdHlsZT4uY2xzLTF7ZmlsbDojZmZmO308L3N0eWxlPjwvZGVmcz48Zz48cGF0
                        aCBjbGFzcz0iY2xzLTEiIGQ9Ik0xMDIuMDcsNDguMTZ2MzYuMDJoLTM3LjU4VjQ4LjE2aC0xOS40
                        M3Y5MC42OWgxOS40M3YtMzcuOTZoMzcuNTh2MzcuOTZoMTkuNDNWNDguMTZoLTE5LjQzWiIvPjxw
                        YXRoIGNsYXNzPSJjbHMtMSIgZD0iTTI0NS41MSwxMjJWNDguMTZoLTE5LjQ1VjEyMi4yN2MwLDEw
                        Ljc2LDUuODUsMTYuNTksMTYuNTksMTYuNTloNDQuMTl2LTE2Ljg2aC00MS4zM1oiLz48cGF0aCBj
                        bGFzcz0iY2xzLTEiIGQ9Ik0xMzMuNjksOTIuNTVjMC0zMC41MiwxOS43Mi00Ni4zLDQyLjIxLTQ2
                        LjMsMjEuMTcsMCwzNi42OCwxMi45MywzOC45NywzMi40NmgtMTguODhjLTEuMi05LjQ0LTkuNS0x
                        NS43OC0yMC4wOS0xNS43OC0xMy41OSwwLTI0LjA1LDEwLjIyLTI0LjA1LDI5LjYxczEwLjQ2LDI5
                        LjQ4LDI0LjA1LDI5LjQ4YzEwLjgyLDAsMTkuMTItNi4zNCwyMC41Ny0xNS42NWgxOC4wNGMtMS41
                        NiwxOS40LTE3LjA4LDMyLjQ2LTM4LjYxLDMyLjQ2LTIyLjg1LDAtNDIuMjEtMTUuNzgtNDIuMjEt
                        NDYuM1oiLz48L2c+PGc+PHBhdGggY2xhc3M9ImNscy0xIiBkPSJNMjkzLjc1LDEwNi43NWgyMi4w
                        MmMuNTIsNy42NCw1LjcsMTIuNTcsMTMuNDcsMTIuNTcsNi44NywwLDExLjI3LTMuMjQsMTEuMjct
                        OC4yOSwwLTE1LjI5LTQ0LjQ0LTEuNDMtNDQuNDQtMzguMzUsMC0xNS40MiwxMy4yMi0yNi40Mywz
                        MS43NC0yNi40MywyMC4yMSwwLDMzLjU2LDExLjUzLDMzLjgxLDI5LjI4aC0yMS43N2MtLjUyLTUu
                        ODMtNC45Mi05LjU5LTEyLjA1LTkuNTktNS43LDAtOS40NiwyLjcyLTkuNDYsNi43NCwwLDE2Ljk3
                        LDQ1LjIyLDEuMyw0NS4yMiwzNy45NiwwLDE3LjIzLTEzLjQ3LDI4LjM3LTM0LjMzLDI4LjM3cy0z
                        NC44NS0xMi43LTM1LjUtMzIuMjZaIi8+PHBhdGggY2xhc3M9ImNscy0xIiBkPSJNNTUwLjQ4LDEz
                        OC44N2gxOC4yN2wxMC4zNi0zNS44OSwxMC4xMSwzNS44OWgxOC4yN2wyMS43Ny02NS4zaC0yMS4z
                        OGwtOS41OSwzNS4zNy05LjcyLTM1LjM3aC0xOS4xN2wtOS41OSwzNS4zNy05LjcyLTM1LjM3aC0z
                        Ni41NXYtMjguNDVoLTIxLjM4djI4LjQ1aC0yNC4zOXYtMTAuOTVoMTcuODh2LTE3LjUxaC0yMy40
                        NWMtOS4zMywwLTE1LjgxLDYuMzctMTUuODEsMTUuN3YxMi43NmgtMTQuNzh2MTEuOWMtNi4xNC04
                        LjUzLTE2LjM2LTEzLjc3LTI4Ljc1LTEzLjc3LTIwLjM0LDAtMzQuOTgsMTQuMzgtMzQuOTgsMzMu
                        NjlzMTQuNjQsMzMuNjksMzQuOTgsMzMuNjksMzQuOTgtMTQuMzgsMzQuOTgtMzMuNjljMC01LjEt
                        MS4wMi05Ljg2LTIuOS0xNC4xbDExLjQ1LC4wMnY0Ny41NmgyMS4zOHYtNDcuNjhoMjQuMzl2MzEu
                        ODdjMCwxMC4xMSw1LjcsMTUuODEsMTUuODEsMTUuODFoMjIuMDN2LTE3LjYyaC0xNi40NXYtMzAu
                        MDZoMTYuMXYtMTUuMTRsMjAuODQsNjIuODFabS0xNDcuNjEtMTcuOTRjLTguMTYsMC0xMy42LTYu
                        MjItMTMuNi0xNS41NXM1LjQ0LTE1LjU1LDEzLjYtMTUuNTUsMTMuNiw2LjIyLDEzLjYsMTUuNTUt
                        NS40NCwxNS41NS0xMy42LDE1LjU1WiIvPjxwYXRoIGNsYXNzPSJjbHMtMSIgZD0iTTYyOC4xNiwx
                        MTkuNTJjMC0xMi44Myw5LjMzLTIwLjYsMjMuMDYtMjAuNmg5LjMzYzMuMzcsMCw1LjE4LTIuMzMs
                        NS4xOC01LjQ0LDAtMy44OS0zLjI0LTYuNjEtOS4wNy02LjYxLTcuMTMsMC05LjcyLDQuNDEtOS44
                        NSw5LjA3aC0xOC42NmMuNTItMTMuMjIsMTAuNDktMjQuMjMsMjkuOC0yNC4yMywxNi4zMiwwLDI5
                        LjAyLDkuNTksMjkuMDIsMjQuMzZ2NDIuNzdoLTIxLjI1di04LjgzYy0xLjY4LDUuNDQtOC4yOSw5
                        LjA3LTE2LjcxLDkuMDctMTIuMTgsMC0yMC44Ni04LjY4LTIwLjg2LTE5LjU2Wm0yNi44Miw0LjY2
                        YzYuODcsMCwxMC43NS01LjcsMTAuNzUtMTEuNzl2LS41MmgtMTAuODhjLTMuNzYsMC02LjQ4LDIu
                        NzItNi40OCw2LjYxLDAsMy4zNywyLjg1LDUuNyw2LjYxLDUuN1oiLz48cGF0aCBjbGFzcz0iY2xz
                        LTEiIGQ9Ik03MzMuNzYsOTEuMjljLTEuODEsNC41Ny0yLjY1LDkuNDctMi42NSwxNC4wOSwwLDE1
                        LjQyLDEwLjYyLDMzLjY5LDM0LjA3LDMzLjY5LDE2LjA3LDAsMjguODktOS4yLDMxLjYxLTIzLjcx
                        aC0yMC42Yy0xLjE3LDQuNDEtNS4xOCw2LjQ4LTExLjAxLDYuNDgtNy43NywwLTEyLjMxLTQuMTUt
                        MTMuNi0xMS40aDQ0Ljk2Yy4xMy0xLjU1LC4yNi0zLjM3LC4yNi02LjM1LDAtMTMuNzMtOC4xNi0z
                        Mi4zOS0zMi45MS0zMi4zOS0xMi4xMiwwLTIwLjQ3LDQuODgtMjUuNzEsMTEuNzJ2LTkuODVoLTI4
                        Ljc2Yy05LjMzLDAtMTUuODEsNi40OC0xNS44MSwxNS44MXY0OS40OWgyMS4zOHYtNDcuNTloMTgu
                        NzZabTMwLjEyLTQuNDNjNy4zOCwwLDExLjQsNS4zMSwxMS43OSwxMC44OGgtMjQuMWMxLjQzLTcu
                        OSw1LjQ0LTEwLjg4LDEyLjMxLTEwLjg4WiIvPjwvZz48L3N2Zz4="
                    alt="product logo"
                />
            </span>
        </header>        
    </div>

    <div class="centered-card">
        <div class="${properties.kcFormCardClass!}">
            <header class="${properties.kcFormHeaderClass!}">
                <#if realm.internationalizationEnabled  && locale.supported?size gt 1>
                    <div class="${properties.kcLocaleMainClass!}" id="kc-locale">
                        <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                            <div id="kc-locale-dropdown" class="${properties.kcLocaleDropDownClass!}">
                                <a href="#" id="kc-current-locale-link">${locale.current}</a>
                                <ul class="${properties.kcLocaleListClass!}">
                                    <#list locale.supported as l>
                                        <li class="${properties.kcLocaleListItemClass!}">
                                            <a class="${properties.kcLocaleItemClass!}" href="${l.url}">${l.label}</a>
                                        </li>
                                    </#list>
                                </ul>
                            </div>
                        </div>
                    </div>
                </#if>
                
            <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
                <#if displayRequiredFields>
                    <div class="${properties.kcContentWrapperClass!}">
                        <div class="${properties.kcLabelWrapperClass!} subtitle">
                            <span class="subtitle"><span class="required">*</span> ${msg("requiredFields")}</span>
                        </div>
                        <div class="col-md-10">
                            <h1 id="kc-page-title"><#nested "header"></h1>
                        </div>
                    </div>
                <#else>
                    <img style = "display: block; margin-left: auto; margin-right: auto; width: 30%;"
                        src=" data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHZpZXdCb3g9IjAgMCA3MTQuMzMgNzE0LjMzIj48ZGVmcz48c3R5bGU+Lmd7ZmlsbDp1cmwoI2UpO30uZywuaCwuaXtmaWxsLXJ1bGU6ZXZlbm9kZDt9Lmh7ZmlsbDp1cmwoI2QpO30uaXtmaWxsOnVybCgjYyk7fTwvc3R5bGU+PGxpbmVhckdyYWRpZW50IGlkPSJjIiB4MT0iMzgyLjkyIiB5MT0iNDIxLjU5IiB4Mj0iMzgyLjU5IiB5Mj0iNjAyLjM0IiBncmFkaWVudFRyYW5zZm9ybT0ibWF0cml4KDEsIDAsIDAsIDEsIDAsIDApIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHN0b3Agb2Zmc2V0PSIuMzciIHN0b3AtY29sb3I9IiMwMGJlZWUiLz48c3RvcCBvZmZzZXQ9Ii40NyIgc3RvcC1jb2xvcj0iIzAwYjVlNyIvPjxzdG9wIG9mZnNldD0iLjYzIiBzdG9wLWNvbG9yPSIjMDA5ZWQ2Ii8+PHN0b3Agb2Zmc2V0PSIuODIiIHN0b3AtY29sb3I9IiMwMDc4YmIiLz48c3RvcCBvZmZzZXQ9IjEiIHN0b3AtY29sb3I9IiMwMDUyOWYiLz48L2xpbmVhckdyYWRpZW50PjxsaW5lYXJHcmFkaWVudCBpZD0iZCIgeDE9IjQwNi41MSIgeTE9IjE0OS42OSIgeDI9IjE0NC42OSIgeTI9IjU4OC43NCIgZ3JhZGllbnRUcmFuc2Zvcm09Im1hdHJpeCgxLCAwLCAwLCAxLCAwLCAwKSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiPjxzdG9wIG9mZnNldD0iLjE5IiBzdG9wLWNvbG9yPSIjMDBiZWVlIi8+PHN0b3Agb2Zmc2V0PSIuMzQiIHN0b3AtY29sb3I9IiMwMGI5ZWIiLz48c3RvcCBvZmZzZXQ9Ii41IiBzdG9wLWNvbG9yPSIjMDBhZGUyIi8+PHN0b3Agb2Zmc2V0PSIuNjYiIHN0b3AtY29sb3I9IiMwMDk5ZDMiLz48c3RvcCBvZmZzZXQ9Ii44MSIgc3RvcC1jb2xvcj0iIzAwN2RiZSIvPjxzdG9wIG9mZnNldD0iLjk3IiBzdG9wLWNvbG9yPSIjMDA1OWE0Ii8+PHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDA1MjlmIi8+PC9saW5lYXJHcmFkaWVudD48bGluZWFyR3JhZGllbnQgaWQ9ImUiIHgxPSIzMTEuOTciIHkxPSI1OC4wMyIgeDI9IjY0Mi41NCIgeTI9IjYyNy42NiIgZ3JhZGllbnRUcmFuc2Zvcm09Im1hdHJpeCgxLCAwLCAwLCAxLCAwLCAwKSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiPjxzdG9wIG9mZnNldD0iLjA3IiBzdG9wLWNvbG9yPSIjMDBiZWVlIi8+PHN0b3Agb2Zmc2V0PSIuMjMiIHN0b3AtY29sb3I9IiMwMGIyZTUiLz48c3RvcCBvZmZzZXQ9Ii41MiIgc3RvcC1jb2xvcj0iIzAwOTJjZCIvPjxzdG9wIG9mZnNldD0iLjkxIiBzdG9wLWNvbG9yPSIjMDA1ZmE4Ii8+PHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDA1MjlmIi8+PC9saW5lYXJHcmFkaWVudD48L2RlZnM+PGcgaWQ9ImEiLz48ZyBpZD0iYiI+PGc+PHBvbHlnb24gY2xhc3M9ImkiIHBvaW50cz0iNDc2LjYyIDU5NC40NyA0MjcuOTkgNTEwLjM0IDMzOC42MyA1MTAuMTQgMjg4LjU5IDU5NC4xNSA0NzYuNjIgNTk0LjQ3Ii8+PHBvbHlnb24gY2xhc3M9ImgiIHBvaW50cz0iMjg3LjU5IDI2Ny4wNyA5Mi40MSA1OTQuMjUgMTkwLjQgNTk0LjI1IDMzNS43NSAzNTAuNTEgMjg3LjU5IDI2Ny4wNyIvPjxwb2x5Z29uIGNsYXNzPSJnIiBwb2ludHM9IjM4Ni4zNyAxMDEuNDggMzM2Ljk4IDE4NC4yOSA1MjUuMjkgNTEwLjM5IDYyMi42MSA1MTAuNjMgMzg2LjM3IDEwMS40OCIvPjwvZz48L2c+PGcgaWQ9ImYiLz48L3N2Zz4="
                        alt="AIDA logo"
                    />
                    <h1 class="aida-header aida-title"> HCL AI DATA ADVISOR (AIDA) Master </h1>
                    <h4 class="aida-header aida-subtitle" >FOR HCL WORKLOAD AUTOMATION</h4>
                </#if>
            <#else>
                <#if displayRequiredFields>
                    <div class="${properties.kcContentWrapperClass!}">
                        <div class="${properties.kcLabelWrapperClass!} subtitle">
                            <span class="subtitle"><span class="required">*</span> ${msg("requiredFields")}</span>
                        </div>
                        <div class="col-md-10">
                            <#nested "show-username">
                            <div id="kc-username" class="${properties.kcFormGroupClass!}">
                                <label id="kc-attempted-username">${auth.attemptedUsername}</label>
                                <a id="reset-login" href="${url.loginRestartFlowUrl}">
                                    <div class="kc-login-tooltip">
                                        <i class="${properties.kcResetFlowIcon!}"></i>
                                        <span class="kc-tooltip-text">${msg("restartLoginTooltip")}</span>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                <#else>
                    <#nested "show-username">
                    <div id="kc-username" class="${properties.kcFormGroupClass!}">
                        <label id="kc-attempted-username">${auth.attemptedUsername}</label>
                        <a id="reset-login" href="${url.loginRestartFlowUrl}">
                            <div class="kc-login-tooltip">
                                <i class="${properties.kcResetFlowIcon!}"></i>
                                <span class="kc-tooltip-text">${msg("restartLoginTooltip")}</span>
                            </div>
                        </a>
                    </div>
                </#if>
            </#if>
        </header>
        <div id="kc-content">
            <div id="kc-content-wrapper">

            <#-- App-initiated actions should not see warning messages about the need to complete the action -->
            <#-- during login.                                                                               -->
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="alert-${message.type} ${properties.kcAlertClass!} pf-m-<#if message.type = 'error'>danger<#else>${message.type}</#if>">
                    <div class="pf-c-alert__icon">
                        <#if message.type = 'success'><span class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
                        <#if message.type = 'warning'><span class="${properties.kcFeedbackWarningIcon!}"></span></#if>
                        <#if message.type = 'error'><span class="${properties.kcFeedbackErrorIcon!}"></span></#if>
                        <#if message.type = 'info'><span class="${properties.kcFeedbackInfoIcon!}"></span></#if>
                    </div>
                        <span class="${properties.kcAlertTitleClass!}">${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>

            <#nested "form">

                <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
                    <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
                        <div class="${properties.kcFormGroupClass!}">
                            <input type="hidden" name="tryAnotherWay" value="on"/>
                            <a href="#" id="try-another-way"
                            onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">${msg("doTryAnotherWay")}</a>
                        </div>
                    </form>
                </#if>

            <#if displayInfo>
                <div id="kc-info" class="${properties.kcSignUpClass!}">
                    <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                        <#nested "info">
                    </div>
                </div>
            </#if>
            </div>
            <div>
                <p style="margin-bottom:-0.9rem; margin-top:0.6rem"> Version 10.2.5 </p>
                <br>
                <p style="margin-bottom:0.2rem"> © Copyright HCL Technologies Limited 2025 </p>
            </div>
        </div>
        </div>
    </div>


        
  </div>
</body>
</html>
</#macro>
