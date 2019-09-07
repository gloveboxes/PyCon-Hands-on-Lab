@ECHO OFF

SETlocal

FOR /f "tokens=4-8 delims=[.] " %%i IN ('ver') DO @(if %%i==Version (SET version=%%j.%%k& SET build=%%l) else (SET version=%%i.%%j& SET build=%%k))

SET usegit="false"

WHERE ssh-keygen /Q

IF ERRORLEVEL 1 (

  REM https://www.tenforums.com/tutorials/23975-find-windows-10-build-number.html

  IF %version% GEQ 10 IF %build% GTR 17763 (

    ECHO Install SSH Client
    ECHO https://docs.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse

  ) ELSE (

    where git /Q

    IF ERRORLEVEL 1 (

      ECHO Version of Windows 10 installed is older than 1803.
      ECHO Install Git Client from https://git-scm.com/download/win

    ) ELSE (

      SET usegit="true"
      GOTO :start

    )

  ) ELSE (
    
    where git /Q

    IF ERRORLEVEL 1 (

      ECHO Older version of Windows installed.
      ECHO Install Git Client from https://git-scm.com/download/win

    ) ELSE (

      ECHO using installed git
      SET usegit="true"
      GOTO :start

    )
  )

  goto :exit

)

:start

SET /P c="Enter Raspberry Pi Network IP Address: "
SET PYLAB_IPADDRESS=%c%
SET /P c="Enter your login name: "
SET PYLAB_LOGIN=%c%

ECHO(

SET /P c="Raspberry Pi Network entered was '%PYLAB_IPADDRESS%' Correct? ([Y]es/[N]o): "
if /I "%c%" EQU "Y" goto :checklogin
goto :exit

:checklogin
SET /P c="Login Name entered was '%PYLAB_LOGIN%' Correct? ([Y]es/[N]o): "
if /I "%c%" EQU "Y" goto :updateconfig
goto :exit

:updateconfig

IF NOT EXIST %USERPROFILE%\.ssh\NUL mkdir %USERPROFILE%\.ssh

SET PYLAB_SSHCONFIG=%USERPROFILE%\.ssh\config
SET PYLAB_TIME=time /T

ECHO(
ECHO +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO Updating SSH Config file %USERPROFILE%\.ssh\config
ECHO +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO(

ECHO( >> %PYLAB_SSHCONFIG%
ECHO #Begin-PyLab %DATE% >> %PYLAB_SSHCONFIG%
ECHO Host pylab-%PYLAB_LOGIN% >> %PYLAB_SSHCONFIG%
ECHO     HostName %PYLAB_IPADDRESS% >> %PYLAB_SSHCONFIG%
ECHO     User %PYLAB_LOGIN% >> %PYLAB_SSHCONFIG%
ECHO     IdentityFile ~/.ssh/id_rsa_python_lab >> %PYLAB_SSHCONFIG%
ECHO #End-PyLab >> %PYLAB_SSHCONFIG%
ECHO( >> %PYLAB_SSHCONFIG%

ECHO(
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO Generating SSH Key file %USERPROFILE%\.ssh\id_rsa_python_lab
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO(

REM Build SSH Key with either the Windows OpenSSH Client or the Git Client
REM Next command does not work inside a conditional block
FOR /F "tokens=* USEBACKQ" %%F IN (where git) DO ( SET gitpath=%%F )

IF %usegit% == "true" (

  ECHO Generating SSH Key with Git SSH

  "%gitpath:~0,-13%\git-bash.exe" -c "ssh-keygen -t rsa -N '' -b 4096 -f ~/.ssh/id_rsa_python_lab"
 
) ELSE (

  ECHO Generating SSH Key Windows SSH Client

  ssh-keygen -t rsa -b 4096 -N "" -f %USERPROFILE%\.ssh\id_rsa_python_lab

)

SET REMOTEHOST=%PYLAB_LOGIN%@%PYLAB_IPADDRESS%
SET PATHOFIDENTITYFILE=%USERPROFILE%\.ssh\id_rsa_python_lab.pub
SET /p PYLAB_KEY=<%USERPROFILE%\.ssh\id_rsa_python_lab.pub

ECHO(
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO You will be prompted for the Raspberry Pi password
ECHO The password is raspberry
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO(

IF %usegit% == "true" (

  "%gitpath:~0,-13%\git-bash.exe" -c "mkdir -p ~/.ssh && chmod 700 ~/.ssh && ECHO '%PYLAB_KEY%' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

) ELSE (

  ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && ECHO '%PYLAB_KEY%' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" 
)

:exit

endlocal