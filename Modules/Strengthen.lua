---模块类
local Module = ModuleBase:createModule('Strengthen')

local cardList = {
    {bookNum=1, itemNum=14801, kind=CONST.道具_生命, value=50},
    {bookNum=2, itemNum=14802, kind=CONST.道具_魔力, value=50},
    {bookNum=3, itemNum=14803, kind=CONST.道具_回复, value=10},
    {bookNum=4, itemNum=14804, kind=CONST.道具_敏捷, value=10},
    {bookNum=5, itemNum=14805, kind=CONST.道具_防御, value=10},
    {bookNum=6, itemNum=14806, kind=CONST.道具_攻击, value=15},
}

local StrStrengMaxLv = 9;
local StrSuccRate = {70, 65, 50, 35, 27, 22, 16, 11, 7}                                                                  --赋予成功率
local StrBreakRate = {0, 0, 0, 0, 0, 8, 10, 12, 14}                                                                           --赋予破坏率
local StrRequireGold = {1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000}                 --赋予所需魔币

local ItemPosName = {"頭 部", "身 体", "右 手", "左 手", "足 部", "飾品1", "飾品2", "水 晶"}
--【开放赋予】
local StrItemEnable = {}
StrItemEnable[79060] = 1    --副武器
StrItemEnable[79061] = 1
StrItemEnable[79062] = 1
StrItemEnable[79063] = 1
StrItemEnable[79064] = 1
StrItemEnable[79065] = 1
StrItemEnable[69226] = 1    --古老巨龍
StrItemEnable[69227] = 1
StrItemEnable[69228] = 1
StrItemEnable[69229] = 1
---------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self.enchanterNPC = self:NPC_createNormal('魔力賦予卷軸魔人', 104746, { x = 27, y = 7, mapType = 0, map = 25000, direction = 4 });
  self:NPC_regTalkedEvent(self.enchanterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local winMsg = "1\\n請選擇需要魔力賦予的裝備：\\n"
        for targetSlot = 0,7 do
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if targetItemIndex>=0 then
                        local tItemID = Item.GetData(targetItemIndex, CONST.道具_ID);
                        local tItemName = Item.GetData(targetItemIndex, CONST.道具_名字);
                        local tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
                        local tMaxLv = StrStrengMaxLv;
                        local tNeedGold = StrRequireGold[tStrLv+1];
                        local tItemCan = "[賦予Ｏ]";
                        if (StrItemEnable[tItemID]~=1) then tItemCan="[賦予Ｘ]"end
                        if (tStrLv>=tMaxLv) then tItemCan="[賦予Max]" end
                        local msg = tItemName .. " " .. tItemCan;
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "：" .. msg .. "\n"
                else
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "：" .. "\n"
                end
        end
        NLG.ShowWindowTalked(player, self.enchanterNPC, CONST.窗口_选择框, CONST.按钮_确定关闭, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.enchanterNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local tPlayerGold = Char.GetData(player, CONST.对象_金币);
    if select > 0 then
      --是否窗口回调
      if (seqno == 1 and select == CONST.按钮_关闭)  then
                 return;
      end
      if (seqno == 12 and select == CONST.按钮_关闭) then
                 return;
      end
    else
      --选择窗口回调
      if (seqno == 1 and data>0)  then      --选择附魔能力
          targetSlot = data-1;  --装备格参数 (选项少1)
          targetItemIndex = Char.GetItemIndex(player, targetSlot);
          tItemID = Item.GetData(targetItemIndex, CONST.道具_ID);
          tItemName = Item.GetData(targetItemIndex, CONST.道具_名字);
          tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
          tMaxLv = StrStrengMaxLv;
          tNeedGold = StrRequireGold[tStrLv+1];
          print(targetItemIndex,tItemName)
          if targetItemIndex>=0 then
                 if (StrItemEnable[tItemID]~=1) then
                        NLG.SystemMessage(player, "[" .. "古力莫" .. "] 你選擇的裝備[" .. tItemName .. "]為[不可賦予]！");
                        return;
                 end
                 if (tStrLv>=tMaxLv) then
                        NLG.SystemMessage(player, "[" .. "古力莫" .. "] 你選擇的裝備[" .. tItemName .. "]已達到[賦予Max]！");
                        return;
                 else
                        local winMsg = "1\\n請選擇要使用的魔法卷軸(賦予的能力)：\\n";
                        for itemSlot = 8,16 do
                              CardIndex = Char.GetItemIndex(player,itemSlot);
                              CardID = Item.GetData(CardIndex,CONST.道具_ID);
                              CardLv = Item.GetData(CardIndex,CONST.道具_等级);
                              CardType = Item.GetData(CardIndex,CONST.道具_类型);
                              CardName = Item.GetData(CardIndex, CONST.道具_名字);
                              if (tStrLv+1==CardLv and CardType==41) then
                                   winMsg = winMsg .. "第".. itemSlot-7 .."格:〈" .. CardName .. "〉" .. "\\n"
                              else
                                   winMsg = winMsg .. "第".. itemSlot-7 .."格:無物品.卡片等級[賦予Ｘ]" .. "\\n"
                              end
                        end
                        NLG.ShowWindowTalked(player, self.enchanterNPC, CONST.窗口_选择框, CONST.BUTTON_关闭, 12, winMsg);
                 end
          else
                 NLG.SystemMessage(player, "[" .. "古力莫" .. "] 你選擇的部位無裝備！");
                 return;
          end
      elseif (seqno == 12 and data>0) then      --进行赋予
          if (targetItemIndex ~=nil) then
                 if (tPlayerGold<tNeedGold) then
                                  NLG.SystemMessage(player, "[" .. "古力莫" .. "] 賦予需要" .. tNeedGold .. "G，所需金幣不足！");
                                  return;
                 end
                 local itemSlot = data+7;
                 CardIndex = Char.GetItemIndex(player,itemSlot);
                 CardID = Item.GetData(CardIndex,CONST.道具_ID);
                 CardLv = Item.GetData(CardIndex,CONST.道具_等级);
                 CardType = Item.GetData(CardIndex,CONST.道具_类型);
                 CardName = Item.GetData(CardIndex, CONST.道具_名字);
                 if (tStrLv+1==CardLv and CardType==41) then
                     Char.SetData(player, CONST.对象_金币, tPlayerGold-tNeedGold);
                     Char.DelItem(player, CardID, 1);
                     local SuccRate = StrSuccRate[tStrLv+1];
                     if (type(SuccRate)=="number" and SuccRate>0) then
                            local tMin = 50 - math.floor(SuccRate/2) + 1;
                            local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2);
                            local tLuck = math.random(1, 100);
                            if (tLuck<tMin or tLuck>tMax)  then
                                if (tStrLv+1>=6) then
                                    local BreakRate = StrBreakRate[tStrLv+1]
                                    if (type(BreakRate)=="number" and BreakRate>0) then
                                        local tMin = 50 - math.floor(BreakRate/2) + 1;
                                        local tMax = 50 + math.floor(BreakRate/2) + math.fmod(BreakRate,2);
                                        local tLuck = math.random(1, 100);
                                        if (tLuck>=tMin and tLuck<=tMax)  then
                                            Item.Kill(player, tItemIndex, targetSlot);
                                            NLG.SystemMessage(player, "[" .. "古力莫" .. "] 裝備魔力賦予大失敗……永久損毀……");
                                            return;
                                        end
                                    end
                                else
                                    Item.SetData(targetItemIndex,CONST.道具_最大耐久, Item.GetData(targetItemIndex,CONST.道具_最大耐久)-5);
                                    if (Item.GetData(targetItemIndex,CONST.道具_耐久)>Item.GetData(targetItemIndex,CONST.道具_最大耐久)) then
                                           Item.SetData(targetItemIndex,CONST.道具_耐久, Item.GetData(targetItemIndex,CONST.道具_最大耐久));
                                    end
                                    Item.UpItem(targetItemIndex, targetSlot);
                                    NLG.SystemMessage(player, "[" .. "古力莫" .. "] 裝備魔力賦予失敗……造成耐久下降……");
                                    return;
                                end
                            end
                            if EquipPlusStat(targetItemIndex)==nil then Item.SetData(targetItemIndex, CONST.道具_鉴前名, targetName); end
                            EquipPlusStat(targetItemIndex, "E", tStrLv+1);
                            setItemName(targetItemIndex);
                            --Item.SetData(targetItemIndex,CONST.道具_攻击, 500);
                            Item.UpItem(targetItemIndex, targetSlot);
                            NLG.SystemMessage(player, "[" .. "古力莫" .. "] 恭喜你！魔力賦予成功到+" .. tStrLv+1 .. "！");
                            NLG.UpChar(player);
                            if (tStrLv+1>=7) then
                                          NLG.SystemMessage(-1, "[" .. "古力莫" .. "] 恭喜 "..Char.GetData(player, CONST.对象_名字).."！將 "..Item.GetData(targetItemIndex, CONST.道具_鉴前名).." 魔力賦予成功到+" .. tStrLv+1 .. "！");
                            end
                     else
                     end
                 else
                     NLG.SystemMessage(player, "[" .. "古力莫" .. "] 無效的選擇！");
                     return;
                 end
          end
      else
                 return;
      end
    end
  end)


end


function EquipPlusStat( _ItemIndex, _StatTab, _StatValue )
	--  E-赋予，P- 喷漆
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = tostring(Item.GetData(_ItemIndex, CONST.道具_自用参数));
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
		Item.SetData(_ItemIndex, CONST.道具_自用参数, tStat);
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

function setItemName( _ItemIndex , _Name)
	local StatTab = EquipPlusStat( _ItemIndex );
	local ItemName = Item.GetData(_ItemIndex, CONST.道具_鉴前名);
	--⊙¤??Фф€◎●◇◆□■★☆㊣
	for k,v in pairs(StatTab) do
		if k=="E" then
			ItemName = ItemName .. "+" .. v
		end
	end
	Item.SetData(_ItemIndex, CONST.道具_名字, ItemName);
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
