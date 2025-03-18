local Module = ModuleBase:createModule('equipSlot')

local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}

--local ExpRate = 3;
local StrRequireExp = {1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 11000,}	--����

local slotCards={}	--��|��|��|��|��|Ѫ|ħ
slotCards[73801] = "4203233";		--�������~
slotCards[73802] = "4240233";
slotCards[73803] = "0203233";
slotCards[73804] = "4003033";
slotCards[73805] = "4243033";
slotCards[73806] = "2504553";		--�������~
slotCards[73807] = "2520553";
slotCards[73808] = "0504553";
slotCards[73809] = "2504053";
slotCards[73810] = "2524053";
slotCards[73811] = "5302232";		--�׻����~
slotCards[73812] = "5330232";
slotCards[73813] = "0302232";
slotCards[73814] = "5302032";
slotCards[73815] = "5332032";
slotCards[73816] = "3204425";		--��ȸ���~
slotCards[73817] = "3250425";
slotCards[73818] = "0204425";
slotCards[73819] = "3204025";
slotCards[73820] = "3254025";
slotCards[73891] = "1111111";		--�l������
slotCards[73892] = "1111111";
slotCards[73893] = "1111111";
slotCards[73894] = "1111111";
slotCards[73895] = "1111111";
slotCards[73896] = "1111111";
slotCards[73897] = "1111111";
slotCards[73898] = "1111111";
---------------------------------------------------------------------
--Զ�̰�ťUI����
function Module:equipSlotInfo(npc, player)
          local winMsg = "2\\n��������������������ɫ�}�F���b��\\n"
                                     .."��������������������������|��|��|��|��|Ѫ|ħ\\n"
          for targetSlot = 0,7 do
                local targetIndex = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q");
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if (targetIndex==nil) then
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", 0);
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "V", 0);
                end
                local cardIndex = EquipSlotStat(player, ItemPosName[targetSlot+1], "C");
                if (cardIndex==nil) then
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "C", "0000000");
                end

                local tStrLv = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q");
                if #tostring(tStrLv) <= 1 then spaceLvMsg = " "; else spaceLvMsg = ""; end

                local tStrExp = EquipSlotStat(player, ItemPosName[targetSlot+1], "V");
                local tStrExp = tStrExp/100;
                if #tostring(tStrExp) <= 5 then spaceExplen = 5 - #tostring(tStrExp); spaceExpMsg = "";
                    for i = 1, math.modf(spaceExplen) do spaceExpMsg = spaceExpMsg .." "; end
                else spaceExpMsg = ""; end

                local tCard = EquipSlotStat(player, ItemPosName[targetSlot+1], "C");
                local Rate_buffer_Info = {}
                Rate_buffer_Info[1] = tonumber(string.sub(tCard, 1, 1));	--�������ʵȼ�
                Rate_buffer_Info[2] = tonumber(string.sub(tCard, 2, 2));	--�������ʵȼ�
                Rate_buffer_Info[3] = tonumber(string.sub(tCard, 3, 3));	--���ݱ��ʵȼ�
                Rate_buffer_Info[4] = tonumber(string.sub(tCard, 4, 4));	--�����ʵȼ�
                Rate_buffer_Info[5] = tonumber(string.sub(tCard, 5, 5));	--�ظ����ʵȼ�
                Rate_buffer_Info[6] = tonumber(string.sub(tCard, 6, 6));	--HP���ʵȼ�
                Rate_buffer_Info[7] = tonumber(string.sub(tCard, 7, 7));	--MP���ʵȼ�

                winMsg = winMsg .. ItemPosName[targetSlot+1] .. "[Lv".. spaceLvMsg..tStrLv .."]:����".. spaceExpMsg..tStrExp .."%  "
                                                   .. Rate_buffer_Info[1].."| " .. Rate_buffer_Info[2].."| " .. Rate_buffer_Info[3].."| " .. Rate_buffer_Info[4].."| " .. Rate_buffer_Info[5].."| " .. Rate_buffer_Info[6].."| " .. Rate_buffer_Info[7].."\n"
          end
          NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, winMsg);
