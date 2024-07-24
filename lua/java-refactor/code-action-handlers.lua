local M = {}

M.commands = {
	ADD_TO_SOURCEPATH = 'java.project.addToSourcePath',
	ADD_TO_SOURCEPATH_CMD = 'java.project.addToSourcePath.command',
	APPLY_REFACTORING_COMMAND = 'java.action.applyRefactoringCommand',
	APPLY_WORKSPACE_EDIT = 'java.apply.workspaceEdit',
	BUILD_PROJECT = 'java.project.build',
	CHANGE_BASE_TYPE = 'java.action.changeBaseType',
	CHANGE_IMPORTED_PROJECTS = 'java.project.changeImportedProjects',
	CHOOSE_IMPORTS = 'java.action.organizeImports.chooseImports',
	CLEAN_SHARED_INDEXES = 'java.clean.sharedIndexes',
	CLEAN_WORKSPACE = 'java.clean.workspace',
	CLIPBOARD_ONPASTE = 'java.action.clipboardPasteAction',
	COMPILE_WORKSPACE = 'java.workspace.compile',
	CONFIGURATION_UPDATE = 'java.projectConfiguration.update',
	CREATE_MODULE_INFO = 'java.project.createModuleInfo',
	CREATE_MODULE_INFO_COMMAND = 'java.project.createModuleInfo.command',
	EXECUTE_WORKSPACE_COMMAND = 'java.execute.workspaceCommand',
	FILESEXPLORER_ONPASTE = 'java.action.filesExplorerPasteAction',
	GENERATE_ACCESSORS_PROMPT = 'java.action.generateAccessorsPrompt',
	GENERATE_CONSTRUCTORS_PROMPT = 'java.action.generateConstructorsPrompt',
	GENERATE_DELEGATE_METHODS_PROMPT = 'java.action.generateDelegateMethodsPrompt',
	GENERATE_TOSTRING_PROMPT = 'java.action.generateToStringPrompt',
	GET_ALL_JAVA_PROJECTS = 'java.project.getAll',
	GET_CLASSPATHS = 'java.project.getClasspaths',
	GET_DECOMPILED_SOURCE = 'java.decompile',
	GET_PROJECT_SETTINGS = 'java.project.getSettings',
	GET_WORKSPACE_PATH = '_java.workspace.path',
	GOTO_LOCATION = 'editor.action.goToLocations',
	HANDLE_PASTE_EVENT = 'java.edit.handlePasteEvent',
	HASHCODE_EQUALS_PROMPT = 'java.action.hashCodeEqualsPrompt',
	IGNORE_INCOMPLETE_CLASSPATH = 'java.ignoreIncompleteClasspath',
	IGNORE_INCOMPLETE_CLASSPATH_HELP = 'java.ignoreIncompleteClasspath.help',
	IMPORT_PROJECTS = 'java.project.import',
	IMPORT_PROJECTS_CMD = 'java.project.import.command',
	IS_TEST_FILE = 'java.project.isTestFile',
	LEARN_MORE_ABOUT_CLEAN_UPS = '_java.learnMoreAboutCleanUps',
	LEARN_MORE_ABOUT_REFACTORING = '_java.learnMoreAboutRefactorings',
	LIST_SOURCEPATHS = 'java.project.listSourcePaths',
	LIST_SOURCEPATHS_CMD = 'java.project.listSourcePaths.command',
	LOMBOK_CONFIGURE = 'java.lombokConfigure',
	MANUAL_CLEANUP = 'java.action.doCleanup',
	MARKDOWN_API_RENDER = 'markdown.api.render',
	METADATA_FILES_GENERATION = '_java.metadataFilesGeneration',
	NAVIGATE_TO_SUPER_IMPLEMENTATION_COMMAND = 'java.action.navigateToSuperImplementation',
	NOT_COVERED_EXECUTION = '_java.notCoveredExecution',
	NULL_ANALYSIS_SET_MODE = 'java.compile.nullAnalysis.setMode',
	OPEN_BROWSER = 'vscode.open',
	OPEN_CLIENT_LOG = 'java.open.clientLog',
	OPEN_FILE = 'java.open.file',
	OPEN_FORMATTER = 'java.open.formatter.settings',
	OPEN_JSON_SETTINGS = 'workbench.action.openSettingsJson',
	OPEN_LOGS = 'java.open.logs',
	OPEN_OUTPUT = 'java.open.output',
	OPEN_SERVER_LOG = 'java.open.serverLog',
	OPEN_SERVER_STDERR_LOG = 'java.open.serverStderrLog',
	OPEN_SERVER_STDOUT_LOG = 'java.open.serverStdoutLog',
	OPEN_STATUS_SHORTCUT = '_java.openShortcuts',
	OPEN_TYPE_HIERARCHY = 'java.navigate.openTypeHierarchy',
	ORGANIZE_IMPORTS = 'java.action.organizeImports',
	ORGANIZE_IMPORTS_SILENTLY = 'java.edit.organizeImports',
	OVERRIDE_METHODS_PROMPT = 'java.action.overrideMethodsPrompt',
	PROJECT_CONFIGURATION_STATUS = 'java.projectConfiguration.status',
	REFRESH_BUNDLES = 'java.reloadBundles',
	REFRESH_BUNDLES_COMMAND = '_java.reloadBundles.command',
	RELOAD_WINDOW = 'workbench.action.reloadWindow',
	REMOVE_FROM_SOURCEPATH = 'java.project.removeFromSourcePath',
	REMOVE_FROM_SOURCEPATH_CMD = 'java.project.removeFromSourcePath.command',
	RENAME_COMMAND = 'java.action.rename',
	RESOLVE_PASTED_TEXT = 'java.project.resolveText',
	RESOLVE_SOURCE_ATTACHMENT = 'java.project.resolveSourceAttachment',
	RESOLVE_TYPE_HIERARCHY = 'java.navigate.resolveTypeHierarchy',
	RESOLVE_WORKSPACE_SYMBOL = 'java.project.resolveWorkspaceSymbol',
	RESTART_LANGUAGE_SERVER = 'java.server.restart',
	RUNTIME_VALIDATION_OPEN = 'java.runtimeValidation.open',
	SHOW_CLASS_HIERARCHY = 'java.action.showClassHierarchy',
	SHOW_JAVA_IMPLEMENTATIONS = 'java.show.implementations',
	SHOW_JAVA_REFERENCES = 'java.show.references',
	SHOW_REFERENCES = 'editor.action.showReferences',
	SHOW_SERVER_TASK_STATUS = 'java.show.server.task.status',
	SHOW_SUBTYPE_HIERARCHY = 'java.action.showSubtypeHierarchy',
	SHOW_SUPERTYPE_HIERARCHY = 'java.action.showSupertypeHierarchy',
	SHOW_TYPE_HIERARCHY = 'java.action.showTypeHierarchy',
	SMARTSEMICOLON_DETECTION = 'java.edit.smartSemicolonDetection',
	SWITCH_SERVER_MODE = 'java.server.mode.switch',
	TEMPLATE_VARIABLES = '_java.templateVariables',
	UPDATE_SOURCE_ATTACHMENT = 'java.project.updateSourceAttachment',
	UPDATE_SOURCE_ATTACHMENT_CMD = 'java.project.updateSourceAttachment.command',
	UPGRADE_GRADLE_WRAPPER = 'java.project.upgradeGradle',
	UPGRADE_GRADLE_WRAPPER_CMD = 'java.project.upgradeGradle.command',
}

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

