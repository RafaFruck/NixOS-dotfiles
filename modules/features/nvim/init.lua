require('config.options')
require('config.keybinds')
require('config.lazy')

local kitty_font_group = vim.api.nvim_create_augroup("KittyDynamicFont", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = kitty_font_group,
	callback = function()
		-- Quando entra no Neovim: Mescla as fontes do nvim.conf na janela atual
		vim.fn.system("kitten @ load-config ~/.config/kitty/nvim.conf")
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = kitty_font_group,
	callback = function()
		-- Quando sai do Neovim: Recarrega o arquivo principal limpando o cache anterior
		vim.fn.system("kitten @ load-config ~/.config/kitty/kitty.conf")
	end,
})
