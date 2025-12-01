#Requires -Version 5.0
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    AutomatedLab script to deploy a Domain Controller (Server 2025) and Windows 11 client.

.DESCRIPTION
    Creates a lab environment with:
    - 1 Domain Controller running Windows Server 2025 Datacenter (Desktop Experience)
    - 1 Windows 11 client joined to the domain
#>

$labPrefix = "ABC"
$labName = 'DCLab'
$switchName = "HVSwitch"
$addressSpace = '192.168.1.0/24'
$domainName = 'ABC.local'

# Start timer
$startTime = Get-Date
Write-Host "Lab deployment started at: $startTime" -ForegroundColor Cyan

# Create new lab definition
New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

# Define network (internal switch with address space)
Add-LabVirtualNetworkDefinition -Name $switchName -AddressSpace $addressSpace

# Define Domain Controller
Add-LabMachineDefinition -Name "${labPrefix}DC01" `
    -Memory 4GB `
    -OperatingSystem 'Windows Server 2025 Standard Evaluation (Desktop Experience)' `
    -Roles RootDC `
    -Network "$switchName" `
    -DomainName $domainName `
    -IpAddress 192.168.1.101 `
    -Gateway 192.168.1.1

# Define Windows 11 Client
Add-LabMachineDefinition -Name "${labPrefix}Client01" `
    -Memory 4GB `
    -OperatingSystem 'Windows 11 Pro' `
    -Network "$switchName" `
    -DomainName $domainName `
    -IpAddress 192.168.1.121 `
    -Gateway 192.168.1.1

# Install the lab
Install-Lab

# Install RSAT tools on Domain Controller
Invoke-LabCommand -ComputerName "${labPrefix}DC01" -ScriptBlock {
    Write-Host "Installing RSAT tools..."
    Install-WindowsFeature -Name RSAT -IncludeAllSubFeature
} -PassThru

# Create AD user
Invoke-LabCommand -ComputerName "${labPrefix}DC01" -ScriptBlock {
    Write-Host "Creating OUs..."
    New-ADOrganizationalUnit -Name "LabUsers" -Path "DC=ABC,DC=local"
    New-ADOrganizationalUnit -Name "LabComputers" -Path "DC=ABC,DC=local"
    
    Write-Host "Creating AD user 'adminuser'..."
    $password = ConvertTo-SecureString "Somepass1" -AsPlainText -Force
    New-ADUser -Name "adminuser" -AccountPassword $password -Enabled $true -PasswordNeverExpires $true -Path "OU=LabUsers,DC=ABC,DC=local"
    Add-ADGroupMember -Identity "Domain Admins" -Members "adminuser"
    
    Write-Host "Creating AD user 'scv-sql'..."
    New-ADUser -Name "scv-sql" -AccountPassword $password -Enabled $true -PasswordNeverExpires $true -Path "OU=LabUsers,DC=ABC,DC=local"
    Add-ADGroupMember -Identity "Domain Admins" -Members "scv-sql"
 
} -PassThru


# Show deployment summary
Show-LabDeploymentSummary

# Calculate and display elapsed time
$endTime = Get-Date
$duration = $endTime - $startTime
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Lab Deployment Completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Start Time: $startTime" -ForegroundColor Cyan
Write-Host "End Time:   $endTime" -ForegroundColor Cyan
Write-Host "Duration:   $($duration.Hours)h $($duration.Minutes)m $($duration.Seconds)s" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green