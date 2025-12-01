#Requires -Version 5.0
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Add VMM Server to existing DCLab environment.

.DESCRIPTION
    This script adds a Windows Server 2025 for System Center VMM to the existing ABC.local domain.
    
.NOTES
    The DCLab must already be running before executing this script.
#>

$labName = 'VMMlab'
$labPrefix = "ABC"
$switchName = "HVSwitch"
$domainName = 'ABC.local'
$addressSpace = '192.168.1.0/24'

# Start timer
$startTime = Get-Date
Write-Host "VMM Server deployment started at: $startTime" -ForegroundColor Cyan

# Create a new lab definition with the same name
New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

# Define network
Add-LabVirtualNetworkDefinition -Name $switchName -AddressSpace $addressSpace

# Define Domain Controller (skip deployment as it already exists)
Add-LabMachineDefinition -Name "${labPrefix}DC01" `
    -Memory 4GB `
    -OperatingSystem 'Windows Server 2025 Standard Evaluation (Desktop Experience)' `
    -Roles RootDC `
    -Network "$switchName" `
    -DomainName $domainName `
    -IpAddress 192.168.1.101 `
    -Gateway 192.168.1.1 `
    -SkipDeployment

# Define VMM Server
Add-LabMachineDefinition -Name "${labPrefix}VMM01" `
    -Memory 8GB `
    -OperatingSystem 'Windows Server 2025 Datacenter Evaluation (Desktop Experience)' `
    -Network "$switchName" `
    -DomainName $domainName `
    -IpAddress 192.168.1.110 `
    -Gateway 192.168.1.1

# Install the new machine
Install-Lab

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "VMM Server deployment completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Server: ${labPrefix}VMM01" -ForegroundColor Cyan
Write-Host "IP: 192.168.1.110" -ForegroundColor Cyan
Write-Host "Domain: $domainName" -ForegroundColor Cyan

# Calculate and display elapsed time
$endTime = Get-Date
$duration = $endTime - $startTime
Write-Host "`nStart Time: $startTime" -ForegroundColor Yellow
Write-Host "End Time:   $endTime" -ForegroundColor Yellow
Write-Host "Duration:   $($duration.Hours)h $($duration.Minutes)m $($duration.Seconds)s" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green
