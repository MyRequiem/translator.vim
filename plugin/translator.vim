vim9script

# File:         translator.vim
# Type:         utility
# Version:      2.0
# Date:         2026 Jul 09
# Author:       MyRequiem <mrvladislavovich@gmail.com>
# License:      MIT
# Description:  Selected text translation utility using translate-shell.

# Prevent loading if disabled or already loaded.
if exists('g:loaded_translator') && g:loaded_translator == 1
    finish
endif
g:loaded_translator = 1

# Check for the required translate-shell executable.
if !executable('trans')
    echoerr 'Translator Error: "trans" executable (translate-shell) not found in PATH'
    finish
endif

# Import autoload functions with script-local alias.
import autoload '../autoload/translator.vim' as tr

setlocal selection=inclusive

# Initialize global plugin configuration variables.
g:translator_hotkey                  = get(g:, 'translator_hotkey', '<leader>t')
g:translator_copy_to_clipboard       = get(g:, 'translator_copy_to_clipboard', 0)
g:translator_color_translated_text   = get(g:, 'translator_color_translated_text', 'White')
g:translator_bgcolor_translated_text = get(g:, 'translator_bgcolor_translated_text', 'Black')

# Define highlight group dynamically using string interpolation.
execute($'hi TranslatedStr cterm=NONE ctermfg={g:translator_color_translated_text} ctermbg={g:translator_bgcolor_translated_text} gui=NONE guifg={g:translator_color_translated_text} guibg={g:translator_bgcolor_translated_text}')

# Map hotkey using <ScriptCmd> to safely evaluate the alias context.
execute($'vnoremap <silent> {g:translator_hotkey} <ScriptCmd>tr.Translate_selected()<CR>')

# vim:nowrap
