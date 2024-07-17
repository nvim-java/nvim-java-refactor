local class = require('java-core.utils.class')
local notify = require('java-core.utils.notify')
local JdtlsClient = require('java-core.ls.clients.jdtls-client')
local List = require('java-core.utils.list')
local ui = require('java.utils.ui')

local refactor_edit_request_needed_actions = {
	'convertVariableToField',
	'extractConstant',
	'extractField',
	'extractMethod',
	'extractVariable',
	'extractVariableAllOccurrence',
}

local selections_needed_refactoring_commands = {
	'convertVariableToField',
	'extractConstant',
	'extractField',
	'extractMethod',
	'extractVariable',
	'extractVariableAllOccurrence',
}

local available_actions = {
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
	'moveFile',
	'moveInstanceMethod',
	'moveStaticMember',
	'moveType',
}

---@class java-refactor.RefactorCommands
---@field jdtls_client java-core.JdtlsClient
local RefactorCommands = class()

---@param client vim.lsp.Client
function RefactorCommands:_init(client)
	self.jdtls_client = JdtlsClient(client)
end

---Run refactor command
---@param action_name jdtls.CodeActionCommand
---@param action_context lsp.CodeActionParams
---@param action_info lsp.LSPAny
function RefactorCommands:refactor(action_name, action_context, action_info)
	if not vim.tbl_contains(available_actions, action_name) then
		notify.error(
			string.format('Refactoring command "%s" is not supported', action_name)
		)
		return
	end

	if vim.tbl_contains(refactor_edit_request_needed_actions, action_name) then
		local formatting_options = RefactorCommands.make_formatting_options()
		local selections

		if
			vim.tbl_contains(selections_needed_refactoring_commands, action_name)
		then
			selections = self:get_selections(action_name, action_context)
		end

		local changes = self.jdtls_client:java_get_refactor_edit(
			action_name,
			action_context,
			formatting_options,
			selections,
			vim.api.nvim_get_current_buf()
		)

		if not changes then
			notify.warn('No edits suggested for action')
			return
		end

		vim.lsp.util.apply_workspace_edit(changes.edit, 'utf-8')

		RefactorCommands.run_lsp_client_command(
			changes.command.command,
			changes.command.arguments
		)
	elseif action_name == 'moveType' then
		self:move_type(
			action_context,
			action_info --[[@as jdtls.CodeActionMoveTypeCommandInfo]]
		)
	elseif action_name == 'moveStaticMember' then
		self:move_static_member(
			action_context,
			action_info --[[@as jdtls.CodeActionMoveTypeCommandInfo]]
		)
	end
end

---@param action_context lsp.CodeActionParams
---@param action_info jdtls.CodeActionMoveTypeCommandInfo
function RefactorCommands:move_static_member(action_context, action_info)
	local exclude = List:new()

	if action_info.enclosingTypeName then
		exclude:push(action_info.enclosingTypeName)
		if
			action_info.memberType == 55
			or action_info.memberType == 71
			or action_info.memberType == 81
		then
			exclude:push(
				action_info.enclosingTypeName .. '.' .. action_info.displayName
			)
		end
	end

	local project_name = action_info and action_info.projectName or nil
	local member_name = action_info
			and action_info.displayName
			and action_info.displayName
		or ''

	local selected_class = self:select_target_class(
		string.format('Select the new class for the static member %s.', member_name),
		project_name,
		exclude
	)

	if not selected_class then
		return
	end

	local changes = self.jdtls_client:java_move({
		moveKind = 'moveStaticMember',
		sourceUris = { action_context.textDocument.uri },
		params = action_context,
		destination = selected_class,
	})

	vim.lsp.util.apply_workspace_edit(changes.edit, 'utf-8')

	if changes.command then
		RefactorCommands.run_lsp_client_command(
			changes.command.command,
			changes.command.arguments
		)
	end
end

---@param action_context lsp.CodeActionParams
---@param action_info jdtls.CodeActionMoveTypeCommandInfo
function RefactorCommands:move_type(action_context, action_info)
	if not action_info or not action_info.supportedDestinationKinds then
		return
	end

	local selected_destination_kind = ui.select(
		'What would you like to do?',
		action_info.supportedDestinationKinds,
		function(kind)
			if kind == 'newFile' then
				return string.format(
					'Move type "%s" to new file',
					action_info.displayName
				)
			else
				return string.format(
					'Move type "%s" to another class',
					action_info.displayName
				)
			end
		end
	)

	if not selected_destination_kind then
		return
	end

	---@type jdtls.RefactorWorkspaceEdit
	local changes

	if selected_destination_kind == 'newFile' then
		changes = self.jdtls_client:java_move({
			moveKind = 'moveTypeToNewFile',
			sourceUris = { action_context.textDocument.uri },
			params = action_context,
		})
	else
		local exclude = List:new()

		if action_info.enclosingTypeName then
			exclude:push(action_info.enclosingTypeName)
			exclude:push(
				action_info.enclosingTypeName .. ':' .. action_info.displayName
			)
		end

		local selected_class = self:select_target_class(
			string.format(
				'Select the new class for the type %s.',
				action_info.displayName
			),
			action_info.projectName,
			exclude
		)

		if not selected_class then
			return
		end

		changes = self.jdtls_client:java_move({
			moveKind = 'moveStaticMember',
			sourceUris = { action_context.textDocument.uri },
			params = action_context,
			destination = selected_class,
		})
	end

	vim.lsp.util.apply_workspace_edit(changes.edit, 'utf-8')

	if changes.command then
		RefactorCommands.run_lsp_client_command(
			changes.command.command,
			changes.command.arguments
		)
	end
end

---@param prompt string
---@param project_name string
---@param exclude string[]
function RefactorCommands:select_target_class(prompt, project_name, exclude)
	local classes = self.jdtls_client:java_search_symbols({
		query = '*',
		projectName = project_name,
		sourceOnly = true,
	})

	---@type lsp.SymbolInformation[]
	local filtered_classes = List:new(classes):filter(function(cls)
		local type_name = cls.containerName .. '.' .. cls.name
		return not vim.tbl_contains(exclude, type_name)
	end)

	local selected = ui.select(prompt, filtered_classes, function(cls)
		return cls.containerName .. '.' .. cls.name
	end)

	return selected
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

---@class jdtls.CodeActionMoveTypeCommandInfo
---@field displayName string
---@field enclosingTypeName string
---@field memberType number
---@field projectName string
---@field supportedDestinationKinds string[]

return RefactorCommands
