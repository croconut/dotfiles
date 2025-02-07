#!/usr/bin/env python3
import os
import subprocess
from typing import List, NamedTuple, Sequence
from pathlib import Path

class TInstall(NamedTuple):
    loc: str
    name: str
    cmds: List[Sequence[str]]
    append_zshrc: List[str]

class SHInstall(NamedTuple):
    url: str
    cmds: List[Sequence[str]]
    append_zshrc: List[str]

HOME_DIR = Path.home().absolute().as_posix()

def env_into_rc(name: str, value: str):
    return f"export {name}=\"{value}\""

def path_into_rc(path: str):
    return f"export PATH=\"$PATH:{path}\""

def chunk_array(arr: List[str], delimiter: str):
    result = []
    current_chunk = []
    for element in arr:
        if element == delimiter:
            if current_chunk:
                result.append(current_chunk)
            current_chunk = []
        else:
            current_chunk.append(element)
    if current_chunk:
        result.append(current_chunk)
    return result

TAR_INSTALLS = [
    TInstall("https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz",
             "nvim-linux-x86_64.tar.gz",
             ["sudo rm -rf /opt/nvim-linux-x86_64".split(" "), 
              "sudo tar -C /opt -xzf ./nvim-linux-x86_64.tar.gz".split(" ")],
             [path_into_rc("/opt/nvim-linux-x86_64/bin")]),
    TInstall("https://downloads.slack-edge.com/desktop-releases/linux/x64/4.41.105/slack-desktop-4.41.105-amd64.deb",
             "slack.deb",
             ["sudo dpkg -i ./slack.deb".split(" "), "sudo apt-get install -f".split(" ")],
             []),
    TInstall("https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb",
            "google-chrome-stable_current_amd64.deb",
             ["sudo dpkg -i ./google-chrome-stable_current_amd64.deb".split(" "), "sudo apt-get install -f".split(" ")],
             []),
    TInstall("https://download.jetbrains.com/datagrip/datagrip-2024.3.4.tar.gz",
             "datagrip.tar.gz",
             ["sudo rm -rf /opt/DataGrip-2024.3.4".split(" "), 
              "sudo tar -C /opt -xzf ./datagrip.tar.gz".split(" ")],
             [path_into_rc("/opt/DataGrip-2024.3.4/bin")]),
    TInstall("https://downloads.sqlc.dev/sqlc_1.28.0_linux_amd64.tar.gz",
             "sqlc.tar.gz",
             ["sudo rm -rf /opt/sqlc".split(" "),
              "mkdir /opt/sqlc".split(" "),
              "sudo tar -C /opt/sqlc -xzf ./sqlc.tar.gz".split(" ")],
             [path_into_rc("/opt/sqlc")]),
]

SH_INSTALLS = [
    SHInstall("https://get.volta.sh", 
              [],
              [env_into_rc("VOLTA_HOME", "$HOME/.volta"), 
               path_into_rc("$VOLTA_HOME/bin")]),
    SHInstall("https://bun.sh/install",
              [],
              [env_into_rc("BUN_INSTALL", "$HOME/.bun"),
               path_into_rc("$BUN_INSTALL/bin")]),
]

## these commands need to actually use arrays
## esp since they have pipes
PRE_ZSH = [
    "sudo apt-get update".split(" "),
    "sudo apt-get install -y build-essential dpkg sudo zip unzip curl wget grep fzf xclip tar redis-tools python-setuptools python-pip \
            passwd openssl gzip diffutils ssh jq zsh".split(" "),
    ["which", "zsh", "|", "sudo", "xargs", "chsh", "-s"],
    ## remove package lists we're writing to
    "sudo rm -f /etc/apt/sources.list.d/mozilla.list".split(" "),
    "sudo rm -f /etc/apt/sources.list.d/shiftkey-packages.list".split(" "),
    ## add to package list after standard packages installed
    "wget -qO- https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg".split(" "),
    ["echo", "deb", "[arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg]", "https://apt.packages.shiftkey.dev/ubuntu/ any main", "|", "sudo", "tee", "-a", "/etc/apt/sources.list.d/shiftkey-packages.list"],
    "sudo install -d -m 0755 /etc/apt/keyrings".split(" "),
    "wget -qO- https://packages.mozilla.org/apt/repo-signing-key.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc".split(" "),
    ["echo", "deb", "[signed-by=/etc/apt/keyrings/packages.mozilla.org.asc]", "https://packages.mozilla.org/apt mozilla main", "|", "sudo", "tee", "-a", "/etc/apt/sources.list.d/mozilla.list"],
    ["sudo", "echo", "-e", "\
Package: *\
Pin: origin packages.mozilla.org\
Pin-Priority: 1000\
", "|", "sudo", "tee", "/etc/apt/preferences.d/mozilla"],
    ## add packages from new package lists
    "sudo apt-get update".split(" "),
    "sudo apt-get install -y github-desktop firefox".split(" "),
    "sudo apt-get autoremove -y".split(" "),
]

