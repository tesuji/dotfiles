#!/usr/bin/env bash

sed -E "s/(\/home\/)[a-z_][a-z0-9_]{0,30}/\1user/"