local event = require('java-core.utils.event')

local M = {}

local group = vim.api.nvim_create_augroup('java-refactor-command-register', {})

event.on_jdtls_attach({
	group = group,
	once = true,
	callback = function()
		M.reg_client_commands()
		M.reg_refactor_commands()
		M.reg_build_commands()
	end,
})

M.reg_client_commands = function()
	local code_action_handlers = require('java-refactor.client-command-handlers')

	for key, handler in pairs(code_action_handlers) do
		vim.lsp.commands[key] = handler
	end
end

M.reg_refactor_commands = function()
	local code_action_api = require('java-refactor.api.refactor')

	for api_name, api in pairs(code_action_api) do
		require('java').register_api({ 'refactor', api_name }, api, { range = 2 })
	end
end

M.reg_build_commands = function()
	local code_action_api = require('java-refactor.api.build')

	for api_name, api in pairs(code_action_api) do
		require('java').register_api({ 'build', api_name }, api, {})
	end
end
