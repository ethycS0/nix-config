# neovim.nix
{
  pkgs,
  ...
}:

{
  programs.neovim =
    let
      toFile = file: builtins.readFile file;
    in
    {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      # ...
      extraPackages = with pkgs; [
        lua-language-server
        ripgrep
      ];

      plugins = with pkgs.vimPlugins; [

        {
          plugin = none-ls-nvim;
          type = "lua";
          config = 
            ''
              require("null-ls").setup({ 
                sources = { 
                  require("null-ls").builtins.formatting.clang_format, 
                  }, 
                })
            '';
        }

        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = toFile ./plugins/lsp.lua;
        }

        {
          plugin = comment-nvim;
          type = "lua";
          config = "require(\"Comment\").setup()";
        }

        {
          plugin = telescope-nvim;
          type = "lua";
          config = toFile ./plugins/telescope.lua;
        }

        {
          plugin = nvim-cmp;
          type = "lua";
          config = toFile ./plugins/cmp.lua;
        }

        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = "require(\"nvim-tree\").setup()";

        }

        {
          plugin = lualine-nvim;
          type = "lua";
          config = "require('lualine').setup()";
        }

        {
          plugin = conform-nvim;
          type = "lua";
          config = toFile ./plugins/conform.lua;
        }

        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = "require('gitsigns').setup()";
        }

        {
          plugin = nvim-autopairs;
          type = "lua";
          config = "require(\"nvim-autopairs\").setup()";
        }

        vim-tmux-navigator

        cmp-path
        cmp-buffer
        cmp-nvim-lsp
        cmp_luasnip
        luasnip

        friendly-snippets
        vim-nix
        telescope-fzf-native-nvim
        nvim-web-devicons
        lazydev-nvim

        {
          plugin = (
            nvim-treesitter.withPlugins (p: [
              p.tree-sitter-nix
              p.tree-sitter-vim
              p.tree-sitter-bash
              p.tree-sitter-lua
              p.tree-sitter-python
              p.tree-sitter-json
              p.tree-sitter-c
              p.tree-sitter-cpp
              p.tree-sitter-rust
              p.tree-sitter-asm
            ])
          );
          type = "lua";
          config = toFile ./plugins/treesitter.lua;
        }
      ];
      extraLuaConfig = ''
        ${builtins.readFile ./options.lua}
        ${builtins.readFile ./mappings.lua}
      '';

    };
}
