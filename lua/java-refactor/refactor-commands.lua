local class = require('java-core.utils.class')
local notify = require('java-core.utils.notify')
local lsp_refactor_commands = require('java-refactor.lsp-refactor-commands')

local JdtlsClient = require('java-core.ls.clients.jdtls-client')

---@class java-refactor.ClientCommands
---@field client lsp.Client
local RefactorCommands = class()

function RefactorCommands:_init(client)
	self.client = client
	self.jdtls_client = JdtlsClient(client)
end

function RefactorCommands:extract_variable()
	local context = vim.lsp.util.make_range_params(0)
	context.context = {}
	context.context.diagnostics = vim.lsp.diagnostic.get_line_diagnostics(0)

	local buffer = vim.api.nvim_get_current_buf()

	local selection =
		self.jdtls_client:java_infer_selection('extractVariable', context, buffer)

	local edit = self.jdtls_client:java_get_refactor_edit(
		'extractVariable',
		context,
		{},
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
	local command

	if lsp_refactor_commands[command_name] then
		command = lsp_refactor_commands[command_name]
	else
		command = vim.lsp.commands[command_name]
	end

	if not command then
		notify.error('Command "' .. command_name .. '" is not supported')
		return
	end

	command(arguments)
end

return RefactorCommands
