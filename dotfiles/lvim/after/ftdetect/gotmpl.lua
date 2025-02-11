vim.cmd [[
  au BufNewFile,BufRead *.yaml.gotmpl,*.yml.gotmpl if search('\([^$]\|^\){{.\+}}', 'nw') | set filetype=gotmpl | LspStop 1 |  endif
]]
