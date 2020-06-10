" Vim plugin for allowing easy reading of files
" Maintainer: mtdol
" License: 

" don't load if already loaded; don't load if compatible is set
if exists("g:loaded_scrollmode") || &cp
  finish
endif
let g:loaded_scrollmode = 1


" save user cpo
let s:save_cpo = &cpo
" for the scripts lifetime, set cpo to vim defaults
set cpo&vim

" basic mappings {{{
" gl is the default map to toggle scroll mode
if !hasmapto('<Plug>ToggleScrollMode')
    nmap <unique> gl <Plug>ToggleScrollMode
endif

nnoremap <unique> <script> <silent> <Plug>ToggleScrollMode :call <SID>ToggleScrollMode()<cr>
nnoremap <unique> <script> <silent> <Plug>EnableScrollMode :call <SID>EnableScrollMode()<cr>
nnoremap <unique> <script> <silent> <Plug>DisableScrollMode :call <SID>DisableScrollMode()<cr>


" allow commands
if !exists(":ToggleScrollMode")
    command -nargs=0 ToggleScrollMode :call <SID>ToggleScrollMode()
endif
if !exists(":EnableScrollMode")
    command -nargs=0 EnableScrollMode :call <SID>EnableScrollMode()
endif
if !exists(":DisableScrollMode")
    command -nargs=0 DisableScrollMode :call <SID>DisableScrollMode()
endif

"}}}

" global variables {{{

" These are the keys that allow the user to exit scroll mode when it is active
if !exists("g:ScrollMode_ExitScrollModeKeys")
    let g:ScrollMode_ExitScrollModeKeys = [
        \ "<esc>",
        \ "i",
        \ "a",
        \ "I",
        \ "A",
        \ "o",
        \ "O",
    \]
endif

" keys to use for scrolling when scroll mode is active
if !exists("g:ScrollMode_ScrollUpKeys")
    let g:ScrollMode_ScrollUpKeys = ["k"]
endif
if !exists("g:ScrollMode_ScrollDownKeys")
    let g:ScrollMode_ScrollDownKeys = ["j"]
endif
if !exists("g:ScrollMode_ScrollUpHardKeys")
    let g:ScrollMode_ScrollUpHardKeys = ["l"]
endif
if !exists("g:ScrollMode_ScrollDownHardKeys")
    let g:ScrollMode_ScrollDownHardKeys = ["h"]
endif

" the speed of the scrolling
if !exists("g:ScrollMode_UpScrollSpeed")
    let g:ScrollMode_UpScrollSpeed = 1
endif
if !exists("g:ScrollMode_DownScrollSpeed")
    let g:ScrollMode_DownScrollSpeed = 1
endif
if !exists("g:ScrollMode_UpHardScrollSpeed")
    let g:ScrollMode_UpHardScrollSpeed = 3
endif
if !exists("g:ScrollMode_DownHardScrollSpeed")
    let g:ScrollMode_DownHardScrollSpeed = 3
endif


"}}}

" script variables {{{

" remember what mode we are in
let s:ScrollEnabled = 0

" remember the users cursor settings
let s:CursorHighlightFG = ""
let s:CursorHighlightBG = ""
let s:TerminalCursorSetting = ""

" the keys that were last mapped to exit scroll mode
let s:ScrollMode_ExitScrollModeKeys = g:ScrollMode_ExitScrollModeKeys

" last used keys for movement
let s:ScrollMode_ScrollUpKeys = g:ScrollMode_ScrollUpKeys
let s:ScrollMode_ScrollDownKeys = g:ScrollMode_ScrollDownKeys
let s:ScrollMode_ScrollUpHardKeys = g:ScrollMode_ScrollUpHardKeys
let s:ScrollMode_ScrollDownHardKeys = g:ScrollMode_ScrollDownHardKeys
"}}}

" Functions {{{
" enter scroll mode
func s:EnableScrollMode()
    " guard against calling while scrollmode is active
    if s:ScrollEnabled ==# 1
        return
    endif

    " hide the cursor
    if has("gui_running")
        " save previous cursor highlight settings
        let s:CursorHighlightFG = synIDattr(synIDtrans(hlID("Cursor")), "fg")
        let s:CursorHighlightBG = synIDattr(synIDtrans(hlID("Cursor")), "bg")
        " clear the cursor highlighting
        highlight Cursor guibg=NONE guifg=NONE
    else
        " save the value for later and disble t_ve
        let s:TerminalCursorSetting = &t_ve
        set t_ve=
    endif

    " cache global settings
    let s:ScrollMode_ScrollUpKeys = g:ScrollMode_ScrollUpKeys
    let s:ScrollMode_ScrollDownKeys = g:ScrollMode_ScrollDownKeys
    let s:ScrollMode_ScrollUpHardKeys = g:ScrollMode_ScrollUpHardKeys
    let s:ScrollMode_ScrollDownHardKeys = g:ScrollMode_ScrollDownHardKeys
    " map movement keys
    for elem in g:ScrollMode_ScrollUpKeys
        exec "nnoremap ".elem." ".g:ScrollMode_UpScrollSpeed."<c-y>"
    endfor
    for elem in g:ScrollMode_ScrollDownKeys
        exec "nnoremap ".elem." ".g:ScrollMode_DownScrollSpeed."<c-e>"
    endfor
    for elem in g:ScrollMode_ScrollUpHardKeys
        exec "nnoremap ".elem." ".g:ScrollMode_UpHardScrollSpeed."<c-y>"
    endfor
    for elem in g:ScrollMode_ScrollDownHardKeys
        exec "nnoremap ".elem." ".g:ScrollMode_DownHardScrollSpeed."<c-e>"
    endfor

    " cache the keys we are mapping for later unmapping
    let s:ScrollMode_ExitScrollModeKeys = g:ScrollMode_ExitScrollModeKeys
    " map keys to exit scroll mode
    for elem in g:ScrollMode_ExitScrollModeKeys
        exec "nnoremap ".elem." :call <SID>DisableScrollMode()<cr>"
    endfor

    let s:ScrollEnabled = 1
    echo "-- ScrollMode Enabled --"
endfunc


" undo scroll mode
func s:DisableScrollMode()
    " guard against calling while scrollmode is not active
    if s:ScrollEnabled ==# 0
        return
    endif

    " show cursor again
    if has("gui_running")
        " return cursor highlighting
        exec "highlight Cursor guifg=".s:CursorHighlightFG
        exec "highlight Cursor guibg=".s:CursorHighlightBG
    else
        " restore terminal cursor highlighting
        let &t_ve = s:TerminalCursorSetting
    endif

    " unmap movement and modal keys
    for elem in s:ScrollMode_ScrollUpKeys
        exec "nunmap ".elem
    endfor
    for elem in s:ScrollMode_ScrollDownKeys
        exec "nunmap ".elem
    endfor
    for elem in s:ScrollMode_ScrollUpHardKeys
        exec "nunmap ".elem
    endfor
    for elem in s:ScrollMode_ScrollDownHardKeys
        exec "nunmap ".elem
    endfor

   
    " unmap exit scroll mode keys
    for elem in s:ScrollMode_ExitScrollModeKeys
        exec "nunmap ".elem
    endfor

    let s:ScrollEnabled = 0
    echo "-- ScrollMode Disabled --"
endfunc

" turn scroll mode off in on and on if off
func s:ToggleScrollMode()
    if (s:ScrollEnabled ==# 0)
        call s:EnableScrollMode() 
    else 
        call s:DisableScrollMode()
    endif
endfunc
" }}}


" reload user cpo
let &cpo = s:save_cpo
unlet s:save_cpo
