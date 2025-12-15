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

local goldSurviveOn = 1;

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('血魔池補充員', 99262,{ map=777, x=33, y=34, direction=0, mapType=0})
  self:NPC_regTalkedEvent(npc, Func.bind(self.onSellerTalked, self))
  self:NPC_regWindowTalkedEvent(npc, Func.bind(self.onSellerSelected, self));
  --self:regCallback('BattleStartEvent', Func.bind(self.onbattleStartEventCallback, self))
  --self:regCallback('ResetCharaBattleStateEvent', Func.bind(self.onBattleReset, self))
  self:regCallback('BattleOverEvent', Func.bind(self.onBattleOver, self))
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))

  self.manaPoolNPC = self:NPC_createNormal('血魔池管理員', 99262,{ map=777, x=34, y=34, direction=0, mapType=0})
  self:NPC_regWindowTalkedEvent(self.manaPoolNPC,Func.bind(self.click,self))
  self:NPC_regTalkedEvent(self.manaPoolNPC,Func.bind(self.facetonpc,self))
end

--远程按钮UI呼叫
function Module:manaPoolInfo(npc, player)
		local LpFpSet = Field.Get(player, 'LpFpSet');
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
			Field.Set(player, 'LpFpSet', tostring("100,100,100,100"));
		end
		local LpFpSet = Field.Get(player, 'LpFpSet');
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
		local lpPool = tonumber(Field.Get(player, 'LpPool')) or 0;
		local fpPool = tonumber(Field.Get(player, 'FpPool')) or 0;
		local maxLp_Limit = Char.GetData(player, CONST.对象_最大血)*30;
		local maxFp_Limit = Char.GetData(player, CONST.对象_最大魔)*30;
		local msg = "5\\n　　　　　　　　【血魔池總資訊】\\n"
					.. "　　輸入指令/add將物品欄[料理、藥水]全部注入\\n"
					.. "　　等級轉換%:45,50,55,60,65,70,75,80,85,90\\n"
					.. "　　血池共:"..lpPool.."/"..maxLp_Limit..",魔池共:"..fpPool.."/"..maxFp_Limit.."\\n\\n"
					.. "　　　　設置人物恢復　血量:" ..setLp_c.. "%\\n"
					.. "　　　　設置人物恢復　魔量:" ..setFp_c.. "%\\n"
					.. "　　　　設置寵物恢復　血量:" ..setLp_p.. "%\\n"
					.. "　　　　設置寵物恢復　魔量:" ..setFp_p.. "%\\n"
		NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
end

