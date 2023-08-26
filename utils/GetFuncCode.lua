---@param func function
---@return string
local function getCode(func)
    if not type(func) == "function" then
        error(tostring(func) .. "is not a function",0)
    end
    local info = debug.getinfo(func, "S")
    if not info.what == "Lua" then
        return ""
    end
    local source = io.open(info.source:sub(2), "r")
    if not source then return "" end
    local lines = {}
    for line in source:lines() do
        lines[#lines + 1] = line
    end
    source:close()
    local code = ""
    for i = info.linedefined, info.lastlinedefined do
        code = code .. lines[i] .. "\n"
    end
    return code:sub(1, -2)
end

return getCode
