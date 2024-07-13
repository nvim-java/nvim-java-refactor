local runner = require('async.runner')
local get_error_handler = require('java-refactor.utils.error_handler')
local RefactorCommands = require('java-refactor.refactor-commands')

local M = {

	commands = {
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

				vim.api.nvim_win_set_cursor(0, { line, start_char })

				vim.lsp.buf.rename(nil, {
					name = 'jdtls',
					bufnr = buffer,
				})
			end
		end,

		---comment
		---@param command lsp.Command
		---@param params java-refactor.ApplyRefactoringCommandParams
		['java.action.applyRefactoringCommand'] = function(command, params)
			runner(function()
					local refactor_type = command.arguments[1] --[[@as jdtls.CodeActionCommand]]

					local client = vim.lsp.get_client_by_id(params.client_id)

					---@type java-refactor.RefactorCommands
					local refactor_commands = RefactorCommands(client)
					refactor_commands:refactor(refactor_type, params.params)
				end)
				.catch(get_error_handler('Failed to run refactoring command'))
				.run()
		end,
	},
}

local id

id = vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == 'jdtls' then
			for name, command in pairs(M.commands) do
				vim.lsp.commands[name] = command
			end

			vim.api.nvim_del_autocmd(id)
		end
	end,
})

---@class java-refactor.ApplyRefactoringCommandParams
---@field bufnr number
---@field client_id number
---@field method string
---@field params lsp.CodeActionParams
---@field version number

--[[
{
		arguments = {
			'extractField',
			{
				context = {
					diagnostics = {},
					triggerKind = 1,
				},
				range = {
					['end'] = {
						character = 9,
						line = 9,
					},
					start = {
						character = 9,
						line = 9,
					},
				},
				textDocument = {
					uri = 'file:///home/s1n7ax/Workspace/demo/src/main/java/com/example/demo/DemoApplication.java',
				},
			},
		},
		command = 'java.action.applyRefactoringCommand',
		title = 'Extract to field',
	})

{
  bufnr = 3,
  client_id = 2,
  method = "textDocument/codeAction",
  params = {
    context = {
      diagnostics = {},
      triggerKind = 1
    },
    range = {
      ["end"] = {
        character = 9,
        line = 9
      },
      start = {
        character = 9,
        line = 9
      }
    },
    textDocument = {
      uri = "file:///home/s1n7ax/Workspace/demo/src/main/java/com/example/demo/DemoApplication.java"
    }
  },
  version = 4
}
]]