function Module:click(npc,player,_seqno,_select,_data)--窗口中点击触发
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
	local LpFpSet = Field.Get(player, 'LpFpSet');
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
	--上页16 下页32 取消2
	if select > 0 then
		if (seqno == 1 and select == CONST.按钮_关闭) then
			return;
		elseif (select == CONST.按钮_否) then
			return;
		elseif (seqno == 11 and select == CONST.按钮_是 and data >= 0) then
			if (math.ceil(data)==data and data<=100) then
				Field.Set(player, 'LpFpSet', tostring(""..data..","..setFp_c..","..setLp_p..","..setFp_p..""));
				NLG.SystemMessage(player, '[血魔池]人物 血池:' ..data.. '%,魔池:' ..setFp_c.. '%。寵物 血池:' ..setLp_p.. '%,魔池:' ..setFp_p.. '%。');
			end
		elseif (seqno == 12 and select == CONST.按钮_是 and data >= 0) then
			if (math.ceil(data)==data and data<=100) then
				Field.Set(player, 'LpFpSet', tostring(""..setLp_c..","..data..","..setLp_p..","..setFp_p..""));
				NLG.SystemMessage(player, '[血魔池]人物 血池:' ..setLp_c.. '%,魔池:' ..data.. '%。寵物 血池:' ..setLp_p.. '%,魔池:' ..setFp_p.. '%。');
			end
		elseif (seqno == 13 and select == CONST.按钮_是 and data >= 0) then
			if (math.ceil(data)==data and data<=100) then
				Field.Set(player, 'LpFpSet', tostring(""..setLp_c..","..setFp_c..","..data..","..setFp_p..""));
				NLG.SystemMessage(player, '[血魔池]人物 血池:' ..setLp_c.. '%,魔池:' ..setFp_c.. '%。寵物 血池:' ..data.. '%,魔池:' ..setFp_p.. '%。');
			end
		elseif (seqno == 14 and select == CONST.按钮_是 and data >= 0) then
			if (math.ceil(data)==data and data<=100) then
				Field.Set(player, 'LpFpSet', tostring(""..setLp_c..","..setFp_c..","..setLp_p..","..data..""));
				NLG.SystemMessage(player, '[血魔池]人物 血池:' ..setLp_c.. '%,魔池:' ..setFp_c.. '%。寵物 血池:' ..setLp_p.. '%,魔池:' ..data.. '%。');
			end
		end
	else
		if (data==1) then
			local winMsg = "　　　　　　　　$1【血魔池恢復設置】\\n"
				.."═════════════════════\\n"
				.."　　$4人物血量$0低於多少百分比啟用自動恢復\\n\\n"
				.."　　輸入0則$5關閉$0自動恢復人物血量\\n\\n"
				.."\\n"
				.."\\n請確認輸入之百分比：\\n";
			NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.窗口_输入框, CONST.按钮_是否, 11, winMsg);
		elseif (data==2) then
			local winMsg = "　　　　　　　　$1【血魔池恢復設置】\\n"
				.."═════════════════════\\n"
				.."　　$4人物魔量$0低於多少百分比啟用自動恢復\\n\\n"
				.."　　輸入0則$5關閉$0自動恢復人物魔量\\n\\n"
				.."\\n"
				.."\\n請確認輸入之百分比：\\n";
			NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.窗口_输入框, CONST.按钮_是否, 12, winMsg);
		elseif (data==3) then
			local winMsg = "　　　　　　　　$1【血魔池恢復設置】\\n"
				.."═════════════════════\\n"
				.."　　$4寵物血量$0低於多少百分比啟用自動恢復\\n\\n"
				.."　　輸入0則$5關閉$0自動恢復寵物血量\\n\\n"
				.."\\n"
				.."\\n請確認輸入之百分比：\\n";
			NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.窗口_输入框, CONST.按钮_是否, 13, winMsg);
		elseif (data==4) then
			local winMsg = "　　　　　　　　$1【血魔池恢復設置】\\n"
				.."═════════════════════\\n"
				.."　　$4寵物魔量$0低於多少百分比啟用自動恢復\\n\\n"
				.."　　輸入0則$5關閉$0自動恢復寵物魔量\\n\\n"
				.."\\n"
				.."\\n請確認輸入之百分比：\\n";
			NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.窗口_输入框, CONST.按钮_是否, 14, winMsg);
		end
	end
end

