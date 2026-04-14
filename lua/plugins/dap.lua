return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap   = require('dap')
      local dapui = require('dapui')

      dapui.setup()

      -- ── Rust: LLDB adapter ──────────────────────────────────────────────────
      dap.adapters.lldb = {
        type    = 'executable',
        command = vim.env.HOME .. '/.local/share/nvim/debuggers/codelldb',
        name    = 'lldb',
      }

      dap.configurations.rust = {
        {
          name    = 'Launch Rust App',
          type    = 'lldb',
          request = 'launch',
          program = function()
            local cwd    = vim.fn.getcwd()
            local handle = io.popen('cargo metadata --format-version=1 | jq -r .packages[0].name')
            if not handle then
              vim.notify('Error: Failed to run cargo metadata', vim.log.levels.ERROR)
              return nil
            end
            local result = handle:read('*a')
            handle:close()
            if not result or result == '' then
              vim.notify('Error: Failed to retrieve binary name', vim.log.levels.ERROR)
              return nil
            end
            return cwd .. '/target/debug/' .. result:gsub('\n', '')
          end,
          cwd           = '${workspaceFolder}',
          stopOnEntry   = false,
          args          = {},
          runInTerminal = false,
        },
        {
          name    = 'Attach to Process',
          type    = 'lldb',
          request = 'attach',
          pid     = function()
            return tonumber(vim.fn.input('Process ID (PID): '))
          end,
          cwd         = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      -- ── Auto-open/close dapui ───────────────────────────────────────────────
      dap.listeners.after.event_initialized['dapui_config']  = function() dapui.open()  end
      dap.listeners.before.event_terminated['dapui_config']  = function() dapui.close() end
      dap.listeners.before.event_exited['dapui_config']      = function() dapui.close() end

      -- ── DAP keymaps ─────────────────────────────────────────────────────────
      local map = vim.keymap.set
      map('n', '<Leader>ds', '<cmd>DapStepOver<CR>',        { desc = 'DAP: step over' })
      map('n', '<Leader>di', '<cmd>DapStepInto<CR>',        { desc = 'DAP: step into' })
      map('n', '<Leader>do', '<cmd>DapStepOut<CR>',         { desc = 'DAP: step out' })
      map('n', '<Leader>dt', '<cmd>DapToggleBreakpoint<CR>', { desc = 'DAP: toggle breakpoint' })
      map('n', '<Leader>dc', '<cmd>DapContinue<CR>',        { desc = 'DAP: continue' })
      map('n', '<Leader>dx', '<cmd>DapStop<CR>',            { desc = 'DAP: stop' })
      map('n', '<Leader>dr', '<cmd>DapRestart<CR>',         { desc = 'DAP: restart' })
      map('n', '<Leader>dp', '<cmd>DapPause<CR>',           { desc = 'DAP: pause' })
      map('n', '<Leader>dl', '<cmd>DapToggleRepl<CR>',      { desc = 'DAP: toggle REPL' })
      map('n', '<Leader>du', '<cmd>DapToggleUI<CR>',        { desc = 'DAP: toggle UI' })
    end,
  },
}
