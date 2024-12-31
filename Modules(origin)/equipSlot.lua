local Module = ModuleBase:createModule('equipSlot')

local ItemPosName = {"頭 部", "身 体", "右 手", "左 手", "足 部", "飾品1", "飾品2", "水 晶"}

--local ExpRate = 3;
local StrRequireExp = {1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 11000,}	--经验

local slotCards={}	--攻|防|敏|精|回|血|魔
slotCards[73801] = "2100200";
slotCards[73802] = "2120000";
slotCards[73803] = "0122000";
slotCards[73804] = "2210000";
slotCards[73805] = "2222000";
slotCards[73806] = "3003033";
slotCards[73807] = "3030033";
slotCards[73808] = "0330033";
slotCards[73809] = "3003033";
slotCards[73810] = "0333300";
slotCards[73891] = "1111110";
slotCards[73892] = "1111101";
slotCards[73893] = "1111011";
slotCards[73894] = "1001111";
slotCards[73895] = "0110111";
slotCards[73896] = "0111111";
slotCards[73897] = "1011111";
slotCards[73898] = "1101111";
---------------------------------------------------------------------
--远程按钮UI呼叫
function Module:equipSlotInfo(npc, player)
          local winMsg = "2\\n　　　　　　　　【角色裝備插槽】\\n"
                                     .."　　　　　　　　　　　　攻|防|敏|精|恢|血|魔\\n"
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
                Rate_buffer_Info[1] = tonumber(string.sub(tCard, 1, 1));	--攻击倍率等级
                Rate_buffer_Info[2] = tonumber(string.sub(tCard, 2, 2));	--防御倍率等级
                Rate_buffer_Info[3] = tonumber(string.sub(tCard, 3, 3));	--敏捷倍率等级
                Rate_buffer_Info[4] = tonumber(string.sub(tCard, 4, 4));	--精神倍率等级
                Rate_buffer_Info[5] = tonumber(string.sub(tCard, 5, 5));	--回复倍率等级
                Rate_buffer_Info[6] = tonumber(string.sub(tCard, 6, 6));	--HP倍率等级
                Rate_buffer_Info[7] = tonumber(string.sub(tCard, 7, 7));	--MP倍率等级

                winMsg = winMsg .. ItemPosName[targetSlot+1] .. "[Lv".. spaceLvMsg..tStrLv .."]:伏特".. spaceExpMsg..tStrExp .."%  "
                                                   .. Rate_buffer_Info[1].."| " .. Rate_buffer_Info[2].."| " .. Rate_buffer_Info[3].."| " .. Rate_buffer_Info[4].."| " .. Rate_buffer_Info[5].."| " .. Rate_buffer_Info[6].."| " .. Rate_buffer_Info[7].."\n"
          end
          NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
end

