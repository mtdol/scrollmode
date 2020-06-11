# scrollmode
Allows easier file reading and scrolling in Vim.

## Installation
Install the plugin to your prefered location
```
cd ~/.vim/bundle
git clone --depth=1 "https://github.com/mtdol/scrollmode"
```
Add to runtime path or use your favorite plugin manager
```
set rtp+=~/.vim/bundle/scrollmode
```

## Default Functionality
Scroll mode allows you to walk up and down the file in the same way as the `<c-e>` and `<c-y>` keys  
except it makes the behavior modal and accesible with just one hand.

Note these keys can be remapped.

By default use:
* the `gl` key to toggle *scrollmode* on and off  
* the `j` key to scroll down  
* the `k` key to scroll up
* the `h` key to scroll down hard
* and the `l` key to scroll up hard

To exit scroll mode use any of:
* `<esc>`
* `i`
* `I`
* `a`
* `A`
* `o`
* `O`

or simply press `gl` again.

Also provided are the Ex commands:
```vimscript
:ToggleScrollMode
:EnableScrollMode
:DisableScrollMode
```


## Customization
The script can be customized by way of global variables and the \<Plug> mapping  
  
For example to map ToggleScrollMode to something other that `gl`, place in your vimrc
```vimscript
nmap {other mapping} <Plug>ToggleScrollMode
```

To change the keys used to exit _scrollmode_ from within use the list:
```vimscript
let g:ScrollMode_ExitScrollModeKeys = [
    \ "<esc>",
    \ "i",
    \ "a",
    \ "I",
    \ "A",
    \ "o",
    \ "O",
\]
```
where the entries in the list are your own values.


To change the keys used to move up, down, hard up, hard down  
assign elements to the following lists:
```vimscript
g:ScrollMode_ScrollUpKeys
g:ScrollMode_ScrollDownKeys
g:ScrollMode_ScrollUpHardKeys
g:ScrollMode_ScrollDownHardKeys
```
For example if I want to use both `j` and `p` to move down I would set
```vimscript
g:ScrollMode_ScrollDownKeys = ["j","p"]
```

Finally the scrolling speed can be changed via the following global variables:
```vimscript
let g:ScrollMode_UpScrollSpeed = 1
let g:ScrollMode_DownScrollSpeed = 1
let g:ScrollMode_UpHardScrollSpeed = 3
let g:ScrollMode_DownHardScrollSpeed = 3
```
where the values given are the defaults.
