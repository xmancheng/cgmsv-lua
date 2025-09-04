---模块类
local Module = ModuleBase:createModule('pokeFisher')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('LoopEvent', Func.bind(self.fishloop,self))
  self:regCallback('fishloop', function(player)
    local ItemID = Char.GetTempData(player, '钓鱼挂机') or 0;
    if (ItemID >0) then
      local floor = Char.GetData(player,CONST.对象_地图);
      if (floor~=80024) then
        Char.SetTempData(player, '钓鱼挂机', 0);
        Char.SetLoopEvent(nil,'fishloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[系統]因為不在小島上釣魚掛機停止。");
        return
      end

      local RodIndex = Char.HaveItem(player,ItemID);
      local RodStr = Item.GetData(RodIndex, CONST.道具_耐久) or 0;
      if (RodStr >= 1) then
        Item.SetData(RodIndex, CONST.道具_耐久, Item.GetData(RodIndex, CONST.道具_耐久)-1);
        Item.UpItem(player, -1);

        local dropMenu = {70257,70257,70257,70257,70258,70258,70258,70259};
        local dropRate = {1,1,1,2,1,1,3,1,1,2};
        Char.GiveItem(player, dropMenu[NLG.Rand(1,8)], dropRate[NLG.Rand(1,10)]);
        NLG.SortItem(player);
        NLG.SystemMessage(player,"消耗1點耐久每10秒進行釣魚，釣竿還有"..(RodStr-1).."點耐久。");
      else
        local dropMenu = {70257,70257,70257,70257,70258,70258,70258,70259};
        local dropRate = {1,1,1,2,1,1,3,1,1,2};
        Char.GiveItem(player, dropMenu[NLG.Rand(1,8)], dropRate[NLG.Rand(1,10)]);
        NLG.SortItem(player);
        NLG.SystemMessage(player,"釣竿消耗殆盡，釣魚關閉！");
      end
    else
        Char.SetTempData(player, '钓鱼挂机', 0);
        Char.SetLoopEvent(nil,'fishloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        return
    end
  end)

  self:regCallback("ItemString", Func.bind(self.Fishing, self), 'LUA_useFisher');
  self.fishingNPC = self:NPC_createNormal('釣魚掛機釣竿', 14682, { x = 41, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.fishingNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "\\n@c【釣魚掛機】\\n\\n此釣竿已經沒有耐久度無法使用了！";
          NLG.ShowWindowTalked(player, self.fishingNPC, CONST.窗口_信息框, CONST.按钮_关闭, 2, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.fishingNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local RodIndex = Char.GetItemIndex(player,RodSlot);
    local RodStr = Item.GetData(RodIndex, CONST.道具_耐久) or 0;
    if select > 0 then
      if (seqno == 2 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and select == CONST.按钮_是) then
        local floor = Char.GetData(player,CONST.对象_地图);
        if (floor~=80024) then
          NLG.SystemMessage(player,"[系統]釣魚只能在專門的小島上進行。");
          return
        end
        local ItemID = Char.GetTempData(player, '钓鱼挂机') or 0;
        if (RodStr > 1 and ItemID==0) then
          local ItemID = Item.GetData(RodIndex, CONST.道具_ID);
          Char.SetTempData(player, '钓鱼挂机', ItemID);
          Char.SetLoopEvent(nil,'fishloop',player,10000);
          NLG.SetAction(player, 11);
          NLG.UpChar(player);
        elseif (RodStr == 1 and ItemID==0) then
          local ItemID = Item.GetData(RodIndex, CONST.道具_ID);
          Char.DelItemBySlot(player, RodSlot);
          Char.SetTempData(player, '钓鱼挂机', ItemID);
          Char.SetLoopEvent(nil,'fishloop',player,10000);
          NLG.SystemMessage(player,"釣魚最後一次生效,請及時補充釣竿！");
        elseif (ItemID>0) then
          Char.SetTempData(player, '钓鱼挂机', 0);
          Char.SetLoopEvent(nil,'fishloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[系統]釣魚掛機停止。");	
        end
      elseif (seqno == 1 and select == CONST.按钮_否) then
        Char.SetTempData(player, '钓鱼挂机', 0);
        Char.SetLoopEvent(nil,'fishloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[系統]釣魚掛機停止。");	
      end
    else

    end
  end)


end

function Module:Fishing(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    RodSlot = itemSlot;
    local RodIndex = Char.GetItemIndex(charIndex,RodSlot);
    local RodStr = Item.GetData(RodIndex, CONST.道具_耐久) or 0;
    if RodStr>=0 then
          local msg = "\\n@c【釣魚掛機】\\n\\n按「是」使用釣竿，進行釣魚\\n\\n按「否」停止正在進行的釣魚";
          NLG.ShowWindowTalked(charIndex, self.fishingNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    elseif RodStr==0 then
          local msg = "\\n@c【釣魚掛機】\\n\\n此釣竿已經沒有耐久度，無法使用了！";
          NLG.ShowWindowTalked(charIndex, self.fishingNPC, CONST.窗口_信息框, CONST.按钮_关闭, 2, msg);
    end
    return 1;
end


function Module:onLoginEvent(charIndex)
	local fishingOn = Char.GetTempData(charIndex, '钓鱼挂机') or 0;
	if (fishingOn>0) then
		Char.SetTempData(charIndex, '钓鱼挂机', 0);
		Char.SetLoopEvent(nil,'fishloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[系統]釣魚掛機停止。");	
	end
end
function Module:onLogoutEvent(charIndex)
	local fishingOn = Char.GetTempData(charIndex, '钓鱼挂机') or 0;
	if (fishingOn>0) then
		Char.SetTempData(charIndex, '钓鱼挂机', 0);
		Char.SetLoopEvent(nil,'fishloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[系統]釣魚掛機停止。");	
	end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
