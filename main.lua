require("init")()

-- 定义基类
local Person = class {
  name = "Person",
  open = true,
  init = function(self, name, age)
    self.name = name
    self.age = age
  end,
  final = {
    Species = "human"
  },
  fields = {
    name = null,
    age = null,
  },
  methods = {
    say = function(self, arg)
      print(arg)
      print(self.name .. self.age .. " years old. ")
    end
  }
}

-- 定义派生类
local Employee = class {
  name = "Employee",
  extend = Person,
  init = function(self, super, name, age, position)
    super(name, age)
    self.position = position
  end,
  overrides = {
    say = function(self, super, words)
      super("call super")
      print(self.name .. "：我是 " .. self.position .. " 而且 " .. words .. ".")
    end,
  },
  methods = {
    todo = function(self, thing)
      print(self.name .. " is going to " .. thing)
    end,
  }
}

-- 通过 cls(args) 直接生成实例
local yjp = Employee("一键爬", 25, "Not Boss")
local emp = Employee("时光星球", 30, "Boss")
local empx = Employee("北斗星", 35, "Big Boss")
emp:say("加入时光帝国")
emp:todo("开发时光客App")
empx:say("lua 得了相思病")

-- 访问final属性
print(emp:getSpecies())
-- 打印对象
print(tostring(emp))
print(type(empx))

local KFC = class {
  name = "KFC",
  static = true,
  fields = {
    Crazy = "Thursday",
  },
  methods = {
    V50 = function()
      print("Vme50")
    end
  }
}
print(KFC)
print(KFC.Crazy)
KFC.V50()


local Ticker = require("utils.Ticker")

local count = 0

local ti = Ticker()

ti:setOnTickListener(function()
  print("onTick")
  count = count + 1
  if count == 2 then
    ti:stop()
  end
end)

ti:start()
