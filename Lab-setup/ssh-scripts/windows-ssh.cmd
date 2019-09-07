@ECHO OFF

setlocal

for /f "tokens=4-8 delims=[.] " %%i in ('ver') do @(if %%i==Version (set version=%%j.%%k& set build=%%l) else (set version=%%i.%%j& set build=%%k))

set usegit="false"

WHERE ssh-keygen /Q

IF ERRORLEVEL 1 (

  REM https://www.tenforums.com/tutorials/23975-find-windows-10-build-number.html

  IF %version% GEQ 10 IF %build% GEQ 17763 (

    echo Install SSH Client
    echo https://docs.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse

    echo(
    echo ===========================================================
    echo ERROR: NO SSH SUPPORT FOUND
    echo Version of Windows 10 1803 or better installed
    echo Install OpenSSH Client https://docs.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse
    echo ===========================================================
    echo(


  ) ELSE (

    where git /Q

    IF ERRORLEVEL 1 (
      echo(
      echo ===========================================================
      echo ERROR: NO SSH SUPPORT FOUND
      echo Version of Windows installed is older than Windows 10 1803.
      echo Install Git Client from https://git-scm.com/download/win
      echo ===========================================================
      echo(

    ) ELSE (

      SET usegit="true"
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

IF NOT EXIST %USERPROFILE%\.ssh\NUL mkdir %USERPROFILE%\.ssh

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

REM Next command does not work inside a conditional block
FOR /F "tokens=* USEBACKQ" %%F IN (where git) DO ( SET gitpath=%%F )

if %usegit% == "true" (

  ECHO Generating SSH Key with Git SSH

  "%gitpath:~0,-13%\git-bash.exe" -c "ssh-keygen -t rsa -N '' -b 4096 -f ~/.ssh/id_rsa_python_lab"
 
) ELSE (

  ECHO Generating SSH Key Windows SSH Client

  ssh-keygen -t rsa -b 4096 -N "" -f %USERPROFILE%\.ssh\id_rsa_python_lab

)

set REMOTEHOST=%PYLAB_LOGIN%@%PYLAB_IPADDRESS%
set PATHOFIDENTITYFILE=%USERPROFILE%\.ssh\id_rsa_python_lab.pub
set /p PYLAB_KEY=<%USERPROFILE%\.ssh\id_rsa_python_lab.pub

echo(
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo You will be prompted for the Raspberry Pi password
echo The password is raspberry
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo(

if %usegit% == "true" (

  "%gitpath:~0,-13%\git-bash.exe" -c "ssh %REMOTEHOST% 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo %PYLAB_KEY% >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'"

) ELSE (

  ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '%PYLAB_KEY%' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" 
)

:exit