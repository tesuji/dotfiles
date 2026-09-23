# Some useful keyboard shortcuts in VIM

## Navigation

| Shortcuts          | Commmand                                  |
|:-------------------|:------------------------------------------|
| H, M, L            | go to **H**ighest, **M**iddle, **L**owest |
| 0, $               | first, last char in line                  |
| gi / g;            | go to the last edited location            |
| w / e              | go to the beginning/end of word           |
| Ctrl+S/Ctrl+Q      | block/unblock terminal                    |
| `{`/`}`            | jump to next/previous paragraph.          |

## Search and indentation

| Shortcuts          | Commmand                                  |
|:-------------------|:------------------------------------------|
| /foo\c             | find ignore case, `\c` is the escape char |
| :%s/\<string\>//gn | count matching pattern                    |
| :%s///gn           | count if having any previously search     |
| gg=G               | autoindent in C code                      |
| = (SUPER)          | reindent current line or selected area    |
| =%                 | reindent the current braces {}            |

**When searching:**
+ `.`, `*`, `\`, `[`, `^`, and `$` are metacharacters.
+ `+`, `?`, `|`, `&`, `{`, `(`, and `)` must be escaped to use their special function.
+ `\/` is / (use backslash + forward slash to search for forward slash)
+ `\t` is tab, `\s` is whitespace (space or tab)
+ `\n` is newline, `\r` is CR (carriage return = Ctrl-M = ^M)
+ After an opening `[`, everything until the next closing `]` specifies a [/collection](http://vimdoc.sourceforge.net/cgi-bin/help?tag=%2Fcollection). Character ranges can be represented with a `-`; for example a letter a, b, c, or the number 1 can be matched with `[1a-c]`. Negate the collection with `[^` instead of `[`; for example `[^1a-c]` matches any character except a, b, c, or 1.
+ `\{#\}` is used for repetition. `/foo.\{2\}` will match foo and the two following characters. The `\` is not required on the closing `}` so `/foo.\{2}` will do the same thing.
+ `\(foo\)` makes a backreference to foo. Parenthesis without escapes are literally matched. Here the `\` is required for the closing `\)`.

**When replacing:**
+ `\r` is newline, `\n` is a null byte (0x00).
+ `\&` is ampersand (`&` is the text that matches the search pattern).
+ `\0` inserts the text matched by the entire pattern
+ `\1` inserts the text of the first backreference. `\2` inserts the second backreference, and so on.

## Selection and mode

| Shortcuts  | Commmand                      |
|:-----------|:------------------------------|
| :x         | write and quit                |
| Q          | to go to ex mode              |
| :visual    | to back to vim                |
| `qq` / `q` | Start/stop recording          |
| q:         | It opens the _command window_ |
| Ctrl+V     | multiple selection            |
| :Ex        | file explorer note capital Ex |
| :ls        | list of buffers(eg following) |
| :cd ..     | move to parent directory      |

## Editing

| Shortcuts         | Commmand                                 |
|:------------------|:-----------------------------------------|
| :set paste        | paste without autoindent                 |
| :set nopaste      | after pasting (turn on autoindent)       |
| guu / gUU         | tolower / toupper line                   |
| gU / gUw          | uppercase letter / word                  |
| ~                 | invert case under cursor                 |
| gf (SUPER)        | open file name under cursor              |
| ga                | ascii, hex, octal of letter under cursor |
| g8                | hex of utf-8 letter under cursor         |
| ggg?G             | rot13 whole file                         |
| xp                | swap next two letters around             |
| Ctrl+A / Ctrl+X   | inc/decc number under cursor             |
| Ctrl+R=5\*5       | insert 25 into text                      |
| C                 | change to end of line (same as `c$`)     |
| `*` `#` `g*` `g#` | find word under cursor (for/back)wards   |
| %                 | match brackets {}[]()                    |
| Ctrl+N / Ctrl+P   | word completion in insert mode           |
| Ctrl+X / Ctrl+L   | Line complete (SUPER USEFUL)             |
| di<               | to delete in <>                          |
| diB               | to delete in {} Block                    |
| di\[              | to delete in \[\]                        |

## Clipboard and Register

| Shortcuts | Commmand                                     |
|:----------|:---------------------------------------------|
| "a        | access register, `a` is name of a register   |
| "kyy      | copy current line into register `k`          |
| "Kyy      | append to register by using a capital letter |
| "kp       | paste it                                     |
| "+p       | paste from system clipboard on Linux         |
| "\*p      | paste from _mouse highlight_ clipboard       |
| :reg      | access all currently defined registers       |
