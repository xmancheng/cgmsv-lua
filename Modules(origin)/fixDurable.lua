---ģ����
local Module = ModuleBase:createModule('fixDurable')

local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.maintainfixNPC = self:NPC_createNormal('�����_Ɲ', 14510, { x =217 , y = 83, mapType = 0, map = 1000, direction = 0 });
  Char.SetData(self.maintainfixNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regTalkedEvent(self.maintainfixNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local winMsg = "1\\nՈ�x��Ҫ����������b��(1�;�100G): \\n"
          for targetSlot = 0,7 do
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
          NLG.ShowWindowTalked(player, self.maintainfixNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.maintainfixNPC, function(npc, player, _seqno, _select, _data)
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
              --local tNeedGold = Item.GetData(targetItemIndex, CONST.����_�ȼ�)*1000;
              local durPlus = NLG.Rand(1, 80);
              if (durPlus ~=nil) then
                  local targetDur_MIN = Item.GetData(targetItemIndex,CONST.����_�;�);
                  local targetDur_MAX = Item.GetData(targetItemIndex,CONST.����_����;�);
                  if (targetDur_MIN>=targetDur_MAX) then
                      NLG.SystemMessage(player, "[ϵ�y] �b�䲻��Ҫ�M������");
                      return;
                  end
                  local tNeedGold = (targetDur_MAX-targetDur_MIN)*100;
                  if (tPlayerGold<tNeedGold) then
                      NLG.SystemMessage(player, "[ϵ�y] ������Ҫ" .. tNeedGold .. "G��������Ų��㡣");
                      return;
                  else
                      Char.SetData(player, CONST.����_���, tPlayerGold-tNeedGold);
                      if (durPlus<=80) then
                          Item.SetData(targetItemIndex,CONST.����_�;�, targetDur_MAX);
                          Item.UpItem(player, targetSlot);
                          NLG.UpChar(player);
                          NLG.SystemMessage(player, "[ϵ�y] ��������ɹ����؏��;õ��M��");
                      elseif (durPlus>80 and durPlus<=90) then
                          Item.SetData(targetItemIndex,CONST.����_�;�, math.ceil(targetDur_MIN * 0.9) );
                          Item.UpItem(player, targetSlot);
                          NLG.UpChar(player);
                          NLG.SystemMessage(player, "[ϵ�y] ��������ʧ�����b���;��»���");
                      elseif (durPlus>90 and durPlus<=100) then
                          Item.SetData(targetItemIndex,CONST.����_����;�, math.ceil(targetDur_MAX * 0.8) );
                          local targetDur_MAX_2 = Item.GetData(targetItemIndex,CONST.����_����;�);
                          if (targetDur_MIN>=targetDur_MAX_2) then
                              Item.SetData(targetItemIndex,CONST.����_�;�, targetDur_MAX_2);
                          end
                          Item.UpItem(player, targetSlot);
                          NLG.UpChar(player);
                          NLG.SystemMessage(player, "[ϵ�y] ���������ʧ�����b������;ý��ͣ�");
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