end

-------------------------------------------------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))
  --self:regCallback('ItemExpansionEvent', Func.bind(self.itemExpansionCallback, self))

  self.equipSloterNPC = self:NPC_createNormal('�b���۹���', 14682, { x =36 , y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.equipSloterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local winMsg = "1\\n��������������������ɫ�}�F���b��\\n"
          for targetSlot = 0,4 do
                local targetIndex = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q");
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if (targetIndex==nil) then
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", 0);
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "V", 0);
                end
                local tStrLv = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q");
                local tStrExp = EquipSlotStat(player, ItemPosName[targetSlot+1], "V");
                local tStrExp = tStrExp/100;
                local msg = "���b�ȼ�: ".. tStrLv .. "  Ŀǰ����: ".. tStrExp .."%";
                winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. msg .. "\n"
          end
          NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.equipSloterNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
      if (seqno == 11 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno == 11 and select == CONST.BUTTON_ȷ�� and data >= 1) then
          local keyNum = data*1;
          local tStrExp = tonumber(EquipSlotStat(player, ItemPosName[targetSlot+1], "V"));
          local tStrLv = tonumber(EquipSlotStat(player, ItemPosName[targetSlot+1], "Q"));
          if (tStrLv>=10) then
              NLG.SystemMessage(player, "[ϵ�y]�쾚�����_100%������");
              return;
          end
          if (tStrExp+keyNum>10000) then
              NLG.SystemMessage(player, "[ϵ�y]����֮���^�d��");
              return;
          end
          if (targetSlot>=0) then
              local killNum = Char.ItemNum(player, 631092);
              if (keyNum ~=nil and math.ceil(keyNum)==keyNum) then
                  if (keyNum>killNum) then
                      NLG.SystemMessage(player, "[ϵ�y]������Ƭ���㣡");
                      return;
                  else
                      EquipSlotStat(player, ItemPosName[targetSlot+1], "V", tStrExp+keyNum);
                      Char.DelItem(player, 631092, keyNum);
                      local tStrExp = tonumber(EquipSlotStat(player, ItemPosName[targetSlot+1], "V"));
                      if tStrExp>=10000 then EquipSlotStat(player, ItemPosName[targetSlot+1], "V", 10000); end
                      if (tStrLv<10) then
                          if (tStrExp>=StrRequireExp[1] and tStrExp<StrRequireExp[2]) then
                              EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", 1);
                          end
                          for k,v in ipairs(StrRequireExp) do
                              if (k<10 and tStrExp>=StrRequireExp[k+1] and tStrExp<StrRequireExp[k+2]) then
                                  EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", k+1);
                              elseif (k>=10) then
                              end
                          end
                      else
                      end
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
              local killNum = Char.ItemNum(player, 631092);
              local winMsg = "����������������$1���}�F���b���Q��\\n"
                                           .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                           .."���ڴ_�J���b�YӍ...\\n"
                                           .."\\n���������䡡�b������λ��$2".. ItemPosName[targetSlot+1] .."\\n"
                                           .."\\n����������ǰ�ɳ��������$4".. killNum .."\\n"
                                           .."\\nՈ�_�Jݔ��֮������Ƭ��\\n";
              NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.����_�����, CONST.BUTTON_ȷ���ر�, 11, winMsg);
      else
                 return;
      end
    end
  end)


  --ʯ�����
  self:regCallback('ItemString', Func.bind(self.indicativeSlate, self),"LUA_useSlate");
  self.setupSlateNPC = self:NPC_createNormal('ָʾʯ��', 14682, { x =35 , y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.setupSlateNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c�����b�����" ..	"\\n\\n\\n�_��ʹ�����Ƕ����}�F���b��λ��";	
        NLG.ShowWindowTalked(player, self.setupSlateNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.setupSlateNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local SlateIndex =SlateIndex;
    local SlateSlot = SlateSlot;
    local SlateName = Item.GetData(SlateIndex, CONST.����_����);
    local PosSlot = Item.GetData(SlateIndex,CONST.����_�Ӳ�һ);

    --ʯ�����
    if select > 0 then
      if seqno == 1 and Char.ItemSlot(player)>=19 and select == CONST.��ť_�� then
                 NLG.SystemMessage(player,"[ϵ�y]��Ʒ���ѝM��");
                 return;
      elseif seqno == 1 and select == CONST.��ť_�� then
                 return;
      elseif seqno == 1 and select == CONST.��ť_�� then
          --����nil���
          local targetIndex = EquipSlotStat(player, ItemPosName[PosSlot+1], "Q");
          local targetItemIndex = Char.GetItemIndex(player, PosSlot);
          if (targetIndex==nil) then
              EquipSlotStat(player, ItemPosName[PosSlot+1], "Q", 0);
              EquipSlotStat(player, ItemPosName[PosSlot+1], "V", 0);
          end
          local cardIndex = EquipSlotStat(player, ItemPosName[PosSlot+1], "C");
          if (cardIndex==nil) then
              EquipSlotStat(player, ItemPosName[PosSlot+1], "C", "0000000");
          end
          --ʯ�嶯��
          local slate_Info = slotCards[Item.GetData(SlateIndex, CONST.����_ID)]
          if (slate_Info ~=nil and PosSlot>=0) then
              local cardIndex = EquipSlotStat(player, ItemPosName[PosSlot+1], "C");
              if (cardIndex == "0000000") then
                  Char.DelItemBySlot(player, SlateSlot);
                  EquipSlotStat(player, ItemPosName[PosSlot+1], "C", slate_Info);
                  NLG.SystemMessage(player, "[ϵͳ]"..SlateName.." �ɹ�Ƕ�밲�b��")
              else
                  Char.DelItemBySlot(player, SlateSlot);
                  EquipSlotStat(player, ItemPosName[PosSlot+1], "C", slate_Info);
                  NLG.SystemMessage(player, "[ϵͳ]"..SlateName.." �ɹ�Ƕ�밲�b��")
                  --[[for k,v in pairs(slotCards) do
                      if (cardIndex==v) then
                          Char.GiveItem(player, k, 1);
                      end
                  end]]
              end
          else
              NLG.SystemMessage(player,"[ϵ�y]δ�O��ָʾ�������");
              return;
          end
      else
                 return;
      end
    else
      if seqno == 2 and Char.ItemSlot(player)>=19 and data >= 1 then
                 NLG.SystemMessage(player,"[ϵ�y]��Ʒ���ѝM��");
                 return;
      elseif seqno == 2 and select == CONST.��ť_�ر� then
                 return;
      elseif seqno == 2 and data >= 1 then
              local PosSlot=data-1;
              --����nil���
              local targetIndex = EquipSlotStat(player, ItemPosName[PosSlot+1], "Q");
              local targetItemIndex = Char.GetItemIndex(player, PosSlot);
              if (targetIndex==nil) then
                  EquipSlotStat(player, ItemPosName[PosSlot+1], "Q", 0);
                  EquipSlotStat(player, ItemPosName[PosSlot+1], "V", 0);
              end
              local cardIndex = EquipSlotStat(player, ItemPosName[PosSlot+1], "C");
              if (cardIndex==nil) then
                  EquipSlotStat(player, ItemPosName[PosSlot+1], "C", "0000000");
              end
              --ʯ�嶯��
              if (cardIndex ~= "0000000") then
                  Char.DelItemBySlot(player, SlateSlot);
                  EquipSlotStat(player, ItemPosName[PosSlot+1], "C", "0000000");
                  NLG.SystemMessage(player, "[ϵͳ]"..SlateName.." �ɹ�Ƕ�밲�b��")
                  --[[for k,v in pairs(slotCards) do
                      if (cardIndex==v) then
                          Char.GiveItem(player, k, 1);
                      end
                  end]]
              else
                  NLG.SystemMessage(player,"[ϵ�y]�����ÿհ����b��");
                  return;
              end
      end
    end
  end)


end


--װ���ӿ�
function Module:itemAttachCallback(charIndex, fromItemIndex)
      local targetSlot = Char.GetTargetItemSlot(charIndex,fromItemIndex)
      print("Attach:"..targetSlot);
      local targetIndex = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q");
      if (targetIndex==nil) then
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q", 0);
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "V", 0);
      end
      local cardIndex = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "C");
      if (cardIndex==nil) then
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "C", "0000000");
      end

      local tStrLv = tonumber(EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q"));
      local tCard = tostring(EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "C"));
      setItemStrData(fromItemIndex, tStrLv, tCard);
      Item.UpItem(charIndex, targetSlot);
      NLG.UpChar(charIndex);
      Char.SaveToDb(charIndex);
  return 0;
