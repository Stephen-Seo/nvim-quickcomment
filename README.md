# NVim QuickComment

## Usage

Add the following to your init.lua (replace "q" with the key you want to map to):

    vim.cmd('nmap q :lua vim.g.quickcomment_togglecommentline()<CR>')
    vim.cmd('vmap q :luado vim.g.quickcomment_togglecommentline(linenr)<CR>')

Or in init.vim:

    nmap q :lua vim.g.quickcomment_togglecommentline()<CR>
    vmap q :luado vim.g.quickcomment_togglecommentline(linenr)<CR>
