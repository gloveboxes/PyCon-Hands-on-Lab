@echo OFF

setlocal

echo(
echo Purpose: This utility creates an SSH key pair and copies the public key to the Raspberry Pi.
echo Platform: Windows 7, 8, and 10.
echo Version: 1.0, September 2019
echo Author: Dave Glover, http://github.com/gloveboxes
echo Licemce: MIT. Free to use, modify, no liability accepted
echo(
echo(

for /f "tokens=4-8 delims=[.] " %%i IN ('ver') do @(if %%i==Version (set version=%%j.%%k& set build=%%l) else (set version=%%i.%%j& set build=%%k))

set usegit="false"

where ssh-keygen /Q

if ERRORLEVEL 1 (

  rem https://www.tenforums.com/tutorials/23975-find-windows-10-build-number.html

  if %version% GEQ 10 if %build% GEQ 17134 (

    echo(
    echo ===========================================================
    echo ERROR: NO SSH SUPPORT FOUND
    echo Version of Windows 10 1803 or better is installed
    echo Install OpenSSH Client https://docs.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse
    echo ===========================================================
    echo(

  ) else (

    where git /Q

    if ERRORLEVEL 1 (
      echo(
      echo ===========================================================
      echo ERROR: NO SSH SUPPORT FOUND
      echo Version of Windows installed is older than Windows 10 1803.
      echo Install Git Client from https://git-scm.com/download/win
      echo ===========================================================
      echo(

    ) else (

      set usegit="true"
      GOTO :start

    )

  )

  goto :exit

)

:start

    set /P c="Enter Raspberry Pi Network IP Address: "
    set PYLAB_IPADDRESS=%c%
    set /P c="Enter your login name: "
    set PYLAB_LOGIN=%c%

    echo(

    set /P c="Raspberry Pi Network entered was '%PYLAB_IPADDRESS%' Correct? ([Y]es/[N]o): "
    if /I "%c%" EQU "Y" goto :checklogin
    goto :exit

:checklogin
    set /P c="Login Name entered was '%PYLAB_LOGIN%' Correct? ([Y]es/[N]o): "
    if /I "%c%" EQU "Y" goto :updateconfig
    goto :exit

:updateconfig

    if not exist %USERPROFILE%\.ssh\NUL mkdir %USERPROFILE%\.ssh

    set PYLAB_SSHCONFIG=%USERPROFILE%\.ssh\config
    set PYLAB_TIME=time /T

    echo(
    echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    echo Updating SSH Config file %USERPROFILE%\.ssh\config
    echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    echo(

    echo( >> %PYLAB_SSHCONFIG%
    echo #Begin-PyLab %DATE% >> %PYLAB_SSHCONFIG%
    echo Host pylab-%PYLAB_LOGIN% >> %PYLAB_SSHCONFIG%
    echo     HostName %PYLAB_IPADDRESS% >> %PYLAB_SSHCONFIG%
    echo     User %PYLAB_LOGIN% >> %PYLAB_SSHCONFIG%
    echo     IdentityFile ~/.ssh/id_rsa_python_lab >> %PYLAB_SSHCONFIG%
    echo #End-PyLab >> %PYLAB_SSHCONFIG%
    echo( >> %PYLAB_SSHCONFIG%

    echo(
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    echo Generating SSH Key file %USERPROFILE%\.ssh\id_rsa_python_lab
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    echo(

    rem Next command does not work inside a conditional block
    for /F "tokens=* USEBACKQ" %%F in (`where git`) do ( set gitpath=%%F )

    if %usegit% == "true" (

      echo Generating SSH Key with Git SSH

      "%gitpath:~0,-13%\git-bash.exe" -c "ssh-keygen -t rsa -N '' -b 4096 -f ~/.ssh/id_rsa_python_lab"
    
    ) else (

      echo Generating SSH Key Windows SSH Client

      ssh-keygen -t rsa -b 4096 -N "" -f %USERPROFILE%\.ssh\id_rsa_python_lab

    )

    set REMOTEHOST=%PYLAB_LOGIN%@%PYLAB_IPADDRESS%
    set PATHOFIDENTITYFILE=%USERPROFILE%\.ssh\id_rsa_python_lab.pub
    set /p PYLAB_KEY=<%USERPROFILE%\.ssh\id_rsa_python_lab.pub

    echo(
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    echo Copying SSH Public Key to the Raspberry Pi
    echo(
    echo Accept continue connecting: type yes
    rem https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011
    if %version% GEQ 10 if %build% GEQ 16257 (
      echo [101;93mRaspberry Pi Password is raspberry [0m
    ) else (
      echo Raspberry Pi Password is raspberry
    )
    echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    echo(

    if %usegit% == "true" (

      "%gitpath:~0,-13%\git-bash.exe" -c "ssh %REMOTEHOST% 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo %PYLAB_KEY% >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'"

    ) else (

      ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '%PYLAB_KEY%' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" 
    )

:exit

    echo(
    echo Finished
    echo(

pause