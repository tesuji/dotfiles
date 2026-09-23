#!/bin/sh
# Remove custom words of current username for Sublime Text
sed '/\"added_words\"/,/]/ d; /^$/d'