end
--ж�½ӿ�
function Module:itemDetachCallback(charIndex, fromItemIndex)
      local targetSlot = Char.GetTargetItemSlot(charIndex,fromItemIndex)
      print("Detach:"..targetSlot);
      local targetIndex = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q");
      if (targetIndex==nil) then
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q", 0);
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "V", 0);
      end
      local cardIndex = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "C");
      if (cardIndex==nil) then
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "C", "0000000");
      end

      setItemRevertData(fromItemIndex);
      Item.UpItem(charIndex, targetSlot);
      NLG.UpChar(charIndex);
      Char.SaveToDb(charIndex);
  return 0;
end

--����˵����Ͻӿ�
function Module:itemExpansionCallback(itemIndex, type, msg, charIndex, slot)
  --self:logDebug('itemExpansionCallback', itemIndex, type, msg, charIndex, slot)
  if (msg=="���b�ȼ���" and type==1) then
      local PosSlot = Item.GetData(itemIndex, CONST.����_�Ӳ�һ);
      local string_1 = Data.GetMessage(7300800);
      local string_PosName = Data.GetMessage(7300801+PosSlot);
      local string = "$2�����֮���bλ " ..string_PosName.. "\n"

      local Rate_buffer_Item = {}
      local card_Rate = slotCards[Item.GetData(itemIndex, CONST.����_ID)]
      Rate_buffer_Item[1] = tonumber(string.sub(card_Rate, 1, 1));	--�������ʵȼ�
      Rate_buffer_Item[2] = tonumber(string.sub(card_Rate, 2, 2));	--�������ʵȼ�
      Rate_buffer_Item[3] = tonumber(string.sub(card_Rate, 3, 3));	--���ݱ��ʵȼ�
      Rate_buffer_Item[4] = tonumber(string.sub(card_Rate, 4, 4));	--�����ʵȼ�
      Rate_buffer_Item[5] = tonumber(string.sub(card_Rate, 5, 5));	--�ظ����ʵȼ�
      Rate_buffer_Item[6] = tonumber(string.sub(card_Rate, 6, 6));	--HP���ʵȼ�
      Rate_buffer_Item[7] = tonumber(string.sub(card_Rate, 7, 7));	--MP���ʵȼ�
      local RatePct_check_b = { 0, 10, 12, 13, 14, 15, 16, 17, 18, 20 }
      local RatePct_check_h = { 0, 1.0, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 2.0 }

      local string_p = Data.GetMessage(7300810);
      for k,v in pairs(Rate_buffer_Item) do
          if (k>=1 and k<=5) then
              if (Rate_buffer_Item[k]>=1) then
                  local string_k = Data.GetMessage(7300810+k);
                  string = string .. string_p .. string_k .. string_1 .. RatePct_check_b[v+1] .. "%\n"
              end
          elseif (k>=6 and k<=7) then
              if (Rate_buffer_Item[k]>=1) then
                  local string_k = Data.GetMessage(7300810+k);
                  string = string .. string_p .. string_k .. string_1 .. RatePct_check_h[v+1] .. "%\n"
              end
          end
      end
      return string
  end
