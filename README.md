"# AutomatedLab - Windows Server 2025 Lab Environment

## Overview
This project uses [AutomatedLab](https://automatedlab.org/) to build a comprehensive Windows Server 2025-based lab environment for System Center Virtual Machine Manager (SCVMM) and System Center Configuration Manager (SCCM) deployment and testing.

## Project Description
The lab environment provides a complete infrastructure for deploying and testing Microsoft System Center products in an automated, repeatable manner. Built on Windows Server 2025, this lab serves as a sandbox for learning, testing, and validating enterprise management solutions.

## Lab Components

### Core Infrastructure
- **Domain Controller (ABCDC01)**
  - Windows Server 2025 Standard Evaluation
  - Domain: ABC.local
  - IP: 192.168.1.101
  - 4GB RAM
  - RSAT tools installed

- **Windows 11 Client (ABCClient01)**
  - Windows 11 Pro
  - Domain-joined to ABC.local
  - IP: 192.168.1.121
  - 4GB RAM

### Active Directory Structure
- **Domain**: ABC.local
- **Organizational Units**:
  - LabUsers - Contains service accounts and administrative users
  - LabComputers - For computer objects
- **User Accounts**:
  - `adminuser` - Domain Administrator
  - `scv-sql` - System Center service account
  - `svc-sql` - SQL Server service account
- **Default Password**: Somepass1 (lab environment only)

### Network Configuration
- **Network**: 192.168.1.0/24
- **Switch**: HVSwitch (Internal)
- **Gateway**: 192.168.1.1

## Planned Components

### System Center Virtual Machine Manager (SCVMM)
SCVMM will be deployed to manage the Hyper-V infrastructure and provide:
- Virtual machine lifecycle management
- Hyper-V host management
- Library management for templates and ISO files
- Network and storage configuration

### System Center Configuration Manager (SCCM)
SCCM will be deployed to provide:
- Operating system deployment
- Software distribution and updates
- Compliance management
- Endpoint protection
- Reporting and monitoring

## Prerequisites

### Software Requirements
- Windows 10/11 or Windows Server with Hyper-V enabled
- AutomatedLab PowerShell module
- Hyper-V role installed and configured
- ISO files for:
  - Windows Server 2025 Standard Evaluation
  - Windows 11 Pro
  - SQL Server 2017/2019
  - System Center VMM 2019
  - System Center Configuration Manager (Current Branch)

### Hardware Requirements
- **Minimum**: 16GB RAM, 100GB free disk space
- **Recommended**: 32GB+ RAM, 200GB+ free disk space
- CPU with virtualization support (Intel VT-x or AMD-V)

## Installation

### 1. Install AutomatedLab
```powershell
Install-Module -Name AutomatedLab -AllowClobber
```

### 2. Configure AutomatedLab
```powershell
# Set the lab sources path (where ISO files are stored)
New-LabSourcesFolder -DriveLetter C
```

### 3. Download Required ISO Files
Place the following ISO files in the AutomatedLab sources folder:
- Windows Server 2025 ISO
- Windows 11 ISO
- SQL Server ISO
- System Center VMM ISO
- System Center Configuration Manager ISO

### 4. Deploy the Base Lab
```powershell
cd C:\Users\Administrator\Documents\.automatedlab\dc
.\DCandClient.ps1
```

## Project Structure

```
.automatedlab/
├── dc/
│   ├── DCandClient.ps1          # Main lab deployment script
│   ├── AddNestedHyperV.ps1      # Add Hyper-V hosts to lab
│   ├── SCCM.README.md           # SCCM deployment guide
│   └── Install-SQLServer2022.ps1 # SQL Server installation (deprecated)
└── README.md                     # This file
```

## Usage

### Deploy Base Lab
The base lab includes a Domain Controller and Windows 11 client:
```powershell
.\dc\DCandClient.ps1
```

Deployment time: Approximately 30-45 minutes depending on hardware.

### Add Nested Hyper-V Hosts
To add nested Hyper-V hosts with iSCSI shared storage:
```powershell
.\dc\AddNestedHyperV.ps1
```

### Deploy SCCM
See `dc/SCCM.README.md` for detailed SCCM deployment instructions.

## Configuration Details

### Timer Tracking
The deployment script includes built-in timing to track deployment duration:
- Start time logged at beginning
- End time and total duration displayed upon completion
- Duration shown in hours, minutes, and seconds

### Naming Convention
All lab resources use the prefix "ABC":
- Computer names: ABCDC01, ABCClient01, ABCServer01, etc.
- Domain: ABC.local
- No hyphens in computer names for compatibility

### IP Address Scheme
| Resource | IP Address | Purpose |
|----------|------------|---------|
| ABCDC01 | 192.168.1.101 | Domain Controller |
| ABCClient01 | 192.168.1.121 | Windows 11 Client |
| 192.168.1.103-112 | Reserved | Future SQL/SCCM/SCVMM servers |
| 192.168.1.131-140 | Reserved | Hyper-V hosts and iSCSI storage |

## Troubleshooting

### Common Issues

**Hyper-V Not Available**
- Ensure Hyper-V role is installed
- Verify CPU supports virtualization
- Check BIOS settings for virtualization enabled

**Insufficient Memory**
- Close unnecessary applications
- Reduce VM memory allocation in scripts
- Add physical RAM to host system

**Network Issues**
- Verify Hyper-V virtual switch creation
- Check IP address conflicts
- Ensure DHCP is not running on lab network

**AutomatedLab Module Issues**
```powershell
# Reinstall AutomatedLab
Uninstall-Module AutomatedLab -Force
Install-Module AutomatedLab -Force
```

## Cleanup

### Remove Entire Lab
```powershell
Remove-Lab -Name DCLab
```

### Remove Specific VMs
```powershell
Remove-LabVM -Name ABCClient01
```

### Remove Lab Sources
Only if you want to completely clean up AutomatedLab:
```powershell
Remove-Item -Path "C:\LabSources" -Recurse -Force
```

## Security Notes

⚠️ **This is a lab environment only!**
- Default passwords are hardcoded for convenience
- Security best practices are simplified for ease of use
- Do not use these configurations in production
- Lab VMs should be isolated from production networks

## Contributing

This is a personal lab project. Feel free to fork and customize for your own needs.

## References

- [AutomatedLab Documentation](https://automatedlab.org/en/latest/)
- [AutomatedLab GitHub](https://github.com/AutomatedLab/AutomatedLab)
- [System Center Documentation](https://docs.microsoft.com/en-us/system-center/)
- [Windows Server 2025 Documentation](https://docs.microsoft.com/en-us/windows-server/)

## License

This project is for educational and testing purposes only.

## Author

tpldevelopment

## Version History

- **v1.0** - Initial base lab with DC and Windows 11 client
- Added Active Directory OUs and user accounts
- Integrated deployment timer
- Removed hyphens from computer names for compatibility

---

**Last Updated**: December 1, 2025
" 
