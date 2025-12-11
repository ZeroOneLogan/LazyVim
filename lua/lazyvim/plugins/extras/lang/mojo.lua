return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = "mojo",
      root = { "mojoproject.toml", ".mojo-project" },
    })
  end,

  -- Add Mojo to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "mojo" } },
  },

  -- Setup mojo-lsp-server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        mojo = {},
      },
    },
  },

  -- Add formatting support
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        mojo = { "mojo" },
      },
      formatters = {
        mojo = {
          command = "mojo",
          args = { "format", "-" },
          stdin = true,
        },
      },
    },
  },

  -- Filetype icons
  {
    "nvim-mini/mini.icons",
    opts = {
      filetype = {
        mojo = { glyph = "🔥", hl = "MiniIconsOrange" },
      },
    },
  },
}
