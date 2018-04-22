#!/usr/bin/env bash
## ~/.bash_logout: executed by bash when "login shell" exits.

## when leaving the console clear the screen to increase privacy
[[ "$SHLVL" == 1 ]] && [[ -x /usr/bin/clear_console ]] && /usr/bin/clear_console -q
