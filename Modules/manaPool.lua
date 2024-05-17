local Module = ModuleBase:createModule('manaPool')
local _ = require "lua/Modules/underscore"
local itemList = {
  { name = '血池補充（1000LP）', image = 27243, price = 1500, desc = '補充血池使用量1000點', count = 1, maxCount = 999, value = 1000, type = 'lp' },
  { name = '血池補充（10000LP）', image = 27243, price = 14500, desc = '補充血池使用量10000點', count = 1, maxCount = 999, value = 10000, type = 'lp' },
  { name = '血池補充（50000LP）', image = 27243, price = 70000, desc = '補充血池使用量50000點', count = 1, maxCount = 999, value = 50000, type = 'lp' },
  { name = '魔池補充（1000FP）', image = 26206, price = 1700, desc = '補充魔池使用量1000點', count = 1, maxCount = 999, value = 1000, type = 'fp' },
  { name = '魔池補充（10000FP）', image = 26206, price = 16500, desc = '補充魔池使用量10000點', count = 1, maxCount = 999, value = 10000, type = 'fp' },
  { name = '魔池補充（50000FP）', image = 26206, price = 80000, desc = '補充魔池使用量50000點', count = 1, maxCount = 999, value = 50000, type = 'fp' },
}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('血魔池', 99262, { map = 1000, x = 230, y = 58, direction = 6, mapType = 0 })
  self:NPC_regTalkedEvent(npc, Func.bind(self.onSellerTalked, self))
  self:NPC_regWindowTalkedEvent(npc, Func.bind(self.onSellerSelected, self));
  --self:regCallback('BattleStartEvent', Func.bind(self.onbattleStartEventCallback, self))
  --self:regCallback('ResetCharaBattleStateEvent', Func.bind(self.onBattleReset, self))
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
	elseif check_msg(msg,"/shm ") then
		local value= string.find(msg,"%s");
		local LpFpSet = string.sub(msg,value+1);
		--print(LpFpSet)
		local part = string.split(LpFpSet, ',');
		local setLp_c=nil; local setFp_c=nil; local setLp_p=nil; local setFp_p=nil;
		for k,v in ipairs(part) do
			if k==1 then
				setLp_c=tonumber(v)
			elseif k==2 then
				setFp_c=tonumber(v)
			elseif k==3 then
 				setLp_p=tonumber(v)
			elseif k==4 then
				setFp_p=tonumber(v)
			end
		end
		if (setLp_c==nil or setFp_c==nil or setLp_p==nil or setFp_p==nil) then
			NLG.SystemMessage(charIndex, '設定格式錯誤，例如: /shm 20,20,20,20');
			Field.Set(charIndex, 'LpFpSet', tostring("100,100,100,100"));
			return 0;
		else			
			NLG.SystemMessage(charIndex, '[血魔池]人物 血池:' ..setLp_c.. '%,魔池:' ..setFp_c.. '%。寵物 血池:' ..setLp_p.. '%,魔池:' ..setFp_p.. '%。');
			Field.Set(charIndex, 'LpFpSet', tostring(LpFpSet));
			return 0;
		end
	end
	return 1;
end
function check_msg(msg,check_msg)
	if(msg == nil) then
		return;
	end

   if(string.sub(msg,1,string.len(check_msg))==check_msg)then
		return true;
   end
   return false;
end

function Module:onBattleOver(battleIndex)
  local poss={}
  for i = 0, 9 do
    table.insert(poss,i)
  end

 _.each(poss,function(pos) 
  local charIndex = Battle.GetPlayer(battleIndex, pos);
  if Char.IsDummy(charIndex) then
    return
  end
  local name = Char.GetData(charIndex,CONST.CHAR_名字);
  local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
  local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
  if lpPool <= 0 and fpPool <= 0 then
    NLG.SystemMessage(charIndex, '[血魔池] 剩餘容量不足，請及時補充。');
    return
  end

  local LpFpSet = tostring(Field.Get(charIndex, 'LpFpSet')) or 0;
  local setLp_c=100; local setFp_c=100; local setLp_p=100; local setFp_p=100;
  if (type(LpFpSet)=="string") then
      local part = string.split(LpFpSet, ',');
      for k,v in ipairs(part) do
          if k==1 then
              setLp_c=tonumber(v)
          elseif k==2 then
              setFp_c=tonumber(v)
          elseif k==3 then
              setLp_p=tonumber(v)
          elseif k==4 then
              setFp_p=tonumber(v)
          end
      end
  end

  local lp = Char.GetData(charIndex, CONST.CHAR_血)
  local maxLp = Char.GetData(charIndex, CONST.CHAR_最大血)
  local fp = Char.GetData(charIndex, CONST.CHAR_魔)
  local maxFp = Char.GetData(charIndex, CONST.CHAR_最大魔)
  if lpPool > 0 and lp < math.floor(maxLp*setLp_c/100) then
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

  if fpPool > 0 and fp < math.floor(maxFp*setFp_c/100) then
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

  Char.SetData(charIndex, CONST.CHAR_血, maxLp)
  Char.SetData(charIndex, CONST.CHAR_魔, maxFp)
  NLG.UpChar(charIndex);

  local petIndex = Char.GetData(charIndex, CONST.CHAR_战宠);
  if petIndex >= 0 then
    petIndex = Char.GetPet(charIndex, petIndex);
    lp = Char.GetData(petIndex, CONST.CHAR_血)
    maxLp = Char.GetData(petIndex, CONST.CHAR_最大血)
    fp = Char.GetData(petIndex, CONST.CHAR_魔)
    maxFp = Char.GetData(petIndex, CONST.CHAR_最大魔)
    if lpPool > 0 and lp < math.floor(maxLp*setLp_p/100) then
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

    if fpPool > 0 and fp < math.floor(maxFp*setFp_p/100) then
      if Char.GetData(charIndex,%对象_组队开关%) == 1  then
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

  end)
end

function Module:onSellerTalked(npc, player)
  if NLG.CanTalk(npc, player) then
    NLG.ShowWindowTalked(player, npc, CONST.窗口_商店买, CONST.BUTTON_是, 0,
      self:NPC_buildBuyWindowData(101024, '血魔池補充', '充值血魔池', '金錢不足', '背包已滿', itemList))
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
