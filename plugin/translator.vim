" File:         translator.vim
" Type:         utility
" Version:      1.0
" Date:         23.08.19
" Author:       MyRequiem <mrvladislavovich@gmail.com>
" License:      MIT
" Description:  Translate selected text

scriptencoding utf-8

if exists('g:loaded_translator') && g:loaded_translator
    finish
endif

let g:loaded_translator = 1

let g:translator_bin = get(g:, 'translator_bin', 'trans')

if !executable(g:translator_bin)
    echoerr 'Executable file "' . g:translator_bin . '" not found'
    finish
endif

let g:translator_param          = get(g:, 'translator_param', '')
let g:translator_param_reversed = get(g:, 'translator_param_reversed', '')

setlocal selection=inclusive

let g:translator_color_translated_text =
        \ get(g:, 'translator_color_translated_text', 'White')

execute printf('hi TranslatedStr cterm=NONE ctermfg=%s gui=NONE guifg=%s',
             \ g:translator_color_translated_text,
             \ g:translator_color_translated_text
        \)

let g:translator_hotkey          = get(g:, 'translator_hotkey', '<leader>t')
let g:translator_hotkey_reversed = get(g:, 'translator_hotkey_reversed',
                                        \ '<leader>T')
execute 'vnoremap ' . g:translator_hotkey .
    \ " :call translator#Translate_selected()\<CR>"
execute 'vnoremap ' . g:translator_hotkey_reversed .
    \ " :call translator#Translate_selected(1)\<CR>"