-------------------------------------------------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))
  --self:regCallback('ItemExpansionEvent', Func.bind(self.itemExpansionCallback, self))

  self.equipSloterNPC = self:NPC_createNormal('裝備插槽管理', 14682, { x =36 , y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.equipSloterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local winMsg = "1\\n　　　　　　　　【角色裝備插槽】\\n"
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
                local msg = "插槽等級: ".. tStrLv .. "  目前熟練度: ".. tStrExp .."%";
                winMsg = winMsg .. ItemPosName[targetSlot+1] .. "：" .. msg .. "\n"
          end
          NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.equipSloterNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
      if (seqno == 11 and select == CONST.按钮_关闭) then
                 return;
      end
      if (seqno == 11 and select == CONST.BUTTON_确定 and data >= 1) then
          local keyNum = data*1;
          local tStrExp = tonumber(EquipSlotStat(player, ItemPosName[targetSlot+1], "V"));
          local tStrLv = tonumber(EquipSlotStat(player, ItemPosName[targetSlot+1], "Q"));
          if (tStrLv>=10) then
              NLG.SystemMessage(player, "[系統]熟練度已達100%能量！");
              return;
          end
          if (tStrExp+keyNum>10000) then
              NLG.SystemMessage(player, "[系統]伏特能量過載！");
              return;
          end
          if (targetSlot>=0) then
              local killNum = Char.ItemNum(player, 631092);
              if (keyNum ~=nil and math.ceil(keyNum)==keyNum) then
                  if (keyNum>killNum) then
                      NLG.SystemMessage(player, "[系統]伏特能量不足！");
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
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
              targetSlot = data-1;  --装备格参数 (选项少1)
              targetItemIndex = Char.GetItemIndex(player, targetSlot);
              local killNum = Char.ItemNum(player, 631092);
              local winMsg = "　　　　　　　　$1【裝備插槽強化】\\n"
                                           .."═════════════════════\\n"
                                           .."正在確認插槽資訊...\\n"
                                           .."\\n　　　　插　槽　部　位：$2".. ItemPosName[targetSlot+1] .."\\n"
                                           .."\\n　　　　當前可充入的量：$4".. killNum .."\\n"
                                           .."\\n請確認輸入之伏特量：\\n";
              NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.窗口_输入框, CONST.BUTTON_确定关闭, 11, winMsg);
      else
                 return;
      end
    end
  end)


  --石板道具
  self:regCallback('ItemString', Func.bind(self.indicativeSlate, self),"LUA_useSlate");
  self.setupSlateNPC = self:NPC_createNormal('指示石板', 14682, { x =35 , y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.setupSlateNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【指示石板】" ..	"\\n\\n\\n確定使用石板嵌入部位的裝備插槽？";	
        NLG.ShowWindowTalked(player, self.setupSlateNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.setupSlateNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local SlateIndex =SlateIndex;
    local SlateSlot = SlateSlot;
    local SlateName = Item.GetData(SlateIndex, CONST.道具_名字);
    local PosSlot = Item.GetData(SlateIndex,CONST.道具_子参一);

    --石板操作
    if select > 0 then
      if seqno == 1 and Char.ItemSlot(player)>=19 and select == CONST.按钮_是 then
                 NLG.SystemMessage(player,"[系統]物品欄已滿。");
                 return;
      elseif seqno == 1 and select == CONST.按钮_否 then
                 return;
      elseif seqno == 1 and select == CONST.按钮_是 then
          --避免nil检测
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
          --石板动作
          local slate_Info = slotCards[Item.GetData(SlateIndex, CONST.道具_ID)]
          if (slate_Info ~=nil and PosSlot>=0) then
              local cardIndex = EquipSlotStat(player, ItemPosName[PosSlot+1], "C");
              if (cardIndex == "0000000") then
                  Char.DelItemBySlot(player, SlateSlot);
                  EquipSlotStat(player, ItemPosName[PosSlot+1], "C", slate_Info);
                  NLG.SystemMessage(player, "[系统]"..SlateName.." 成功嵌入安裝。")
              else
                  Char.DelItemBySlot(player, SlateSlot);
                  EquipSlotStat(player, ItemPosName[PosSlot+1], "C", slate_Info);
                  NLG.SystemMessage(player, "[系统]"..SlateName.." 成功嵌入安裝。")
                  for k,v in pairs(slotCards) do
                      if (cardIndex==v) then
                          Char.GiveItem(player, k, 1);
                      end
                  end
              end
          else
              NLG.SystemMessage(player,"[系統]未設定指示的石板。");
              return;
          end
      else
                 return;
      end
    else
      if seqno == 2 and Char.ItemSlot(player)>=19 and data >= 1 then
                 NLG.SystemMessage(player,"[系統]物品欄已滿。");
                 return;
      elseif seqno == 2 and select == CONST.按钮_关闭 then
                 return;
      elseif seqno == 2 and data >= 1 then
              local PosSlot=data-1;
              --避免nil检测
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
              --石板动作
              if (cardIndex ~= "0000000") then
                  Char.DelItemBySlot(player, SlateSlot);
                  EquipSlotStat(player, ItemPosName[PosSlot+1], "C", "0000000");
                  NLG.SystemMessage(player, "[系统]"..SlateName.." 成功嵌入安裝。")
                  for k,v in pairs(slotCards) do
                      if (cardIndex==v) then
                          Char.GiveItem(player, k, 1);
                      end
                  end
              else
                  NLG.SystemMessage(player,"[系統]已重置空白石板。");
                  return;
              end
      end
    end
  end)


end


--装备接口
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
--卸下接口
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

--道具说明组合接口
function Module:itemExpansionCallback(itemIndex, type, msg, charIndex, slot)
  --self:logDebug('itemExpansionCallback', itemIndex, type, msg, charIndex, slot)
  if (msg=="插槽等級×" and type==1) then
      local PosSlot = Item.GetData(itemIndex, CONST.道具_子参一);
      local string_1 = Data.GetMessage(7300800);
      local string_PosName = Data.GetMessage(7300801+PosSlot);
      local string = "$2此石板之插槽位 " ..string_PosName.. "\n"

      local Rate_buffer_Item = {}
      local card_Rate = slotCards[Item.GetData(itemIndex, CONST.道具_ID)]
      Rate_buffer_Item[1] = tonumber(string.sub(card_Rate, 1, 1));	--攻击倍率等级
      Rate_buffer_Item[2] = tonumber(string.sub(card_Rate, 2, 2));	--防御倍率等级
      Rate_buffer_Item[3] = tonumber(string.sub(card_Rate, 3, 3));	--敏捷倍率等级
      Rate_buffer_Item[4] = tonumber(string.sub(card_Rate, 4, 4));	--精神倍率等级
      Rate_buffer_Item[5] = tonumber(string.sub(card_Rate, 5, 5));	--回复倍率等级
      Rate_buffer_Item[6] = tonumber(string.sub(card_Rate, 6, 6));	--HP倍率等级
      Rate_buffer_Item[7] = tonumber(string.sub(card_Rate, 7, 7));	--MP倍率等级
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

--指示石板
function Module:indicativeSlate(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    SlateSlot =itemSlot;
    SlateIndex = Char.GetItemIndex(charIndex,itemSlot);
    local SlateName = Item.GetData(SlateIndex,CONST.道具_名字);
    local PosSlot = Item.GetData(SlateIndex,CONST.道具_子参一);
    if (PosSlot~=10) then
        local PosName = ItemPosName[PosSlot+1]
        local msg = "@c【指示石板】\\n"
                            .. "$2如果部位已有石板將會替換下來\\n\\n"
        local msg = msg .. "$5此石板嵌入[ " ..PosName.. " ]部位\\n"

        local Rate_buffer_Item = {}
        local card_Rate = slotCards[Item.GetData(SlateIndex, CONST.道具_ID)]
        Rate_buffer_Item[1] = tonumber(string.sub(card_Rate, 1, 1));	--攻击倍率等级
        Rate_buffer_Item[2] = tonumber(string.sub(card_Rate, 2, 2));	--防御倍率等级
        Rate_buffer_Item[3] = tonumber(string.sub(card_Rate, 3, 3));	--敏捷倍率等级
        Rate_buffer_Item[4] = tonumber(string.sub(card_Rate, 4, 4));	--精神倍率等级
        Rate_buffer_Item[5] = tonumber(string.sub(card_Rate, 5, 5));	--回复倍率等级
        Rate_buffer_Item[6] = tonumber(string.sub(card_Rate, 6, 6));	--HP倍率等级
        Rate_buffer_Item[7] = tonumber(string.sub(card_Rate, 7, 7));	--MP倍率等级
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
        local msg = msg .. "\\n確定使用$4" ..SlateName.. "$0嵌入角色的插槽部位？";	
        NLG.ShowWindowTalked(charIndex, self.setupSlateNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    elseif (PosSlot==10) then
          local msg = "2\\n　　　　　　　　【空白指示石板】\\n"
                               .."　　　　攻擊|防禦|敏捷|精神|恢復|生命|魔力\\n"
          for targetSlot = 0,7 do
                local tCard = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "C");
                local Rate_buffer_Info = {}
                Rate_buffer_Info[1] = tonumber(string.sub(tCard, 1, 1));	--攻击倍率等级
                Rate_buffer_Info[2] = tonumber(string.sub(tCard, 2, 2));	--防御倍率等级
                Rate_buffer_Info[3] = tonumber(string.sub(tCard, 3, 3));	--敏捷倍率等级
                Rate_buffer_Info[4] = tonumber(string.sub(tCard, 4, 4));	--精神倍率等级
                Rate_buffer_Info[5] = tonumber(string.sub(tCard, 5, 5));	--回复倍率等级
                Rate_buffer_Info[6] = tonumber(string.sub(tCard, 6, 6));	--HP倍率等级
                Rate_buffer_Info[7] = tonumber(string.sub(tCard, 7, 7));	--MP倍率等级

                msg = msg .. ItemPosName[targetSlot+1] .. "："
                                      .. "　" .. Rate_buffer_Info[1].." |  " .. Rate_buffer_Info[2].." |  "
                                      .. Rate_buffer_Info[3].." |  " .. Rate_buffer_Info[4].." |  "
                                      .. Rate_buffer_Info[5].." |  " .. Rate_buffer_Info[6].." |  "
                                      .. Rate_buffer_Info[7].."\n"
          end
        NLG.ShowWindowTalked(charIndex, self.setupSlateNPC, CONST.窗口_选择框, CONST.按钮_关闭, 2, msg);
    end
    return 1;
end
------------------------------------------------------------------------------------------
--功能函数
function EquipSlotStat( _Index, _StatSlot, _StatTab, _StatValue )
	--  E-赋予，P- 喷漆，H- 猎，G- 鬼，Q- 插槽，V- 伏特，C- 卡片
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

--装备时增加素质
function setItemStrData( _ItemIndex, _StrLv, _Card)

	--SQL.Run("ALTER TABLE tbl_item MODIFY COLUMN Argument char(45) Default 0");
	local Rate_buffer = {}
	Rate_buffer[1] = tonumber(string.sub(_Card, 1, 1));	--攻击倍率等级
	Rate_buffer[2] = tonumber(string.sub(_Card, 2, 2));	--防御倍率等级
	Rate_buffer[3] = tonumber(string.sub(_Card, 3, 3));	--敏捷倍率等级
	Rate_buffer[4] = tonumber(string.sub(_Card, 4, 4));	--精神倍率等级
	Rate_buffer[5] = tonumber(string.sub(_Card, 5, 5));	--回复倍率等级
	Rate_buffer[6] = tonumber(string.sub(_Card, 6, 6));	--HP倍率等级
	Rate_buffer[7] = tonumber(string.sub(_Card, 7, 7));	--MP倍率等级
	local Rate_check_b = { 0, 1.0, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 2.0 }
	local Rate_check_h = { 0, 0.10, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20 }

	--local bRate = 1 + (_StrLv/10 * 2);
	--local hRate = 1 + (_StrLv/10 * 2 * 0.1);
	local strData = {18, 19, 20, 21, 22, 27, 28}	--%道具_攻击%,%道具_防御%,%道具_敏捷%,%道具_精神%,%道具_回复%,%道具_HP%,%道具_MP%
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

	--local tStat = Item.GetData(_ItemIndex, CONST.道具_自用参数) or "";
	local tStat = Plus_buffer[1].."|" ..Plus_buffer[2].."|" ..Plus_buffer[3].."|" ..Plus_buffer[4].."|" ..Plus_buffer[5].."|" ..Plus_buffer[6].."|" ..Plus_buffer[7];
	Item.SetData(_ItemIndex, CONST.道具_自用参数, tStat);
end

--卸下时还原素质
function setItemRevertData( _ItemIndex)
	local Plus_buffer = {}
	local tItemStat = tostring(Item.GetData(_ItemIndex, CONST.道具_自用参数));
	if (string.find(tItemStat, "|")==nil) then
		return;
	else
		local strData = {18, 19, 20, 21, 22, 27, 28}	--%道具_攻击%,%道具_防御%,%道具_敏捷%,%道具_精神%,%道具_回复%,%道具_HP%,%道具_MP%
		local Plus_buffer = string.split(tItemStat, "|");

		for k,v in pairs(strData) do
			Item.SetData(_ItemIndex, strData[k], Item.GetData(_ItemIndex, strData[k]) - tonumber(Plus_buffer[k]));
		end
		Item.SetData(_ItemIndex, CONST.道具_自用参数, "");
	end
end

------------------------------------------------------------------------------------------
--自定义接口
Char.GetTargetItemSlot = function(charIndex,fromItemIndex)
  local type = Item.GetData(fromItemIndex, CONST.道具_类型);
  if (type==8 or type==9) then
      return 0;
  elseif (type==10 or type==11 or type==12) then
      return 1;
  elseif (type==13 or type==14) then
      return 4;
  elseif (type==0 or type==1 or type==2 or type==3 or type==4 or type==5 or type==6 or type==7) then
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
      if (ItemIndex < 0) then
          return 2;
      elseif (ItemIndex >= 0) then
          local Vicetype = Item.GetData(ItemIndex, CONST.道具_类型);
          if (Vicetype==65 or Vicetype==66 or Vicetype==67 or Vicetype==68 or Vicetype==69 or Vicetype==70) then
              return 3;
          else
              return 2;
          end
      end
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手);
      if (ItemIndex < 0) then
          return 3;
      elseif (ItemIndex >= 0) then
          local Vicetype = Item.GetData(ItemIndex, CONST.道具_类型);
          if (Vicetype==65 or Vicetype==66 or Vicetype==67 or Vicetype==68 or Vicetype==69 or Vicetype==70) then
              return 2;
          else
              return 3;
          end
      end
  elseif (type==15 or type==16 or type==17 or type==18 or type==19 or type==20 or type==21 or type==55) then
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_首饰1);
      if (ItemIndex < 0) then
          return 5;
      elseif (ItemIndex >= 0) then
          local Sittingtype = Item.GetData(ItemIndex, CONST.道具_类型);
          if (Sittingtype==62) then
              return 6;
          else
              return 5;
          end
      end
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_首饰2);
      if (ItemIndex < 0) then
          return 6;
      elseif (ItemIndex >= 0) then
          local Sittingtype = Item.GetData(ItemIndex, CONST.道具_类型);
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
