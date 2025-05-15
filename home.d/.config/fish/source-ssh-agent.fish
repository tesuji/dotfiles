#!/bin/env fish
# source-ssh-agent: Script to source for ssh-agent to work.
# copy /data/data/com.termux/files/usr/libexec/source-ssh-agent.sh
# also need to add addkeystoagent yes to ssh config

function start_agent
    ssh-agent -a $argv[1] > /dev/null
    ssh-add
end

set -gx SSH_AUTH_SOCK $PREFIX/var/run/ssh-agent.socket

set MESSAGE (ssh-add -L 2>&1)
if contains -- $MESSAGE 'Could not open a connection to your authentication agent.' \
    || contains -- $MESSAGE 'Error connecting to agent: Connection refused' \
    || contains -- $MESSAGE 'Error connecting to agent: No such file or directory'
    rm -f $SSH_AUTH_SOCK
    start_agent $SSH_AUTH_SOCK
else if test "$MESSAGE" = "The agent has no identities."
    ssh-add
end

# may be used by wrapper scripts:
# source /path/to/source-ssh-agent.fish
# $wrapped_cmd $argv
#set -l _arg_zero (status filename)
#set -g wrapped_cmd (string replace -r 'a$' '' $_arg_zero)
#set -e _arg_zero
