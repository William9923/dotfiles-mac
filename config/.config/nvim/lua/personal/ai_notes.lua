local M = {}

local defaults = {
  filename = "ai-input.md",
  default_kind = "review",
  keymap = "<leader>an",
  use_git_root = true,
  notify = true,
}

local config = vim.deepcopy(defaults)

local function notify(message, level)
  if config.notify then
    vim.notify(message, level or vim.log.levels.INFO)
  end
end

local function joinpath(...)
  if vim.fs and vim.fs.joinpath then
    return vim.fs.joinpath(...)
  end

  return table.concat({ ... }, "/"):gsub("/+", "/")
end

local function get_project_root()
  if not config.use_git_root then
    return vim.fn.getcwd()
  end

  if vim.fs and vim.fs.root then
    local ok, root = pcall(vim.fs.root, 0, ".git")
    if ok and root then
      return root
    end
  end

  if vim.fs and vim.fs.find and vim.fs.dirname then
    local bufname = vim.api.nvim_buf_get_name(0)
    local start_path = bufname ~= "" and vim.fs.dirname(bufname) or vim.fn.getcwd()
    local git_dir = vim.fs.find(".git", { path = start_path, upward = true })[1]

    if git_dir then
      return vim.fs.dirname(git_dir)
    end
  end

  return vim.fn.getcwd()
end

local function get_relative_path(root)
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return "[No Name]"
  end

  local absolute_path = vim.fn.fnamemodify(path, ":p")
  local absolute_root = vim.fn.fnamemodify(root, ":p")

  if vim.startswith(absolute_path, absolute_root) then
    return absolute_path:sub(#absolute_root + 1)
  end

  return vim.fn.fnamemodify(path, ":.")
end

local function get_visual_selection(opts)
  local start_line = math.min(opts.line1, opts.line2)
  local end_line = math.max(opts.line1, opts.line2)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  return {
    start_line = start_line,
    end_line = end_line,
    snippet = table.concat(lines, "\n"),
  }
end

local function get_language()
  if vim.bo.filetype ~= "" then
    return vim.bo.filetype
  end

  return vim.fn.expand("%:e")
end

local function format_note(note)
  return string.format(
    "## %s: %s:%d-%d\n\n"
      .. "Source:\n"
      .. "- file: `%s`\n"
      .. "- lines: %d-%d\n"
      .. "- kind: %s\n\n"
      .. "Instruction:\n"
      .. "> %s\n\n"
      .. "Code:\n"
      .. "```%s\n"
      .. "%s\n"
      .. "```\n\n"
      .. "---\n\n",
    note.kind,
    note.filepath,
    note.start_line,
    note.end_line,
    note.filepath,
    note.start_line,
    note.end_line,
    note.kind,
    note.message,
    note.language,
    note.snippet
  )
end

local function append_note(root, content)
  local output_path = joinpath(root, config.filename)
  local file, err = io.open(output_path, "a")

  if not file then
    return false, err or output_path
  end

  file:write(content)
  file:close()

  return true, output_path
end

local function write_note(opts, kind)
  local message = vim.trim(opts.args or "")

  if message == "" then
    notify("AINote requires a note message", vim.log.levels.WARN)
    return
  end

  if opts.range == 0 then
    notify("AINote requires a visual selection", vim.log.levels.WARN)
    return
  end

  local root = get_project_root()
  local selection = get_visual_selection(opts)
  local note = {
    kind = kind,
    filepath = get_relative_path(root),
    start_line = selection.start_line,
    end_line = selection.end_line,
    message = message,
    language = get_language(),
    snippet = selection.snippet,
  }

  local ok, result = append_note(root, format_note(note))
  if not ok then
    notify("AINote could not write note: " .. result, vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_exec_autocmds("User", {
    pattern = "AINoteWritten",
    data = {
      path = result,
      kind = kind,
    },
  })

  notify("AI note appended: " .. result)
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", defaults, opts or {})

  vim.api.nvim_create_user_command("AINote", function(command_opts)
    write_note(command_opts, config.default_kind)
  end, {
    range = true,
    nargs = "*",
    desc = "Append selected code and instruction to ai-input.md",
  })

  vim.keymap.set("x", config.keymap, ":AINote ", {
    desc = "AI note from selection",
  })
end

return M
