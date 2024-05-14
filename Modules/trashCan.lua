---ģ����
local Module = ModuleBase:createModule('trashCan')

local DirList={
  {14,15,4},{13,15,3},{13,16,2},{13,17,1},{14,17,0}
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemDropEvent', function(charIndex, itemIndex)
    local Target_FloorId = Char.GetData(charIndex, CONST.CHAR_��ͼ)
    local Target_X = Char.GetData(charIndex,CONST.CHAR_X)
    local Target_Y = Char.GetData(charIndex,CONST.CHAR_Y)
    local Dir = Char.GetData(charIndex,CONST.CHAR_����)
    if Target_FloorId==25000  then
         table.forEach(DirList, function(e)
            if (Target_X==e[1] and Target_Y==e[2] and Dir==e[3]) then
                for itemSlot=8,27 do
                   local bagIndex = Char.GetItemIndex(charIndex,itemSlot)
                   if (bagIndex==itemIndex) then
                     local ItemName = Item.GetData(bagIndex,CONST.����_����);
                     Char.DelItemBySlot(charIndex, itemSlot);
                     NLG.Say(charIndex,-1,"��"..ItemName.."���������g��",4,3);
                   end
                end
                return;
            end
         end)
    end
    return;
  end)

  self.trashCan1NPC = self:NPC_createNormal('�����g', 111136, { x = 14, y = 16, mapType = 0, map = 25000, direction = 0 });
  self:NPC_regTalkedEvent(self.trashCan1NPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c�������g��������" ..	"\\n\\n�����̎���G���Ė|��"
                                                                               ..	"\\n\\n�����ͷ��؂��������g";
        NLG.ShowWindowTalked(player, self.trashCan1NPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.trashCan1NPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
  end)


end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
