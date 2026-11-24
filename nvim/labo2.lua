-- Labo II: run SQL files against the local Oracle from Neovim.
-- Installed by setup/install.sh as a symlink in ~/.local/share/nvim/site/plugin/,
-- so it does not touch your own nvim config. Only active for .sql files inside
-- the labo2-ejercicios repo.
--
--   <leader>lr   save and run the whole file            (lab run %)
--   <leader>ls   run the visual selection               (include the trailing "/" of a block)
--   <leader>lq   open an interactive SQLcl session
--   <leader>ld   launch SQL Developer
--   <leader>lc   close the output window
--   :LabRun [file]  same as <leader>lr

local M = {}

local function repo_root(path)
  local marker = vim.fs.find({ "docker-compose.yml" }, { path = path, upward = true })[1]
  if marker and vim.fn.filereadable(vim.fs.dirname(marker) .. "/bin/lab") == 1 then
    return vim.fs.dirname(marker)
  end
end

local function lab_bin(root)
  return root .. "/bin/lab"
end

local out_buf, out_win

function M.close()
  if out_win and vim.api.nvim_win_is_valid(out_win) then
    vim.api.nvim_win_close(out_win, true)
  end
  if out_buf and vim.api.nvim_buf_is_valid(out_buf) then
    vim.api.nvim_buf_delete(out_buf, { force = true })
  end
  out_buf, out_win = nil, nil
end

-- Opens (or reuses) a bottom split with a terminal running `cmd`.
local function term(cmd)
  local src_win = vim.api.nvim_get_current_win()
  M.close()
  vim.cmd("botright 15split")
  out_win = vim.api.nvim_get_current_win()
  vim.cmd("enew")
  out_buf = vim.api.nvim_get_current_buf()
  vim.bo[out_buf].bufhidden = "wipe"
  vim.fn.jobstart(cmd, { term = true })
  -- Enter insert mode so &substitution prompts can be answered right away.
  vim.cmd("startinsert")
  return src_win
end

function M.run_file(file)
  file = (file and file ~= "") and vim.fn.fnamemodify(file, ":p") or vim.api.nvim_buf_get_name(0)
  local root = repo_root(file)
  if not root then
    vim.notify("labo2: not inside the labo2-ejercicios repo", vim.log.levels.WARN)
    return
  end
  if vim.bo.modified then vim.cmd("silent write") end
  term({ lab_bin(root), "run", file })
end

function M.run_selection()
  local root = repo_root(vim.api.nvim_buf_get_name(0))
  if not root then return end
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then s, e = e, s end
  local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
  -- A PL/SQL block needs a "/" to be executed; add it if the selection ends in END;
  local last = (lines[#lines] or ""):gsub("%s+$", "")
  if last:upper():match("END%s*[%w_]*;$") then table.insert(lines, "/") end
  local tmp = vim.fn.tempname() .. ".sql"
  vim.fn.writefile(lines, tmp)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  term({ lab_bin(root), "run", tmp })
end

function M.sqlcl()
  local root = repo_root(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
  term({ lab_bin(root), "sql" })
end

function M.sqldev()
  local root = repo_root(vim.api.nvim_buf_get_name(0))
  if root then vim.fn.jobstart({ lab_bin(root), "sqldev" }, { detach = true }) end
end

local group = vim.api.nvim_create_augroup("Labo2", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "sql", "plsql" },
  callback = function(args)
    if not repo_root(vim.api.nvim_buf_get_name(args.buf)) then return end
    local o = function(desc) return { buffer = args.buf, silent = true, desc = "Labo2: " .. desc } end
    vim.keymap.set("n", "<leader>lr", M.run_file, o("run file"))
    vim.keymap.set("x", "<leader>ls", M.run_selection, o("run selection"))
    vim.keymap.set("n", "<leader>lq", M.sqlcl, o("SQLcl session"))
    vim.keymap.set("n", "<leader>ld", M.sqldev, o("SQL Developer"))
    vim.keymap.set("n", "<leader>lc", M.close, o("close output"))
  end,
})

vim.api.nvim_create_user_command("LabRun", function(a) M.run_file(a.args) end,
  { nargs = "?", complete = "file" })

return M