end

--ָʾʯ��
function Module:indicativeSlate(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    SlateSlot =itemSlot;
    SlateIndex = Char.GetItemIndex(charIndex,itemSlot);
    local SlateName = Item.GetData(SlateIndex,CONST.����_����);
    local PosSlot = Item.GetData(SlateIndex,CONST.����_�Ӳ�һ);
    if (PosSlot~=10) then
        local PosName = ItemPosName[PosSlot+1]
        local msg = "@c�����b�����\\n"
                            .. "$2�����λ��������������w\\n\\n"
        local msg = msg .. "$5�����Ƕ��[ " ..PosName.. " ]��λ\\n"

        local Rate_buffer_Item = {}
        local card_Rate = slotCards[Item.GetData(SlateIndex, CONST.����_ID)]
        Rate_buffer_Item[1] = tonumber(string.sub(card_Rate, 1, 1));	--�������ʵȼ�
        Rate_buffer_Item[2] = tonumber(string.sub(card_Rate, 2, 2));	--�������ʵȼ�
        Rate_buffer_Item[3] = tonumber(string.sub(card_Rate, 3, 3));	--���ݱ��ʵȼ�
        Rate_buffer_Item[4] = tonumber(string.sub(card_Rate, 4, 4));	--�����ʵȼ�
        Rate_buffer_Item[5] = tonumber(string.sub(card_Rate, 5, 5));	--�ظ����ʵȼ�
        Rate_buffer_Item[6] = tonumber(string.sub(card_Rate, 6, 6));	--HP���ʵȼ�
        Rate_buffer_Item[7] = tonumber(string.sub(card_Rate, 7, 7));	--MP���ʵȼ�
        local RatePct_check_b = { 0, 10, 12, 13, 14, 15, 16, 17, 18, 20 }
        local RatePct_check_h = { 0, 1.0, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 2.0 }

        local string_1 = Data.GetMessage(7300800);
        local string_p = Data.GetMessage(7300810);
        for k,v in pairs(Rate_buffer_Item) do
            if (k>=1 and k<=5) then
                if (Rate_buffer_Item[k]>=1) then
                    local string_k = Data.GetMessage(7300800+k);
                    msg = msg .. string_p .. string_k .. string_1 .. RatePct_check_b[v+1] .. "%\\n"
                end
            elseif (k>=6 and k<=7) then
                if (Rate_buffer_Item[k]>=1) then
                    local string_k = Data.GetMessage(7300800+k);
                    msg = msg .. string_p .. string_k .. string_1 .. RatePct_check_h[v+1] .. "%\\n"
                end
            end
        end
        local msg = msg .. "\\n�_��ʹ��$4" ..SlateName.. "$0Ƕ���ɫ�����b��λ��";	
        NLG.ShowWindowTalked(charIndex, self.setupSlateNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    elseif (PosSlot==10) then
          local msg = "2\\n�������������������հ����b�����\\n"
                               .."������������|���R|����|����|�֏�|����|ħ��\\n"
          for targetSlot = 0,7 do
                local tCard = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "C");
                local Rate_buffer_Info = {}
                Rate_buffer_Info[1] = tonumber(string.sub(tCard, 1, 1));	--�������ʵȼ�
                Rate_buffer_Info[2] = tonumber(string.sub(tCard, 2, 2));	--�������ʵȼ�
                Rate_buffer_Info[3] = tonumber(string.sub(tCard, 3, 3));	--���ݱ��ʵȼ�
                Rate_buffer_Info[4] = tonumber(string.sub(tCard, 4, 4));	--�����ʵȼ�
                Rate_buffer_Info[5] = tonumber(string.sub(tCard, 5, 5));	--�ظ����ʵȼ�
                Rate_buffer_Info[6] = tonumber(string.sub(tCard, 6, 6));	--HP���ʵȼ�
                Rate_buffer_Info[7] = tonumber(string.sub(tCard, 7, 7));	--MP���ʵȼ�

                msg = msg .. ItemPosName[targetSlot+1] .. "��"
                                      .. "��" .. Rate_buffer_Info[1].." |  " .. Rate_buffer_Info[2].." |  "
                                      .. Rate_buffer_Info[3].." |  " .. Rate_buffer_Info[4].." |  "
                                      .. Rate_buffer_Info[5].." |  " .. Rate_buffer_Info[6].." |  "
                                      .. Rate_buffer_Info[7].."\n"
          end
        NLG.ShowWindowTalked(charIndex, self.setupSlateNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 2, msg);
    end
    return 1;
end
------------------------------------------------------------------------------------------
--���ܺ���
function EquipSlotStat( _Index, _StatSlot, _StatTab, _StatValue )
	--  E-���裬P- ���ᣬH- �ԣ�G- ��Q- ��ۣ�V- ���أ�C- ��Ƭ
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = tostring(Char.GetExtData(_Index, _StatSlot));
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
			tStatTab[tSub[1]]=tSub[2];
		end
		return tStatTab;
	elseif type(_StatTab)=="table" then
		--SetAll
		local tStat = "";
		for k,v in pairs(_StatTab) do
			tStat = tStat .. k .. "," .. v .. "|";
		end
		Char.SetExtData(_Index, _StatSlot, tStat);
		NLG.UpChar(_Index);
	elseif type(_StatTab)=="string" and type(_StatValue)=="nil" then
		--GetSub
		local tStatTab = EquipSlotStat(_Index, _StatSlot) or {};
		for k,v in pairs(tStatTab) do
			if _StatTab==k then
				return v;
			end
		end
		return nil;
	elseif type(_StatTab)=="string" then
		--SetSub
		local tStatTab = EquipSlotStat(_Index, _StatSlot) or {};
		tStatTab[_StatTab]=_StatValue;
		EquipSlotStat(_Index, _StatSlot, tStatTab);
	end
end

--װ��ʱ��������
function setItemStrData( _ItemIndex, _StrLv, _Card)

	--SQL.Run("ALTER TABLE tbl_item MODIFY COLUMN Argument char(45) Default 0");
	local Rate_buffer = {}
	Rate_buffer[1] = tonumber(string.sub(_Card, 1, 1));	--�������ʵȼ�
	Rate_buffer[2] = tonumber(string.sub(_Card, 2, 2));	--�������ʵȼ�
	Rate_buffer[3] = tonumber(string.sub(_Card, 3, 3));	--���ݱ��ʵȼ�
	Rate_buffer[4] = tonumber(string.sub(_Card, 4, 4));	--�����ʵȼ�
	Rate_buffer[5] = tonumber(string.sub(_Card, 5, 5));	--�ظ����ʵȼ�
	Rate_buffer[6] = tonumber(string.sub(_Card, 6, 6));	--HP���ʵȼ�
	Rate_buffer[7] = tonumber(string.sub(_Card, 7, 7));	--MP���ʵȼ�
	local Rate_check_b = { 0, 1.0, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 2.0 }
	local Rate_check_h = { 0, 0.10, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20 }

	--local bRate = 1 + (_StrLv/10 * 2);
	--local hRate = 1 + (_StrLv/10 * 2 * 0.1);
	local strData = {18, 19, 20, 21, 22, 27, 28}	--%����_����%,%����_����%,%����_����%,%����_����%,%����_�ظ�%,%����_HP%,%����_MP%
	local Plus_buffer = {}

	for k,v in pairs(strData) do
 		if Item.GetData(_ItemIndex, v)>0 then
			if (k>=1 and k<=5) then
				if (Rate_buffer[k]>=1) then
					local CardLv = Rate_buffer[k];
					local bRate = 1 + (_StrLv/10 * Rate_check_b[CardLv+1]);
					Plus= math.floor(Item.GetData(_ItemIndex, v)*bRate) - Item.GetData(_ItemIndex, v);
					Item.SetData(_ItemIndex, v, math.floor(Item.GetData(_ItemIndex, v)*bRate));
				else
					Plus = 0;
				end
			elseif (k>=6 and k<=7) then
				if (Rate_buffer[k]>=1) then
					local CardLv = Rate_buffer[k];
					local hRate = 1 + (_StrLv/10 * Rate_check_h[CardLv+1]);
					Plus= math.floor(Item.GetData(_ItemIndex, v)*hRate) - Item.GetData(_ItemIndex, v);
					Item.SetData(_ItemIndex, v, math.floor(Item.GetData(_ItemIndex, v)*hRate));
				else
					Plus = 0;
				end
			end
			Plus_buffer[k] = Plus;
		else
			Plus_buffer[k] = 0;
		end
	end

	--local tStat = Item.GetData(_ItemIndex, CONST.����_���ò���) or "";
	local tStat = Plus_buffer[1].."|" ..Plus_buffer[2].."|" ..Plus_buffer[3].."|" ..Plus_buffer[4].."|" ..Plus_buffer[5].."|" ..Plus_buffer[6].."|" ..Plus_buffer[7];
	Item.SetData(_ItemIndex, CONST.����_���ò���, tStat);
end

--ж��ʱ��ԭ����
function setItemRevertData( _ItemIndex)
	local Plus_buffer = {}
	local tItemStat = tostring(Item.GetData(_ItemIndex, CONST.����_���ò���));
	if (string.find(tItemStat, "|")==nil) then
		return;
	else
		local strData = {18, 19, 20, 21, 22, 27, 28}	--%����_����%,%����_����%,%����_����%,%����_����%,%����_�ظ�%,%����_HP%,%����_MP%
		local Plus_buffer = string.split(tItemStat, "|");

		for k,v in pairs(strData) do
			Item.SetData(_ItemIndex, strData[k], Item.GetData(_ItemIndex, strData[k]) - tonumber(Plus_buffer[k]));
		end
		Item.SetData(_ItemIndex, CONST.����_���ò���, "");
	end
end

------------------------------------------------------------------------------------------
--�Զ���ӿ�
Char.GetTargetItemSlot = function(charIndex,fromItemIndex)
  local type = Item.GetData(fromItemIndex, CONST.����_����);
  if (type==8 or type==9) then
      return 0;
  elseif (type==10 or type==11 or type==12) then
      return 1;
  elseif (type==13 or type==14) then
      return 4;
  elseif (type==0 or type==1 or type==2 or type==3 or type==4 or type==5 or type==6 or type==7) then
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
      if (ItemIndex < 0) then
          return 2;
      elseif (ItemIndex >= 0) then
          local Vicetype = Item.GetData(ItemIndex, CONST.����_����);
          if (Vicetype==65 or Vicetype==66 or Vicetype==67 or Vicetype==68 or Vicetype==69 or Vicetype==70) then
              return 3;
          else
              return 2;
          end
      end
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
      if (ItemIndex < 0) then
          return 3;
      elseif (ItemIndex >= 0) then
          local Vicetype = Item.GetData(ItemIndex, CONST.����_����);
          if (Vicetype==65 or Vicetype==66 or Vicetype==67 or Vicetype==68 or Vicetype==69 or Vicetype==70) then
              return 2;
          else
              return 3;
          end
      end
  elseif (type==15 or type==16 or type==17 or type==18 or type==19 or type==20 or type==21 or type==55) then
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����1);
      if (ItemIndex < 0) then
          return 5;
      elseif (ItemIndex >= 0) then
          local Sittingtype = Item.GetData(ItemIndex, CONST.����_����);
          if (Sittingtype==62) then
              return 6;
          else
              return 5;
          end
      end
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����2);
      if (ItemIndex < 0) then
          return 6;
      elseif (ItemIndex >= 0) then
          local Sittingtype = Item.GetData(ItemIndex, CONST.����_����);
          if (Sittingtype==62) then
              return 5;
          else
              return 6;
          end
      end
  elseif (type==22) then
      return 7;
  elseif (type==65 or type==66 or type==67 or type==68 or type==69 or type==70) then
      return 3;
  elseif (type==62) then
      return 6;
  end
  return -1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
