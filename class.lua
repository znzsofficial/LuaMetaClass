return function(name)
    if extends.__className ~= null then error("Class already defined") end
    extends.__className = type(name) == "string" and name or error("Invalid class name")
end