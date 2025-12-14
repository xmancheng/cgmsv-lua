---模块类
local Module = ModuleBase:createModule('gathering')
local gather_table = require "lua/Modules/techarea"

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('LoopEvent', Func.bind(self.Logloop,self))
  self:regCallback('Logloop', function(player)
    local ItemID = Char.GetTempData(player, '伐木挂机') or 0;
    if (ItemID >0) then
      local mapId = Char.GetData(player,CONST.对象_地图类型);
      local floor = Char.GetData(player,CONST.对象_地图);
      local px = Char.GetData(player,CONST.对象_X);
      local py = Char.GetData(player,CONST.对象_Y);
      if (floor==1000) then
        Char.SetTempData(player, '伐木挂机', 0);
        Char.SetLoopEvent(nil,'Logloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[系統]在法蘭城內工作停止。");
        return
      end
      local HuntingOn = Char.GetTempData(player, '狩猎挂机') or 0;
      local MiningOn = Char.GetTempData(player, '挖掘挂机') or 0;
      if (HuntingOn>0 or MiningOn>0) then
          if HuntingOn>0 then 
            Char.SetTempData(player, '狩猎挂机', 0);
            Char.SetLoopEvent(nil,'Hunterloop',player,0);
            NLG.SystemMessage(player,"[系統]只能進行單一工作，已停止狩獵。");
          elseif MiningOn>0 then 
            Char.SetTempData(player, '挖掘挂机', 0);
            Char.SetLoopEvent(nil,'Minerloop',player,0);
            NLG.SystemMessage(player,"[系統]只能進行單一工作，已停止挖掘。");
          end
          Char.UnsetLoopEvent(player);
          Char.SetLoopEvent(nil,'Logloop',player,5000);
      end

      local AxeIndex = Char.HaveItem(player,ItemID);
      local AxeStr = Item.GetData(AxeIndex, CONST.道具_耐久) or 0;
      if (AxeIndex>0 and AxeStr >= 1) then
        --local count,areaIndex_tbl = TechArea.GetIndexList(mapId, floor, px, py, 225);
        --print(count)
        Item.SetData(AxeIndex, CONST.道具_耐久, Item.GetData(AxeIndex, CONST.道具_耐久)-1);
        Item.UpItem(player, -1);

        local areaIndex_tbl = get_player_gather_info(px, py, floor, gather_table, 225)
        if (areaIndex_tbl==nil) then
          Char.SetTempData(player, '伐木挂机', 0);
          Char.SetLoopEvent(nil,'Logloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]此處無素材可用到這工具。");
          return
        end
        local itemId,itemProb = dropMap(areaIndex_tbl);
		if (itemProb==1) then
          local dropRate = {1,1,1,2,1,1,3,1,1,2};
          Char.GiveItem(player, itemId, dropRate[NLG.Rand(1,10)]);
          NLG.SortItem(player);
		elseif (itemProb==0) then
          NLG.SystemMessage(player,"伐木採集失敗。");
		end
        NLG.SystemMessage(player,"消耗1點耐久每5秒進行伐木，工具還有"..(AxeStr-1).."點耐久。");
        if (Item.GetData(AxeIndex, CONST.道具_耐久)== 0) then
          local AxeSlot = Char.FindItemId(player, ItemID);
          Char.DelItemBySlot(player, AxeSlot);
          NLG.UpChar(player);
        end
      elseif (AxeIndex<0 or AxeStr < 1) then
        Char.SetTempData(player, '伐木挂机', 0);
        Char.SetLoopEvent(nil,'Logloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"工具消耗殆盡，伐木關閉！");
      end
    else
        Char.SetTempData(player, '伐木挂机', 0);
        Char.SetLoopEvent(nil,'Logloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        return
    end
  end)

  self:regCallback('LoopEvent', Func.bind(self.Hunterloop,self))
  self:regCallback('Hunterloop', function(player)
    local ItemID = Char.GetTempData(player, '狩猎挂机') or 0;
    if (ItemID >0) then
      local mapId = Char.GetData(player,CONST.对象_地图类型);
      local floor = Char.GetData(player,CONST.对象_地图);
      local px = Char.GetData(player,CONST.对象_X);
      local py = Char.GetData(player,CONST.对象_Y);
      if (floor==1000) then
        Char.SetTempData(player, '狩猎挂机', 0);
        Char.SetLoopEvent(nil,'Hunterloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[系統]在法蘭城內工作停止。");
        return
      end
      local LoggingOn = Char.GetTempData(player, '伐木挂机') or 0;
      local MiningOn = Char.GetTempData(player, '挖掘挂机') or 0;
      if (LoggingOn>0 or MiningOn>0) then
          if LoggingOn>0 then 
            Char.SetTempData(player, '伐木挂机', 0);
            Char.SetLoopEvent(nil,'Logloop',player,0);
            NLG.SystemMessage(player,"[系統]只能進行單一工作，已停止伐木。");
          elseif MiningOn>0 then 
            Char.SetTempData(player, '挖掘挂机', 0);
            Char.SetLoopEvent(nil,'Minerloop',player,0);
            NLG.SystemMessage(player,"[系統]只能進行單一工作，已停止挖掘。");
          end
          Char.UnsetLoopEvent(player);
          Char.SetLoopEvent(nil,'Hunterloop',player,5000);
      end

      local BowIndex = Char.HaveItem(player,ItemID);
      local BowStr = Item.GetData(BowIndex, CONST.道具_耐久) or 0;
      if (BowIndex>0 and BowStr >= 1) then
        --local count,areaIndex_tbl = TechArea.GetIndexList(mapId, floor, px, py, 226);
        --print(count,areaIndex_tbl)
        Item.SetData(BowIndex, CONST.道具_耐久, Item.GetData(BowIndex, CONST.道具_耐久)-1);
        Item.UpItem(player, -1);

        local areaIndex_tbl = get_player_gather_info(px, py, floor, gather_table, 226)
        if (areaIndex_tbl==nil) then
          Char.SetTempData(player, '狩猎挂机', 0);
          Char.SetLoopEvent(nil,'Hunterloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]此處無素材可用到這工具。");
          return
        end
        local itemId,itemProb = dropMap(areaIndex_tbl);
		if (itemProb==1) then
          local dropRate = {1,1,1,2,1,1,3,1,1,2};
          Char.GiveItem(player, itemId, dropRate[NLG.Rand(1,10)]);
          NLG.SortItem(player);
		elseif (itemProb==0) then
          NLG.SystemMessage(player,"狩獵採集失敗。");
		end
        NLG.SystemMessage(player,"消耗1點耐久每5秒進行狩獵，工具還有"..(BowStr-1).."點耐久。");
        if (Item.GetData(BowIndex, CONST.道具_耐久)== 0) then
          local BowSlot = Char.FindItemId(player, ItemID);
          Char.DelItemBySlot(player, BowSlot);
          NLG.UpChar(player);
        end
      elseif (BowIndex<0 or BowStr < 1) then
        Char.SetTempData(player, '狩猎挂机', 0);
        Char.SetLoopEvent(nil,'Hunterloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"工具消耗殆盡，狩獵關閉！");
      end
    else
        Char.SetTempData(player, '狩猎挂机', 0);
        Char.SetLoopEvent(nil,'Hunterloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        return
    end
  end)

  self:regCallback('LoopEvent', Func.bind(self.Minerloop,self))
  self:regCallback('Minerloop', function(player)
    local ItemID = Char.GetTempData(player, '挖掘挂机') or 0;
    if (ItemID >0) then
      local mapId = Char.GetData(player,CONST.对象_地图类型);
      local floor = Char.GetData(player,CONST.对象_地图);
      local px = Char.GetData(player,CONST.对象_X);
      local py = Char.GetData(player,CONST.对象_Y);
      if (floor==1000) then
        Char.SetTempData(player, '挖掘挂机', 0);
        Char.SetLoopEvent(nil,'Minerloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[系統]在法蘭城內工作停止。");
        return
      end
      local LoggingOn = Char.GetTempData(player, '伐木挂机') or 0;
      local HuntingOn = Char.GetTempData(player, '狩猎挂机') or 0;
      if (LoggingOn>0 or HuntingOn>0) then
          if LoggingOn>0 then 
            Char.SetTempData(player, '伐木挂机', 0);
            Char.SetLoopEvent(nil,'Logloop',player,0);
            NLG.SystemMessage(player,"[系統]只能進行單一工作，已停止伐木。");
          elseif HuntingOn>0 then 
            Char.SetTempData(player, '狩猎挂机', 0);
            Char.SetLoopEvent(nil,'Hunterloop',player,0);
            NLG.SystemMessage(player,"[系統]只能進行單一工作，已停止狩獵。");
          end
          Char.UnsetLoopEvent(player);
          Char.SetLoopEvent(nil,'Minerloop',player,5000);
      end

      local HawkIndex = Char.HaveItem(player,ItemID);
      local HawkStr = Item.GetData(HawkIndex, CONST.道具_耐久) or 0;
      if (HawkIndex>0 and HawkStr >= 1) then
        --local count,areaIndex_tbl = TechArea.GetIndexList(mapId, floor, px, py, 227);
        --print(count,areaIndex_tbl)
        Item.SetData(HawkIndex, CONST.道具_耐久, Item.GetData(HawkIndex, CONST.道具_耐久)-1);
        Item.UpItem(player, -1);

        local areaIndex_tbl = get_player_gather_info(px, py, floor, gather_table, 227)
        if (areaIndex_tbl==nil) then
          Char.SetTempData(player, '挖掘挂机', 0);
          Char.SetLoopEvent(nil,'Minerloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]此處無素材可用到這工具。");
          return
        end
        local itemId,itemProb = dropMap(areaIndex_tbl);
		if (itemProb==1) then
          local dropRate = {1,1,1,2,1,1,3,1,1,2};
          Char.GiveItem(player, itemId, dropRate[NLG.Rand(1,10)]);
          NLG.SortItem(player);
		elseif (itemProb==0) then
          NLG.SystemMessage(player,"挖掘採集失敗。");
		end
        NLG.SystemMessage(player,"消耗1點耐久每5秒進行挖掘，工具還有"..(HawkStr-1).."點耐久。");
        if (Item.GetData(HawkIndex, CONST.道具_耐久)== 0) then
          local HawkSlot = Char.FindItemId(player, ItemID);
          Char.DelItemBySlot(player, HawkSlot);
          NLG.UpChar(player);
        end
      elseif (HawkIndex<0 or HawkStr < 1) then
        Char.SetTempData(player, '挖掘挂机', 0);
        Char.SetLoopEvent(nil,'Minerloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"工具消耗殆盡，挖掘關閉！");
      end
    else
        Char.SetTempData(player, '挖掘挂机', 0);
        Char.SetLoopEvent(nil,'Minerloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        return
    end
  end)



  -----------------------------------------------------------------------------------------------------------------------
  self:regCallback("ItemString", Func.bind(self.Logging, self), 'LUA_useLumber');
  self.loggingNPC = self:NPC_createNormal('伐木掛機', 14682, { x = 42, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.loggingNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "\\n@c【伐木掛機】\\n\\n此工具已經沒有耐久度無法使用了！";
          NLG.ShowWindowTalked(player, self.loggingNPC, CONST.窗口_信息框, CONST.按钮_关闭, 2, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.loggingNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local AxeIndex = Char.GetItemIndex(player,AxeSlot);
    local AxeStr = Item.GetData(AxeIndex, CONST.道具_耐久) or 0;
    if select > 0 then
      if (seqno == 2 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and select == CONST.按钮_是) then
        local floor = Char.GetData(player,CONST.对象_地图);
        local ItemID = Char.GetTempData(player, '伐木挂机') or 0;
        if (AxeStr > 1 and ItemID==0) then
          local ItemID = Item.GetData(AxeIndex, CONST.道具_ID);
          Char.SetTempData(player, '伐木挂机', ItemID);
          Char.SetLoopEvent(nil,'Logloop',player,5000);
          NLG.SetAction(player, 11);
          NLG.UpChar(player);
        elseif (AxeStr == 1 and ItemID==0) then
          local ItemID = Item.GetData(AxeIndex, CONST.道具_ID);
          Char.DelItemBySlot(player, AxeSlot);
          Char.SetTempData(player, '伐木挂机', ItemID);
          Char.SetLoopEvent(nil,'Logloop',player,5000);
          NLG.SystemMessage(player,"伐木最後一次生效,請及時補充工具！");
        elseif (AxeStr == 0) then
          Char.DelItemBySlot(player, AxeSlot);
          Char.SetTempData(player, '伐木挂机', 0);
          Char.SetLoopEvent(nil,'Logloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]伐木工作停止。");	
        elseif (ItemID>0) then
          Char.SetTempData(player, '伐木挂机', 0);
          Char.SetLoopEvent(nil,'Logloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]伐木工作停止。");	
        end
      elseif (seqno == 1 and select == CONST.按钮_否) then
        Char.SetTempData(player, '伐木挂机', 0);
        Char.SetLoopEvent(nil,'Logloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[系統]伐木工作停止。");	
      end
    else

    end
  end)

  self:regCallback("ItemString", Func.bind(self.Hunting, self), 'LUA_useHunter');
  self.huntingNPC = self:NPC_createNormal('狩獵掛機', 14682, { x = 43, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.huntingNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "\\n@c【狩獵掛機】\\n\\n此工具已經沒有耐久度無法使用了！";
          NLG.ShowWindowTalked(player, self.huntingNPC, CONST.窗口_信息框, CONST.按钮_关闭, 2, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.huntingNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local BowIndex = Char.GetItemIndex(player,BowSlot);
    local BowStr = Item.GetData(BowIndex, CONST.道具_耐久) or 0;
    if select > 0 then
      if (seqno == 2 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and select == CONST.按钮_是) then
        local floor = Char.GetData(player,CONST.对象_地图);
        local ItemID = Char.GetTempData(player, '狩猎挂机') or 0;
        if (BowStr > 1 and ItemID==0) then
          local ItemID = Item.GetData(BowIndex, CONST.道具_ID);
          Char.SetTempData(player, '狩猎挂机', ItemID);
          Char.SetLoopEvent(nil,'Hunterloop',player,5000);
          NLG.SetAction(player, 11);
          NLG.UpChar(player);
        elseif (BowStr == 1 and ItemID==0) then
          local ItemID = Item.GetData(BowIndex, CONST.道具_ID);
          Char.DelItemBySlot(player, BowSlot);
          Char.SetTempData(player, '狩猎挂机', ItemID);
          Char.SetLoopEvent(nil,'Hunterloop',player,5000);
          NLG.SystemMessage(player,"狩獵最後一次生效,請及時補充工具！");
        elseif (BowStr == 0) then
          Char.DelItemBySlot(player, BowSlot);
          Char.SetTempData(player, '狩猎挂机', 0);
          Char.SetLoopEvent(nil,'Hunterloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]狩獵工作停止。");	
        elseif (ItemID>0) then
          Char.SetTempData(player, '狩猎挂机', 0);
          Char.SetLoopEvent(nil,'Hunterloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]狩獵工作停止。");	
        end
      elseif (seqno == 1 and select == CONST.按钮_否) then
        Char.SetTempData(player, '狩猎挂机', 0);
        Char.SetLoopEvent(nil,'Hunterloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[系統]狩獵工作停止。");	
      end
    else

    end
  end)

  self:regCallback("ItemString", Func.bind(self.Mining, self), 'LUA_useMiner');
  self.miningNPC = self:NPC_createNormal('挖掘掛機', 14682, { x = 44, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.miningNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "\\n@c【挖掘掛機】\\n\\n此工具已經沒有耐久度無法使用了！";
          NLG.ShowWindowTalked(player, self.miningNPC, CONST.窗口_信息框, CONST.按钮_关闭, 2, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.miningNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local HawkIndex = Char.GetItemIndex(player,HawkSlot);
    local HawkStr = Item.GetData(HawkIndex, CONST.道具_耐久) or 0;
    if select > 0 then
      if (seqno == 2 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and select == CONST.按钮_是) then
        local floor = Char.GetData(player,CONST.对象_地图);
        local ItemID = Char.GetTempData(player, '挖掘挂机') or 0;
        if (HawkStr > 1 and ItemID==0) then
          local ItemID = Item.GetData(HawkIndex, CONST.道具_ID);
          Char.SetTempData(player, '挖掘挂机', ItemID);
          Char.SetLoopEvent(nil,'Minerloop',player,5000);
          NLG.SetAction(player, 11);
          NLG.UpChar(player);
        elseif (HawkStr == 1 and ItemID==0) then
          local ItemID = Item.GetData(HawkIndex, CONST.道具_ID);
          Char.DelItemBySlot(player, HawkSlot);
          Char.SetTempData(player, '挖掘挂机', ItemID);
          Char.SetLoopEvent(nil,'Minerloop',player,5000);
          NLG.SystemMessage(player,"挖掘最後一次生效,請及時補充工具！");
        elseif (HawkStr == 0) then
          Char.DelItemBySlot(player, HawkSlot);
          Char.SetTempData(player, '挖掘挂机', 0);
          Char.SetLoopEvent(nil,'Minerloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]挖掘工作停止。");	
        elseif (ItemID>0) then
          Char.SetTempData(player, '挖掘挂机', 0);
          Char.SetLoopEvent(nil,'Minerloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]挖掘工作停止。");	
        end
      elseif (seqno == 1 and select == CONST.按钮_否) then
        Char.SetTempData(player, '挖掘挂机', 0);
        Char.SetLoopEvent(nil,'Minerloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[系統]挖掘工作停止。");	
      end
    else

    end
  end)


end

--工具调用
function Module:Logging(charIndex,targetIndex,itemSlot)
    AxeItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    AxeSlot = itemSlot;
    local AxeIndex = Char.GetItemIndex(charIndex,AxeSlot);
    local AxeStr = Item.GetData(AxeIndex, CONST.道具_耐久) or 0;
    if AxeStr>=0 then
          local msg = "\\n@c【伐木掛機】\\n\\n按「是」使用工具，進行伐木\\n\\n按「否」停止正在進行的伐木";
          NLG.ShowWindowTalked(charIndex, self.loggingNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return 1;
end
function Module:Hunting(charIndex,targetIndex,itemSlot)
    BowItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    BowSlot = itemSlot;
    local BowIndex = Char.GetItemIndex(charIndex,BowSlot);
    local BowStr = Item.GetData(BowIndex, CONST.道具_耐久) or 0;
    if BowStr>=0 then
          local msg = "\\n@c【狩獵掛機】\\n\\n按「是」使用工具，進行狩獵\\n\\n按「否」停止正在進行的狩獵";
          NLG.ShowWindowTalked(charIndex, self.huntingNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return 1;
end
function Module:Mining(charIndex,targetIndex,itemSlot)
    HawkItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    HawkSlot = itemSlot;
    local HawkIndex = Char.GetItemIndex(charIndex,HawkSlot);
    local HawkStr = Item.GetData(HawkIndex, CONST.道具_耐久) or 0;
    if HawkStr>=0 then
          local msg = "\\n@c【挖掘掛機】\\n\\n按「是」使用工具，進行挖掘\\n\\n按「否」停止正在進行的挖掘";
          NLG.ShowWindowTalked(charIndex, self.miningNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return 1;
end

--登入停止
function Module:onLoginEvent(charIndex)
	local LoggingOn = Char.GetTempData(charIndex, '伐木挂机') or 0;
	if (LoggingOn>0) then
		Char.SetTempData(charIndex, '伐木挂机', 0);
		Char.SetLoopEvent(nil,'Logloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[系統]伐木工作停止。");	
	end
	local HuntingOn = Char.GetTempData(charIndex, '狩猎挂机') or 0;
	if (HuntingOn>0) then
		Char.SetTempData(charIndex, '狩猎挂机', 0);
		Char.SetLoopEvent(nil,'Hunterloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[系統]狩獵工作停止。");	
	end
	local MiningOn = Char.GetTempData(charIndex, '挖掘挂机') or 0;
	if (MiningOn>0) then
		Char.SetTempData(charIndex, '挖掘挂机', 0);
		Char.SetLoopEvent(nil,'Minerloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[系統]挖掘工作停止。");	
	end
end
function Module:onLogoutEvent(charIndex)
	local LoggingOn = Char.GetTempData(charIndex, '伐木挂机') or 0;
	if (LoggingOn>0) then
		Char.SetTempData(charIndex, '伐木挂机', 0);
		Char.SetLoopEvent(nil,'Logloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[系統]伐木工作停止。");	
	end
	local HuntingOn = Char.GetTempData(charIndex, '狩猎挂机') or 0;
	if (HuntingOn>0) then
		Char.SetTempData(charIndex, '狩猎挂机', 0);
		Char.SetLoopEvent(nil,'Hunterloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[系統]狩獵工作停止。");	
	end
	local MiningOn = Char.GetTempData(charIndex, '挖掘挂机') or 0;
	if (MiningOn>0) then
		Char.SetTempData(charIndex, '挖掘挂机', 0);
		Char.SetLoopEvent(nil,'Minerloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[系統]挖掘工作停止。");	
	end
end

function dropMap(areaIndex_tbl)
	local itemId = 0;
	local itemProb = 0;

	--失败MISS
	--local fail = TechArea.GetData(areaIndex,CONST.TECH_AREA_FAILEDPROB);
	local failRate = math.floor(areaIndex_tbl.failRate/1000)*100;
	if (NLG.Rand(1,100)<=failRate) then
		return itemId,itemProb;
	end
	--成功计算掉落物
	local items = {}
	for i=1,#areaIndex_tbl.drops do
		--local temp_Id = TechArea.GetData(areaIndex,i);		--採集情报道具ID
		--local temp_Prob = TechArea.GetData(areaIndex,i+10);	--採集情报发生率
		local temp_Id = areaIndex_tbl.drops[i].id;		--採集情报道具ID
		local temp_Prob = areaIndex_tbl.drops[i].rate;	--採集情报发生率
		local tempSET = {name=temp_Id, weight=temp_Prob};
		if (temp_Id>0) then
			table.insert(items,tempSET);
		end
	end
	local total = 0;
	for i=1,#items do
		total = total + items[i].weight;
	end
	local rnd = NLG.Rand(1,total);
	local sum = 0;
	for i=1,#items do
		sum = sum + items[i].weight;
		if (rnd <= sum) then
			local itemId = items[i].name;
			local itemProb = 1;
			return itemId,itemProb;
		end
	end
	return itemId,itemProb;
end

------------------------------------------------------------------
-- 檢查玩家是否在矩形區域內
function is_in_rect(px, py, gather)
	return px >= gather.x1 and px <= gather.x2
		and py >= gather.y1 and py <= gather.y2
end

-- 取得玩家可採集資料
function get_player_gather_info(px, py, floor, gather_table, tooltype)
	local candidates = {}

	for k, v in pairs(gather_table) do
		if v.mapId == floor and v.skillId==tooltype and is_in_rect(px, py, v) then
			table.insert(candidates, v)
		end
	end

	-- 多個矩形重疊時，priority 越小越優先
	table.sort(candidates, function(a, b)
		return a.priority < b.priority
	end)

	return candidates[1] -- 回傳 priority 最小的那筆
end





--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
