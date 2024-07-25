local M = {}

---@return java-refactor.Action
function M.get_action()
	local InstanceFactory = require('java-core.utils.instance-factory')
	local Action = require('java-refactor.action')
	local client = InstanceFactory.get_client()

	return Action(client)
end

return M
