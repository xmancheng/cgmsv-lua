---模块类
local Module = ModuleBase:createModule('trashCan')

local DirList={
  {14,15,4},{13,15,3},{13,16,2},{13,17,1},{14,17,0}
}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemDropEvent', function(charIndex, itemIndex)
    local Target_FloorId = Char.GetData(charIndex, CONST.CHAR_地图)
    local Target_X = Char.GetData(charIndex,CONST.CHAR_X)
    local Target_Y = Char.GetData(charIndex,CONST.CHAR_Y)
    local Dir = Char.GetData(charIndex,CONST.CHAR_方向)
    if Target_FloorId==25000  then
         table.forEach(DirList, function(e)
            if (Target_X==e[1] and Target_Y==e[2] and Dir==e[3]) then
                for itemSlot=8,27 do
                   local bagIndex = Char.GetItemIndex(charIndex,itemSlot)
                   if (bagIndex==itemIndex) then
                     local ItemName = Item.GetData(bagIndex,CONST.道具_名字);
                     Char.DelItemBySlot(charIndex, itemSlot);
                     NLG.Say(charIndex,-1,"將"..ItemName.."送往異空間。",4,3);
                   end
                end
                return;
            end
         end)
    end
    return;
  end)

  self.trashCan1NPC = self:NPC_createNormal('異空間', 111136, { x = 14, y = 16, mapType = 0, map = 25000, direction = 0 });
  self:NPC_regTalkedEvent(self.trashCan1NPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【異空間垃圾場】" ..	"\\n\\n朝向此處所丟棄的東西"
                                                                               ..	"\\n\\n將不復返地傳至異空間";
        NLG.ShowWindowTalked(player, self.trashCan1NPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.trashCan1NPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
  end)


end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
