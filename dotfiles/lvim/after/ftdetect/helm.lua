vim.cmd [[
  au BufNewFile,BufRead */templates/*.yaml,*/templates/*.yml,helmfile.yaml,helmfile.yml,*/values.yaml,*/values.yml,values*.yml.gotmpl,values*.yaml.gotmpl if search('\([^$]\|^\){{.\+}}', 'nw') | set filetype=helm | LspStop 1 |  endif
]]
