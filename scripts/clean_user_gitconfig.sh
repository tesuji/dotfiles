#!/usr/bin/env bash

sed -E "s/(^\s*signingkey\s*=\s*)[0-9A-Z]{16}/\1DEAFBEEFCAFEBABE/;s/(^\s*name\s*=\s*)\w*/\1user/;s/(^\s*email\s*=\s*).*/\1example@email.com/"
