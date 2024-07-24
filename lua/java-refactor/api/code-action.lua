local M = {}

---@param action_type string
---@param filter? string
local function run_code_action(action_type, filter)
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			diagnostics = vim.lsp.diagnostic.get_line_diagnostics(0),
			only = { action_type },
		},
		filter = filter and function(refactor)
			return refactor.command.arguments[1] == filter
		end or nil,
	})
end

function M.extract_variable()
	run_code_action('refactor.extract.variable', 'extractVariable')
end

function M.extract_variable_all_occurrence()
	run_code_action('refactor.extract.variable', 'extractVariableAllOccurrence')
end

function M.extract_constant()
	run_code_action('refactor.extract.constant')
end

function M.extract_method()
	run_code_action('refactor.extract.function')
end

function M.extract_field()
	run_code_action('refactor.extract.field')
end

return M
