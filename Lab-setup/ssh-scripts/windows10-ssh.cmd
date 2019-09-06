@ECHO OFF

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

ssh-keygen -t rsa -b 4096 -N "" -f %USERPROFILE%\.ssh\id_rsa_python_lab

set REMOTEHOST=%PYLAB_LOGIN%@%PYLAB_IPADDRESS%
set PATHOFIDENTITYFILE=%USERPROFILE%\.ssh\id_rsa_python_lab.pub
set /p PYLAB_KEY=<%USERPROFILE%\.ssh\id_rsa_python_lab.pub

echo(
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo You will be prompted for the Raspberry Pi password
echo The password is raspberry
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo(

ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '%PYLAB_KEY%' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" 

:exit