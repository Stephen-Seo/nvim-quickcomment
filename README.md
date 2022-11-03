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

## Overrides

Say you want to use `// ` to comment lines in C files instead of `/* ... */`.  
Set an override string like the following:

    let b:quickcomment_commentstring_override = '// %s'

This will override how the comment is set for the current buffer.  
It can also be set globally:

    let g:quickcomment_commentstring_override = '/* a comment: %s */'

Note that `b:quickcomment_...` has precedence over `g:quickcomment_...`. Also
note that `%s` must be in the override `commentstring` which denotes where the
line content is relative to the comment symbols.

[![Quick comment override demo](https://github.com/Stephen-Seo/nvim-quickcomment/raw/main/images/quickcomment_override.gif)](https://github.com/Stephen-Seo/nvim-quickcomment#overrides)
