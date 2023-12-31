---@class Ticker
class "Ticker" extends "Any" {
    open = true,
    fields = {
        period = 100,
        enabled = false,
        onTick = null,
        commands = {
            Android = "sleep", 
            Linux = "sleep", 
            Windows = "timeout"
        },
        system = require("utils.LuaRuntime").getSystemName(),
    },
    methods = {
        ---@param self any
        ---@param func function
        setOnTickListener = function(self, func)
            self.onTick = func
        end,
        start = function(self)
            self.enabled = true
            while self.enabled do
                local startTime = os.time()

                if self.onTick ~= nil then
                    self.onTick()
                end

                local endTime = os.time()
                local elapsedTime = (endTime - startTime) * 1000 -- 转换为毫秒

                if elapsedTime < self.period then
                    -- 等待剩余时间
                    local remainingTime = self.period - elapsedTime
                    os.execute(self.commands[self.system] .. " " .. math.floor(remainingTime / 1000))
                end
            end
        end,
        stop = function(self)
            self.enabled = false
        end
    }

}