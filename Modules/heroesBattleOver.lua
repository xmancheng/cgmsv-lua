local Module = ModuleBase:createModule('manaPool')
local _ = require "lua/Modules/underscore"
local itemList = {
  { name = '血池補充（1000LP）', image = 27243, price = 1500, desc = '補充血池使用量1000點', count = 1, maxCount = 999, value = 1000, type = 'lp' },
  { name = '血池補充（10000LP）', image = 27243, price = 14500, desc = '補充血池使用量10000點', count = 1, maxCount = 999, value = 10000, type = 'lp' },
  { name = '血池補充（50000LP）', image = 27243, price = 70000, desc = '補充血池使用量50000點', count = 1, maxCount = 999, value = 50000, type = 'lp' },
  { name = '魔池補充（1000FP）', image = 26206, price = 1700, desc = '補充魔池使用量1000點', count = 1, maxCount = 999, value = 1000, type = 'fp' },
  { name = '魔池補充（10000FP）', image = 26206, price = 16500, desc = '補充魔池使用量10000點', count = 1, maxCount = 999, value = 10000, type = 'fp' },
  { name = '魔池補充（50000FP）', image = 26206, price = 80000, desc = '補充魔池使用量50000點', count = 1, maxCount = 999, value = 50000, type = 'fp' },
  -- { name = '回复·秋菟祝福', image = 494861, price = 10000, desc = '携带时, 战斗结束角色生命恢复200, 魔法恢复200', count = 1, maxCount = 1, value = 100000, type = ''}
}

local 自动卖魔石 = true
local soldrate=1
local maxMoney=10000000

-- 全局掉落道具
local itemSetting={
  -- {道具id，随机数最小值，随机数最大值，随机1~1000}
  {60056,1,50}, --随机掉落钻石
  -- {20211055,950,980},
}


--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('血魔池', 99262, { x = 230, y = 58, mapType = 0, map = 1000, direction = 6 })
  self:NPC_regTalkedEvent(npc, Func.bind(self.onSellerTalked, self))
  self:NPC_regWindowTalkedEvent(npc, Func.bind(self.onSellerSelected, self));
  -- self:regCallback('BattleStartEvent', Func.bind(self.onBattleStart, self))
  self:regCallback('BattleOverEvent', Func.bind(self.onBattleOver, self))
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
end


function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/shm" or msg=="/SHM" ) then
		local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
		local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
		NLG.SystemMessage(charIndex, '[血魔池] 血池共: ' .. lpPool .. ', 魔池共: ' .. fpPool .. '。');
		NLG.UpChar(charIndex);
		return 0;
	end
	return 1;
end

function Module:onBattleOver(battleIndex)
  local poss={}
  for i = 0, 9 do
    table.insert(poss,i)
  end

  _.each(poss,function(pos) 
    local charIndex = Battle.GetPlayer(battleIndex, pos);

    if Char.GetData(charIndex,CONST.CHAR_类型)~=CONST.对象类型_人 then
      return
    end

    NLG.SortItem(charIndex);
    
    if Char.IsDummy(charIndex) then
      return
    end

    -- 获取佣兵
    local campHeroesData = getModule('heroesFn'):getCampHeroesData(charIndex)
    -- 玩家自己补血魔
    self:heal(charIndex,charIndex)

    -- 玩家的佣兵补血魔
    for k,v in pairs(campHeroesData) do
      self:heal(charIndex,v.index)
      if Char.GetData(charIndex,%对象_交易开关%) == 1 then
        self:clearBag(charIndex,v.index)
      end
      NLG.UpChar(v.index);
      Item.UpItem(v.index, -1);
    end

    if Char.GetData(charIndex,%对象_交易开关%) == 1 then
      self:clearBag(charIndex,charIndex)
      NLG.Say(charIndex,-1,"檢測到你開啟了交易，戰鬥後包包自動清理完畢。",1,3);
    end

      --开始分配 道具
    local randValue = NLG.Rand(1,1000);
    for i = 1,#itemSetting do
      local min= itemSetting[i][2]
      local max = itemSetting[i][3]
      local itemId = itemSetting[i][1]
      if randValue>=min and randValue<=max then
        itemIndex = Char.GiveItem(charIndex,itemId,1);
        if itemIndex<0 then
          --NLG.Say(charIndex,-1,"背包满了" ,CONST.颜色_红色,0)
          return
        end
        Item.SetData( itemIndex , CONST.道具_已鉴定 ,1)
        goto continue;
      end
      ::continue::
    end

    NLG.UpChar(charIndex);
    Item.UpItem(charIndex, -1);
  end)
end


