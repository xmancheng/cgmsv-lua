---ģ����
local Module = ModuleBase:createModule('setupItemType')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  local itemType = {
    { type=60, name="����", place=2, job=1, level=10 },
    { type=61, name="ħ��", place=3, job=2001, level=10 },
    { type=62, name="����", place=3, job=2002, level=10 },
    { type=63, name="����", place=3, job=2003, level=10 },
    { type=64, name="�Lħ", place=3, job=2004, level=10 },
    { type=65, name="ȭ��", place=3, job=2005, level=10 },
  }
  for k, v in ipairs(itemType) do
      Item.SetItemTypeName( v.type, v.name )
      Item.SetItemTypeEquipPlace(v.type, v.place)
      Item.SetItemTypeEquipLevelForJob(v.job, v.type, v.level)
  end

end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
