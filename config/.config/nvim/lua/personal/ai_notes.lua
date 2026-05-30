local M = {}

local defaults = {
  filename = "ai-input.md",
  default_kind = "review",
  keymap = "<leader>an",
  use_git_root = true,
  notify = true,
  kind_order = { "review", "question", "context", "task" },
  kinds = {
    review = {
      label = "Review",
      prompt = "Act as a senior engineer. Review the following code. Highlight critical bugs, performance issues, and suggest concise improvements.",
    },
    question = {
      label = "Question",
      prompt = 'Answer the question based on the context below. Keep the answer short and concise. Respond "Unsure about answer" if not sure about the answer.',
    },
    context = {
      label = "Context",
      prompt = "Use the following code as additional context for future instructions. Do not modify it unless explicitly asked.",
    },
    task = {
      label = "Task",
      prompt = "Complete the requested task using the selected code as context. Keep the change focused and explain any important tradeoffs.",
    },
  },
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

local function merge_kinds(kinds)
  return vim.tbl_deep_extend("force", vim.deepcopy(defaults.kinds), kinds or {})
end

local function merge_config(opts)
  local user_opts = opts or {}
  local merged = vim.tbl_deep_extend("force", vim.deepcopy(defaults), user_opts)
  merged.kinds = merge_kinds(user_opts.kinds)

  return merged
end

local function resolve_kind(kind)
  local resolved_kind = kind or config.default_kind
  local kind_config = config.kinds[resolved_kind]

  if kind_config then
    return resolved_kind, kind_config
  end

  local fallback_kind = config.default_kind
  return fallback_kind, config.kinds[fallback_kind] or { label = fallback_kind, prompt = "" }
end

local function get_kind_items()
  local items = {}
  local seen = {}

  for _, kind in ipairs(config.kind_order or {}) do
    local kind_config = config.kinds[kind]
    if kind_config then
      table.insert(items, {
        name = kind,
        label = kind_config.label or kind,
        prompt = kind_config.prompt or "",
      })
      seen[kind] = true
    end
  end

  local extra_kinds = vim.tbl_keys(config.kinds or {})
  table.sort(extra_kinds)

  for _, kind in ipairs(extra_kinds) do
    if not seen[kind] then
      local kind_config = config.kinds[kind]
      table.insert(items, {
        name = kind,
        label = kind_config.label or kind,
        prompt = kind_config.prompt or "",
      })
    end
  end

  return items
end

local function blockquote(text)
  local lines = vim.split(text or "", "\n", { plain = true })
  return "> " .. table.concat(lines, "\n> ")
end

local function format_note(note)
  return string.format(
    "## %s: %s:%d-%d\n\n"
      .. "Prompt:\n"
      .. "%s\n\n"
      .. "User note:\n"
      .. "%s\n\n"
      .. "Source:\n"
      .. "- file: `%s`\n"
      .. "- lines: %d-%d\n"
      .. "- kind: %s\n\n"
      .. "Code:\n"
      .. "```%s\n"
      .. "%s\n"
      .. "```\n\n"
      .. "---\n\n",
    note.kind,
    note.filepath,
    note.start_line,
    note.end_line,
    blockquote(note.prompt),
    blockquote(note.message),
    note.filepath,
    note.start_line,
    note.end_line,
    note.kind,
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

local function write_note(opts, kind, message)
  message = vim.trim(message or opts.args or "")

  if message == "" then
    notify("AINote requires a note message", vim.log.levels.WARN)
    return
  end

  if opts.range == 0 then
    notify("AINote requires a visual selection", vim.log.levels.WARN)
    return
  end

  local root = get_project_root()
  local resolved_kind, kind_config = resolve_kind(kind)
  local selection = get_visual_selection(opts)
  local note = {
    kind = resolved_kind,
    prompt = kind_config.prompt or "",
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
      kind = resolved_kind,
      prompt = kind_config.prompt or "",
    },
  })

  notify("AI note appended: " .. result)
end

local function start_note_flow(opts)
  if opts.range == 0 then
    notify("AINote requires a visual selection", vim.log.levels.WARN)
    return
  end

  local items = get_kind_items()
  if #items == 0 then
    notify("AINote has no note kinds configured", vim.log.levels.WARN)
    return
  end

  vim.ui.select(items, {
    prompt = "AI note kind",
    format_item = function(item)
      return item.label
    end,
  }, function(item)
    if not item then
      return
    end

    vim.ui.input({ prompt = "AI " .. item.label .. " note: " }, function(input)
      if input == nil then
        return
      end

      write_note(opts, item.name, input)
    end)
  end)
end

function M.setup(opts)
  config = merge_config(opts)

  vim.api.nvim_create_user_command("AINote", function(command_opts)
    write_note(command_opts, config.default_kind, command_opts.args)
  end, {
    range = true,
    nargs = "*",
    desc = "Append selected code and instruction to ai-input.md",
  })

  vim.api.nvim_create_user_command("AINotePick", function(command_opts)
    start_note_flow(command_opts)
  end, {
    range = true,
    desc = "Pick AI note kind and append selected code",
  })

  vim.keymap.set("x", config.keymap, ":AINotePick<CR>", {
    desc = "AI note from selection",
  })
end

return M
