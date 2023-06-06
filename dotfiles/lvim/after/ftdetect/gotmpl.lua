vim.cmd [[
  au BufNewFile,BufRead *.yaml,*.yml if search('\([^$]\|^\){{.\+}}', 'nw') | set filetype=gotmpl |  endif
]]
