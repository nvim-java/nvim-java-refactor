local class = require('java-core.utils.class')
local notify = require('java-core.utils.notify')
local JdtlsClient = require('java-core.ls.clients.jdtls-client')

---@class java-refactor.RefactorCommands
---@field client vim.lsp.Client
---@field jdtls_client java-core.JdtlsClient
local RefactorCommands = class()

---@param client vim.lsp.Client
function RefactorCommands:_init(client)
	self.client = client
	self.jdtls_client = JdtlsClient(client)
end

---Run refactor command
---@param refactor_type jdtls.CodeActionCommand
function RefactorCommands:refactor(refactor_type)
	local context = vim.lsp.util.make_range_params(0)
	context.context = {}
	context.context.diagnostics = vim.lsp.diagnostic.get_line_diagnostics(0)

	local formatting_options = {
		tabSize = vim.bo.tabstop,
		insertSpaces = vim.bo.expandtab,
	}

	local buffer = vim.api.nvim_get_current_buf()

	local selection =
		self.jdtls_client:java_infer_selection(refactor_type, context, buffer)

	local edit = self.jdtls_client:java_get_refactor_edit(
		refactor_type,
		context,
		formatting_options,
		selection,
		buffer
	)

	vim.lsp.util.apply_workspace_edit(edit.edit, 'utf-8')

	RefactorCommands.run_lsp_client_command(
		edit.command.command,
		edit.command.arguments
	)
end

function RefactorCommands.run_lsp_client_command(command_name, arguments)
	-- vim.print(command_name, arguments)
	local command = vim.lsp.commands[command_name]

	if not command then
		notify.error('Command "' .. command_name .. '" is not supported')
		return
	end

	command(arguments)
end

return RefactorCommands
