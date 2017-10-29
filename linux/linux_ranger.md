### RESOURCES

Inside ranger, **you can press ? for a list of key bindings, commands or settings.**  The file HACKING.md contains guidelines for code modification.  The directory doc/configs contains configuration files.  They are usually installed to /etc/ranger/config and can be obtained with ranger's --copy-config option.  The directory examples contains reference implementations for ranger plugins, sample configuration files and some programs for integrating ranger with other software.  They are usually installed to /usr/share/doc/ranger/examples.

### KEY BINDINGS

Key bindings are defined in the file ranger/config/rc.conf.  Check this file for a list of all key bindings.  You can copy it to your local configuration directory with the --copy-config=rc option.

Many key bindings take an additional numeric argument.  Type 5j to move down 5 lines, 2l to open a file in mode 2, 10<Space> to mark 10 files.

This list contains the most useful bindings:

#### MAIN BINDINGS

##### General

```
h, j, k, l    Move left, down, up or right
H, L          Move back and forward in the history
[, ]          Move up and down in the parent directory.
i             Inspect the current file in a bigger window.
E             Edit the current file in $EDITOR ("nano" by default)
S             Open a shell in the current directory
```

##### Operator Files

```
yy            Copy (yank) the selection, like pressing Ctrl+C in modern GUI programs.
dd            Cut the selection, like pressing Ctrl+X in modern GUI programs.
pp            Paste the files which were previously copied or cut, like pressing Ctrl+V in modern GUI programs.
po            Paste the copied/cut files, overwriting existing files.

pl, pL        Create symlinks (absolute or relative) to the copied files
phl           Create hardlinks to the copied files
```

##### Modify Permissions

```
<octal>=, +<who><what>, -<who><what>
Change the permissions of the selection.  For example, "777=" is equivalent to "chmod 777 %s", "+ar" does "chmod a+r %s", "-ow" does "chmod o-w %s" etc.
```

##### Bookmark

```
mX            Create a bookmark with the name X
`X            Move to the bookmark with the name X
```

##### Mark

```
Space         Mark a file.
v             Toggle the mark-status of all files
V             Starts the visual mode, which selects all files between the starting point and the cursor until you press ESC.  To unselect files in the same way, use "uV".
```

##### Sort

```
oX            Change the sort method (like in mutt)
zX            Change settings.  See the settings section for a list of settings and their hotkey.
```

##### Find

```
/             Search for files in the current directory.
f             Quickly navigate by entering a part of the filename. # find
n             Find the next file.  By default, this gets you to the newest file in the directory, but if you search something using the keys /, cm, ct, ..., it will get you to the next found entry.
N             Find the previous file.
```

##### Console

```
:             Open the console.
!             Open the console with the content "shell " so you can quickly run commands
@             Open the console with the content "shell  %s", placing the cursor before the " %s" so you can quickly run commands with the current selection as the argument.
r             Open the console with the content "open with " so you can decide which program to use to open the current file selection.
cd            Open the console with the content "cd "
```

##### Tab

```
Alt-N         Open a tab. N has to be a number from 0 to 9. If the tab doesn't exist yet, it will be created.
gn, ^N        Create a new tab.
gt, gT        Go to the next or previous tab. You can also use TAB and SHIFT+TAB instead.
gc, ^W        Close the current tab.  The last tab cannot be closed this way.
```

---