function Module:facetonpc(npc,player)
	if NLG.CanTalk(npc,player) == true then
		local LpFpSet = Field.Get(player, 'LpFpSet');
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
			Field.Set(player, 'LpFpSet', tostring("100,100,100,100"));
		end
		local LpFpSet = Field.Get(player, 'LpFpSet');
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
		local lpPool = tonumber(Field.Get(player, 'LpPool')) or 0;
		local fpPool = tonumber(Field.Get(player, 'FpPool')) or 0;
		local maxLp_Limit = Char.GetData(player, CONST.对象_最大血)*30;
		local maxFp_Limit = Char.GetData(player, CONST.对象_最大魔)*30;
		local msg = "5\\n　　　　　　　　【血魔池總資訊】\\n"
					.. "　　輸入指令/add將物品欄[料理、藥水]全部注入\\n"
					.. "　　等級轉換%:45,50,55,60,65,70,75,80,85,90\\n"
					.. "　　血池共:"..lpPool.."/"..maxLp_Limit..",魔池共:"..fpPool.."/"..maxFp_Limit.."\\n\\n"
					.. "　　　　設置人物恢復　血量:" ..setLp_c.. "%\\n"
					.. "　　　　設置人物恢復　魔量:" ..setFp_c.. "%\\n"
					.. "　　　　設置寵物恢復　血量:" ..setLp_p.. "%\\n"
					.. "　　　　設置寵物恢復　魔量:" ..setFp_p.. "%\\n"
		NLG.ShowWindowTalked(player, self.manaPoolNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
	end
	return
end

local Item_SHM_Lv = {45, 50, 55, 60, 65, 70, 75, 80, 85, 90}	--药水、料理注入百分比

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/add") then
		--local maxLp_Limit = Char.GetData(charIndex, CONST.对象_最大血)*30;
		--local maxFp_Limit = Char.GetData(charIndex, CONST.对象_最大魔)*30;
		for slot=7,27 do
			local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
			local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
			local ItemIndex = Char.GetItemIndex(charIndex, slot);
			if (ItemIndex>0) then
				local itemType = Item.GetData(ItemIndex,CONST.道具_类型);
				local itemLv = Item.GetData(ItemIndex,CONST.道具_等级);
				local ItemNum = tonumber(Item.GetData(ItemIndex,CONST.道具_堆叠数));
				if (itemType==43) then	--药品
					local Item_LV = (Item_SHM_Lv[itemLv] or 100)/100;
					local msg1 = Item.GetData(ItemIndex,CONST.道具_自用参数);
					local val1,val2 = string.find(msg1,"LP");
					local msg_Lp = string.sub(msg1,val2+1,-1);
					local Lp1 = tonumber(msg_Lp) or 0;
					local totalLp = math.floor(Item_LV * Lp1 * ItemNum);
					Field.Set(charIndex, 'LpPool', tostring(lpPool + totalLp));
					Char.DelItemBySlot(charIndex, slot);
					NLG.UpChar(charIndex);	
				elseif (itemType==23) then	--料理
					local Item_LV = (Item_SHM_Lv[itemLv] or 100)/100;
					local msg1 = Item.GetData(ItemIndex,CONST.道具_自用参数);
					local val3,val4 = string.find(msg1,"FP");
					local msg_Fp = string.sub(msg1,val4+1,-1);
					local Fp1 = tonumber(msg_Fp) or 0;
					local totalFp = math.floor(Item_LV * Fp1 * ItemNum);
					Field.Set(charIndex, 'FpPool', tostring(fpPool + totalFp));
					Char.DelItemBySlot(charIndex, slot);
					NLG.UpChar(charIndex);
				end
			end
		end
		local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
		local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
		NLG.SystemMessage(charIndex, '[血魔池] 血池共: ' .. lpPool .. ', 魔池共: ' .. fpPool .. '。');
		return 0;
	elseif (msg=="/shm" or msg=="/SHM" ) then
		local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
		local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
		local maxLp_Limit = Char.GetData(charIndex, CONST.对象_最大血)*30;
		local maxFp_Limit = Char.GetData(charIndex, CONST.对象_最大魔)*30;
		NLG.SystemMessage(charIndex, '[血魔池] 血池共: ' .. lpPool .. '/'..maxLp_Limit..', 魔池共: ' .. fpPool .. '/'..maxFp_Limit..'。');
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
  local charIndex = Battle.GetPlayIndex(battleIndex, pos);
  if Char.IsDummy(charIndex) then
    return
  end
  local name = Char.GetData(charIndex,CONST.对象_名字);
  local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
  local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
  if lpPool <= 0 and fpPool <= 0 then
    --NLG.SystemMessage(charIndex, '[血魔池] 剩餘容量不足，請及時補充。');
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
  else
      if (setLp_c==nil or setFp_c==nil or setLp_p==nil or setFp_p==nil) then
        Field.Set(charIndex, 'LpFpSet', tostring("100,100,100,100"));
        setLp_c=100;        setFp_c=100;        setLp_p=100;        setFp_p=100;
      end
  end

  local lp = Char.GetData(charIndex, CONST.对象_血)
  local maxLp = Char.GetData(charIndex, CONST.对象_最大血)
  local fp = Char.GetData(charIndex, CONST.对象_魔)
  local maxFp = Char.GetData(charIndex, CONST.对象_最大魔)
  if lpPool > 0 and lp < math.floor(maxLp*setLp_c/100) then
    if Char.GetData(charIndex,CONST.对象_组队开关) == 1 then
      lpPool = lpPool - maxLp + lp;
      if lpPool < 0 then
        maxLp = maxLp + lpPool;
        lpPool = 0;
      end
    else
      maxLp = lp;
    end
    if Char.GetData(charIndex,CONST.对象_队聊开关) == 1 then
        NLG.SystemMessage(charIndex, '[血魔池] 已為'..name..'恢復: ' .. (maxLp - lp) .. 'LP, 血池剩餘: ' .. lpPool);
    end
  else
    maxLp = lp;
  end

  if fpPool > 0 and fp < math.floor(maxFp*setFp_c/100) then
    if Char.GetData(charIndex,CONST.对象_组队开关) == 1 then
      fpPool = fpPool - maxFp + fp;
      if fpPool < 0 then
        maxFp = maxFp + fpPool;
        fpPool = 0;
      end
    else
      maxFp = fp;
    end
    if Char.GetData(charIndex,CONST.对象_队聊开关) == 1 then
        NLG.SystemMessage(charIndex, '[血魔池] 已為'..name..'恢復: ' .. (maxFp - fp) .. 'FP, 魔池剩餘: ' .. fpPool);
    end
  else
    maxFp = fp;
  end

  Char.SetData(charIndex, CONST.对象_血, maxLp)
  Char.SetData(charIndex, CONST.对象_魔, maxFp)
  NLG.UpChar(charIndex);

  --金币支付
  local gold = Char.GetData(charIndex, CONST.对象_金币);
  if (goldSurviveOn==1 and gold>0) then
    local lp = Char.GetData(charIndex, CONST.对象_血)
    local maxLp = Char.GetData(charIndex, CONST.对象_最大血)
    local totalLpGold = maxLp - lp;
    if (lp<maxLp and gold>=totalLpGold) then
      Char.SetData(charIndex, CONST.对象_血, maxLp);
      Char.AddGold(charIndex, -totalLpGold);
      NLG.UpChar(charIndex);
      if Char.GetData(charIndex,CONST.对象_队聊开关) == 1 then
        NLG.SystemMessage(charIndex, '[金幣池] 已消耗'..totalLpGold..'G為'..name..'恢復: ' .. (maxLp - lp) .. 'LP');
      end
    end
    local gold = gold - totalLpGold;
    local fp = Char.GetData(charIndex, CONST.对象_魔)
    local maxFp = Char.GetData(charIndex, CONST.对象_最大魔)
    local totalFpGold = (maxFp - fp)*0.5;
    if (fp<maxFp and gold>=totalFpGold) then
      Char.SetData(charIndex, CONST.对象_魔, maxFp);
      Char.AddGold(charIndex, -totalFpGold);
      NLG.UpChar(charIndex);
      if Char.GetData(charIndex,CONST.对象_队聊开关) == 1 then
        NLG.SystemMessage(charIndex, '[金幣池] 已消耗'..totalFpGold..'G為'..name..'恢復: ' .. (maxFp - fp) .. 'FP');
      end
    end
  end

  local petIndex = Char.GetData(charIndex, CONST.对象_战宠);
  if petIndex >= 0 then
    petIndex = Char.GetPet(charIndex, petIndex);
    lp = Char.GetData(petIndex, CONST.对象_血)
    maxLp = Char.GetData(petIndex, CONST.对象_最大血)
    fp = Char.GetData(petIndex, CONST.对象_魔)
    maxFp = Char.GetData(petIndex, CONST.对象_最大魔)
    if lpPool > 0 and lp < math.floor(maxLp*setLp_p/100) then
      if Char.GetData(charIndex,CONST.对象_组队开关) == 1 then
        lpPool = lpPool - maxLp + lp;
        if lpPool < 0 then
          maxLp = maxLp + lpPool;
          lpPool = 0;
        end
      else
        maxLp = lp;
      end
      if Char.GetData(charIndex,CONST.对象_队聊开关) == 1 then
          NLG.SystemMessage(charIndex, '[血魔池] 已恢復寵物: ' .. (maxLp - lp) .. 'LP, 血池剩餘: ' .. lpPool);
      end
    else
      maxLp = lp;
    end

    if fpPool > 0 and fp < math.floor(maxFp*setFp_p/100) then
      if Char.GetData(charIndex,CONST.对象_组队开关) == 1  then
        fpPool = fpPool - maxFp + fp;
        if fpPool < 0 then
          maxFp = maxFp + fpPool;
          fpPool = 0;
        end
      else
        maxFp = fp;
      end
      if Char.GetData(charIndex,CONST.对象_队聊开关) == 1 then
          NLG.SystemMessage(charIndex, '[血魔池] 已恢復寵物: ' .. (maxFp - fp) .. 'FP, 魔池剩餘: ' .. fpPool);
      end
    else
      maxFp = fp;
    end

    Char.SetData(petIndex, CONST.对象_血, maxLp)
    Char.SetData(petIndex, CONST.对象_魔, maxFp)
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
  local gold = Char.GetData(player, CONST.对象_金币)
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
  maxLp_Limit = Char.GetData(player, CONST.对象_最大血)*30;
  maxFp_Limit = Char.GetData(player, CONST.对象_最大魔)*30;
  if lpPool >= maxLp_Limit and fpPool >= maxFp_Limit then
    NLG.SystemMessage(player, '血池上限:不能超過'..maxLp_Limit..'。');
    NLG.SystemMessage(player, '魔池上限:不能超過'..maxFp_Limit..'。');
    return
  elseif lpPool+totalLp >= maxLp_Limit and fpPool + totalFp >= maxFp_Limit then
    totalLp = (maxLp_Limit-lpPool);
    totalLpGold = (maxLp_Limit-lpPool)*1.5;
    if lpPool==maxLp_Limit then
        totalLp = 0;
        totalLpGold = 0;
    end
    totalFp = (maxFp_Limit-fpPool);
    totalFpGold = (maxFp_Limit-fpPool)*1.7;
    if fpPool==maxFp_Limit then
        totalFp = 0;
        totalFpGold = 0;
    end
    totalGold = totalLpGold+totalFpGold;
  elseif lpPool+totalLp >= maxLp_Limit and fpPool + totalFp < maxFp_Limit then
    totalLp = (maxLp_Limit-lpPool);
    totalLpGold = (maxLp_Limit-lpPool)*1.5;
    if lpPool==maxLp_Limit then
        totalLp = 0;
        totalLpGold = 0;
    end
    totalFp = totalFp;
    totalFpGold = totalFp*1.6;
    totalGold = totalLpGold+totalFpGold;
  elseif lpPool+totalLp < maxLp_Limit and fpPool + totalFp >= maxFp_Limit then
    totalLp = totalLp;
    totalLpGold = totalLp*1.4;
    totalFp = (maxFp_Limit-fpPool);
    totalFpGold = (maxFp_Limit-fpPool)*1.7;
    if fpPool==maxFp_Limit then
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
