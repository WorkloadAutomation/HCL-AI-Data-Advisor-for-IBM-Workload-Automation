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
                <img
                    src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIzIiBoZWlnaHQ9IjE0IiB2aWV3Qm94PSIwIDAgMTIzIDE0IiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8cGF0aCBkPSJNNTAuOTgxIDEyLjUwNjRDNDQuNjU1IDEwLjQ0MDQgNDUuMTM5IDYuMjI4NDEgNTEuNDkgMy40Mjc0MUM1OS41NDcgLTAuMTA2NTkxIDcwLjg2MSAtMC42MjU1OTEgODEuMzIgMC42MDA0MDlDODYuNjI2IDEuMjAwNDEgODkuMzAzIDIuNzI4NDEgODkuMzggNC45MjM0MUg3Ni43MTRDNzUuNjg4IDMuOTE1NDEgNzMuODE0IDMuMjQ1NDEgNzAuMDE0IDMuMzIzNDFDNjUuMTk0IDMuNDIzNDEgNjIuMDM1IDQuNzE4NDEgNjAuNTMgNy4wODk0MUM1OS4yNjUgOS4wOTc0MSA2MC4yMjQgMTAuODQ0NCA2Ny40ODcgMTAuODA2NEM2OS43Mjk4IDEwLjg3NiA3MS45NDk5IDEwLjMzOTIgNzMuOTEzIDkuMjUyNDFIODYuODUxQzg0LjYzMyAxMS4yNzU0IDgwLjY3MyAxMi42MjQ0IDc1LjQ4OSAxMy4zMjc0QzcxLjkwMzQgMTMuNzg1OCA2OC4yOTE4IDE0LjAxMDYgNjQuNjc3IDE0LjAwMDRDNTkuMzExIDE0LjAwMDQgNTQuMTI1IDEzLjUyMTQgNTAuOTgxIDEyLjUwNjRaTTg4LjUyIDEzLjU0OTRMOTUuODg4IDAuNDczNDA5SDEwOS42MTZMMTAzLjk3NSAxMC40MzU0SDEyM0wxMjEuMjM2IDEzLjU0OTRIODguNTJaTTAgMTMuMDU4NEw3LjQ1OSAwLjM0OTQwOUgyMC43NDVMMTguMjU3IDQuNjM0NDFIMzEuNEwzMy44NTcgMC4zNTE0MDlINDcuNTI4TDQwLjA3NyAxMy4wNTE0SDI2LjVMMjkuNDU0IDcuOTg4NDFIMTYuM0wxMy40MjUgMTMuMDU4NEgwWiIgZmlsbD0id2hpdGUiLz4KPC9zdmc+Cg=="
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
                    <h1 class="aida-header aida-title" >HCL AIDA</h1>
                    <h2 class="aida-header aida-subtitle" >FOR HCL WORKLOAD AUTOMATION</h2>
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
        </div>

        </div>
    </div>
  </div>
</body>
</html>
</#macro>
