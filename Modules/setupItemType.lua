---Ä£¿éÀà
local Module = ModuleBase:createModule('setupItemType')

--- ¼ÓÔØÄ£¿é¹³×Ó
function Module:onLoad()
  self:logInfo('load')
  local itemType = {
    { type=60, name="ÁîÆì", place=2, job=1, level=10 },
    { type=61, name="Ä§„¦", place=3, job=2001, level=10 },
    { type=62, name="ÏÝÚå", place=3, job=2002, level=10 },
    { type=63, name="•ø¼®", place=3, job=2003, level=10 },
    { type=64, name="ïLÄ§", place=3, job=2004, level=10 },
    { type=65, name="È­Ì×", place=3, job=2005, level=10 },
  }
  for k, v in ipairs(itemType) do
      Item.SetItemTypeName( v.type, v.name )
      Item.SetItemTypeEquipPlace(v.type, v.place)
      Item.SetItemTypeEquipLevelForJob(v.job, v.type, v.level)
  end

end

--- Ð¶ÔØÄ£¿é¹³×Ó
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
