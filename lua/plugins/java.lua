-- java.lua
-- Full Java + Spring Boot development setup using nvim-jdtls.
--
-- Prerequisites — install these via Mason (:MasonInstall):
--   jdtls                  (Java LSP)
--   java-debug-adapter     (DAP support)
--   java-test              (run/debug individual tests)
--
-- Also requires Java 17+ on your system: `java --version`
--
-- nvim-jdtls is intentionally NOT set up through lspconfig.
-- It must be started via a BufEnter autocmd so it can receive
-- per-project data directories and attach the DAP bundles correctly.

return {
	{
		-- Mason installer entries for Java tooling
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"jdtls",
				"java-debug-adapter",
				"java-test",
			})
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" }, -- only loaded when a .java file is opened
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			-- Resolve Mason-installed paths
			local mason_registry = require("mason-registry")

			local function get_mason_pkg_path(name)
				local ok, pkg = pcall(mason_registry.get_package, name)
				if not ok or not pkg:is_installed() then
					vim.notify(
						"[java.lua] Mason package '" .. name .. "' is not installed.\n"
						.. "Run :MasonInstall " .. name,
						vim.log.levels.WARN
					)
					return nil
				end
				return pkg:get_install_path()
			end

			local jdtls_path    = get_mason_pkg_path("jdtls")
			local java_debug    = get_mason_pkg_path("java-debug-adapter")
			local java_test     = get_mason_pkg_path("java-test")

			if not jdtls_path then return end

			-- Collect DAP bundles (jars that extend jdtls with debug/test capabilities)
			local bundles = {}

			if java_debug then
				local debug_jar = vim.fn.glob(
					java_debug .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
					true, true
				)
				vim.list_extend(bundles, debug_jar)
			end

			if java_test then
				local test_jars = vim.fn.glob(
					java_test .. "/extension/server/*.jar",
					true, true
				)
				vim.list_extend(bundles, test_jars)
			end

			-- Find the jdtls launcher jar (version-agnostic glob)
			local launcher_jar = vim.fn.glob(
				jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar",
				true, false
			)

			-- Detect OS for the correct config directory
			local os_config
			local uname = vim.fn.system("uname -s"):gsub("\n", "")
			if uname == "Darwin" then
				os_config = "config_mac"
			elseif uname == "Linux" then
				os_config = "config_linux"
			else
				os_config = "config_win"
			end

			-- Per-project workspace so jdtls indexes don't bleed between projects
			local function get_workspace_dir()
				local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
				return vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name
			end

			-- The main jdtls setup function — called on every Java buffer
			local function setup_jdtls()
				local config = {
					-- Command to launch jdtls
					cmd = {
						"java",
						"-Declipse.application=org.eclipse.jdt.ls.core.id1",
						"-Dosgi.bundles.defaultStartLevel=4",
						"-Declipse.product=org.eclipse.jdt.ls.core.product",
						"-Dlog.protocol=true",
						"-Dlog.level=ALL",
						"-Xmx4g",                              -- 4GB heap for large Spring projects
						"--add-modules=ALL-SYSTEM",
						"--add-opens", "java.base/java.util=ALL-UNNAMED",
						"--add-opens", "java.base/java.lang=ALL-UNNAMED",
						"-jar", launcher_jar,
						"-configuration", jdtls_path .. "/" .. os_config,
						"-data", get_workspace_dir(),
					},

					-- Project root markers — covers Maven, Gradle, and plain Java
					root_dir = vim.fs.root(0, {
						"pom.xml",          -- Maven / Spring Boot
						"build.gradle",     -- Gradle
						"build.gradle.kts", -- Kotlin DSL Gradle
						"settings.gradle",
						".git",
					}),

					-- Per-project data directory (separate from workspace)
					-- This stores compiled class files and index caches
					settings = {
						java = {
							eclipse = { downloadSources = true },
							configuration = {
								updateBuildConfiguration = "interactive",
								-- Add your installed JDKs here if you have multiple
								-- runtimes = {
								--   { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
								--   { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk" },
								-- },
							},
							maven = { downloadSources = true },
							implementationsCodeLens = { enabled = true },
							referencesCodeLens = { enabled = true },
							references = { includeDecompiledSources = true },
							inlayHints = {
								parameterNames = { enabled = "all" }, -- literals, all, none
							},
							format = {
								enabled = true,
								-- Uncomment and point to your formatter XML if using a team style:
								-- settings = {
								--   url = vim.fn.stdpath("config") .. "/java-formatter.xml",
								--   profile = "GoogleStyle",
								-- },
							},
							-- Spring Boot specific: enable bean navigation codelenses
							springBoot = {
								enabled = true,
							},
							signatureHelp = { enabled = true },
							completion = {
								favoriteStaticMembers = {
									"org.hamcrest.MatcherAssert.assertThat",
									"org.hamcrest.Matchers.*",
									"org.hamcrest.CoreMatchers.*",
									"org.junit.jupiter.api.Assertions.*",
									"java.util.Objects.requireNonNull",
									"java.util.Objects.requireNonNullElse",
									"org.mockito.Mockito.*",
								},
								filteredTypes = {
									"com.sun.*",
									"io.micrometer.shaded.*",
									"java.awt.*",
									"jdk.*",
									"sun.*",
								},
							},
							sources = {
								organizeImports = {
									starThreshold = 9999,
									staticStarThreshold = 9999,
								},
							},
							codeGeneration = {
								toString = {
									template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
								},
								useBlocks = true,
							},
						},
					},

					-- Register DAP bundles so jdtls can expose debug/test endpoints
					init_options = {
						bundles = bundles,
					},

					-- Capabilities from nvim-cmp
					capabilities = require("cmp_nvim_lsp").default_capabilities(),

					-- On-attach: set up Java-specific keymaps and DAP
					on_attach = function(client, bufnr)
						local opts = { buffer = bufnr, noremap = true, silent = true }

						-- Java-specific code actions (beyond standard LSP)
						vim.keymap.set("n", "<leader>jo", function()
							require("jdtls").organize_imports()
						end, vim.tbl_extend("force", opts, { desc = "Java: organize imports" }))

						vim.keymap.set("n", "<leader>jv", function()
							require("jdtls").extract_variable()
						end, vim.tbl_extend("force", opts, { desc = "Java: extract variable" }))

						vim.keymap.set("v", "<leader>jv", function()
							require("jdtls").extract_variable(true)
						end, vim.tbl_extend("force", opts, { desc = "Java: extract variable (visual)" }))

						vim.keymap.set("n", "<leader>jc", function()
							require("jdtls").extract_constant()
						end, vim.tbl_extend("force", opts, { desc = "Java: extract constant" }))

						vim.keymap.set("v", "<leader>jm", function()
							require("jdtls").extract_method(true)
						end, vim.tbl_extend("force", opts, { desc = "Java: extract method (visual)" }))

						vim.keymap.set("n", "<leader>jt", function()
							require("jdtls").test_nearest_method()
						end, vim.tbl_extend("force", opts, { desc = "Java: run nearest test" }))

						vim.keymap.set("n", "<leader>jT", function()
							require("jdtls").test_class()
						end, vim.tbl_extend("force", opts, { desc = "Java: run test class" }))

						vim.keymap.set("n", "<leader>ju", function()
							require("jdtls").update_projects_config()
						end, vim.tbl_extend("force", opts, { desc = "Java: update project config" }))

						-- Wire DAP extensions (debug adapter + test runner)
						if #bundles > 0 then
							require("jdtls").setup_dap({ hotcodereplace = "auto" })
							require("jdtls.dap").setup_dap_main_class_configs()
						end
					end,
				}

				require("jdtls").start_or_attach(config)
			end

			-- Start jdtls whenever a Java file is opened
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = setup_jdtls,
				desc = "Start nvim-jdtls for Java files",
			})
		end,
	},
}
