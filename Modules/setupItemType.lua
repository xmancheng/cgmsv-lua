---模块类
local Module = ModuleBase:createModule('setupItemType')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  local itemType = {
    { type=65, name="令旗", defaultImage=27821, place=2, flags=0, job=1, level=10 },
    { type=66, name="魔劍", defaultImage=20075, place=3, flags=0, job=2001, level=10 },
    { type=67, name="陷阱", defaultImage=27938, place=3, flags=0, job=2002, level=10 },
    { type=68, name="書籍", defaultImage=27446, place=3, flags=0, job=2003, level=10 },
    { type=69, name="風魔", defaultImage=99521, place=3, flags=0, job=2004, level=10 },
    { type=70, name="拳套", defaultImage=21303, place=2, flags=128, job=2005, level=10 },
  }
  for k, v in ipairs(itemType) do
      Item.CreateNewItemType(v.type, v.name, v.defaultImage, v.place, v.flags)
      --Item.SetItemTypeName( v.type, v.name )
      --Item.SetItemTypeEquipPlace(v.type, v.place)
      Item.SetItemTypeEquipLevelForJob(v.job, v.type, v.level)
  end
  --self:regCallback('ItemAttachEvent', Func.bind(self.ItemAttachEvent, self))
  --self:regCallback('ItemDetachEvent', Func.bind(self.ItemDetachEvent, self))

  --宠物装
  local petEquipType = {
    { type=56, name="宠物水晶", place=CONST.宠道栏_水晶, enable=1 },
    { type=57, name="宠物饰品", place=CONST.宠道栏_饰品1, enable=1 },
    { type=58, name="宠物装甲", place=CONST.宠道栏_身替, enable=1 },
    { type=59, name="宠物服饰", place=CONST.宠道栏_身替, enable=1 },
    { type=60, name="宠物颈圈", place=CONST.宠道栏_颈圈, enable=1 },
    { type=61, name="宠物护符", place=CONST.宠道栏_饰品2, enable=1 },
  }
  --for k, v in ipairs(petEquipType) do
  --    Item.SetPetEquipPlace(v.type, v.place, v.enable)
  --end

end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
