local class = require('java-core.utils.class')
local notify = require('java-core.utils.notify')
local JdtlsClient = require('java-core.ls.clients.jdtls-client')
local List = require('java-core.utils.list')
local ui = require('java.utils.ui')

local available_commands = {
	-- 'assignField',
	-- 'assignVariable',
	-- 'changeSignature',
	-- 'convertAnonymousClassToNestedCommand',
	-- 'convertVariableToField',
	'extractConstant',
	'extractField',
	-- 'extractInterface',
	'extractMethod',
	'extractVariable',
	'extractVariableAllOccurrence',
	-- 'introduceParameter',
	-- 'invertVariable',
}

---@class java-refactor.RefactorCommands
---@field jdtls_client java-core.JdtlsClient
local RefactorCommands = class()

---@param client vim.lsp.Client
function RefactorCommands:_init(client)
	self.jdtls_client = JdtlsClient(client)
end

---Run refactor command
---@param refactor_type jdtls.CodeActionCommand
---@param context lsp.CodeActionContext
function RefactorCommands:refactor(refactor_type, context)
	if not vim.tbl_contains(available_commands, refactor_type) then
		notify.error(
			string.format('Refactoring command "%s" is not supported', refactor_type)
		)
		return
	end

	if not context then
		context = vim.lsp.util.make_range_params(0)
		context.context = {}
		context.context.diagnostics = vim.lsp.diagnostic.get_line_diagnostics(0)
	end

	local formatting_options = {
		tabSize = vim.bo.tabstop,
		insertSpaces = vim.bo.expandtab,
	}

	local buffer = vim.api.nvim_get_current_buf()

	local selections = List:new()

	if
		context.range.start.character == context.range['end'].character
		and context.range.start.line == context.range['end'].line
	then
		local selection =
			self.jdtls_client:java_infer_selection(refactor_type, context, buffer)[1]

		if refactor_type == 'extractField' then
			if selection.params and vim.islist(selection.params) then
				local initialize_in =
					ui.select('Initialize the field in', selection.params)

				if not initialize_in then
					return
				end

				selections:push(initialize_in)
			end
		end

		selections:push(selection)
		vim.print(selections)
	end

	local edit = self.jdtls_client:java_get_refactor_edit(
		refactor_type,
		context,
		formatting_options,
		selections,
		buffer
	)

	if not edit then
		notify.warn('No edits suggested for action')
		return
	end

	vim.lsp.util.apply_workspace_edit(edit.edit, 'utf-8')

	RefactorCommands.run_lsp_client_command(
		edit.command.command,
		edit.command.arguments
	)
end

function RefactorCommands.run_lsp_client_command(command_name, arguments)
	local command = vim.lsp.commands[command_name]

	if not command then
		notify.error('Command "' .. command_name .. '" is not supported')
		return
	end

	command(arguments)
end

return RefactorCommands
