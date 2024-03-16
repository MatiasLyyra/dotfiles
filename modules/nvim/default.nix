{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  config = {
    programs.nixvim = {
      enable = true;
      plugins = {
        nix.enable = true;
        conform-nvim = {
          enable = true;
          formattersByFt = {
            nix = [ "nixpkgs-fmt" ];
            go = [ "gofmt" ];
          };
          formatOnSave = {
            lspFallback = true;
            timeoutMs = 500;
          };
          formatters = {
            nixpkgs-fmt = {
              command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
            };
            gofmt = {
              command = "${pkgs.go_1_22}/bin/gofmt";
              args = [ "-w" ];
            };
          };
        };
        lsp = {
          enable = true;
          servers.gopls.enable = true;
          servers.nil_ls.enable = true;
        };
        lint = {
          enable = true;
          lintersByFt = {
            go = [ "${pkgs.go-tools}/bin/staticcheck" ];
          };
        };
        cmp = {
          enable = true;
          settings.sources = [
            { name = "buffer"; }
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "neorg"; }
            { name = "treesitter"; }
            { name = "lspconfig"; }
          ];
          settings.mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
        nvim-tree.enable = true;
        nvim-tree.openOnSetup = true;
        treesitter = {
          enable = true;
        };
      };
      clipboard.providers.wl-copy.enable = true;
      colorschemes.catppuccin = {
        enable = true;
      };
      extraConfigLua = ''
        vim.opt.tabstop = 2
        vim.opt.smartindent = true
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
      '';
    };
  };
}

