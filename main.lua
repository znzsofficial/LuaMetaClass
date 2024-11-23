require("init")()
-- 定义基类
class "Person" extends "Any" {
  -- package = "com.lua",
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
class "Employee" extends "Person" {
  init = function(self, name, age, position)
    self.__extend:__init(name, age)
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

print(yjp)
print(tostring(emp))
-- 访问final属性
print(emp:getSpecies())

object "KFC" {
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

-- print(dump(KFC))

require("utils.Ticker")

-- 测试对象声明
object "MyTicker" {
  Ticker,
  fields = {
    count = 0
  }
}

MyTicker:setOnTickListener(function()
  print("onTick")
  MyTicker.count = MyTicker.count + 1
  if MyTicker.count == 1 then
    MyTicker:stop()
  end
end)

MyTicker:start()