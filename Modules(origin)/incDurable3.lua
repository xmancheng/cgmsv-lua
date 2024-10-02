---ģ����
local Module = ModuleBase:createModule('incDurable3')

local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.maintain3NPC = self:NPC_createNormal('�����_Ɲ', 14510, { x =234 , y = 83, mapType = 0, map = 1000, direction = 0 });
  Char.SetData(self.maintain3NPC,502,0);
  self:NPC_regTalkedEvent(self.maintain3NPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local winMsg = "1\\nՈ�x��Ҫħ�����������������: \\n"
          for targetSlot = 0,4 do
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if targetItemIndex>=0 then
                        local tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
                        local tItemName = Item.GetData(targetItemIndex, CONST.����_����);
                        local targetDur_MIN = Item.GetData(targetItemIndex,CONST.����_�;�);
                        local targetDur_MAX = Item.GetData(targetItemIndex,CONST.����_����;�);
                        local msg = tItemName .. " "..targetDur_MIN.."/"..targetDur_MAX;
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. msg .. "\n"
                else
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. "\n"
                end
          end
          NLG.ShowWindowTalked(player, self.maintain3NPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.maintain3NPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local tPlayerGold = Char.GetData(player, CONST.����_���);
    if select > 0 then
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      end
    else
      if (seqno == 1 and data >= 1) then
          local targetSlot = data-1;  --װ������� (ѡ����1)
          local targetItemIndex = Char.GetItemIndex(player, targetSlot);
          if (targetItemIndex>0) then
              local tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
              local tItemName = Item.GetData(targetItemIndex, CONST.����_����);
              local tNeedGold = Item.GetData(targetItemIndex, CONST.����_�ȼ�)*1000;
              local durPlus = NLG.Rand(1, 100);
              if (durPlus ~=nil) then
                  if (tPlayerGold<tNeedGold) then
                      NLG.SystemMessage(player, "[ϵ�y] ������Ҫ" .. tNeedGold .. "G��������Ų��㡣");
                      return;
                  else
                      local targetDur_MIN = Item.GetData(targetItemIndex,CONST.����_�;�);
                      local targetDur_MAX = Item.GetData(targetItemIndex,CONST.����_����;�);
                      if (targetDur_MIN>=targetDur_MAX) then
                          NLG.SystemMessage(player, "[ϵ�y] �b�䲻��Ҫ�M������");
                          return;
                      end
                      Char.SetData(player, CONST.����_���, tPlayerGold-tNeedGold);
                      if (durPlus<=80) then
                          Item.SetData(targetItemIndex,CONST.����_�;�, targetDur_MAX);
                          Item.UpItem(player, targetSlot);
                          NLG.UpChar(player);
                          NLG.SystemMessage(player, "[ϵ�y] ħ������ɹ����؏��;õ��M��");
                      elseif (durPlus>80 and durPlus<=90) then
                          Item.SetData(targetItemIndex,CONST.����_�;�, math.ceil(targetDur_MIN * 0.9) );
                          Item.UpItem(player, targetSlot);
                          NLG.UpChar(player);
                          NLG.SystemMessage(player, "[ϵ�y] ħ������ʧ�����b���;��»���");
                      elseif (durPlus>90 and durPlus<=100) then
                          Item.SetData(targetItemIndex,CONST.����_����;�, math.ceil(targetDur_MAX * 0.8) );
                          local targetDur_MAX_2 = Item.GetData(targetItemIndex,CONST.����_����;�);
                          if (targetDur_MIN>=targetDur_MAX_2) then
                              Item.SetData(targetItemIndex,CONST.����_�;�, targetDur_MAX_2);
                          end
                          Item.UpItem(player, targetSlot);
                          NLG.UpChar(player);
                          NLG.SystemMessage(player, "[ϵ�y] ħ�������ʧ�����b������;ý��ͣ�");
                      end
                  end
              end
          end
      end

    end
  end)


end


--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
