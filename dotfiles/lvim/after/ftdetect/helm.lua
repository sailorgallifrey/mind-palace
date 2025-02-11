vim.cmd [[
  au BufNewFile,BufRead */templates/*.yaml,*/templates/*.yml,helmfile.yaml,helmfile.yml,*/values.yaml,*/values.yml if search('\([^$]\|^\){{.\+}}', 'nw') | set filetype=helm | LspStop 1 |  endif
]]
