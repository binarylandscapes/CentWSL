# CentWSL

CentOS on WSL (Windows 10 FCU or later)
based on [wsldl](https://github.com/yuk7/wsldl)
but adds the following capabilities:

* Git-LFS (Allows for files over 4GB that Windows OS has limited)
* Sphinx and multiple supporting packages like PlantUML and Graphwiz and Latex support
* MKISOFS Capability

![screenshot](https://raw.githubusercontent.com/wiki/yuk7/wsldl/img/Arch_Alpine_Cent.png)

[![Build Status](https://img.shields.io/travis/binarylandscapes/CentWSL.svg?style=flat-square)](https://travis-ci.org/binarylandscapes/CentWSL)
[![Github All Releases](https://img.shields.io/github/downloads/binarylandscapes/CentWSL/total.svg?style=flat-square)](https://github.com/binarylandscapes/CentWSL/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
![License](https://img.shields.io/github/license/binarylandscapes/CentWSL.svg?style=flat-square)

## [Download](https://github.com/binarylandscapes/CentWSL/releases)

## Requirements

* Windows 10 1903 April 2018 Update x64 or later.
* Windows Subsystem for Linux feature is enabled.
* Windows Terminal installed from (https://aka.ms/windowsterminal)

---
**IMPORTANT**

Be aware that if installing any WSL instance on Windows 10 1803+, your system automatically is configured with NTFS "Case Sensitive" enabled for any folder created by the WSL instance. This may have issues with Windows usage of files in those folders.

[Per-directory case sensitivity and WSL](https://blogs.msdn.microsoft.com/commandline/2018/02/28/per-directory-case-sensitivity-and-wsl/)

[Improved per-directory case sensitivity support in WSL](https://devblogs.microsoft.com/commandline/improved-per-directory-case-sensitivity-support-in-wsl/)

If you are currently on Windows 10 2004 for the Insiders Program and planning to use WSL 2 and get the following error message "HRESULT:0x800701bc", then you will need to update your WSL Linux Kernel per (https://docs.microsoft.com/en-us/windows/wsl/wsl2-kernel)

---

## References

* [Microsoft WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/about)

## Install

### 1. [Download](https://github.com/binarylandscapes/CentWSL/releases/latest) CentOS8.zip

### 2. Extract zip file to a new Alpine directory containing all files (Recommend C:\TEMP or Downloads folder)

### 3. Run ```addWSLfeature.ps1``` as an Administrator to add Windows Subsystem for Linux feature and reboot, if not already done

### 4. Run ```install.ps1``` as the desired user (this is not an all users installation) to

* Checks for and prompts to remove previous CentWSL distro (if distro location matches script parameters)
* Copies files from zip to ```C:\Users\<user>\.wsl\<distroName>\``` for install location
* Installs, silently
* Completes system\user configuration for Git, Git-LFS and Sphinx. **Will prompt for password of distro user, this is also your sudo password**
* Creates a desktop shortcut
* Performs cleanup

Note -  Exe filename is using to the instance name to register. If you rename it, you can register with a different name and have multiple installs.

```cmd
`install.ps1 [parameter <default value>]`

  Parameters:
  - `--distroName <CentOS8>`: Sets the name of <installer> exe file, this must match the filename of the actual exe
  - `--user <$env:UserName.ToLower()>`: Sets the username for this distro and Git to your Windows user name that opened Powershell
  - `--email <username@domain>`: Sets the email for Git config. This is forced prompted to enter during script
```

## How-to-Use (for Installed Instance)

### exe Usage (Based off wsldl)

```cmd
Usage:

    <no args>
      - Open a new shell with your default settings.

    run <command line>
      - Run the given command line in that distro. Inherit current directory.

    runp <command line (includes windows path)>
      - Run the path translated command line in that distro.

    config [setting [value]]
      - `--default-user <user>`: Set the default user for this distro to <user>
      - `--default-uid <uid>`: Set the default user uid for this distro to <uid>
      - `--append-path <on|off>`: Switch of Append Windows PATH to $PATH
      - `--mount-drive <on|off>`: Switch of Mount drives
      - `--default-term <default|wt|flute>`: Set default terminal window

    get [setting]
      - `--default-uid`: Get the default user uid in this distro
      - `--append-path`: Get on/off status of Append Windows PATH to $PATH
      - `--mount-drive`: Get on/off status of Mount drives
      - `--wsl-version`: Get WSL Version 1/2 for this distro
      - `--default-term`: Get Default Terminal for this distro launcher
      - `--lxguid`: Get WSL GUID key for this distro

    backup [contents]
      - `--tgz`: Output backup.tar.gz to the current directory using tar command
      - `--reg`: Output settings registry file to the current directory

    clean
      - Uninstall the distro.

    help
      - Print this usage message.
```

#### Set "Windows Terminal" as default terminal

```cmd
<DistributionName>.exe config --default-term wt
```

### How to uninstall instance

```cmd
<DistributionName>.exe clean

```

### Helpful tips

* The commands `bash` or `wsl` will open your default distro of WSL as well

* If you forgot your password, `wsl --distribution <DistributionName> --user root` will open the distro as root. So you can use passwd <user> to reset. Then close all terminals and reopen Alpine normally under your user account with new password.

* If you need to virtually "reboot" the WSL distro or distros, as an Administrator open Services and restart the running LxssManager service. 


### WSL Command Line Reference

See [Microsoft WSL Reference Documentation](https://docs.microsoft.com/en-us/windows/wsl/reference)

```cmd
Usage: wsl.exe [Argument] [Options...] [CommandLine]
```

#### Arguments to run Linux binaries

If no command line is provided, wsl.exe launches the default shell.

`--exec, -e <CommandLine>`: Execute the specified command without using the default Linux shell.

`-- <CommandLine>`: Pass the remaining command line as is.

  Options:

  `--distribution, -d <DistributionName>`: Run the specified distribution.

  `--user, -u <UserName>`: Run as the specified user.

#### Arguments to manage Windows Subsystem for Linux

`--export <DistributionName> <FileName>`: Exports the distribution to a tar file.
                                          The filename can be - for standard output.

`--import <DistributionName> <InstallLocation> <FileName>`: Imports the specified tar file as a new distribution.
                                                            The filename can be - for standard input.

`--list, -l [Options]`: Lists distributions.

  Options:

  `--all`: List all distributions, including distributions that are currently
           being installed or uninstalled.

  `--running`: List only distributions that are currently running.

  `--verbose`: Lists which version of WSL for distributions.

  `--set-default, -s <DistributionName>`: Sets the distribution as the default.

  `--set-default-version <wslVersion>`: Sets the default WSL version for newly created distributions.

  `--set-version <DistributionName> <wslVersion>`: Sets the WSL version for distribution.

  `--terminate, -t <DistributionName>`: Terminates the distribution.

  `--unregister <DistributionName>`: Unregisters the distribution.

  `--upgrade <DistributionName>`: Upgrades the distribution to the WslFs file system format.

  `--help`: Display usage information.

## How-to-Build

CentWSL can build on GNU/Linux or WSL.

`curl`, `bsdtar`, `tar`(gnu) and `sudo` is required for build.

```shell
$ make
```
