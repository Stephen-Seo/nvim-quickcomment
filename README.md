# NVim QuickComment

[![Quick comment demo](https://github.com/Stephen-Seo/nvim-quickcomment/raw/main/images/quickcomment.gif)](https://github.com/Stephen-Seo/nvim-quickcomment)

Quickly comment lines in a file with a single command.

## Installation

Create the directory structure `${HOME}/.config/nvim/pack/plugins/start/` and
place `nvim-quickcomment/` in `start/`, or use a plugin manager.

## Usage

Add the following to your init.lua (replace "q" with the key you want to map to):

    vim.cmd('nmap q :lua vim.g.quickcomment_togglecommentline()<CR>')
    vim.cmd('vmap q :luado vim.g.quickcomment_togglecommentline(linenr)<CR>')

Or in init.vim:

    nmap q :lua vim.g.quickcomment_togglecommentline()<CR>
    vmap q :luado vim.g.quickcomment_togglecommentline(linenr)<CR>
