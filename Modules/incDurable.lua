---ģ����
local Module = ModuleBase:createModule('incDurable')

local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.maintainNPC = self:NPC_createNormal('�����D�Q���Bħ��', 104745, { x =26 , y = 7, mapType = 0, map = 25000, direction = 4 });
  self:NPC_regTalkedEvent(self.maintainNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local killNum = Char.GetData(player,CONST.CHAR_�˺���);
          local winMsg = "1\\nՈ�x����Ҫ���B�����;õ��b�䡾"..killNum.."����\\n"
          for targetSlot = 0,7 do
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if targetItemIndex>=0 then
                        local tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
                        local tItemName = Item.GetData(targetItemIndex, CONST.����_����);
                        local targetDur_MIN = Item.GetData(targetItemIndex,CONST.����_�;�);
                        local targetDur_MAX = Item.GetData(targetItemIndex,CONST.����_����;�);
                        local tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
                        local tItemCan = "[���B��]";
                        if (tStrLv==9) then tItemCan="[���B��]" end
                        local msg = tItemName .. " " .. tItemCan;
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. msg .. "\n"
                else
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. "\n"
                end
          end
          NLG.ShowWindowTalked(player, self.maintainNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.maintainNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
      if (seqno == 11 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno == 11 and select == CONST.BUTTON_ȷ�� and data >= 1) then
          local keyNum = data;
          if (targetItemIndex>0) then
              local killNum = Char.GetData(player,CONST.CHAR_�˺���);
              local tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
              local tItemName = Item.GetData(targetItemIndex, CONST.����_����);
              local tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
              if (keyNum ~=nil and math.ceil(keyNum)==keyNum) then
                  if (keyNum>killNum) then
                      NLG.SystemMessage(player, "[" .. "����Ī" .. "] ��Ļ���Ŀǰ�顾" .. killNum .. "���o�����^��");
                      return;
                  else
                      local targetDur_MIN = Item.GetData(targetItemIndex,CONST.����_�;�);
                      local targetDur_MAX = Item.GetData(targetItemIndex,CONST.����_����;�);
                      Item.SetData(targetItemIndex,CONST.����_�;�, targetDur_MIN + keyNum);
                      Item.SetData(targetItemIndex,CONST.����_����;�, targetDur_MAX + keyNum);
                      Char.SetData(player,CONST.CHAR_�˺���, killNum - keyNum);
                      Item.UpItem(player, targetSlot);
                      NLG.UpChar(player);
                      NLG.SystemMessage(player, "[" .. "����Ī" .. "] �����D�Q���B�ɹ��؏��;�" .. keyNum .. "��");
                  end
              end
          end
      end
    else
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          targetSlot = data-1;  --װ������� (ѡ����1)
          targetItemIndex = Char.GetItemIndex(player, targetSlot);
          if (targetItemIndex>0) then
              local killNum = Char.GetData(player,CONST.CHAR_�˺���);
              local tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
              local tItemName = Item.GetData(targetItemIndex, CONST.����_����);
              local tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
              if (tStrLv~=9) then
                  NLG.SystemMessage(player, "[" .. "����Ī" .. "] ���x����b��[" .. tItemName .. "]��[���ɱ��B]��");
                  return;
              end
              local winMsg = "�������D�Q���B��\\n"
                                           .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                           .."�����O���;�...\\n"
                                           .."\\n���������b���䡡�����Q��".. tItemName .."\\n"
                                           .."\\n����������ǰ���еĻ�����".. killNum .."\\n"
                                           .."\\nՈݔ��؏͵��;�����\\n";
              NLG.ShowWindowTalked(player, self.maintainNPC, CONST.����_�����, CONST.BUTTON_ȷ���ر�, 11, winMsg);
          end

      else
                 return;
      end
    end
  end)


end


function EquipPlusStat( _ItemIndex, _StatTab, _StatValue )
	--  E-���裬P- ����
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = tostring(Item.GetData(_ItemIndex, CONST.����_���ò���));
		if string.find(tItemStat, ",")==nil then
			return nil;
		end
		if string.find(tItemStat, "|")==nil then
			local tSub = string.split(tItemStat, ",");
			tStatTab[tSub[1]]=tonumber(tSub[2]);
			return tStatTab;
		end
		local tStat = string.split(tItemStat, "|")
		for k,v in pairs(tStat) do
			local tSub = string.split(v, ",");
			tStatTab[tSub[1]]=tonumber(tSub[2]);
		end
		return tStatTab;
	elseif type(_StatTab)=="table" then
		--SetAll
		local tStat = "";
		for k,v in pairs(_StatTab) do
			tStat = tStat .. k .. "," .. v .. "|";
		end
		Item.SetData(_ItemIndex, CONST.����_���ò���, tStat);
	elseif type(_StatTab)=="string" and type(_StatValue)=="nil" then
		--GetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {};
		for k,v in pairs(tStatTab) do
			if _StatTab==k then
				return tonumber(v);
			end
		end
		return nil;
	elseif type(_StatTab)=="string" then
		--SetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {};
		tStatTab[_StatTab]=_StatValue;
		EquipPlusStat(_ItemIndex, tStatTab);
	end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
