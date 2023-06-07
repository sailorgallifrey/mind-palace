vim.cmd [[
  au BufNewFile,BufRead *.yaml,*.yml if search('\([^$]\|^\){{.\+}}', 'nw') | set filetype=gotmpl | LspStop 1 |  endif
]]
