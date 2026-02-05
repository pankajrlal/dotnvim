-- Utility to check if Cargo.toml exists in current or parent directories
local function is_cargo_project()
  local cargo_toml = vim.fn.findfile("Cargo.toml", ".;")
  return cargo_toml ~= ""
end

-- Autocmd: if file is Rust and in a Cargo project, set makeprg + errorformat
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.rs",
  callback = function()
    if is_cargo_project() then
      vim.bo.makeprg = "cargo build"
      vim.bo.errorformat = table.concat({
        "%Eerror:%m",
        "%C%*\\s--> %f:%l:%c",
        "%Z",
        "%Wwarning:%m"
      }, ",")
    end
  end
})

local function run_cargo_cmd(cmd)
  if is_cargo_project() then
    vim.bo.makeprg = "cargo " .. cmd
    vim.cmd("make")
  else
    vim.notify("Not inside a Cargo project", vim.log.levels.WARN)
  end
end

vim.api.nvim_create_user_command("CargoBuild", function() run_cargo_cmd("build") end, {})
vim.api.nvim_create_user_command("CargoInit", function() run_cargo_cmd("build --bin init_app") end, {})
vim.api.nvim_create_user_command("CargoCheck", function() run_cargo_cmd("check") end, {})

vim.api.nvim_create_user_command("CargoTest", function()
  if vim.fn.findfile("Cargo.toml", ".;") ~= "" then
    vim.cmd("botright 10split | terminal bash -c 'env $(cat .env | xargs) cargo test'")
    vim.cmd("wincmd p")
  else
    vim.notify("Not inside a Cargo project", vim.log.levels.WARN)
  end
end, {})

