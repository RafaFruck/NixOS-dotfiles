return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				window = {
					mappings = {
						["h"] = "toggle_node",
						["l"] = "open",
					}
				},
				filesystem = {
					filtered_items = {
						visible = true,
					}
				}
			})
		end
	}
}
