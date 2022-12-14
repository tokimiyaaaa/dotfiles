local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    vim.cmd [[packadd packer.nvim]]
    return true
  end
end

local packer_bootstrap = ensure_packer()

vim.cmd [[
  augroup packer_user_config
   autocmd!
   autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
  return
end

packer.init {
  max_jobs = 10,
  profile = {
    enable = true,
    threshold = 0, -- integer in milliseconds, plugins which load faster than this won't be shown in profile output
  },
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup {
  function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    use {
      "neovim/nvim-lspconfig",
    }

    use {
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "saadparwaiz1/cmp_luasnip",
      },
    }

    use {
      "L3MON4D3/LuaSnip",
    }

    use {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
      run = ":TSUpdate",
      config = function()
        require("configs.treesitter").setup()
      end,
    }

    use {
      "lewis6991/gitsigns.nvim",
      event = "BufRead",
      config = function()
        require("configs.gitsigns").setup()
      end,
    }

    use {
      "folke/tokyonight.nvim",
      event = "BufEnter",
      module = { "tokyonight", "tokyonight.colors" },
      config = function()
        require("configs.colorscheme").setup()
      end,
    }

    use {
      "nvim-lualine/lualine.nvim",
      after = "tokyonight.nvim",
      event = "BufEnter",
      config = function()
        require("configs.statusline").setup()
      end,
    }

    use {
      "akinsho/bufferline.nvim",
      tag = "v3.*",
      after = "tokyonight.nvim",
      config = function()
        require("configs.bufferline").setup()
      end,
    }

    use {
      "kyazdani42/nvim-tree.lua",
      requires = { "kyazdani42/nvim-web-devicons" },
      cmd = {
        "NvimTreeToggle",
        "NvimTreeOpen",
        "NvimTreeClose",
        "NvimTreeFindFile",
      },
      config = function()
        require("configs.nvim-tree").setup()
      end,
    }

    use {
      "nvim-telescope/telescope.nvim",
      tag = "*",
      requires = { "nvim-lua/plenary.nvim" },
      module = "telescope",
      config = function()
        require("configs.telescope").setup()
      end,
    }

    use {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
    }

    use {
      "folke/which-key.nvim",
      config = function()
        require("configs.which-key").setup()
      end,
    }

    use {
      "glepnir/dashboard-nvim",
      event = "VimEnter",
      config = function()
        require("configs.dashboard").setup()
      end,
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      packer.sync()
    end
  end,
}
