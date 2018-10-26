<#

.SYNOPSIS
This script installs and completes the initial setup of the ITGlue PowerShell Wrapper.

.DESCRIPTION
Options:

    -APIKey               - Your ITGlue API key
    -RememberAPI          - Exports a configuration file at %UserProfile%\ITGlueAPI which stores your base uri and API key

.EXAMPLE
./PSWrapperSetup.ps1 -APIKey APIKeyHere
./PSWrapperSetup.ps1 -APIKey APIKeyHere -RememberAPI

.NOTES
Author: Shay Hosking

For more information on the ITGlue PowerShell wrapper go to https://github.com/itglue/powershellwrapper

.LINK
https://github.com/DefaultDrop/DocAutomation

#>

Param(

    [switch]$RememberAPI = $false,
    
    [Parameter(Mandatory = $true)]
    [string]$APIKey

)

# Checks if ITGlue PowerShell module is installed and installs if not
$ModuleName = "ITGlueAPI"
   
if (Get-Module -ListAvailable -Name $ModuleName) {
    Write-Host "$ModuleName installed OK" -ForegroundColor Green
}
else {
    Write-Host "$ModuleName not installed" -ForegroundColor Yellow
    Write-Host "Installing..." -ForegroundColor Yellow
    try {
        # Set PowerShell Gallery to trusted
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        # Install module with current user to avoid running as admin
        Install-Module -Name $ModuleName -Scope CurrentUser -ErrorAction Stop
    }
    catch {
        #If the install fails, write the message to the screen
        $ErrorMessage = $_.Exception.Message
        Write-Host "Failed to install $ModuleName" -ForegroundColor Red
        Write-Host $ErrorMessage -ForegroundColor Red
    }   
}

# Configure ITGlue base URI, using the default api.itglue.com URI
Write-Host "Adding base URI"
Add-ITGlueBaseURI

# Configure ITGlue API key
Write-Host "Adding API key"
Add-ITGlueAPIKey -Api_Key $APIKey

# If RememberAPI is specified then export the settings to a config file 
if ($RememberAPI) {
    Write-Host "Exporting module settings"
    Export-ITGlueModuleSettings
}

