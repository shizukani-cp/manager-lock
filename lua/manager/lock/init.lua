local M = {}

local function lock(self)
    self.is_locked = true
end

local function unlock(self)
    self.is_locked = false
    local queue = self.load_queue
    self.load_queue = {}
    for _, id in ipairs(queue) do
        self:original_load(id)
    end
end

local function locked_load(self, id)
    if self.is_locked then
        table.insert(self.load_queue, id)
        return
    end
    self:original_load(id)
end

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
