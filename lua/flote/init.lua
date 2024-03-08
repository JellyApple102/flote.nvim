local M = {}

M.config = {
	q_to_quit = true,
	window_style = 'minimal',
	window_border = 'solid',
	window_title = true,
	notes_dir = vim.fn.stdpath('cache') .. '/flote',
	files = {
		global = 'flote-global.md',
		cwd = function()
			return vim.fn.getcwd()
		end,
		file_name = function(cwd)
			local base_name = vim.fs.basename(cwd)
			local parent_base_name = vim.fs.basename(vim.fs.dirname(cwd))
			return parent_base_name .. '_' .. base_name .. '.md'
		end
	}

}

local check_cache_dir = function(dir)
	local flote_cache_dir = vim.fs.normalize(dir)

	if vim.fn.isdirectory(flote_cache_dir) == 0 then
		local success = vim.loop.fs_mkdir(flote_cache_dir, 493)
		if not success then
			vim.print("Could not create folder " .. flote_cache_dir)
		end
	end

	return flote_cache_dir
end

local check_note_file = function(file)
	local note_file_path = vim.fs.normalize(M.flote_cache_dir .. '/' .. file)
	if vim.tbl_isempty(vim.fs.find(file, { type = 'file', path = M.flote_cache_dir })) then
		vim.loop.fs_open(note_file_path, 'w', 420, function(err, fd)
			if err ~= nil or fd == nil then
				vim.print("Could not create note file " .. note_file_path)
				return
			end
			vim.loop.fs_close(fd)
		end)
	end

	return note_file_path
end

local open_float = function(file_path, file_name)
	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor((ui.width * 0.5) + 0.5)
	local height = math.floor((ui.height * 0.5) + 0.5)

	local note_buf = vim.api.nvim_create_buf(false, true)

	local win_opts = {
		relative = 'editor',
		width = width,
		height = height,
		col = (ui.width - width) / 2,
		row = (ui.height - height) / 2,
		focusable = false,
		style = M.config.window_style,
		border = M.config.window_border
	}

	if M.config.window_title then
		win_opts.title = file_name
		if M.config.q_to_quit then
			if file_name ~= nil then
				win_opts.title = win_opts.title .. " - press 'q' to quit"
			else
				win_opts.title = ""
			end
			win_opts.title_pos = "left"
		end
	end

	vim.api.nvim_open_win(note_buf, true, win_opts)

	vim.cmd('edit ' .. file_path)
	vim.api.nvim_buf_set_option(note_buf, 'bufhidden', 'wipe')
	if M.config.q_to_quit then
		local buf = vim.api.nvim_win_get_buf(0)

		local cmd = "<cmd>wq<CR>"
		if vim.bo[buf].readonly then
			cmd = "<cmd>q!<CR>"
		end
		vim.api.nvim_buf_set_keymap(note_buf, "n", "q", cmd, { noremap = true, silent = false })
	end
end

M.setup = function(config)
	M.config = vim.tbl_deep_extend('force', M.config, config or {})

	M.flote_cache_dir = check_cache_dir(M.config.notes_dir)

	vim.api.nvim_create_user_command('Flote', function(opts)
		if opts.fargs[1] == 'global' then
			local note_file_path = check_note_file(M.config.files.global)
			open_float(note_file_path, M.config.files.global)
		elseif opts.fargs[1] == 'manage' then
			open_float(M.flote_cache_dir)
		else
			local cwd = vim.fs.normalize(M.config.files.cwd())
			local file_name = M.config.files.file_name(cwd)
			local note_file_path = check_note_file(file_name)
			open_float(note_file_path, file_name)
		end
	end, {
		nargs = '?',
		complete = function(_, _, _)
			return { 'global', 'manage' }
		end
	})
end

return M
