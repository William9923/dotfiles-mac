return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "luacheck",
        "shellcheck",
        "shfmt",
        "goimports",
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints = vim.tbl_deep_extend("force", opts.inlay_hints or {}, { enabled = true })
      opts.servers = opts.servers or {}

      local function add_lsp_keys(keys)
        vim.list_extend(keys, {
          { "<leader>ca", false },
          { "<leader>cr", false },
          { "gh", "<cmd>FzfLua lsp_references<cr>", desc = "References", has = "references" },
          {
            "<leader>la",
            vim.lsp.buf.code_action,
            desc = "Code Action",
            mode = { "n", "v" },
            has = "codeAction",
          },
        })

        if LazyVim.has("inc-rename.nvim") then
          keys[#keys + 1] = {
            "<leader>lr",
            function()
              local inc_rename = require("inc_rename")
              return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
            end,
            expr = true,
            desc = "Rename",
            has = "rename",
          }
        else
          keys[#keys + 1] = { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
        end
      end

      local keymaps = require("lazyvim.plugins.lsp.keymaps")
      if keymaps.set then
        opts.servers["*"] = opts.servers["*"] or {}
        opts.servers["*"].keys = opts.servers["*"].keys or {}
        add_lsp_keys(opts.servers["*"].keys)
      else
        add_lsp_keys(keymaps.get())
      end

      opts.servers.yamlls = vim.tbl_deep_extend("force", opts.servers.yamlls or {}, {
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      })

      opts.servers.lua_ls = vim.tbl_deep_extend("force", opts.servers.lua_ls or {}, {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath("config")
              and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
              path = { "lua/?.lua", "lua/?/init.lua" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          })
        end,
        settings = {
          Lua = {}, -- will be extended by on_init if no .luarc.json present
        },
      })

      opts.servers.vtsls = vim.tbl_deep_extend("force", opts.servers.vtsls or {}, {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data")
                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
      })

      opts.servers.gopls = vim.tbl_deep_extend("force", opts.servers.gopls or {}, {
        settings = {
          gopls = {
            buildFlags = { "-tags=cgo" },
            hints = {},
          },
        },
      })

      opts.setup = opts.setup or {}
      opts.setup.gopls = function()
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("user_gopls_semantic_tokens", { clear = true }),
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client or client.name ~= "gopls" or client.server_capabilities.semanticTokensProvider then
              return
            end

            local semantic = vim.tbl_get(client.config, "capabilities", "textDocument", "semanticTokens")
            if semantic == nil then
              return
            end

            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end,
        })
        -- end workaround
      end
    end,
  },
}
