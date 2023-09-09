return setmetatable({
    build = function(name, config)
        -- 创建一个空的表，用于存储类
        local cls = {}

        -- 设置索引元方法，指向类本身
        cls.__index = cls
        -- 设置类名，如果没有提供，则默认为 Unnamed
        cls.__name = type(name) == "string"
            and name
            or "Unnamed"
        -- 设置初始化函数，如果没有提供，则默认为空
        cls.__init = type(config.init) == "function"
            and config.init
            or null
        -- 设置 open 修饰符，如果没有提供，则默认为 false
        cls.__open = config.open
            or false
        -- 设置 static 修饰符，如果没有提供，则默认为 false
        cls.__static = config.static
            or false
        -- 设置类型函数，用于返回字符串 "class"
        cls.__type = function()
            return "class"
        end
        -- 设置 tostring 元方法，用于显示类名
        cls.__tostring = function(self)
            return "class " .. self.__name
        end
        -- 设置相等性的比较函数，比较类名是否相同
        cls.__eq = function(self, other)
            if not type(other) == "class" then
                return false
            end
            return rawequal(self, other)
                or (getmetatable(self).__name == getmetatable(other).__name)
        end
        -- 设置 call 元方法，用于创建实例
        cls.__call = function(self, ...)
            -- 如果是静态类，则报错
            if self.__static then
                error("InstantiationException : Attempt to instantiate a static class " .. self.__name)
            end
            return self:__constructor(...)
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
        -- 设置实例构造器
        function cls:__constructor(...)
            -- 设置实例对象的元表
            local __mt = table.clone(self)
            math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 7)))
            __mt.__id = math.random(1, 1000000000)
            __mt.__tostring = function(self)
                return self.__name .. " @" .. self.__id
            end
            __mt.__type = function()
                return "object"
            end
            __mt.__eq = function(self, other)
                if not type(other) == "object" then
                    return false
                end
                return rawequal(self, other)
                    or (getmetatable(self).__name == getmetatable(other).__name)
            end
            __mt.__call = function(self)
                return error("ObjectCallException : Attempt to call a object " .. tostring(self))
            end

            -- 创建一个空表，作为实例对象
            local instance = setmetatable({}, __mt)

            -- 如果存在初始化函数，则调用
            if type(self.__init) == "function" then
                -- 处理父类初始化函数
                local super = config.extend
                    and type(config.extend.__init) == "function"
                    and function(...)
                        return config.extend.__init(instance, ...)
                    end
                -- 如果存在，则传递给子类
                if super then
                    self.__init(instance, super, ...)
                else
                    self.__init(instance, ...)
                end
            end

            -- 返回实例
            return instance
        end

        -- 使用 fields 表定义类的字段
        if type(config.fields) == "table" then
            for name, field in pairs(config.fields) do
                if cls[name] and cls[name] ~= null then
                    error("RedefinedVariableException : Attempt to assign a defined value " .. name)
                end
                cls[name] = field
            end
        end

        -- 使用 final 表定义final变量
        if type(config.final) == "table" then
            cls.__final = setmetatable({}, {
                __newindex = function(table, key, value)
                    -- 拦截对不存在的索引的赋值操作
                    error("FinalTableModificationException : Attempt to modify the final table.")
                end
            })
            for name, v in pairs(config.final) do
                rawset(cls.__final, name, v)
                cls["get" .. name] = function
                (self)
                    return self.__final[name]
                end
            end
        end

        -- 使用 methods 表定义类的方法
        if type(config.methods) == "table" then
            for name, fn in pairs(config.methods) do
                if not type(fn) == "function" then
                    error("InvalidMethodException : Method must be a function or a lambda expression")
                elseif cls[name] and cls[name] ~= null then
                    error("RedefinedVariableException : Attempt to assign a defined value " .. name)
                end
                cls[name] = fn
            end
        end

        -- 使用 overrides 表重写父类方法
        if type(config.overrides) == "table" and config.extend then
            for name, fn in pairs(config.overrides) do
                local super = rawget(config.extend, name)
                if super then
                    -- 如果父类中也存在该方法，则将它包装起来，并传递给子类的函数
                    cls[name] = function(self, ...)
                        return fn(self, function(...)
                            return super(self, ...)
                        end, ...)
                    end
                else
                    error("MethodNotFoundException : Can not find method " .. name .. " in base class")
                end
            end
        end
        -- 返回创建的类
        return cls
    end
}, {
    __call = function(self, name)
        return function(config)
            return self.build(name, config)
        end
    end
})
