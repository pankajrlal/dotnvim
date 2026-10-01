local autocmd = vim.api.nvim_create_autocmd
local augroup  = vim.api.nvim_create_augroup

-- ── Cursorline: show only in the active window ────────────────────────────────
local cursorline = augroup('CursorLineToggle', { clear = true })
autocmd('WinEnter', { group = cursorline, callback = function() vim.opt_local.cursorline = true  end })
autocmd('WinLeave', { group = cursorline, callback = function() vim.opt_local.cursorline = false end })

-- ── Relative line numbers in normal mode, absolute in insert ──────────────────
local numtoggle = augroup('NumberToggle', { clear = true })
autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
  group    = numtoggle,
  callback = function() vim.opt_local.relativenumber = true end,
})
autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' }, {
  group    = numtoggle,
  callback = function() vim.opt_local.relativenumber = false end,
})

-- ── YAML: 2-space indent, suppress : and # auto-indent triggers ───────────────
autocmd('FileType', {
  group   = augroup('YamlFix', { clear = true }),
  pattern = 'yaml',
  callback = function()
    local o       = vim.opt_local
    o.tabstop     = 2
    o.softtabstop = 2
    o.shiftwidth  = 2
    o.expandtab   = true
    o.indentkeys:remove('0#')
    o.indentkeys:remove('<:>')
  end,
})

-- ── Filetype-specific prose settings ─────────────────────────────────────────
autocmd('FileType', {
  pattern  = 'rst',
  callback = function()
    vim.opt_local.wrap      = true
    vim.opt_local.textwidth = 0
  end,
})

-- Markdown: nowrap so render-markdown tables keep their grid (a table row is
-- one source line; wrapping splits it). Set here rather than in the plugin's
-- win_options, which re-applies on every render and would undo the toggle.
autocmd('FileType', {
  group    = augroup('MarkdownWrap', { clear = true }),
  pattern  = 'markdown',
  callback = function(ev)
    vim.opt_local.wrap = false
    -- Hard-wrap at 80 columns while typing (t), keeping numbered-list indent (n).
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:append('tn')
    -- The markdown ftplugin adds 'l', which exempts lines already longer than
    -- textwidth from auto-wrap.
    vim.opt_local.formatoptions:remove('l')
    -- Auto-wrap only fires when the cursor is past textwidth; also re-wrap the
    -- current line when typing earlier in an over-long line (tables and code
    -- excluded). 'a' would do this but reflows the paragraph, rejoining the
    -- sentence-per-line breaks below. The overflow line is tracked with an
    -- extmark so later overflows reflow into it instead of each pushing one
    -- word onto a fresh line.
    local ns = vim.api.nvim_create_namespace('MarkdownWrapTail')
    vim.api.nvim_create_autocmd('InsertLeave', {
      buffer   = ev.buf,
      callback = function() vim.api.nvim_buf_clear_namespace(ev.buf, ns, 0, -1) end,
    })
    vim.api.nvim_create_autocmd('TextChangedI', {
      buffer   = ev.buf,
      callback = function()
        local line = vim.api.nvim_get_current_line()
        if vim.fn.strdisplaywidth(line) <= vim.bo.textwidth or line:match('^%s*|') then return end
        local ok, node = pcall(function()
          vim.treesitter.get_parser():parse()
          return vim.treesitter.get_node()
        end)
        while ok and node do
          if node:type() == 'fenced_code_block' then return end
          node = node:parent()
        end
        -- Reflow from the cursor line through the tracked tail, if below us.
        local row   = vim.fn.line('.')            -- 1-based
        local mark  = vim.api.nvim_buf_get_extmarks(ev.buf, ns, { row, 0 }, -1, { limit = 1 })[1]
        local span  = mark and (mark[2] + 1 - row) or 0
        local count = vim.fn.line('$')
        vim.api.nvim_buf_clear_namespace(ev.buf, ns, 0, -1)
        vim.cmd(span > 0 and ('normal! gw' .. span .. 'j') or 'normal! gww')
        local last = row + span + vim.fn.line('$') - count
        if last > row then
          vim.api.nvim_buf_set_extmark(ev.buf, ns, last - 1, 0, {})
        end
      end,
    })

    -- One sentence per line: a space typed right after . ? or ! becomes a
    -- newline. Skipped for list markers ("1. "), table rows, inline code
    -- (odd backtick count before the cursor) and fenced code blocks.
    vim.keymap.set('i', '<Space>', function()
      local before = vim.api.nvim_get_current_line():sub(1, vim.fn.col('.') - 1)
      if not before:match('[%.%?!]$')
        or before:match('^%s*%d+[.)]$')
        or before:match('^%s*|')
        or select(2, before:gsub('`', '')) % 2 == 1 then
        return ' '
      end
      -- Reparse first: the tree is stale while typing.
      local ok, node = pcall(function()
        vim.treesitter.get_parser():parse()
        return vim.treesitter.get_node()
      end)
      while ok and node do
        if node:type() == 'fenced_code_block' then return ' ' end
        node = node:parent()
      end
      return '<CR>'
    end, { buffer = ev.buf, expr = true, desc = 'Break line after sentence' })

    vim.keymap.set('n', '<leader>uw', function()
      vim.wo.wrap = not vim.wo.wrap
      vim.notify('wrap ' .. (vim.wo.wrap and 'on' or 'off'))
    end, { buffer = ev.buf, desc = 'Toggle wrap' })
  end,
})

