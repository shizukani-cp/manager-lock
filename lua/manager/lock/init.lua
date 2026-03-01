---@class Manager
---@field is_locked boolean
---@field load_queue string[]
---@field lock fun(self: Manager)
---@field unlock fun(self: Manager)
---@field original_load fun(self: Manager, id: string)
---@field locked_load fun(self: Manager, id: string)

local M = {}

---@param self Manager
local function lock(self)
    self.is_locked = true
end

---@param self Manager
local function unlock(self)
    self.is_locked = false
    local queue = self.load_queue
    self.load_queue = {}
    for _, id in ipairs(queue) do
        self:original_load(id)
    end
end

---@param self Manager
---@param id string
local function locked_load(self, id)
    if self.is_locked then
        table.insert(self.load_queue, id)
        return
    end
    self:original_load(id)
end

---@param manager Manager
---@param override? boolean
function M.setup(manager, override)
    manager.lock = lock
    manager.unlock = unlock
    manager.original_load = manager.load
    manager.locked_load = locked_load
    manager.is_locked = false
    manager.load_queue = {}
    if override then
        manager.load = locked_load
    end
end

return M
