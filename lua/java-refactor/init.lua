local event = require('java-core.utils.event')

local group = vim.api.nvim_create_augroup('java-refactor-command-register', {})

local setup = function()
	-- setting all the vim.lsp.commands
	local code_action_handler = require('java-refactor.code-action-handlers')

	for key, handler in pairs(code_action_handler.handlers) do
		vim.lsp.commands[key] = handler
	end

	-- setting all the user commands and APIs
	local code_action_api = require('java-refactor.api.code-action')

	for api_name, api in pairs(code_action_api) do
		require('java').register_api({ 'refactor', api_name }, api, { range = 2 })
	end
end

event.on_jdtls_attach({
	group = group,
	once = true,
	callback = setup,
})
