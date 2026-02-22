# manager-lock

An extension for [manager.nvim](https://github.com/shizukani-cp/manager.nvim) that provides a locking mechanism for plugin loading.

## Features
- Defer plugin loading during critical startup phases.
- Queue `manager.load()` requests and process them in bulk.
- Prevent race conditions or UI flickers by controlling load timing.

## Installation
Ensure you have `manager.nvim` installed. Add `manager-lock` to your configuration:

```lua
local manager = require("manager.core")

manager.add({
    id = "manager-lock",
    url = "https://github.com/shizukani-cp/manager-lock",
})

manager.load("manager-lock")
```
## Usage
Load the module as lock and manage the state:
```lua
local lock = require("manager-lock")

-- Lock the manager to queue load requests
lock.lock()

-- These plugins will not be loaded immediately
lock.load("telescope.nvim")
lock.load("plenary.nvim")

-- Unlock to execute all queued load requests at once
lock.unlock()
```
## API
- lock.lock(): Sets the lock state to true.
- lock.unlock(): Sets the lock state to false and flushes the queue.
- lock.load(id): Queues the ID if locked, otherwise loads immediately.