-- ── BNF filetype detection ────────────────────────────────────────────────────
autocmd({ 'BufReadPre', 'BufNewFile' }, {
  pattern  = '*.bnf',
  callback = function() vim.bo.filetype = 'bnf' end,
})

-- ── Rust: rustdoc standard for vim-doge ──────────────────────────────────────
autocmd('FileType', {
  group    = augroup('RustDocs', { clear = true }),
  pattern  = 'rst',
  callback = function() vim.b.doge_doc_standard = 'rustdoc' end,
})

-- ── Rust / Cargo integration ──────────────────────────────────────────────────
local function in_cargo_project()
  return vim.fn.findfile('Cargo.toml', '.;') ~= ''
end

local cargo = augroup('CargoIntegration', { clear = true })

-- Set makeprg + errorformat when opening a Rust file inside a Cargo project
autocmd('BufReadPost', {
  group   = cargo,
  pattern = '*.rs',
  callback = function()
    if in_cargo_project() then
      vim.bo.makeprg = 'cargo build'
      vim.bo.errorformat = table.concat({
        '%Eerror:%m',
        '%C%*\\s--> %f:%l:%c',
        '%Z',
        '%Wwarning:%m',
      }, ',')
    end
  end,
})

-- Per-buffer F5/F7 shortcuts for Rust files
autocmd('FileType', {
  group   = cargo,
  pattern = 'rust',
  callback = function(ev)
    vim.keymap.set('n', '<F5>', '<cmd>make r<CR>', { buffer = ev.buf, desc = 'Cargo run' })
    vim.keymap.set('n', '<F7>', '<cmd>make c<CR>', { buffer = ev.buf, desc = 'Cargo check' })
  end,
})

local function run_cargo(cmd)
  if in_cargo_project() then
    vim.bo.makeprg = 'cargo ' .. cmd
    vim.cmd('make')
  else
    vim.notify('Not inside a Cargo project', vim.log.levels.WARN)
  end
end

vim.api.nvim_create_user_command('CargoBuild', function() run_cargo('build')               end, {})
vim.api.nvim_create_user_command('CargoInit',  function() run_cargo('build --bin init_app') end, {})
vim.api.nvim_create_user_command('CargoCheck', function() run_cargo('check')               end, {})
vim.api.nvim_create_user_command('CargoTest',  function()
  if in_cargo_project() then
    vim.cmd("botright 10split | terminal bash -c 'env $(cat .env | xargs) cargo test'")
    vim.cmd('wincmd p')
  else
    vim.notify('Not inside a Cargo project', vim.log.levels.WARN)
  end
end, {})
