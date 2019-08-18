## SSH Authentication with private/public keys

![ssh login](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/ssh-login.jpg)

**Tip: Don't have ssh-keygen? Install a [supported SSH client](https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client?WT.mc_id=pycon-blog-dglover).**

Setting up a public/private key pair for SSH authentication is a secure and fast way to authenticate from your computer to the Raspberry Pi. This is needed for this hands-on lab.

1. Generate a separate SSH key in a different file.

    On macOS / Linux, run the following command in a **local terminal**:

    ```bash
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa-python-lab
    ```

    On Windows, run the following command in a **local command prompt**:

    ```bat
    ssh-keygen -t rsa -b 4096 -f %USERPROFILE%\.ssh\id_rsa-python-lab
    ```

3. Add the contents of the **local** `id_rsa-python-lab.pub` file generated in step 1 to the appropriate `authorized_keys` file(s) on the **SSH host**.

    On **macOS / Linux**, run the following command in a **local terminal**, replacing `name-of-ssh-host-here` with the host name in the SSH config file from step 2:

    ```bash
    ssh-copy-id -i ~/.ssh/id_rsa-python-lab.pub <Address or Raspberry Pi>
    ```

    On **Windows**, run the following commands in a **local command prompt**, replacing `name-of-ssh-host-here` with the host name in the SSH config file from step 2.

    ```bat
    SET REMOTEHOST=login-name@raspberry-ip-address
    SET PATHOFIDENTITYFILE=%USERPROFILE%\.ssh\id_rsa-python-lab.pub

    scp %PATHOFIDENTITYFILE% %REMOTEHOST%:~/tmp.pub
    ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm -f ~/tmp.pub"
    ```

### Test the SSH Authentication Key

1. Open a Terminal/PowerShell window from your Linux, macOS, or Windows computer.
2. Start a **ssh** session to the Raspberry Pi.

    On macOS / Linux, run the following command in a **local terminal**:

    ```bash
    ssh login-name@raspberry-pi-address -i ~/.ssh/id_rsa-python-lab
    ```

    On Windows, run the following command in a **local command prompt**:

    ```bat
    ssh login-name@raspberry-pi-address -i %USERPROFILE%\.ssh\id_rsa-python-lab
    ```

    A new SSH session will start. You should now be connected to the Raspberry Pi **without** being prompted for the password.

3. Close the SSH session. In the SSH terminal, type **exit**, followed by **ENTER**.

### Reusing a key generated in PuTTYGen

If you used PuTTYGen to set up SSH public key authentication for the host you are connecting to, you need to convert your private key so that other SSH clients can use it. To do this:

1. Open PuTTYGen **locally** and load the private key you want to convert.
2. Select **Conversions > Export OpenSSH key** from the application menu. Save the converted key to a **local** location such as `%USERPROFILE%\.ssh`.
3. Validate that the **local** permissions on the exported key file only grant `Full Control` to your user, Administrators, and SYSTEM.
4. In VS Code, run **Remote-SSH: Open Configuration File...** in the Command Palette (`kbstyle(F1)`), select the SSH config file you wish to change, and add (or modify) a host entry in the config file as follows:

    ```yaml
    Host name-of-ssh-host-here
        User your-user-name-on-host
        HostName host-fqdn-or-ip-goes-here
        IdentityFile C:\path\to\your\exported\private\keyfile
    ```


## WARNING: UNPROTECTED PRIVATE KEY FILE! 

if you encounter this error message

```bat
C:\>ssh dev01@rpialfa.local -i %USERPROFILE%\.ssh\id_rsa-python-lab
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions for 'id_rsa-python-lab' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
Load key "id_rsa-python-lab": bad permissions
dev01@rpialfa.local: Permission denied (publickey).

C:\>
C:\>
C:\>ssh dev01@rpialfa.local -i %USERPROFILE%\.ssh\id_rsa-python-lab
Warning: Identity file private-key.ppm not accessible: No such file or directory.
dev01@rpialfa.local: Permission denied (publickey).
```

In Windows File Explorer navigate to %USERPROFILE%\.ssh

1. Locate **id_rsa-python-lab** in Windows Explorer.
1. right-click on it then select "Properties".
1. Navigate to the "Security" tab and click "Advanced".
1. Change the owner to you, disable inheritance and delete all permissions.
1. Then grant yourself "Full control" and save the permissions.

Now SSH won't complain about file permission too open anymore.

[Windows SSH: Permissions for 'private-key' are too open](https://superuser.com/questions/1296024/windows-ssh-permissions-for-private-key-are-too-open)
