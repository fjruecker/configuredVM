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
#
# (*)  object orientation:
#      use an object to define the properties of the new VM instead a bunch
#      of variables
#
# (*)  version control:
#      implement version control with git
#
# (*)  coding style:
#      find an appropriate and widely accepted coding style and apply it here

# --- custom configuration block (begin)
$VMName                 = "[VMName]"
$VMGeneration           = 2
$VMMemoryStartupBytes   = MB
$MemoryMinimumBytes     = MB
$MemoryMaximumBytes     = MB
$ProcessorCount         = 1
$VMVHDSize              = GB
$VMHasDvdDrive          = $true
$IsoImage               = "[c:\path\to\file.iso]"
$VMDescription          = "[Description]"
$StartAction            = "Nothing"
$StopAction             = "Save"
$DynamicMemory          = $true
$SecureBoot             = $true
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
# $IsoImage             = "C:\path\to\wserv2016.iso"
# $VMDescription        = ""
# $StartAction          = "Nothing"
# $StopAction           = "Save"
# $DynamicMemory        = $true
# $SecureBoot           = $true
# --- configuration block for VM "zz-tmpl-wserv2016-zz" (end)

# --- configuration block for VM "zz-tmpl-w100v1803-zz" (begin)
# $VMName               = "zz-tmpl-w100v1803-zz"
# $VMGeneration         = 2
# $VMMemoryStartupBytes = 2048MB
# $MemoryMinimumBytes   = 512MB
# $MemoryMaximumBytes   = 4096MB
# $ProcessorCount       = 4
# $VMVHDSize            = 32GB
# $VMHasDvdDrive        = $true
# $IsoImage             = "C:\path\to\Win10_1903_German_x64.iso"
# --- configuration block for VM "zz-tmpl-w100v1803-zz" (end)

# Our VMs are stored in a repository (in a directory structure).  We have to
# define the path to this repository.  Below this path directories for every
# project we are working on are created.
$HyperVRepoPath = "E:\florian\hyperv"
# The variable '$ProjectName' contains the name of the subdirectory in our
# repository.
$ProjectName = "ProjectName"

Write-Output("Creation and Configuration of VM $VMName started.")

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
