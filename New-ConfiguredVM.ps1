#
# New-ConfiguredVM - create a Hyper-V virtual machine and configure it
#
# This script creates a new virtual machine to be used in Hyper-V and
# configures most settings so that the operating system can be installed.
# It also creates a virtual hard disk.
# The virtual machine will be equiped with an virtual DVD, into which an
# ISO-Image is loaded.
#
# This script needs to be executed with administrative permissions.
#
#
# Author:   Reinhard Binder [BvO]           <reinhard.binder@gmx.net>
#
#
# History:
# v 0.5.2       2018-10-30  Florian Rücker [FjR]
# (*)  notes can be added with a variable called $VMDescription
# (*)  AutomaticStopAction and AutomaticStartAction are not hard-coded anymore
# (*)  implemented a variable called $DynamicMemory to configure whether the VM uses dynamic memory allocation or not
# (*)  implemented a variable called $SecureBoot to configure whether the VM uses Secure Boot or not
# 
# v 0.5.1		2018-10-27	Reinhard Binder [BvO]
# (*)  creating and adding a VHD containing the installation tools
# (*)  implementation of three VM definition blocks: uncomment the VM you
#      want to set up
#
# v 0.5.0     	2018-10-27	Reinhard Binder [BvO]
#	   initial release
#
#
# ToDo:
# (*)  read config from file:
#      read the configuration for the new VM from a file (INI or XML)
#
# (*)  Boot Order Generation 1:
#      Due to the $SecureBoot-Variable, the configuration of the boot order
#      does not work properly whilst creating Generation-1-VM. A quick and
#      dirty if-statement fixes it for now, but there definitely is a need
#      for a proper solution on this issue.
#
# (*)  Boot Order:
#      implement a way to configure the boot order.  Currently the boot order
#      is hard coded and set to DVD - HDD - Network.
# (*)  object orientation:
#      use an object to define the properties of the new VM instead a bunch 
#      of variables
# (*)  version control:
#      implement version control with git
# (*)  coding style:
#      find an appropriate and widely accepted coding style and apply it here



# ---  Start of VM properties definition: here you have to fill in the 
#      appropriate values as long as this silly script is not able to read
#      the configuration from a file or accepts parameters.
#
#
# define the properties of the new machine:
# $VMName              : defines the name of the new VM
# $VMGeneration        : defines which generation it should be
#                        Generation 2 requires a 64 bit operating system,
#                        which (in case of Windows) must be Windows 8 or newer
#
# $VMMemoryStartupBytes: how much RAM the VM needs on startup
# $MemoryMinimumBytes  : minimum amount of RAM the host will reserve for
#                        this VM 
# $MemoryMaximumBytes  : maximum amount of RAM the VM can use
# $DynamicMemory       : should the new VM use dynamic memory?
#
# CAVE:
# Too less memory will lead to:
# (a) a about 10 minute delay when the VM reboots the first time during the
#     installation of Windows 10
# (b) a WDF VIOLATION blue screen, followed by an automatic reboot, after
#     the first reboot during the installation of Windows 10.
#
#
# $ProcessorCount      : how many processor cores are assigned to this VM
#
# $VMVHDSize           : the capacity of the virtual disk
#
# $VMHasDvdDrive       : should the new VM be equiped with a DVD drive?
# $IsoImage            : which ISO Image should be mounted into the DVD drive
#
# $VMDescription       : a note for the VM (displayed in the Hyper-V-Manager
#
# $StartAction         : AutomaticStartAction, valid options are: Nothing | StartIfRunning | Start
# $StopAction          : AutomaticStopAction, valid options are:  TurnOff | Save | ShutDown
#
#
# $SecureBoot          : should Secure Boot be enabled on the VM?
#
# --- custom configuration block (begin)
$VMName                 = "vyos02"
$VMGeneration           = 1
$VMMemoryStartupBytes   = 512MB
$MemoryMinimumBytes     = 512MB
$MemoryMaximumBytes     = 512MB
$ProcessorCount         = 1   
$VMVHDSize              = 5GB
$VMHasDvdDrive          = $true
$IsoImage               = "E:\florian\tech\os\lin\vyos\1_1_8\vyos-1_1_8-amd64.iso"
$VMDescription          = "Test-Installation vyos"
$StartAction            = "Nothing"
$StopAction             = "Save"
$DynamicMemory          = $true
$SecureBoot             = $false
# --- custom configuration block (end)