function Module:clearBag(charIndex,targetIndex)
  
  for laji = 14801,15055 do--3.0图鉴
    Char.DelItem(targetIndex,laji,1);
  end
  for laji2 = 606600,606691 do--7.0图鉴
    Char.DelItem(targetIndex,laji2,99);
  end
  for laji3 = 18310,18313 do--水晶碎片
    Char.DelItem(targetIndex,laji3,99);
  end
  Char.DelItem(targetIndex,18194,99)--红头盔
  Char.DelItem(targetIndex,18195,99)--绿头盔
  local price = 0
  local money = Char.GetData(charIndex, CONST.CHAR_金币)
  for laji4 = 18005,18088 do--魔石
    if Char.HaveItem(targetIndex,laji4) > -1 then
      local msprice = Item.GetData(Char.HaveItem(targetIndex,laji4),%道具_价格%)
      price = price + msprice
      Char.DelItem(targetIndex,laji4,1)
    end
  end
  if 自动卖魔石 then
    local targetName = Char.GetData(targetIndex,CONST.CHAR_名字)
    -- local soldrate = 20;  --20倍
    local money1 = money+price*soldrate;
    if money1 <= maxMoney and price > 0 then
      Char.SetData(charIndex, CONST.CHAR_金币, money1);
      NLG.SystemMessage(charIndex, targetName.."魔石已售出，獲得【" .. price*soldrate .. "】魔幣。");
    elseif money1 > maxMoney then
      Char.SetData(charIndex, CONST.CHAR_金币, maxMoney);
      NLG.SystemMessage(charIndex, "錢包滿了！");
    end
  end
  --NLG.SortItem(player);
  -- Item.UpItem(player, -1);
  -- NLG.UpChar(player);
  
  
end

function Module:heal(charIndex,targetIndex)
  local name = Char.GetData(targetIndex,CONST.CHAR_名字)
  local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
  local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
  if lpPool <= 0 and fpPool <= 0 then
    NLG.SystemMessage(charIndex, '[血魔池] 剩餘容量不足，請及時補充。');
    return
  end
  
  local lp = Char.GetData(targetIndex, CONST.CHAR_血)
  local maxLp = Char.GetData(targetIndex, CONST.CHAR_最大血)
  local fp = Char.GetData(targetIndex, CONST.CHAR_魔)
  local maxFp = Char.GetData(targetIndex, CONST.CHAR_最大魔)
  if lpPool > 0 and lp < maxLp then
    if Char.GetData(charIndex,%对象_组队开关%) == 1 then
      lpPool = lpPool - maxLp + lp;
      if lpPool < 0 then
        maxLp = maxLp + lpPool;
        lpPool = 0;
      end
    else
      maxLp = lp;
    end
    if Char.GetData(charIndex,%对象_队聊开关%) == 1 then
        NLG.SystemMessage(charIndex, '[血魔池] 已為'..name..'恢復: ' .. (maxLp - lp) .. 'LP, 血池剩餘: ' .. lpPool);
    end
  else
    maxLp = lp;
  end

  if fpPool > 0 and fp < maxFp then
    if Char.GetData(charIndex,%对象_组队开关%) == 1 then
      fpPool = fpPool - maxFp + fp;
      if fpPool < 0 then
        maxFp = maxFp + fpPool;
        fpPool = 0;
      end
    else
      maxFp = fp;
    end
    if Char.GetData(charIndex,%对象_队聊开关%) == 1 then
        NLG.SystemMessage(charIndex, '[血魔池] 已為'..name..'恢復: ' .. (maxFp - fp) .. 'FP, 魔池剩餘: ' .. fpPool);
    end
  else
    maxFp = fp;
  end
  
  Char.SetData(targetIndex, CONST.CHAR_血, maxLp)
  Char.SetData(targetIndex, CONST.CHAR_魔, maxFp)
  
  local petSlot = Char.GetData(targetIndex, CONST.CHAR_战宠);
  if petSlot >= 0 then
    petIndex = Char.GetPet(targetIndex, petSlot);
    lp = Char.GetData(petIndex, CONST.CHAR_血)
    maxLp = Char.GetData(petIndex, CONST.CHAR_最大血)
    fp = Char.GetData(petIndex, CONST.CHAR_魔)
    maxFp = Char.GetData(petIndex, CONST.CHAR_最大魔)
    
    if lpPool > 0 and lp < maxLp then
      if Char.GetData(charIndex,%对象_组队开关%) == 1 then
        lpPool = lpPool - maxLp + lp;
        if lpPool < 0 then
          maxLp = maxLp + lpPool;
          lpPool = 0;
        end
      else
        maxLp = lp;
      end
      if Char.GetData(charIndex,%对象_队聊开关%) == 1 then
          NLG.SystemMessage(charIndex, '[血魔池] 已恢復寵物: ' .. (maxLp - lp) .. 'LP, 血池剩餘: ' .. lpPool);
      end
    else
      maxLp = lp;
    end

    if fpPool > 0 and fp < maxFp then
      if Char.GetData(charIndex,%对象_组队开关%) == 1 then
        fpPool = fpPool - maxFp + fp;
        if fpPool < 0 then
          maxFp = maxFp + fpPool;
          fpPool = 0;
        end
      else
        maxFp = fp;
      end
      if Char.GetData(charIndex,%对象_队聊开关%) == 1 then
          NLG.SystemMessage(charIndex, '[血魔池] 已恢復寵物: ' .. (maxFp - fp) .. 'FP, 魔池剩餘: ' .. fpPool);
      end
    else
      maxFp = fp;
    end

    Char.SetData(petIndex, CONST.CHAR_血, maxLp)
    Char.SetData(petIndex, CONST.CHAR_魔, maxFp)
    NLG.UpChar(petIndex);
  end

  Field.Set(charIndex, 'LpPool', tostring(lpPool));
  Field.Set(charIndex, 'FpPool', tostring(fpPool));
