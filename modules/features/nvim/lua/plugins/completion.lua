return {
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		priority = 100,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- A ponte que você já usa no lsp.lua
			"hrsh7th/cmp-buffer", -- Autocompletar palavras do arquivo atual
			"hrsh7th/cmp-path",  -- Autocompletar caminhos de arquivos (/home/...)
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),       -- Força abrir o menu
					["<C-e>"] = cmp.mapping.abort(),              -- Fecha o menu
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter aceita a sugestão
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- Puxa dados do seu lsp.lua (Nix, Python, C, etc.)
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
