#!/usr/bin/env bash
## Clean up personal info in ~/.gitconfig before pushing to remote server

sed -E "s/(^\s*signingkey\s*=\s*)[0-9A-Z]{16}/\1DEAFBEEFCAFEBABE/;s/(^\s*name\s*=\s*).*/\1user/;s/(^\s*email\s*=\s*).*/\1example@email.com/"