end



function Module:onSellerTalked(npc, player)
  if NLG.CanTalk(npc, player) then
    local npcInfo = self:NPC_buildBuyWindowData(101024, '血魔池補充', '充值血魔池', '金錢不足', '背包已滿', itemList);
    NLG.ShowWindowTalked(player, npc, CONST.窗口_商店买, CONST.BUTTON_是, 0,npcInfo)
  end
end

function Module:onSellerSelected(npc, player, seqNo, select, data)
  local items = string.split(data, '|');
  local lpPool = tonumber(Field.Get(player, 'LpPool')) or 0;
  local fpPool = tonumber(Field.Get(player, 'FpPool')) or 0;
  local gold = Char.GetData(player, CONST.CHAR_金币)
  local totalGold = 0;
  local totalLp = 0;
  local totalFp = 0;
  for i = 1, #items / 2 do
    local c = itemList[items[(i - 1) * 2 + 1] + 1]
    if c then
      local count = (tonumber(items[(i - 1) * 2 + 2]) or 0);
      if c.type == 'lp' then
        totalLp = totalLp + c.value * count;
      else
        totalFp = totalFp + c.value * count;
      end
      totalGold = totalGold + c.price * count;
    end
  end
  if lpPool >= 250000 and fpPool >= 250000 then
    NLG.SystemMessage(player, '血池上限:不能超過250000。');
    NLG.SystemMessage(player, '魔池上限:不能超過250000。');
    return
  elseif lpPool+totalLp >= 250000 and fpPool + totalFp >= 250000 then
    totalLp = (250000-lpPool);
    totalLpGold = (250000-lpPool)*1.5;
    if lpPool==250000 then
        totalLp = 0;
        totalLpGold = 0;
    end
    totalFp = (250000-fpPool);
    totalFpGold = (250000-fpPool)*1.7;
    if fpPool==250000 then
        totalFp = 0;
        totalFpGold = 0;
    end
    totalGold = totalLpGold+totalFpGold;
  elseif lpPool+totalLp >= 250000 and fpPool + totalFp < 250000 then
    totalLp = (250000-lpPool);
    totalLpGold = (250000-lpPool)*1.5;
    if lpPool==250000 then
        totalLp = 0;
        totalLpGold = 0;
    end
    totalFp = totalFp;
    totalFpGold = totalFp*1.6;
    totalGold = totalLpGold+totalFpGold;
  elseif lpPool+totalLp < 250000 and fpPool + totalFp >= 250000 then
    totalLp = totalLp;
    totalLpGold = totalLp*1.4;
    totalFp = (250000-fpPool);
    totalFpGold = (250000-fpPool)*1.7;
    if fpPool==250000 then
        totalFp = 0;
        totalFpGold = 0;
    end
    totalGold = totalLpGold+totalFpGold;
  end
  if gold < totalGold then
    NLG.SystemMessage(player, '購買所需總金額: '..totalGold..'，你的錢不夠。');
    return
  end
  Char.AddGold(player, -totalGold);
  Field.Set(player, 'LpPool', tostring(lpPool + totalLp));
  Field.Set(player, 'FpPool', tostring(fpPool + totalFp));
  NLG.UpChar(player);
  if totalLp > 0 then
    NLG.SystemMessage(player, '[血魔池] 補充血池: ' .. totalLp .. ', 共: ' .. (lpPool + totalLp));
  end
  if totalFp > 0 then
    NLG.SystemMessage(player, '[血魔池] 補充魔池: ' .. totalFp .. ', 共: ' .. (fpPool + totalFp));
  end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
