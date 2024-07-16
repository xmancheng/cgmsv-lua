---ģ����
local Module = ModuleBase:createModule('setupItemType')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  local itemType = {
    { type=65, name="����", defaultImage=27821, place=2, flags=0, job=1, level=10 },
    { type=66, name="ħ��", defaultImage=20075, place=3, flags=0, job=15, level=10 },
    { type=67, name="����", defaultImage=27938, place=3, flags=0, job=45, level=10 },
    { type=68, name="����", defaultImage=27446, place=3, flags=0, job=75, level=10 },
    { type=69, name="�Lħ", defaultImage=99521, place=3, flags=0, job=115, level=10 },
    { type=70, name="ȭ��", defaultImage=21303, place=2, flags=128, job=145, level=10 },
  }
  for k, v in ipairs(itemType) do
      Item.CreateNewItemType(v.type, v.name, v.defaultImage, v.place, v.flags)
      --Item.SetItemTypeName( v.type, v.name )
      --Item.SetItemTypeEquipPlace(v.type, v.place)
      Item.SetItemTypeEquipLevelForJob(v.job, v.type, v.level)
  end
  --self:regCallback('ItemAttachEvent', Func.bind(self.ItemAttachEvent, self))
  --self:regCallback('ItemDetachEvent', Func.bind(self.ItemDetachEvent, self))

  --����װ
  local petEquipType = {
    { type=56, name="����ˮ��", place=CONST.�����_ˮ��, enable=1 },
    { type=57, name="������Ʒ", place=CONST.�����_��Ʒ1, enable=1 },
    { type=58, name="����װ��", place=CONST.�����_����, enable=1 },
    { type=59, name="�������", place=CONST.�����_����, enable=1 },
    { type=60, name="���ﾱȦ", place=CONST.�����_��Ȧ, enable=1 },
    { type=61, name="���ﻤ��", place=CONST.�����_��Ʒ2, enable=1 },
  }
  --for k, v in ipairs(petEquipType) do
  --    Item.SetPetEquipPlace(v.type, v.place, v.enable)
  --end

end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
