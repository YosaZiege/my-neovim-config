return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")

		-- Function to get all files in a directory
		local function get_all_files_in_dir(dir)
			local files = {}
			local scan = vim.fn.globpath(dir, "**/*.lua", true, true)
			for _, file in ipairs(scan) do
				table.insert(files, file)
			end
			return files
		end

		-- Function to load a random header
		local function load_random_header()
			math.randomseed(os.time())
			local header_folder = vim.fn.stdpath("config") .. "/lua/plugins/header_img/"
			local files = get_all_files_in_dir(header_folder)

			if #files == 0 then
				return nil
			end

			local random_file = files[math.random(#files)]
			local relative_path = random_file:sub(#header_folder + 1)
			local module_name = "plugins.header_img." .. relative_path:gsub("/", "."):gsub("\\", "."):gsub("%.lua$", "")

			package.loaded[module_name] = nil

			local ok, module = pcall(require, module_name)
			if ok and module.header then
				return module.header
			else
				return nil
			end
		end

		-- Attempt to load random header
		local header = load_random_header()

		if header then
			dashboard.config.layout[2] = header
		else
			print("No images inside header_img folder.")
		end
		local function change_header()
			local new_header = load_random_header()
			if new_header then
				dashboard.config.layout[2] = new_header
				vim.cmd("AlphaRedraw")
			else
				print("No images inside header_img folder.")
			end
		end
		alpha.setup(dashboard.opts)
	end,
}