# --- configuration block for VM "zz-tmpl-wserv2016-zz" (begin)
# $VMName               = "zz-tmpl-wserv2016-zz"
# $VMGeneration         = 2
# $VMMemoryStartupBytes = 1536MB
# $MemoryMinimumBytes   = 1536MB
# $MemoryMaximumBytes   = 2048MB
# $ProcessorCount       = 4
# $VMVHDSize            = 32GB
# $VMHasDvdDrive        = $true
# $IsoImage             = "D:\sysmgmt\os\win\server"          + "\" +     `
#                         "server2016\evaluation\iso"         + "\" +     `
#                         "server2016-eval-x64-en.iso"
# $VMDescription        = "ENTER DESCRIPTION"
# $StartAction          = "Nothing"
# $StopAction           = "Save"
# $DynamicMemory        = $true
# $SecureBoot           = $true
# --- configuration block for VM "zz-tmpl-wserv2016-zz" (end)

# --- configuration block for VM "zz-tmpl-w100v1803-zz" (begin)
#  Info: the minimum requirements for Windows 10 are:
#  	2 GB RAM (64 bit installation)
# 	20 GB hard disk
# $VMName               = "zz-tmpl-w100v1803-zz"
# $VMGeneration         = 2
# $VMMemoryStartupBytes = 2048MB
# $MemoryMinimumBytes   =  512MB
# $MemoryMaximumBytes   = 4096MB
# $ProcessorCount       = 4
# $VMVHDSize            = 32GB
# $VMHasDvdDrive        = $true
# $IsoImage             = "D:\sysmgmt\os\win\client\w100-x64" + "\" +     `
#                         "v1803-mue-de\00-original\iso"      + "\" +     `
#                         "Win10_1803_German_x64.iso"
# --- configuration block for VM "zz-tmpl-w100v1803-zz" (end)

# --- configuration block for VM "zz-tmpl-w100v1809-zz" (begin)
# Info: the minimum requirements for Windows 10 are:
# 	2 GB RAM (64 bit installation)
#	20 GB hard disk
# $VMName               = "zz-tmpl-w100v1809-zz"
# $VMGeneration         = 2
# $VMMemoryStartupBytes = 2048MB
# $MemoryMinimumBytes   =  512MB
# $MemoryMaximumBytes   = 4096MB
# $ProcessorCount       = 4
# $VMVHDSize            = 32GB
# $VMHasDvdDrive        = $true
# $IsoImage             = "D:\sysmgmt\os\win\client\w100-x64" + "\" +     ` 
#                         "v1809-mue-de\00-original\iso"      + "\" +     `
#                         "Win10_1809_German_x64-NOT-FOR-PRODUCTION.iso"
# --- configuration block for VM "zz-tmpl-w100v1809-zz" (end)
# --- 
# Our VMs are grouped by project.  We have to define the project for this new
# VM.
$ProjectName = "Networking"
# ---  End of VM properties definition


Write-Output("Creation and Configuration of VM $VMName started.")



# Our VMs are stored in a repository (in a directory structure).  We have to
# define the path to this repository.  Below of this path there is are
# directories for every project we are working on.  The project for the
# VM we want to create is defined by the variable $ProjectName some lines
# above.
$HyperVRepoPath = "E:\florian\hyperv"



# below of the project directory we use directories for VM definition files,
# virtual disk files, VM snapshot files and VM smartpaging files.
$VMDefinitions = "definitions"
$VMDisks       = "disks"
$VMSmartpaging = "smartpaging"
$VMSnapshots   = "snapshots"



