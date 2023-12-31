return setmetatable({
    build = function(name, config)
        -- 创建一个空的表，用于存储对象
        local obj = {}

        obj.__index = obj
        -- 设置类名，如果没有提供，则默认为 Unnamed
        obj.__name = type(name) == "string"
            and name
            or "Unnamed"
        -- 设置初始化函数，如果没有提供，则默认为空
        obj.__init = type(config.init) == "function"
            and config.init
            or null
        -- 设置 tostring 元方法，用于显示类名
        obj.__tostring = function(self)
            return "object " .. self.__name
        end
        -- 设置相等性的比较函数，比较对象名是否相同
        obj.__eq = function(self, other)
            if not type(other) == "object" then
                return false
            end
            return rawequal(self, other)
                or (getmetatable(self).__name == getmetatable(other).__name)
        end
        -- 设置 call 元方法，用于创建实例
        obj.__call = function(self)
            error("InstantiationException : Attempt to instantiate a object declaration " .. self.__name)
        end

        obj.__extend = config[1] or null

        -- 判断是否继承自另一个类
        if type(obj.__extend) == "class" then
            -- 判断是否使用 open 修饰符
            if not obj.__extend.__open then
                error("InvalidExtendException : " ..
                    tostring(obj) .. " attempt to extend a final class " .. obj.__extend.__name)
            end
        elseif obj.__extend ~= null then
            -- 如果父类不是一个 class，则报错
            error("InvalidExtendException : " ..
                tostring(obj) .. " attempt to extend a " .. type(obj.__extend) .. " value")
        end

        -- 设置元表，用于处理类的各种操作
        setmetatable(obj, {
            __index = obj.__extend,
            __tostring = obj.__tostring,
            __call = obj.__call,
            __eq = obj.__eq,
            __type = "object"
        })

        -- 使用 fields 表定义字段
        if type(config.fields) == "table" then
            for name, field in pairs(config.fields) do
                if obj[name] and obj[name] ~= null then
                    error("RedefinedVariableException : Attempt to assign a defined value " .. name)
                end
                obj[name] = field
            end
        end
        -- 使用 methods 表定义方法
        if type(config.methods) == "table" then
            for name, fn in pairs(config.methods) do
                if not type(fn) == "function" then
                    error("InvalidMethodException : Method must be a function")
                elseif obj[name] and obj[name] ~= null then
                    error("RedefinedVariableException : Attempt to assign a defined value " .. name)
                end
                obj[name] = fn
            end
        end
        -- 如果有初始化函数就执行一下
        if type(config.init) == "function" then
            config.init(obj)
        end
        -- 将创建的对象放在全局表里
        _G[obj.__name] = obj
    end
}, {
    __call = function(self, name)
        return function(config)
            return self.build(name, config)
        end
    end
})
