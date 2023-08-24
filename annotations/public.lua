local annotations = require("annotations.annotation")

local function public(func)
    return annotations(func, "public")
end

return public
