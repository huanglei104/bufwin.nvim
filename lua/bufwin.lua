local main_win = vim.fn.win_getid()
function split(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

 local buf_names = {}
 local buf_map = {}

 --vim.cmd("botright 30vs")
 vim.api.nvim_command("botright 35vs")
 local bufnr = vim.api.nvim_create_buf(false, false)
 local win_id = vim.api.nvim_get_current_win()
 vim.api.nvim_win_set_buf(win_id, bufnr)

for _, buf in pairs(vim.api.nvim_list_bufs()) do
   if (vim.fn.buflisted(buf) == 1) then
       local bufname = vim.api.nvim_buf_get_name(buf)
       local strs = split(bufname, "/")
       bufname = strs[#strs]
       if (string.len(bufname) == 0) then
           bufname = "NONAME"
       end
       table.insert(buf_names, " " .. bufname)
       table.insert(buf_map, buf)
   end
end

vim.api.nvim_buf_set_lines(bufnr, 0, #buf_names, false, buf_names)

vim.api.nvim_create_autocmd({"WinClosed"}, {
  pattern = {tostring(win_id)},
  callback = function(ev)
      local buf = vim.api.nvim_win_get_buf(0)
      local opt = {
          force = true,
          unload = false
      }
      vim.api.nvim_buf_delete(buf, opt)
  end
})

function select_item()
    local bufnr = buf_map[vim.fn.line(".")]
    vim.api.nvim_win_set_buf(main_win, bufnr)
end

local km_opt = {
    noremap = true,
    callback = select_item
}
vim.api.nvim_buf_set_keymap(bufnr, "n", "<CR>", "", km_opt)
