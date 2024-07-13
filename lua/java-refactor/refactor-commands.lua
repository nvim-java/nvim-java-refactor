local class = require('java-core.utils.class')
local notify = require('java-core.utils.notify')
local JdtlsClient = require('java-core.ls.clients.jdtls-client')
local List = require('java-core.utils.list')
local ui = require('java.utils.ui')

local selections_needed_refactoring_commands = {
	'convertVariableToField',
	'extractConstant',
	'extractField',
	'extractMethod',
	'extractVariable',
	'extractVariableAllOccurrence',
}

local available_commands = {
	'assignField',
	'assignVariable',
	-- 'changeSignature',
	'convertAnonymousClassToNestedCommand',
	'convertVariableToField',
	'extractConstant',
	'extractField',
	-- 'extractInterface',
	'extractMethod',
	'extractVariable',
	'extractVariableAllOccurrence',
	'introduceParameter',
	'invertVariable',
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
---@param params lsp.CodeActionParams
function RefactorCommands:refactor(refactor_type, params)
	if not vim.tbl_contains(available_commands, refactor_type) then
		notify.error(
			string.format('Refactoring command "%s" is not supported', refactor_type)
		)
		return
	end

	params = params or RefactorCommands.make_action_params()
	local formatting_options = RefactorCommands.make_formatting_options()
	local selections

	if selections_needed_refactoring_commands then
		selections = self:get_selections(refactor_type, params)
	end

	local edit = self.jdtls_client:java_get_refactor_edit(
		refactor_type,
		params,
		formatting_options,
		selections,
		vim.api.nvim_get_current_buf()
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

---@private
---@param command_name string
---@param arguments any
function RefactorCommands.run_lsp_client_command(command_name, arguments)
	local command = vim.lsp.commands[command_name]

	if not command then
		notify.error('Command "' .. command_name .. '" is not supported')
		return
	end

	command(arguments)
end

---Returns action params
---@private
---@return lsp.CodeActionParams
function RefactorCommands.make_action_params()
	---@type lsp.CodeActionParams
	local params = vim.lsp.util.make_range_params(0)

	---@type lsp.CodeActionContext
	local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics(0) }

	params.context = context

	return params
end

---@private
---@return lsp.FormattingOptions
function RefactorCommands.make_formatting_options()
	return {
		tabSize = vim.bo.tabstop,
		insertSpaces = vim.bo.expandtab,
	}
end

---@private
---@param refactor_type jdtls.CodeActionCommand
---@param params lsp.CodeActionParams
---@return jdtls.SelectionInfo[]
function RefactorCommands:get_selections(refactor_type, params)
	local selections = List:new()
	local buffer = vim.api.nvim_get_current_buf()

	if
		params.range.start.character == params.range['end'].character
		and params.range.start.line == params.range['end'].line
	then
		local selection_res =
			self.jdtls_client:java_infer_selection(refactor_type, params, buffer)

		if not selection_res then
			return selections
		end

		local selection = selection_res[1]

		if selection.params and vim.islist(selection.params) then
			local initialize_in =
				ui.select('Initialize the field in', selection.params)

			if not initialize_in then
				return selections
			end

			selections:push(initialize_in)
		end

		selections:push(selection)
	end

	return selections
end

return RefactorCommands
