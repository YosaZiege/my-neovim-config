return {
   "goolord/alpha-nvim",
   config = function()
      local startify = require("alpha.themes.startify")
      startify.file_icons.provider = "devicons"

      -- Keep track of last used header file
      local last_header_file = nil

      -- Function to get all files in a directory
      local function get_all_files_in_dir(dir)
         local files = {}
         local scan = vim.fn.globpath(dir, "**/*.lua", true, true)
         for _, file in ipairs(scan) do
            table.insert(files, file)
         end
         return files
      end

      -- Function to load a random header different from last one
      local function load_random_header()
         math.randomseed(os.time())
         local header_folder = vim.fn.stdpath("config") .. "/lua/plugins/header_img/"
         local files = get_all_files_in_dir(header_folder)

         if #files == 0 then
            return nil
         end

         -- Remove the last-used file from candidates (if more than 1 file exists)
         local candidates = {}
         for _, f in ipairs(files) do
            if f ~= last_header_file or #files == 1 then
               table.insert(candidates, f)
            end
         end

         -- Pick a random candidate
         local random_file = candidates[math.random(#candidates)]

         last_header_file = random_file -- store it

         -- Convert to module name
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

      -- Load on startup
      local header = load_random_header()
      if header then
         startify.config.layout[2] = header
      else
         print("No images inside header_img folder.")
      end

      -- Change header on demand
      local function change_header()
         local new_header = load_random_header()
         if new_header then
            startify.config.layout[2] = new_header
            vim.cmd("AlphaRedraw")
         else
            print("No images inside header_img folder.")
         end
      end

      vim.keymap.set("n", "<leader>h", change_header, { desc = "Change the Header" })
      require("alpha").setup(startify.config)
   end,
}
