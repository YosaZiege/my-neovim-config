return {
   "HakonHarnes/img-clip.nvim",
   event = "VeryLazy",
   opts = {
      dir_path = "images",           -- folder to store pasted images
      file_name = "%Y-%m-%d-%H-%M-%S", -- image naming template
      use_absolute_path = false,
   },
   vim.api.nvim_create_user_command("PasteImage", function()
      local img_dir = "images"
      vim.fn.mkdir(img_dir, "p")
      local img_name = os.date("%Y-%m-%d-%H-%M-%S") .. ".png"
      local img_path = img_dir .. "/" .. img_name
      vim.fn.system('xclip -selection clipboard -t image/png -o > ' .. img_path)
      vim.api.nvim_put({ "![](" .. img_path .. ")" }, "l", true, true)

      -- Inline preview in Kitty
      if vim.fn.exists(":ImageDraw") ~= 0 then
         vim.cmd("ImageDraw " .. img_path)
      end
   end, {})
}
