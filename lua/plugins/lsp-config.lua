return {
   {
      "williamboman/mason.nvim",
      config = function()
         require("mason").setup()
      end,
   },
   { "b0o/schemastore.nvim" },
   {
      "williamboman/mason-lspconfig.nvim",
      config = function()
         require("mason-lspconfig").setup({
            ensure_installed = {
               "ast_grep",
               "css_variables",
               "html",
               "tailwindcss",
               "cssls",
               "jdtls",
               "ts_ls",
               "eslint",
               "clangd",
               "jsonls",
               "lua_ls",
               "pylsp",
               "sqlls",
               "gopls",
            },
         })
      end,
   },
   -- Remove the nvim-lspconfig plugin entirely - it's no longer needed!
   -- LSP configuration is now built into Neovim 0.11+
   {
      "hrsh7th/nvim-cmp", -- Assuming you have nvim-cmp installed
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
         local capabilities = require("cmp_nvim_lsp").default_capabilities()

         -- Configure each LSP server
         vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
               Lua = {
                  diagnostics = {
                     globals = { "vim" },
                  },
                  workspace = {
                     library = vim.api.nvim_get_runtime_file("", true),
                     checkThirdParty = false,
                  },
                  telemetry = {
                     enable = false,
                  },
               },
            },
         })

         vim.lsp.config("clangd", {
            capabilities = capabilities,
            cmd = {
               "clangd",
               "--background-index",
               "--clang-tidy",
               "--header-insertion=iwyu",
               "--completion-style=detailed",
               "--function-arg-placeholders",
               "--fallback-style=llvm",
            },
            init_options = {
               usePlaceholders = true,
               completeUnimported = true,
               clangdFileStatus = true,
            },
            settings = {
               clangd = {
                  InlayHints = {
                     Designators = true,
                     Enabled = true,
                     ParameterNames = true,
                     DeducedTypes = true,
                  },
                  fallbackFlags = { "-std=c++20" },
               },
            },
         })

         vim.lsp.config("ts_ls", {
            capabilities = capabilities,
            filetypes = {
               "javascript",
               "javascriptreact",
               "javascript.jsx",
               "typescript",
               "typescriptreact",
               "typescript.tsx",
            },
            settings = {
               typescript = {
                  inlayHints = {
                     includeInlayParameterNameHints = "all",
                     includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                     includeInlayFunctionParameterTypeHints = true,
                     includeInlayVariableTypeHints = true,
                     includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                     includeInlayPropertyDeclarationTypeHints = true,
                     includeInlayFunctionLikeReturnTypeHints = true,
                     includeInlayEnumMemberValueHints = true,
                  },
                  suggest = {
                     includeCompletionsForModuleExports = true,
                     includeAutomaticOptionalChainCompletions = true,
                  },
                  preferences = {
                     importModuleSpecifier = "auto",
                     quoteStyle = "auto",
                     includePackageJsonAutoImports = "auto",
                  },
                  updateImportsOnFileMove = {
                     enabled = "always",
                  },
               },
               javascript = {
                  inlayHints = {
                     includeInlayParameterNameHints = "all",
                     includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                     includeInlayFunctionParameterTypeHints = true,
                     includeInlayVariableTypeHints = true,
                     includeInlayPropertyDeclarationTypeHints = true,
                     includeInlayFunctionLikeReturnTypeHints = true,
                     includeInlayEnumMemberValueHints = true,
                  },
                  suggest = {
                     includeCompletionsForModuleExports = true,
                     includeAutomaticOptionalChainCompletions = true,
                  },
                  preferences = {
                     importModuleSpecifier = "auto",
                     quoteStyle = "auto",
                  },
                  updateImportsOnFileMove = {
                     enabled = "always",
                  },
               },
               completions = {
                  completeFunctionCalls = true,
               },
            },
            flags = {
               debounce_text_changes = 150,
            },
         })

         vim.lsp.config("gopls", {
            capabilities = capabilities,
            settings = {
               gopls = {
                  completeUnimported = true,
                  usePlaceholders = true,
                  staticcheck = true,
                  gofumpt = true,
                  analyses = {
                     unusedparams = true,
                     nilness = true,
                     shadow = true,
                     unusedwrite = true,
                     useany = true,
                     experimentalWorkspaceModule = true,
                  },
                  codelenses = {
                     generate = true,
                     gc_details = true,
                     tidy = true,
                     test = true,
                  },
                  hints = {
                     assignVariableTypes = true,
                     compositeLiteralFields = true,
                     compositeLiteralTypes = true,
                     constantValues = true,
                     functionTypeParameters = true,
                     parameterNames = true,
                     rangeVariableTypes = true,
                  },
               },
            }
         })

         vim.lsp.config("tailwindcss", {
            capabilities = capabilities,
            filetypes = {
               "html",
               "css",
               "scss",
               "javascript",
               "javascriptreact",
               "typescript",
               "typescriptreact",
               "vue",
               "svelte",
            },
            settings = {
               tailwindCSS = {
                  classAttributes = { "class", "className", "classList", "ngClass" },
                  lint = {
                     cssConflict = "warning",
                     invalidApply = "error",
                     invalidConfigPath = "error",
                     invalidScreen = "error",
                     invalidTailwindDirective = "error",
                     invalidVariant = "error",
                     recommendedVariantOrder = "warning",
                  },
                  experimental = {
                     classRegex = {
                        "tw`([^`]*)",
                        "tw=\"([^\"]*)",
                        "tw={\"([^\"}]*)",
                        "tw\\.\\w+`([^`]*)",
                        { "clsx\\(([^)]*)\\)",       "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                        { "classnames\\(([^)]*)\\)", "'([^']*)'" },
                        { "cva\\(([^)]*)\\)",        "[\"'`]([^\"'`]*).*?[\"'`]" },
                     },
                  },
                  validate = true,
                  showPixelEquivalents = true,
                  rootFontSize = 16,
                  colorDecorators = true,
               },
            },
         })

         vim.lsp.config("html", {
            capabilities = capabilities,
            filetypes = { "html", "htmldjango" },
            settings = {
               html = {
                  format = {
                     enable = true,
                     wrapLineLength = 120,
                     wrapAttributes = "auto",
                     indentInnerHtml = true,
                     preserveNewLines = true,
                     maxPreserveNewLines = 2,
                  },
                  hover = {
                     documentation = true,
                     references = true,
                  },
                  autoClosingTags = true,
                  suggest = {
                     html5 = true,
                  },
                  validate = {
                     scripts = true,
                     styles = true,
                  },
               },
            },
         })

         vim.lsp.config("cssls", {
            capabilities = capabilities,
            settings = {
               css = {
                  validate = true,
                  lint = {
                     unknownAtRules = "ignore",
                     duplicateProperties = "warning",
                     emptyRules = "warning",
                     importStatement = "ignore",
                     float = "ignore",
                     fontFaceProperties = "warning",
                  },
                  completion = {
                     triggerPropertyValueCompletion = true,
                     completePropertyWithSemicolon = true,
                  },
                  hover = {
                     documentation = true,
                     references = true,
                  },
               },
               scss = {
                  validate = true,
                  lint = {
                     unknownAtRules = "ignore",
                     duplicateProperties = "warning",
                  },
               },
               less = {
                  validate = true,
                  lint = {
                     unknownAtRules = "ignore",
                     duplicateProperties = "warning",
                  },
               },
            },
         })

         vim.lsp.config("eslint", {
            capabilities = capabilities,
            settings = {
               codeAction = {
                  disableRuleComment = {
                     enable = true,
                     location = "separateLine",
                  },
                  showDocumentation = {
                     enable = true,
                  },
               },
               codeActionOnSave = {
                  enable = false,
                  mode = "all",
               },
               format = true,
               nodePath = "",
               onIgnoredFiles = "off",
               packageManager = "npm",
               quiet = false,
               rulesCustomizations = {},
               run = "onType",
               useESLintClass = false,
               validate = "on",
               workingDirectory = {
                  mode = "auto",
               },
            },
         })

         vim.lsp.config("jsonls", {
            capabilities = capabilities,
            settings = {
               json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
               },
            },
         })

         vim.lsp.config("pylsp", {
            capabilities = capabilities,
         })

         vim.lsp.config("sqlls", {
            capabilities = capabilities,
         })

         vim.lsp.config("jdtls", {
            capabilities = capabilities,
         })

         -- Enable all configured LSP servers
         vim.lsp.enable({
            "lua_ls",
            "ts_ls",
            "gopls",
            "tailwindcss",
            "html",
            "cssls",
            "eslint",
            "jsonls",
            "pylsp",
            "sqlls",
            "jdtls",
            "clangd"
         })

         -- LSP Keymaps
         vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
         vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
         vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
         vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
         vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show References" })
         vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "Signature Help" })
         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
         vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
         vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
         end, { desc = "Format Document" })

         -- Inlay hints toggle
         vim.keymap.set("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
         end, { desc = "Toggle Inlay Hints" })
      end,
   },
}