M.handlers = {
	---@param params java-refactor.RenameAction[]
	[M.commands.RENAME_COMMAND] = function(params)
		run('Failed to rename the symbol', function(action)
			action:rename(params)
		end)
	end,

	---@param params nvim.CodeActionParamsResponse
	[M.commands.GENERATE_CONSTRUCTORS_PROMPT] = function(_, params)
		run('Failed to generate constructor', function(action)
			action:generate_constructor(params)
		end)
	end,

	---@param params nvim.CodeActionParamsResponse
	[M.commands.GENERATE_TOSTRING_PROMPT] = function(_, params)
		run('Failed to generate toString', function(action)
			action:generate_to_string(params)
		end)
	end,

	---@param params nvim.CodeActionParamsResponse
	[M.commands.HASHCODE_EQUALS_PROMPT] = function(_, params)
		run('Failed to generate hash code and equals', function(action)
			action:generate_hash_code_and_equals(params)
		end)
	end,

	---@param params nvim.CodeActionParamsResponse
	[M.commands.GENERATE_DELEGATE_METHODS_PROMPT] = function(_, params)
		run('Failed to generate delegate methods', function(action)
			action:generate_delegate_mothods_prompt(params)
		end)
	end,

	---@param command lsp.Command
	[M.commands.APPLY_REFACTORING_COMMAND] = function(command)
		run('Failed to apply refactoring command', function(action)
			action:apply_refactoring_command(command)
		end)
	end,

	---@param is_full_build boolean
	[M.commands.COMPILE_WORKSPACE] = function(is_full_build)
		run('Failed to build workspace', function(action)
			action:build_workspace(is_full_build)
		end)
	end,

	[M.commands.CLEAN_WORKSPACE] = function()
		run('Failed to clean workspace', function(action)
			action:clean_workspace()
		end)
	end,
}

local ignored_commands = { M.commands.REFRESH_BUNDLES_COMMAND }

for _, command in pairs(M.commands) do
	if
		not M.handlers[command] and not vim.tbl_contains(ignored_commands, command)
	then
		local message = string.format(
			'"%s" is not supported yet!'
				.. '\nPlease request the feature using below link'
				.. '\nhttps://github.com/nvim-java/nvim-java/issues/new?assignees='
				.. '&labels=enhancement&projects=&template=feature_request.yml&title=feature%%3A+',
			command
		)

		M.handlers[command] = function()
			require('java-core.utils.notify').warn(message)

			return vim.lsp.rpc_response_error(
				vim.lsp.protocol.ErrorCodes.MethodNotFound,
				'Not implemented yes'
			)
		end
	end
end

return M
