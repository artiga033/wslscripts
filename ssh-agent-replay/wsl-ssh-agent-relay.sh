#!/bin/sh

# On the Windows side, install https://github.com/jstarks/npiperelay
npiperelay=/mnt/c/path/to/npiperelay.exe
socat UNIX-LISTEN:/run/user/1000/wsl-ssh-agent.sock,fork EXEC:"$npiperelay -ei -s //./pipe/openssh-ssh-agent",nofork
