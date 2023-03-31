local M = {}

local check_cache_dir = function()
    local nvim_cache_dir = vim.fs.normalize(vim.fn.stdpath('cache'))
    local flote_cache_dir = vim.fs.normalize(nvim_cache_dir .. '/flote')

    if vim.fn.isdirectory(flote_cache_dir) == 0 then
        os.execute('mkdir ' .. flote_cache_dir)
    end

    return flote_cache_dir
end

local check_note_file = function(file)
    local note_file_path = vim.fs.normalize(M.flote_cache_dir .. '/' .. file)
    if vim.tbl_isempty(vim.fs.find(file, { type = 'file', path = M.flote_cache_dir })) then
        os.execute('touch ' .. note_file_path)
    end

    return note_file_path
end

local open_float = function(file)
    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor((ui.width * 0.5) + 0.5)
    local height = math.floor((ui.height * 0.5) + 0.5)

    local note_buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_open_win(note_buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = (ui.width - width) / 2,
        row = (ui.height - height) / 2,
        focusable = false,
        style = 'minimal',
        border = 'solid'
    })

    vim.cmd('edit ' .. file)
    vim.api.nvim_buf_set_option(note_buf, 'bufhidden', 'wipe')
end

M.setup = function()
    M.flote_cache_dir = check_cache_dir()

    vim.api.nvim_create_user_command('Flote', function(opts)
        if opts.fargs[1] == 'global' then
            local note_file = check_note_file('flote-global.md')
            open_float(note_file)
        elseif opts.fargs[1] == 'manage' then
            open_float(M.flote_cache_dir)
        else
            local cwd = vim.fs.normalize(vim.fn.getcwd())
            local base_name = vim.fs.basename(cwd)
            local parent_base_name = vim.fs.basename(vim.fs.dirname(cwd))
            local file_name = parent_base_name .. '_' .. base_name .. '.md'
            local note_file = check_note_file(file_name)
            open_float(note_file)
        end
    end, { nargs='?', complete = function(ArgLead, CmdLine, CursorPos)
            return { 'global', 'manage' }
    end})
end

return M
