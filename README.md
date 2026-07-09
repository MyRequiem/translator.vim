# translator.vim

A lightweight Vim9script plugin for automatic, bidirectional text translation via `translate-shell`.

## Features
* **Zero Configuration**: Automatically detects language direction (`ru:en` or `en:ru`) by scanning selected text for Cyrillic characters.
* **Blazing Fast**: Written entirely in native Vim9script, leveraging compiled `def` functions without temporal file overhead.
* **Smart Output**: Displays translations instantly in the command-line area with custom highlights and optional system clipboard integration.

![screenshot](https://raw.githubusercontent.com/MyRequiem/translator.vim/master/screenshot.png)
