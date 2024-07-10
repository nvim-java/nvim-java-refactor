local ui = require('java.utils.ui')

local M = {
	commands = {
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
				local end_char = start_char + rename.length

				local name = ui.input('Variable Name')

				if not name then
					return
				end

				vim.api.nvim_buf_set_text(
					buffer,
					line - 1,
					start_char,
					line - 1,
					end_char,
					{ name }
				)
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
				vim.print(name, command)
				vim.lsp.commands[name] = command
			end

			vim.api.nvim_del_autocmd(id)
		end
	end,
})
