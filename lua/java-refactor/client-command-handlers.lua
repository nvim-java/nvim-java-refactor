local ClientCommand = require('java-refactor.client-command')

---@param message string
---@param func fun(action: java-refactor.Action)
local run = function(message, func)
	local runner = require('async.runner')
	local get_error_handler = require('java-refactor.utils.error_handler')
	local instance = require('java-refactor.utils.instance-factory')

	runner(function()
			func(instance.get_action())
		end)
		.catch(get_error_handler(message))
		.run()
end

local M = {
	---@param params java-refactor.RenameAction[]
	[ClientCommand.RENAME_COMMAND] = function(params)
		run('Failed to rename the symbol', function(action)
			action.rename(params)
		end)
	end,

	---@param params nvim.CodeActionParamsResponse
	[ClientCommand.GENERATE_CONSTRUCTORS_PROMPT] = function(_, params)
		run('Failed to generate constructor', function(action)
			action:generate_constructor(params)
		end)
	end,

	---@param params nvim.CodeActionParamsResponse
	[ClientCommand.GENERATE_TOSTRING_PROMPT] = function(_, params)
		run('Failed to generate toString', function(action)
			action:generate_to_string(params)
		end)
	end,

	---@param params nvim.CodeActionParamsResponse
	[ClientCommand.HASHCODE_EQUALS_PROMPT] = function(_, params)
		run('Failed to generate hash code and equals', function(action)
			action:generate_hash_code_and_equals(params)
		end)
	end,

	---@param params nvim.CodeActionParamsResponse
	[ClientCommand.GENERATE_DELEGATE_METHODS_PROMPT] = function(_, params)
		run('Failed to generate delegate methods', function(action)
			action:generate_delegate_mothods_prompt(params)
		end)
	end,

	---@param command lsp.Command
	[ClientCommand.APPLY_REFACTORING_COMMAND] = function(command)
		run('Failed to apply refactoring command', function(action)
			action:apply_refactoring_command(command)
		end)
	end,

	---@param is_full_build boolean
	[ClientCommand.COMPILE_WORKSPACE] = function(is_full_build)
		run('Failed to build workspace', function(action)
			action:build_workspace(is_full_build)
			require('java-core.utils.notify').info('Successfully built the workspace')
		end)
	end,

	[ClientCommand.CLEAN_WORKSPACE] = function()
		run('Failed to clean workspace', function(action)
			action:clean_workspace()
			require('java-core.utils.notify').info(
				'Successfully cleared the workspace cache'
					.. '\nPlease close and reopen neovim to restart JDTLS'
			)
		end)
	end,
}

local ignored_commands = { ClientCommand.REFRESH_BUNDLES_COMMAND }

for _, command in pairs(ClientCommand) do
	if not M[command] and not vim.tbl_contains(ignored_commands, command) then
		local message = string.format(
			'"%s" is not supported yet!'
				.. '\nPlease request the feature using below link'
				.. '\nhttps://github.com/nvim-java/nvim-java/issues/new?assignees='
				.. '&labels=enhancement&projects=&template=feature_request.yml&title=feature%%3A+',
			command
		)

		M[command] = function()
			require('java-core.utils.notify').warn(message)

			return vim.lsp.rpc_response_error(
				vim.lsp.protocol.ErrorCodes.MethodNotFound,
				'Not implemented yes'
			)
		end
	end
end

return M
