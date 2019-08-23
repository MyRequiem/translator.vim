function! translator#Translate_selected(...) range abort " {{{1
    echo 'translate selected text...'

    let l:tr_param = g:translator_param
    if len(a:000)
        let l:tr_param = g:translator_param_reversed
    endif

    let l:tmp_file = fnamemodify('~/.vim-translate-inp-text', ':p')
    call writefile([], l:tmp_file, 's')

    " list of contents of all selected lines
    " ['str1_content', 'str2_content', ...]
    let s:lines = getline(a:firstline, a:lastline)
    " column of the first and last selected character (for indexing from 0)
    let s:col_start = getpos("'<")[2] - 1
    let s:col_stop = getpos("'>")[2] - 1

    " selection found in only one line
    if len(s:lines) < 2
        let s:lines[0]  = s:lines[0][s:col_start : s:col_stop]
    else
        " first line: take a substring from the beginning of the selection
        " to the end of the line
        let s:lines[0]  = s:lines[0][s:col_start :]
        " last line: take a substring from the beginning of the line to
        " the end of the selection
        let s:lines[-1] = s:lines[-1][:s:col_stop]
    endif

    " write line-by-line selected text to a temporary file
    for l:line in s:lines
        " duplicate double quotes, remove backslashes
        let line = substitute(l:line, '"', '""', 'g')
        let line = substitute(l:line, '\', '', 'g')
        let line = substitute(l:line, '`', '', 'g')

        call writefile([l:line], l:tmp_file, 'as')
    endfor

    let l:translator_command = g:translator_bin
    if !empty(l:tr_param)
        let l:translator_command .= ' ' . l:tr_param
    endif

    " read the temporary file and translate its contents
    let translated_text = system(
        \l:translator_command . ' "' . system('cat ' . l:tmp_file) . '"'
    \)

    if exists('g:translator_copy_to_clipboard') &&
            \ g:translator_copy_to_clipboard
        " check if unnamedplus register is available
        " (Vim should be compiled with a 'xterm_clipboard' feature)
        if has('unnamedplus')
            let @+ = translated_text
        endif
    endif

    " output translated text
    execute 'normal! :<Esc>'
    echohl TranslatedStr
    echo translated_text
    echohl None
    echo ' '

    " delete the temporary file
    call delete(fnameescape(l:tmp_file))
endfunction " 1}}}
