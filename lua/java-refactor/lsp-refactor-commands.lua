-- local ui = require('java.utils.ui')

local M = {

	commands = {
		-- ['java.action.applyRefactoringCommand'] = function() end,

		---@class java-refactor.RenameAction
		---@field length number
		---@field offset number
		---@field uri string

		---Rename a given item
		---@param arguments java-refactor.RenameAction[]
		['java.action.rename'] = function(arguments)
			for _, rename in ipairs(arguments) do
				local buffer = vim.uri_to_bufnr(rename.uri)

				local line

				vim.api.nvim_buf_call(buffer, function()
					line = vim.fn.byte2line(rename.offset)
				end)

				local start_char = rename.offset - vim.fn.line2byte(line) + 1

				vim.api.nvim_win_set_cursor(0, { line, start_char })

				vim.lsp.buf.rename(nil, {
					name = 'jdtls',
					bufnr = buffer,
				})
			end
		end,
	},
}

local id

id = vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == 'jdtls' then
			for name, command in pairs(M.commands) do
				vim.lsp.commands[name] = command
			end

			vim.api.nvim_del_autocmd(id)
		end
	end,
})
