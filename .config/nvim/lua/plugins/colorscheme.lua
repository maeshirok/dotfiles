return {
	-- Solarized Osaka(参考: craftzdog/dotfiles の見た目)
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = {
			transparent = true,
		},
	},

	-- LazyVim のカラースキームとして適用する
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "solarized-osaka",
		},
	},
}
