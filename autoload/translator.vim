vim9script

# File:         translator.vim
# Type:         utility
# Version:      2.0
# Date:         2026 Jul 09
# Author:       MyRequiem <mrvladislavovich@gmail.com>
# License:      MIT
# Description:  Core logic for selected text translation.

# Extract text slice bounds based on visual selection.
def GetSelectedText(): string
    var is_visual = (mode() =~# "[vV\<C-v>]")
    if is_visual
        execute "normal! \<Esc>"
    endif

    var first_line = is_visual ? line("'<") : line('.')
    var last_line  = is_visual ? line("'>") : line('.')
    var lines      = getline(first_line, last_line)

    if empty(lines)
        return ''
    endif

    var col_start = getpos("'<")[2] - 1
    var col_stop  = getpos("'>")[2] - 1

    if len(lines) == 1
        lines[0] = lines[0][col_start : col_stop]
    else
        lines[0]  = lines[0][col_start : ]
        lines[-1] = lines[-1][ : col_stop]
    endif

    return join(lines, "\n")
enddef

# Main entry point for text translation.
export def Translate_selected()
    echo 'Translating selected text...'

    var text = GetSelectedText()
    if empty(text)
        echo 'No text selected.'
        return
    endif

    # Detect translation direction automatically by checking for Cyrillic
    # characters.
    var mode_param = 'en:ru'
    if match(text, '\v[а-яА-ЯёЁ]') != -1
        mode_param = 'ru:en'
    endif

    # Sanitize input to escape shells and prevent execution payload injection.
    var sanitized_text = substitute(text, '"', '""', 'g')
    sanitized_text     = substitute(sanitized_text, '\\', '', 'g')
    sanitized_text     = substitute(sanitized_text, '`', '', 'g')

    # Execute translation using system call to translate-shell.
    var cmd = $'trans {mode_param} -brief -no-warn -no-browser -ipv4 "{sanitized_text}"'
    var translated_text = system(cmd)

    # Trim trailing newlines or whitespace from the shell output.
    translated_text = substitute(translated_text, '\v\n+$', '', '')

    # Copy output to system clipboard if requested and supported.
    if g:translator_copy_to_clipboard == 1 && has('unnamedplus')
        @+ = translated_text
    endif

    # Clear the "Translating selected text..." message from the command-line.
    redraw

    # Display result using highlighting.
    echohl TranslatedStr
    echo translated_text
    echohl None
enddef