APPEND_ZSHRC = [
    "alias neovim=\"nvim\"",
    "alias vimhuge=\"nvim -u NONE\"",
    "alias repo='(){ cd \"$HOME/Documents/git/$1/\" ;}'",
    "alias gitbranch='(){ git checkout -b $1; git push -u origin $1; }'",
    "fpath=(~/.zsh $fpath)",
    "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh",
    env_into_rc("TERM", "xterm-256color"),
    env_into_rc("SH_LOCATION", "/usr/bin/zsh"),
    env_into_rc("AWS_SHARED_CREDENTIALS_FILE", "$HOME/.aws/credentials"),
    path_into_rc("$HOME/.local/bin")
]

for cmd in PRE_ZSH:
    cmds = chunk_array(cmd, "|")
    if len(cmds) < 2:
        subprocess.run(cmds[0], check=True)
    else:
        prev = []
        for cmd in cmds:
            if len(prev) == 0:
                print('starting new piped cmd', " ".join(cmd))
                prev.append(subprocess.Popen(cmd, stdout=subprocess.PIPE))
            else:
                print('cont. piped cmd', " ".join(cmd))
                lastout = prev[-1].stdout
                prev.append(subprocess.Popen(cmd, stdin=lastout, stdout=subprocess.PIPE))
        for proc in prev[:-1]:
            proc.stdout.close()
        output, error = prev[-1].communicate()
        if error:
            print(error.decode())
        else:
            try:
                print(output.decode().strip())
            except Exception as e:
                print("could not decode, continuing", e)



## install zsh
zsh1 = subprocess.Popen(["wget", "-q", "-L", "-O-", "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"], stdout=subprocess.PIPE)
zsh2 = subprocess.Popen(["bash"], stdin=zsh1.stdout, stdout=subprocess.PIPE)
zsh1.stdout.close()
output, error = zsh2.communicate()
if error:
    print(error.decode())
else:
    try:
        print(output.decode().strip())
    except Exception as e:
        print("could not decode, continuing", e)

with open(HOME_DIR + "/.zshrc", 'a') as zshrc:
    for app in APPEND_ZSHRC:
        print(app, file=zshrc)

    for ins in TAR_INSTALLS: 
        subprocess.run(["wget", "-q", "-L", "-O", ins.name, ins.loc],  check=True)
        for cmd in ins.cmds:
            subprocess.run(cmd,  check=True)
        for app in ins.append_zshrc:
            print(app, file=zshrc)


    for ins in SH_INSTALLS:
        proc1 = subprocess.Popen(["wget", "-q", "-L", "-O-", ins.url],  stdout=subprocess.PIPE)
        proc2 = subprocess.Popen(["bash"],  stdin=proc1.stdout, stdout=subprocess.PIPE)
        proc1.stdout.close()
        output, error = proc2.communicate()
        if error:
            print(error.decode())
        else:
            try:
                print(output.decode().strip())
            except Exception as e:
                print("could not decode, continuing", e)
        for cmd in ins.cmds:
            subprocess.run(cmd,  check=True)
        for app in ins.append_zshrc:
            print(app, file=zshrc)

# clean up files created by tar / zip installs
for t in TAR_INSTALLS:
    os.remove("./" + t.name)

## post completion instructions

print("in the ~/.zshrc file you'll need to:")
print('  *  set export AWS_MFA_ARN yourself -> format looks like export AWS_MFA_ARN="arn:aws:iam::MY_AWS_ACCOUNT_ID:mfa/MY_IAM_NAME"')
print('  *  set export AWS_ACCOUNT_USERNAME')
print('  *  set export TEST_EMAIL')
print('  *  set export EMAIL_ADDR_NO_REPLY')
print('then you\'ll want to log into chrome, add the "open in firefox" extension, set behavior to default \
open in firefox, and get the PWA for ringcentral, hoppscotch, and outlook')
print('and finally, run source ~/.zshrc and you can init volta to LTS node with `volta install node`')
