local state = {
	stl = nil
}

local augroup = vim.api.nvim_create_augroup('clmt', { clear = true })

local function update_stl()
	vim.o.statusline = (vim.o.ignorecase
		and '  ignorecase'
		or 'NoIgnoreCase'
	)..' (ctrl-x to toggle)'
end

-- set the statusline
vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
	group = augroup,
	pattern = { "/", "\\?" },
	callback = function()
		state.stl = vim.o.statusline
		update_stl()
		vim.keymap.set('c', '<C-x>', function()
			vim.o.ignorecase = not vim.o.ignorecase
			update_stl()
			vim.cmd('redraw')
		end)
	end
})

-- restore the statusline
vim.api.nvim_create_autocmd({ 'CmdlineLeave' }, {
	group = augroup,
	pattern = { "/", "\\?" },
	callback = function()
		vim.o.statusline = state.stl
		pcall(vim.keymap.del, 'c', '<C-x>')
	end
})

-- easier to type / than ctrl-d
vim.keymap.set('c', '/', function()
	return (
		vim.fn.getcmdline():sub(-1) == '/'
		and vim.tbl_contains({
			'file', 'file_in_path', 'dir', 'dir_in_path',
		}, vim.fn.getcmdcompltype())
	) and '<C-d>' or '/'
end, { expr = true })
