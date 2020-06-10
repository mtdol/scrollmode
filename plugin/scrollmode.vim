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


" script variables

" remember what mode we are in
let s:ScrollEnabled = 0

" remember the users cursor settings
let s:CursorHighlightFG = ""
let s:CursorHighlightBG = ""
let s:TerminalCursorSetting = ""


" enter scroll mode
func EnableScrollMode()
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

    nnoremap j <c-e>
    nnoremap k <c-y>
    nnoremap h 3<c-e>
    nnoremap l 3<c-y>
    nnoremap <esc> :call DisableScrollMode()<cr>
    nnoremap i :call DisableScrollMode()<cr>
    nnoremap a :call DisableScrollMode()<cr>
    nnoremap I :call DisableScrollMode()<cr>
    nnoremap A :call DisableScrollMode()<cr>
    nnoremap o :call DisableScrollMode()<cr>
    nnoremap O :call DisableScrollMode()<cr>
    let s:ScrollEnabled = 1
    echom "-- ScrollMode Enabled --"
endfunc


" undo scroll mode
func DisableScrollMode()
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
    nunmap j
    nunmap k
    nunmap h
    nunmap l
    nunmap <esc>
    nunmap i
    nunmap a
    nunmap I
    nunmap A
    nunmap o
    nunmap O
    let s:ScrollEnabled = 0
    echom "-- ScrollMode Disabled --"
endfunc


func ToggleScrollMode()
    if (s:ScrollEnabled ==# 0)
        call EnableScrollMode() 
    else 
        call DisableScrollMode()
    endif
endfunc


nnoremap gl :call ToggleScrollMode()<cr>


" reload user cpo
let &cpo = s:save_cpo
unlet s:save_cpo
