local annotations = require("annotations.annotation")

local function private(func)
    return annotations(func, "private")
end

return private
