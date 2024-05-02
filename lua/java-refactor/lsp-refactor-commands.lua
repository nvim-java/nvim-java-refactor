local ui = require('java.utils.ui')

local M = {
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
}

return M
