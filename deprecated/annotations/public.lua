local annotations = require("annotations.annotation")

return function(func)
    return annotations(func, "public")
end
