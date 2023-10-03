return function(name)
    if __oopSpace.__className then error("Class already defined") end
    __oopSpace.__className = type(name) == "string" and name or error("Invalid class name")
end