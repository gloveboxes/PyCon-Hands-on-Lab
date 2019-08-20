
# SSH for Windows 7 or older Windows 10 Systems

Install [Git for Windows](https://git-scm.com/download/win).

## Create an SSH Key from Windows Command Prompt

From a Windows **Command Prompt** run the following commands:

1. Create your key. This is typically a one-time operation. **Take the default options**.

    ```bat
    ssh-keygen -t rsa -b 4096 -f %USERPROFILE%\.ssh\id_rsa_python_lab
    ```

2. Copy the public key to your Raspberry Pi

    ```bat
    SET REMOTEHOST=<login@Raspberry IP Address>

    SET PATHOFIDENTITYFILE=%USERPROFILE%\.ssh\id_rsa_python_lab.pub

    scp %PATHOFIDENTITYFILE% %REMOTEHOST%:~/tmp.pub

    ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh &&
    cat ~/tmp.pub >> ~/.ssh/authorized_keys &&
    chmod 600 ~/.ssh/authorized_keys && rm -f ~/tmp.pub"
    ```

3. Test the SSH Authentication Key

    ```bat
    ssh -i %USERPROFILE%\.ssh\id_rsa_python_lab <login@Raspberry IP Address>
    ```

    A new SSH session will start. You should now be connected to the Raspberry Pi **without** being prompted for the password.

4. Close the SSH session. In the SSH terminal, type **exit**, followed by **ENTER**.