# the defined path items must not end with a backslash.  To be sure we check
# this here (and fix it if neccesary).
$RemoveTrailingPathSeparator =
{
	Param ($PathVariable)

	While ($PathVariable.EndsWith("\"))
	{
	    $PathVariable = $PathVariable.Remove($PathVariable.Length - 1)
	}
    Return $PathVariable    
}


$HyperVRepoPath = Invoke-Command -ScriptBlock  $RemoveTrailingPathSeparator  `
                                 -ArgumentList $HyperVRepoPath
$ProjectName    = Invoke-Command -ScriptBlock  $RemoveTrailingPathSeparator  `
                                 -ArgumentList $ProjectName
$VMDefinitions  = Invoke-Command -ScriptBlock  $RemoveTrailingPathSeparator  `
                                 -ArgumentList $VMDefinitions
$VMDisks        = Invoke-Command -ScriptBlock  $RemoveTrailingPathSeparator  `
                                 -ArgumentList $VMDisks
$VMSmartpaging  = Invoke-Command -ScriptBlock  $RemoveTrailingPathSeparator  `
                                 -ArgumentList $VMSmartpaging
$VMSnapshots    = Invoke-Command -ScriptBlock  $RemoveTrailingPathSeparator  `
                                 -ArgumentList $VMSnapshots



# Only the path to the Hyper-V Repository may start with a backslash.  To be
# sure we check the other items and remove a leading backslash if it is here.
$RemoveLeadingPathSeparator =
{
	Param ($PathVariable)

	While ($PathVariable.StartsWith("\"))
	{
	    $PathVariable = $PathVariable.Remove(0, 1)
	}
    Return $PathVariable    
}

$ProjectName    = Invoke-Command -ScriptBlock  $RemoveLeadingPathSeparator  `
                                 -ArgumentList $ProjectName

$VMDefinitions  = Invoke-Command -ScriptBlock  $RemoveLeadingPathSeparator  `
                                 -ArgumentList $VMDefinitions

$VMDisks        = Invoke-Command -ScriptBlock  $RemoveLeadingPathSeparator  `
                                 -ArgumentList $VMDisks

$VMSmartpaging  = Invoke-Command -ScriptBlock  $RemoveLeadingPathSeparator  `
                                 -ArgumentList $VMSmartpaging

$VMSnapshots    = Invoke-Command -ScriptBlock  $RemoveLeadingPathSeparator  `
                                 -ArgumentList $VMSnapshots



# create the folder structure for the Hyper-V repository and the subfolders
New-Item -Name     $VMName                    `
         -Path     ( $HyperVRepoPath + "\" +  `
                     $ProjectName    + "\" +  `
                     $VMDefinitions           `
                   )                          `
         -ItemType Directory                  `
         -Force

New-Item -Name     $VMName                    `
         -Path     ( $HyperVRepoPath + "\" +  `
                     $ProjectName    + "\" +  `
                     $VMDisks                 `
                   )                          `
         -ItemType Directory                  `
         -Force

New-Item -Name     $VMName                    `
         -Path     ( $HyperVRepoPath + "\" +  `
                     $ProjectName    + "\" +  `
                     $VMSmartpaging           `
                   )                          `
         -ItemType Directory                  `
         -Force

New-Item -Name     $VMName                    `
         -Path     ( $HyperVRepoPath + "\" +  `
                     $ProjectName    + "\" +  `
                     $VMSnapshots             `
                   )                          `
         -ItemType Directory                  `
         -Force



# create the new VM
New-VM	-Name               $VMName                    `
        -Path               ( $HyperVRepoPath + "\" +  `
                              $ProjectName    + "\" +  `
                              $VMDefinitions           `
                            )                          `
        -Generation         $VMGeneration              `
	    -NewVHDPath         ( $HyperVRepoPath + "\" +  `
                              $ProjectName    + "\" +  `
                              $VMDisks        + "\" +  `
                              $VMName         + "\" +  `                              $VMName         +        `                              "-disk0.vhdx"            `
                            )                          `
        -NewVHDSizeBytes    $VMVHDSize                 `
	    -MemoryStartupBytes $VMMemoryStartupBytes



# provide the VM with an DVD Drive
If ($VMHasDvdDrive)  {
    Add-VMDvdDrive -VMName $VMName
    Set-VMDvdDrive -VMName $VMName -ControllerNumber 0 -ControllerLocation 1 -Path $IsoImage
}



# memory configuration, processor count, smart paging and snapshot location
#
# CAVE: SmartPagingFilePath and SnapshotFileLocation have to be _absolute_
# paths!  Using relative paths will lead to the creation of subdirectories
# below %SystemRoot%\System32 (at least in Windows 10 v1703).
#
Set-VM	-Name                 $VMName                        `
        -Notes                $VMDescription                 `
	    -AutomaticStartAction $StartAction                   `
        -AutomaticStopAction  $StopAction                    `
	    -ProcessorCount       $ProcessorCount                `
	    -SmartPagingFilePath  ( $HyperVRepoPath + "\" +      `
                                    $ProjectName    + "\" +  `
                                    $VMSmartpaging  + "\" +  `
                                    $VMName )                `
	    -SnapshotFileLocation ( $HyperVRepoPath + "\" +      `
                                    $ProjectName    + "\" +  `
                                    $VMSnapshots    + "\" +  `
                                    $VMName )

# configure dynamic memory
Set-VMMemory $VMName -DynamicMemoryEnabled $DynamicMemory -MinimumBytes $MemoryMinimumBytes -MaximumBytes $MemoryMaximumBytes


# configure the boot order for the VM:
# DVD-Drive / HDD-Drive / Network Adapter if there is a DVD-Drive
# Network Adapter / HDD-Drive if there is no DVD-Drive
#
# ~~ ToDo: Boot Order ~~
If ($VMHasDvdDrive)  {
    $VMDvdDrive   = Get-VMDvdDrive       -VMName $VMName
}

$VMHardDiskDrive  = Get-VMHardDiskDrive  -VMName $VMName
$VMNetworkAdapter = Get-VMNetworkAdapter -VMName $VMName

If ($VMGeneration -eq 2) {
    If ($VMHasDvdDrive)  {
        If ($SecureBoot) {
            Set-VMFirmware -VMName           $VMName            `
	                       -BootOrder        $VMDvdDrive,       `
                                             $VMHardDiskDrive,  `
                                             $VMNetworkAdapter  `
                           -EnableSecureBoot On
        }
        Else {
            Set-VMFirmware -VMName           $VMName            `
                           -BootOrder        $VMDvdDrive,       `
                                             $VMHardDiskDrive,  `
                                             $VMNetworkAdapter  `
                           -EnableSecureBoot Off
        }
    }

    Else  {
        If ($SecureBoot) {
            Set-VMFirmware -VMName           $VMName            `
                           -BootOrder        $VMHardDiskDrive,  `
                                             $VMNetworkAdapter  `
                           -EnableSecureBoot On
        }
        Else {
            Set-VMFirmware -VMName           $VMName            `
                           -BootOrder        $VMHardDiskDrive,  `
                                             $VMNetworkAdapter  `
                           -EnableSecureBoot Off
        }
    }
}


# Create VHD containing some installtion tools (currently: diskpart script,
# WSUS Offline).  A differncing disk will be used because changes on this
# disk should not be permanent.
### New-VHD -Path         ( $HyperVRepoPath             + "\" +  `
###                         $ProjectName                + "\" +  `
###                         $VMDisks                    + "\" +  `
###                         $VMName                     + "\" +  `
###                         $VMName                     +        `
###                         "-w100deplutils.vhdx"                `
###                       )                                      `
###         -ParentPath   ( $HyperVRepoPath             + "\" +  `
###                         "zz-tools-zz\disks"         + "\" +  `
###                         "w100deplutils-master.vhdx"          `
###                       )                                      `
###         -Differencing
### 
### 
### 
### # add the VHD containing the installation tools
### Add-VMHarddiskDrive -VMName $VMName                          `
###                     -Path   ( $HyperVRepoPath       + "\" +  `
###                               $ProjectName          + "\" +  `
###                               $VMDisks              + "\" +  `
###                               $VMName               + "\" +  `
###                               $VMName               +        `
###                               "-w100deplutils.vhdx"          `
###                             )
### 

Write-Output("Creation and Configuration of VM $VMName finished.")
