-- lsp-config.lua
-- Fixed: uses vim.lsp.config() + vim.lsp.enable() (Neovim 0.11+ API)
-- All servers now actually start. tailwindcss/html/cssls/eslint/jsonls added to mason.

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
			require("mason").setup()
			require("mason-lspconfig").setup({
				-- All servers you configure below must be listed here so Mason installs them
				ensure_installed = {
					"lua_ls",
					"gopls",
					"clangd",
					"ts_ls",
					"tailwindcss",   -- was missing
					"html",          -- was missing
					"cssls",         -- was missing
					"eslint",        -- was missing
					"jsonls",        -- was missing
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local util = require("lspconfig.util")

			-- ─── Lua ───────────────────────────────────────────────────────────────
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					on_dir(vim.fs.root(bufnr, {
						".luarc.json", ".luarc.jsonc", ".luacheckrc",
						".stylua.toml", "stylua.toml", "selene.toml",
						"selene.yml", ".git",
					}))
				end,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- ─── Go ────────────────────────────────────────────────────────────────
			vim.lsp.config("gopls", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					on_dir(vim.fs.root(bufnr, { "go.mod", ".git" }))
				end,
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						staticcheck = true,
						gofumpt = true,
						-- Added: vulnerability checking
						vulncheck = "Imports",
						-- Added: reduce noise while typing
						diagnosticsDelay = "500ms",
						analyses = {
							unusedparams = true,
							nilness = true,
							shadow = true,
							unusedwrite = true,
							useany = true,
							-- Added: deprecated API warnings
							SA1019 = true,
						},
						codelenses = {
							generate = true,
							gc_details = true,
							tidy = true,
							test = true,
							run_vulncheck_exp = true, -- Added: vuln codelens
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
				},
			})

			-- ─── C/C++ ─────────────────────────────────────────────────────────────
			vim.lsp.config("clangd", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					on_dir(vim.fs.root(bufnr, {
						".clangd", ".clang-tidy", ".clang-format",
						"compile_commands.json", "compile_flags.txt",
						"configure.ac", ".git",
					}))
				end,
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

			-- ─── TypeScript / JavaScript ───────────────────────────────────────────
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					on_dir(vim.fs.root(bufnr, {
						"package.json", "tsconfig.json", "jsconfig.json", ".git",
					}))
				end,
				filetypes = {
					"javascript", "javascriptreact", "javascript.jsx",
					"typescript", "typescriptreact", "typescript.tsx",
				},
				settings = {
					-- Added: increase memory for large Next.js projects
					tsserver = {
						maxTsServerMemory = 4096,
					},
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
						updateImportsOnFileMove = { enabled = "always" },
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
						updateImportsOnFileMove = { enabled = "always" },
					},
					-- Fixed: completeFunctionCalls belongs at root completions key
					completions = {
						completeFunctionCalls = true,
					},
				},
				flags = { debounce_text_changes = 150 },
			})

			-- ─── Tailwind CSS ──────────────────────────────────────────────────────
			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					on_dir(vim.fs.root(bufnr, {
						"tailwind.config.js", "tailwind.config.cjs",
						"tailwind.config.mjs", "tailwind.config.ts",
						"postcss.config.js", "postcss.config.cjs",
						"postcss.config.mjs", "postcss.config.ts",
						"package.json", ".git",
					}))
				end,
				filetypes = {
					"html", "css", "scss", "javascript", "javascriptreact",
					"typescript", "typescriptreact", "vue", "svelte",
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
								'tw="([^"]*)',
								'tw={"([^"}]*)',
								"tw\\.\\w+`([^`]*)",
								{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
								{ "classnames\\(([^)]*)\\)", "'([^']*)'" },
								{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
							},
						},
						validate = true,
						showPixelEquivalents = true,
						rootFontSize = 16,
						colorDecorators = true,
					},
				},
			})

			-- ─── HTML ──────────────────────────────────────────────────────────────
			vim.lsp.config("html", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, { "package.json", ".git" })
					on_dir(root or vim.fn.getcwd())
				end,
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
						hover = { documentation = true, references = true },
						autoClosingTags = true,
						suggest = { html5 = true },
						validate = { scripts = true, styles = true },
					},
				},
			})

			-- ─── CSS / SCSS / Less ─────────────────────────────────────────────────
			vim.lsp.config("cssls", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, { "package.json", ".git" })
					on_dir(root or vim.fn.getcwd())
				end,
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
						hover = { documentation = true, references = true },
					},
					scss = {
						validate = true,
						lint = { unknownAtRules = "ignore", duplicateProperties = "warning" },
					},
					less = {
						validate = true,
						lint = { unknownAtRules = "ignore", duplicateProperties = "warning" },
					},
				},
			})

			-- ─── ESLint ────────────────────────────────────────────────────────────
			vim.lsp.config("eslint", {
				capabilities = capabilities,
				filetypes = {
					"javascript", "javascriptreact", "javascript.jsx",
					"typescript", "typescriptreact", "typescript.tsx",
					"vue", "svelte",
				},
				root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, {
						".eslintrc", ".eslintrc.js", ".eslintrc.cjs",
						".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json",
						"eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
						"package.json",
					})
					if root then
						on_dir(root)
					else
						local git_root = util.find_git_ancestor(vim.api.nvim_buf_get_name(bufnr))
						if git_root then on_dir(git_root) end
					end
				end,
				settings = {
					codeAction = {
						disableRuleComment = { enable = true, location = "separateLine" },
						showDocumentation = { enable = true },
					},
					codeActionOnSave = { enable = false, mode = "all" },
					format = true,
					nodePath = "",
					onIgnoredFiles = "off",
					packageManager = "npm",
					quiet = false,
					rulesCustomizations = {},
					run = "onType",
					useESLintClass = false,
					validate = "on",
					workingDirectory = { mode = "auto" },
				},
			})

			-- ─── JSON ──────────────────────────────────────────────────────────────
			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, { ".git" })
					on_dir(root or vim.fn.getcwd())
				end,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			-- ─── Enable all configured servers ────────────────────────────────────
			-- CRITICAL: vim.lsp.config() only defines the config. vim.lsp.enable()
			-- is what actually starts the servers. Without this, nothing runs.
			vim.lsp.enable({
				"lua_ls",
				"gopls",
				"clangd",
				"ts_ls",
				"tailwindcss",
				"html",
				"cssls",
				"eslint",
				"jsonls",
				-- Note: jdtls is intentionally excluded here.
				-- It is managed by nvim-jdtls in java.lua via BufEnter autocmd.
			})

			-- ─── Keymaps ──────────────────────────────────────────────────────────
			-- These fire once and apply globally via the LspAttach autocmd pattern
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "K",           vim.lsp.buf.hover,           vim.tbl_extend("force", opts, { desc = "LSP hover" }))
					vim.keymap.set("n", "gd",          vim.lsp.buf.definition,      vim.tbl_extend("force", opts, { desc = "Go to definition" }))
					vim.keymap.set("n", "gD",          vim.lsp.buf.declaration,     vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
					vim.keymap.set("n", "gi",          vim.lsp.buf.implementation,  vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
					vim.keymap.set("n", "gr",          vim.lsp.buf.references,      vim.tbl_extend("force", opts, { desc = "Show references" }))
					vim.keymap.set("n", "gs",          vim.lsp.buf.signature_help,  vim.tbl_extend("force", opts, { desc = "Signature help" }))
					vim.keymap.set("n", "<leader>rn",  vim.lsp.buf.rename,          vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, vim.tbl_extend("force", opts, { desc = "Format document" }))
					-- Added: diagnostic navigation
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,  vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next,  vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
					vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Open diagnostic float" }))
				end,
			})
		end,
	},
}
