local M = {}

M.is_locked = false
M.load_queue = {}

local manager = require("manager.core")

function M.lock()
	M.is_locked = true
end

function M.unlock()
	M.is_locked = false
	local queue = M.load_queue
	M.load_queue = {}
	for _, id in ipairs(queue) do
		manager.load(id)
	end
end

function M.locked_load(id)
	if M.is_locked then
		table.insert(M.load_queue, id)
		return
	end
	manager.load(id)
end

M.load = M.locked_load

return M
