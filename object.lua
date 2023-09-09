return setmetatable({
    build = function(name, config)
        -- 创建一个空的表，用于存储对象
        local cls = {}

        -- 设置索引元方法，指向对象本身
        cls.__index = cls
        -- 设置类名，如果没有提供，则默认为 Unnamed
        cls.__name = type(name) == "string"
            and name
            or "Unnamed"
        -- 设置初始化函数，如果没有提供，则默认为空
        cls.__init = type(config.init) == "function"
            and config.init
            or null
        -- 设置类型函数，用于返回字符串 "class"
        cls.__type = function()
            return "object"
        end
        -- 设置 tostring 元方法，用于显示类名
        cls.__tostring = function(self)
            return "object " .. self.__name
        end
        -- 设置相等性的比较函数，比较类名是否相同
        cls.__eq = function(self, other)
            if not type(other) == "object" then
                return false
            end
            return rawequal(self, other)
                or (getmetatable(self).__name == getmetatable(other).__name)
        end
        -- 设置 call 元方法，用于创建实例
        cls.__call = function(self)
            error("InstantiationException : Attempt to instantiate a object " .. self.__name)
        end

        -- 判断是否继承自另一个类
        if type(config.extend) == "class" then
            -- 判断是否使用 open 修饰符
            if not config.extend.__open then
                error("InvalidExtendException : Attempt to extend a final class " .. config.extend.__name)
            end
        elseif config.extend
            and config.extend ~= null then
            -- 如果父类不是一个 class，则报错
            error("InvalidExtendException : Attempt to extend a " .. type(config.extend))
        end

        -- 设置元表，用于处理类的各种操作
        setmetatable(cls, {
            __index = config.extend,
            __tostring = cls.__tostring,
            __call = cls.__call,
            __eq = cls.__eq,
            __type = cls.__type,
        })

        -- 使用 fields 表定义字段
        if type(config.fields) == "table" then
            for name, field in pairs(config.fields) do
                if cls[name] and cls[name] ~= null then
                    error("RedefinedVariableException : Attempt to assign a defined value " .. name)
                end
                cls[name] = field
            end
        end
        -- 使用 methods 表定义方法
        if type(config.methods) == "table" then
            for name, fn in pairs(config.methods) do
                if not type(fn) == "function" then
                    error("InvalidMethodException : Method must be a function")
                elseif cls[name] and cls[name] ~= null then
                    error("RedefinedVariableException : Attempt to assign a defined value " .. name)
                end
                cls[name] = fn
            end
        end
        -- 如果有初始化函数就执行一下
        if type(config.init) == "function" then
            config.init(cls)
        end
        -- 返回创建的对象
        return cls
    end
}, {
    __call = function(self, name)
        return function(config)
            return self.build(name, config)
        end
    end
})
