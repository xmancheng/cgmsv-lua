---模块类
local Module = ModuleBase:createModule('aptitude')

--- NPC顯示頁面
local AptitudeUIList = {
    {key = "HP_REGEN", name = "快速恢復", desc = "戰鬥中自動回復生命", curve = "STABLE",},
    {key = "MP_REGEN", name = "禪心法源", desc = "戰鬥中自動回復魔力", curve = "STABLE",},
    {key = "CRIT_RATE",name = "致命洞悉", desc = "提升暴擊發生機率　", curve = "COMBAT",},
    {key = "CRIT_DMG", name = "致命狂擊", desc = "提升暴擊傷害倍率　", curve = "COMBAT",},
    {key = "DOUBLE_HIT", name = "追擊節奏", desc = "提升二連擊觸發機率", curve = "COMBAT",},
    {key = "STATUS", name = "厄詭滲透", desc = "有機率附加異常狀態", curve = "RISK",},
    {key = "LOOT", name = "掠奪妙手", desc = "提升掉落與偷竊機率", curve = "RISK",},
    {key = "EXECUTE", name = "終結預感", desc = "有機率直接終結敵人", curve = "EXTREME",},
}
-- 適性天賦基本架構
local AdventureAptitude = {
    HP_REGEN = {id = 1,name = "快速恢復",desc = "戰鬥中自動回復生命",maxLevel = 10,},	-- 自動回復生命
    MP_REGEN = {id = 2,name = "禪心法源",desc = "戰鬥中自動回復魔力",maxLevel = 10,},	-- 自動回復魔力
    CRIT_RATE = {id = 3,name = "致命洞悉",desc = "提升暴擊發生機率",maxLevel = 10,},	-- 暴擊機率提高
    CRIT_DMG = {id = 4,name = "致命狂擊",desc = "提升暴擊傷害倍率",maxLevel = 10,},		-- 暴擊傷害提高
    DOUBLE_HIT = {id = 5,name = "追擊節奏",desc = "提升二連擊觸發機率",maxLevel = 10,},	-- 二連擊機率提高
    STATUS = {id = 6,name = "厄詭滲透",desc = "有機率附加異常狀態",maxLevel = 10,},	-- 異常附加機率提高
    LOOT = {id = 7,name = "掠奪妙手",desc = "提升掉落與偷竊機率",maxLevel = 10,},		-- 掉落 / 偷竊機率提高
    EXECUTE = {id = 8,name = "終結預感",desc = "有機率直接終結敵人",maxLevel = 10,},		-- 絕殺機率提高
}
-- 適性每級所需點數
local AdventureAptitudeCost = {
    [1] = 4,   -- Lv0 -> Lv1
    [2] = 6,   -- Lv1 -> Lv5
    [3] = 8,   -- Lv2 -> Lv6
    [4] = 12,  -- Lv3 -> Lv4
    [5] = 18,  -- Lv4 -> Lv5
    [6] = 26,  -- Lv5 -> Lv6
    [7] = 38,  -- Lv6 -> Lv7
    [8] = 54,  -- Lv7 -> Lv8
    [9] = 76,  -- Lv8 -> Lv9
    [10] = 100,  -- Lv9 -> Lv10
}
--- 適性效果機率成長曲線
local AptitudeCurve_STABLE = {	--A 型｜穩定型（前中期強，後期趨緩）快速恢復.禪心法源
    [1]=0.15, [2]=0.25, [3]=0.35, [4]=0.45, [5]=0.55,
    [6]=0.65, [7]=0.75, [8]=0.85, [9]=0.93, [10]=1.00,
}
local AptitudeCurve_COMBAT = {	--B 型｜標準戰鬥型（最佳區在 Lv6～8）致命洞悉.致命狂擊.追擊節奏
    [1]=0.08, [2]=0.15, [3]=0.23, [4]=0.32, [5]=0.42,
    [6]=0.55, [7]=0.70, [8]=0.85, [9]=0.95, [10]=1.00,
}
local AptitudeCurve_RISK = {	--C 型｜風險回報型（中後期才明顯）厄詭滲透.掠奪妙手
    [1]=0.03, [2]=0.07, [3]=0.12, [4]=0.18, [5]=0.25,
    [6]=0.38, [7]=0.55, [8]=0.72, [9]=0.88, [10]=1.00,
}
local AptitudeCurve_EXTREME = {	--D 型｜極端型（後期爆發，專精用）終結預感
    [1]=0.00, [2]=0.01, [3]=0.03, [4]=0.06, [5]=0.10,
    [6]=0.18, [7]=0.30, [8]=0.50, [9]=0.75, [10]=0.95,
}
----------------------------------------
-- 標籤對照地圖
local AdventureAptitudeCurveMap = {
    HP_REGEN    = "STABLE",   -- 快速恢復
    MP_REGEN    = "STABLE",   -- 禪心法源
    CRIT_RATE   = "COMBAT",   -- 致命洞悉
    CRIT_DMG    = "COMBAT",   -- 致命狂擊
    DOUBLE_HIT  = "COMBAT",   -- 追擊節奏
    STATUS      = "RISK",     -- 厄詭滲透
    LOOT        = "RISK",     -- 掠奪妙手
    EXECUTE    = "EXTREME",  -- 終結預感
}
local AptitudeCurves = {
    STABLE  = AptitudeCurve_STABLE,
    COMBAT  = AptitudeCurve_COMBAT,
    RISK    = AptitudeCurve_RISK,
    EXTREME = AptitudeCurve_EXTREME,
}
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self:regCallback('ItemString', Func.bind(self.tianfu, self),"LUA_useTianFu");

  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCallback, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
  self:regCallback('BattleActionTargetEvent',Func.bind(self.OnBattleActionTargetCallback,self));
  self:regCallback('ItemDropRateEvent', Func.bind(self.OnItemDropRateCallBack, self));
  self:regCallback('StealItemEmitRateEvent', Func.bind(self.OnStealItemEmitRateCallBack, self));
  self:regCallback('BattleAfterActionEvent',Func.bind(self.OnBattleAfterActionCallBack,self));

  self.aptitudeNPC = self:NPC_createNormal('勇者適性管理', 14682, { x =36 , y = 30, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.aptitudeNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local heroLv = Char.GetExtData(player, '勇者等级') or 1;
          local winMsg = "2\\n 【勇者適性天賦】　 勇者等級:"..heroLv.." 剩餘點數:" .. GetPlayerRemainAptitudePoint(player,heroLv) .."\\n"
                           .."  --------------------------------------\\n"
          for _, apt in pairs(AptitudeUIList) do
              local aptTbl = GetPlayerAptitudeTable(player)
              local level = aptTbl[apt.key] or 0;
              if (level>=10) then
                space = "";
                nextCost = "MAX";
              else
                space = " ";
                nextCost = AdventureAptitudeCost[level+1];
              end
              if (apt.key=="STATUS") then
                rate = math.floor(GetAptitudeEffectRate(apt.key, level) * 100 * 0.3);
              else
                rate = GetAptitudeEffectRate(apt.key, level) * 100;
              end
              winMsg = winMsg .." ".. apt.name .. "[Lv." .. level .. "]"..space.. apt.desc .."(".. rate .."%)" .." ".. nextCost .."\n"
          end
          NLG.ShowWindowTalked(player, self.aptitudeNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.aptitudeNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local heroLv = Char.GetExtData(player, '勇者等级') or 1;
    --print(data)
    if select > 0 then
      if (seqno == 1 and select == CONST.按钮_关闭) then
         return;
      end
    else
      if (seqno == 1 and data >= 1) then
        local apt = AptitudeUIList[data];
        local aptTbl = GetPlayerAptitudeTable(player);
        local level = aptTbl[apt.key] or 0;
        local nextCost = AdventureAptitudeCost[level+1];
        local rate = GetAptitudeEffectRate(apt.key, level) * 100;

        if (level >= 10) then
		  NLG.SystemMessage(player, "[系統]"..apt.name.."已經最高級。");
          return
        end
        if (GetPlayerRemainAptitudePoint(player,heroLv) < nextCost) then
		  NLG.SystemMessage(player, "[系統]需要 "..nextCost.." 適性點數。");
          return
        end
        if (level < 10 and nextCost and GetPlayerRemainAptitudePoint(player,heroLv) >= nextCost) then
          UpgradeAptitude(player, apt.key);
          NLG.UpChar(player);
          NLG.SystemMessage(player, "[系統]"..apt.name.."提升至Lv." .. (level + 1) .. "（消耗" .. nextCost .. "點）");
        end

        -- 點完回到初始視窗
        local heroLv = Char.GetExtData(player, '勇者等级') or 1;
        local winMsg = "2\\n 【勇者適性天賦】　 勇者等級:"..heroLv.." 剩餘點數:" .. GetPlayerRemainAptitudePoint(player,heroLv) .."\\n"
                         .."  --------------------------------------\\n"
        for _, apt in pairs(AptitudeUIList) do
            local aptTbl = GetPlayerAptitudeTable(player);
            local level = aptTbl[apt.key] or 0;
            if (level>=10) then
              space = "";
              nextCost = "MAX";
            else
              space = " ";
              nextCost = AdventureAptitudeCost[level+1];
            end
            if (apt.key=="STATUS") then
              rate = math.floor(GetAptitudeEffectRate(apt.key, level) * 100 * 0.3);
            else
              rate = GetAptitudeEffectRate(apt.key, level) * 100;
            end
            winMsg = winMsg .." ".. apt.name .. "[Lv." .. level .. "]"..space.. apt.desc .."(".. rate .."%)" .." ".. nextCost .."\n"
        end
        NLG.ShowWindowTalked(player, self.aptitudeNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
      else
        return;
      end
    end
  end)


  -- 完成委託獲得勇者經驗   
  self.tianfuNPC = self:NPC_createNormal('勇者等級管理', 14682, { x =35 , y = 30, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.tianfuNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local heroLv = Char.GetExtData(player, '勇者等级') or 1;
      SetHeroGetExp(player,heroLv,100);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.tianfuNPC, function(npc, player, _seqno, _select, _data)
  end)


end

------------------------------------------------
-- UI 顯示
function Module:aptitude(npc, player)
	local heroLv = Char.GetExtData(player, '勇者等级') or 1;
	local winMsg = "2\\n 【勇者適性天賦】　 勇者等級:"..heroLv.." 剩餘點數:" .. GetPlayerRemainAptitudePoint(player,heroLv) .."\\n"
                         .."  --------------------------------------\\n"
	for _, apt in pairs(AptitudeUIList) do
		local aptTbl = GetPlayerAptitudeTable(player);
		local level = aptTbl[apt.key] or 0;
		if (level>=10) then
			space = "";
			nextCost = "MAX";
		else
			space = " ";
			nextCost = AdventureAptitudeCost[level+1];
		end
        if (apt.key=="STATUS") then
          rate = math.floor(GetAptitudeEffectRate(apt.key, level) * 100 * 0.3);
        else
		  rate = GetAptitudeEffectRate(apt.key, level) * 100;
        end
		winMsg = winMsg .." ".. apt.name .. "[Lv." .. level .. "]"..space.. apt.desc .."(".. rate .."%)" .." ".. nextCost .."\n"
	end
	NLG.ShowWindowTalked(player, self.aptitudeNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
end
function Module:handleTalkEvent(player,msg,color,range,size)
	if (msg=="/tianfu") then
		self:aptitude(self.aptitudeNPC,player);
		return 0;
	end
	return 1;
end
-- 達成委託狀
function Module:tianfu(charIndex, targetCharIndex, itemSlot)
	local ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
	local ItemIndex = Char.GetItemIndex(charIndex,itemSlot);
	local heroLv = Char.GetExtData(charIndex, '勇者等级') or 1;
	local value = tonumber(Item.GetData(ItemIndex,CONST.道具_自用参数)) or 0;
	if (value>0) then
		if (heroLv>=100) then
			NLG.SystemMessage(charIndex,"[系統]勇者等級100已是最高級。");
			return 0
		else
			Char.DelItem(charIndex,ItemID,1);
			SetHeroGetExp(charIndex,heroLv,value);
		end
	elseif (value<0) then
		for _, apt in pairs(AptitudeUIList) do
			local aptTbl = GetPlayerAptitudeTable(charIndex);
			local level = aptTbl[apt.key] or 0;
			if (level>=1) then
				Char.DelItem(charIndex,ItemID,1);
				RevertAptitude(charIndex);
				NLG.UpChar(charIndex);
				NLG.SystemMessage(charIndex,"[系統]勇者適性天賦已重置。");
				break
			end
		end
	end
	return 0
end
------------------------------------------------
----回合後事件(快速恢復.禪心法源)
function Module:OnAfterBattleTurnCallback(battleIndex)
	local battleturn = Battle.GetTurn(battleIndex);
	for i=0, 19 do
		local charIndex = Battle.GetPlayIndex(battleIndex, i)
		if (charIndex>=0 and Char.IsPlayer(charIndex)==true and math.fmod(battleturn,4)==0) then	--間隔4回合
			local HPlevel = Char.GetExtData(charIndex, 'HP_REGEN') or 0;	-- 快速恢復
			local HPRegenRate = GetAptitudeEffectRate("HP_REGEN", HPlevel);
			local MPlevel = Char.GetExtData(charIndex, 'MP_REGEN') or 0;	-- 禪心法源
			local MPRegenRate = GetAptitudeEffectRate("MP_REGEN", MPlevel);
			if (HPRegenRate>0) then
				local hp = Char.GetData(charIndex,CONST.对象_血);
				local val = Char.GetData(charIndex,CONST.对象_回复);
				local mod_hp = math.floor(val * HPRegenRate);
				if hp<Char.GetData(charIndex,CONST.对象_最大血) then
					if hp + mod_hp <= Char.GetData(charIndex,CONST.对象_最大血) then
						Char.SetData(charIndex,CONST.对象_血, hp + mod_hp);
					else
						Char.SetData(charIndex,CONST.对象_血, Char.GetData(charIndex,CONST.对象_最大血));
					end
					NLG.SystemMessage(charIndex,"[系統]快速恢復"..mod_hp.."點生命。");
				end
				local hurt = Char.GetData(charIndex,CONST.对象_受伤);
				if (hurt>0 and HPRegenRate*100>=math.random(1,100)) then
					Char.SetData(charIndex, CONST.对象_受伤, 0);
					NLG.SystemMessage(charIndex,"[系統]快速恢復了健康。");
				end
			end
			if (MPRegenRate>0) then
				local mp = Char.GetData(charIndex,CONST.对象_魔);
				local val = Char.GetData(charIndex,CONST.对象_精神);
				local mod_mp = math.floor(val * MPRegenRate);
				if mp<Char.GetData(charIndex,CONST.对象_最大魔) then
					if mp + mod_mp <= Char.GetData(charIndex,CONST.对象_最大魔) then
						Char.SetData(charIndex,CONST.对象_魔, mp + mod_mp);
					else
						Char.SetData(charIndex,CONST.对象_魔, Char.GetData(charIndex,CONST.对象_最大魔));
					end
					NLG.SystemMessage(charIndex,"[系統]禪心法源"..mod_mp.."點魔力。");
				end
				local soul = Char.GetData(charIndex,CONST.对象_掉魂);
				if (soul>0 and MPRegenRate*100>=math.random(1,100)) then
					Char.SetData(charIndex, CONST.对象_掉魂, 0);
					NLG.SystemMessage(charIndex,"[系統]禪心召回了掉魂。");
				end
			end
			NLG.UpChar(charIndex);
		end
	end
end
----伤害事件(致命洞悉.致命狂擊.厄詭滲透)
function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
	--self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
	if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPlayer(charIndex) == true then
		if flg == CONST.DamageFlags.Normal or flg == CONST.DamageFlags.Magic then
			local ratelevel = Char.GetExtData(charIndex, 'CRIT_RATE') or 0;	-- 致命洞悉
			local CritRRate = GetAptitudeEffectRate("CRIT_RATE", ratelevel)*100;
			local dmglevel = Char.GetExtData(charIndex, 'CRIT_DMG') or 0;	-- 致命狂擊
			local CritDRate = GetAptitudeEffectRate("CRIT_DMG", dmglevel);
			if (CritRRate>=math.random(1,100)) then		--暴擊
				if (CritDRate>0) then
					damage = damage * (1.25+CritDRate);	--暴擊+暴傷
				else
					damage = damage * 1.25;				--暴擊1.25倍
				end
			end
		elseif flg == CONST.DamageFlags.Critical  then
			local ratelevel = Char.GetExtData(charIndex, 'CRIT_RATE') or 0;	-- 致命洞悉
			local CritRRate = GetAptitudeEffectRate("CRIT_RATE", ratelevel)*100;
			local dmglevel = Char.GetExtData(charIndex, 'CRIT_DMG') or 0;	-- 致命狂擊
			local CritDRate = GetAptitudeEffectRate("CRIT_DMG", dmglevel);
			if (CritRRate>=math.random(1,100)) then		--暴擊
				if (CritDRate>0) then
					damage = damage * (1.05+CritDRate);	--暴擊+暴傷
				else
					damage = damage * 1.05;				--必殺已增傷1.25*1.05=1.3125
				end
			end
		end
		local level = Char.GetExtData(charIndex, 'STATUS') or 0;	-- 厄詭滲透
		local StatusRate = GetAptitudeEffectRate("STATUS", level)*100*0.3;
		if (StatusRate>=math.random(1,100)) then
			Battle.SetBattleCharacterStatus(defCharIndex, NLG.Rand(6,11), 3);
			NLG.UpChar(defCharIndex);
		end
		return damage;
	end
	return damage;
end
----动作目标事件(追擊節奏)
function Module:OnBattleActionTargetCallback(charIndex, battleIndex, com1, com2, com3, tgl)
	--self:logDebug('OnBattleActionTargetCallback', charIndex, battleIndex, com1, com2, com3, tgl)
	if Char.IsPlayer(charIndex) == true then
		local level = Char.GetExtData(charIndex, 'DOUBLE_HIT') or 0;	-- 追擊節奏
		local DoubleRate = GetAptitudeEffectRate("DOUBLE_HIT", level)*100;
		local skillId = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_SKILLID);
		local skill_exlist = {27,28,29,30,95,1010,1011,}
		if (DoubleRate>=math.random(1,100) and CheckInTable(skill_exlist, skillId)==false) then
		--if (DoubleRate>=math.random(1,100)) then
			local new_tgl = copyTarget(tgl,2);
			NLG.SystemMessage(charIndex,"[系統]追擊節奏觸發攻擊目標2次。");
			return new_tgl
		end
		return tgl
	end
end
function copyTarget(tgl, times)
    local new_tgl = {}
    for i = 1, times do
        for _, value in ipairs(tgl) do
            table.insert(new_tgl, value);
        end
    end
    return new_tgl
end
---- 掠奪妙手
function Module:OnItemDropRateCallBack(battleIndex, enemyIndex, charIndex, itemId, rate)
	--self:logDebug('OnItemDropRateCallBack', battleIndex, enemyIndex, charIndex, itemId, rate)
	local level = Char.GetExtData(charIndex, 'LOOT') or 0;	-- 掠奪妙手
	local DropRate = GetAptitudeEffectRate("LOOT", level);
	if (DropRate>0) then
		local rate = math.floor(rate + (rate*DropRate));
		if (rate>=1000000) then
			rate=1000000;
		end
		if (Char.GetData(charIndex,CONST.对象_队聊开关) == 1) then
			NLG.SystemMessage(charIndex,"[系統]掠奪妙手發動。");
		end
		return rate
	end
	return rate
end
function Module:OnStealItemEmitRateCallBack(battleIndex, enemyIndex, charIndex, itemId, rate)
	--self:logDebug('OnStealItemEmitRateCallBack', battleIndex, enemyIndex, charIndex, itemId, rate)
	--美丽项链16900~兽人的乐器D17155范围
	--大吟酿鬼酒17700~月亮之斧17822范围
	--local aptTbl = GetPlayerAptitudeTable(charIndex);	--玩家天賦樹配點
	--local level = aptTbl["LOOT"] or 0;
	local level = Char.GetExtData(charIndex, 'LOOT') or 0;	-- 掠奪妙手
	local stealRate = GetAptitudeEffectRate("LOOT", level);
	if (stealRate>0) then
		local rate = math.floor(rate + (rate*stealRate));
		if (rate>=1000000) then
			rate=1000000;
		end
		if (Char.GetData(charIndex,CONST.对象_队聊开关) == 1) then
			NLG.SystemMessage(charIndex,"[系統]掠奪妙手發動。");
		end
		return rate
	end
	return rate
end
----26.1a战斗ACTION后事件(終結預感)
function Module:OnBattleAfterActionCallBack(battleindex, charIndex, addAction)
	--self:logDebug('OnBattleAfterActionCallback', battleindex, charIndex, addAction)
	if Char.IsPlayer(charIndex) == true then
		local level = Char.GetExtData(charIndex, 'EXECUTE') or 0;	-- 終結預感
		local ExecuteRate = GetAptitudeEffectRate("EXECUTE", level)*100;
		if (ExecuteRate>=math.random(1,100)) then
			local side = Char.GetData(charIndex,CONST.对象_战斗Side);
			if side==0 then
				tSlot = NLG.Rand(10,19);
			elseif side==1 then
				tSlot = NLG.Rand(0,9);
			end
			addAction(charIndex,CONST.BATTLE_COM.BATTLE_COM_P_ASSASSIN,tSlot,9609)	--暗殺
			NLG.SystemMessage(charIndex,"[系統]終結預感觸發隨機目標受到暗殺。");
			return 0
		end
	end
	return 0
end
------------------------------------------------
-- 勇者適性熟練度表
function GetHeroExpNeed(lv)
	if lv >= 100 then return 0 end
	return 20 * lv * lv + 80 * lv + 100
end
-- 委託狀增加經驗值
function SetHeroGetExp(player,heroLv,value)
	local heroExp = Char.GetExtData(player, '勇者经验') or 0;
	local heroExp = heroExp + value;
	-- 熟練度經驗
	local need = GetHeroExpNeed(heroLv);
	if (heroExp >= need and need~=0) then
		repeat
			need = GetHeroExpNeed(heroLv);
			Char.SetExtData(player, '勇者经验', heroExp - need);
			Char.SetExtData(player, '勇者等级', heroLv + 1);
			NLG.UpChar(player);
			heroLv = heroLv + 1;
			heroExp = heroExp - need;
		until heroExp < need and heroLv < 100
		NLG.SystemMessage(player,"[系統]勇者等級:"..heroLv.." 距離升級"..heroExp.."/"..need.."。");
	elseif (heroExp < need and need~=0) then
		Char.SetExtData(player, '勇者经验', heroExp);
		NLG.SystemMessage(player,"[系統]勇者等級:"..heroLv.." 距離升級"..heroExp.."/"..need.."。");
	end
	NLG.UpChar(player);
end
---------------------
-- 獲取玩家適性樹配點
function GetPlayerAptitudeTable(player)
	local id1 = Char.GetExtData(player, 'HP_REGEN') or 0;		-- 快速恢復
	local id2 = Char.GetExtData(player, 'MP_REGEN') or 0;		-- 禪心法源
	local id3 = Char.GetExtData(player, 'CRIT_RATE') or 0;		-- 致命洞悉
	local id4 = Char.GetExtData(player, 'CRIT_DMG') or 0;		-- 致命狂擊
	local id5 = Char.GetExtData(player, 'DOUBLE_HIT') or 0;		-- 追擊節奏
	local id6 = Char.GetExtData(player, 'STATUS') or 0;			-- 厄詭滲透
	local id7 = Char.GetExtData(player, 'LOOT') or 0;			-- 掠奪妙手
	local id8 = Char.GetExtData(player, 'EXECUTE') or 0;		-- 終結預感

	local tbl = {};
	tbl["HP_REGEN"] = id1;
	tbl["MP_REGEN"] = id2;
	tbl["CRIT_RATE"] = id3;
	tbl["CRIT_DMG"] = id4;
	tbl["DOUBLE_HIT"] = id5;
	tbl["STATUS"] = id6;
	tbl["LOOT"] = id7;
	tbl["EXECUTE"] = id8;
	return tbl
end
-- 更新玩家適性樹配點
function SetPlayerAptitudeTable(player, tbl)
	local id1 = tbl["HP_REGEN"];		-- 快速恢復
	local id2 = tbl["MP_REGEN"];		-- 禪心法源
	local id3 = tbl["CRIT_RATE"];		-- 致命洞悉
	local id4 = tbl["CRIT_DMG"];		-- 致命狂擊
	local id5 = tbl["DOUBLE_HIT"];		-- 追擊節奏
	local id6 = tbl["STATUS"];		-- 厄詭滲透
	local id7 = tbl["LOOT"];		-- 掠奪妙手
	local id8 = tbl["EXECUTE"];		-- 終結預感
	Char.SetExtData(player, 'HP_REGEN', id1);
	Char.SetExtData(player, 'MP_REGEN', id2);
	Char.SetExtData(player, 'CRIT_RATE', id3);
	Char.SetExtData(player, 'CRIT_DMG', id4);
	Char.SetExtData(player, 'DOUBLE_HIT', id5);
	Char.SetExtData(player, 'STATUS', id6);
	Char.SetExtData(player, 'LOOT', id7);
	Char.SetExtData(player, 'EXECUTE', id8);
end
-- 點擊適性天賦的升級處理
function UpgradeAptitude(player, key)
	local heroLv = Char.GetExtData(player, '勇者等级') or 1;
	local aptTbl = GetPlayerAptitudeTable(player);
	local level = aptTbl[key] or 0;

	aptTbl[key] = level + 1;
	SetPlayerAptitudeTable(player, aptTbl);
end
-- 重置適性樹配點
function RevertAptitude(player)
	Char.SetExtData(player, 'HP_REGEN', 0);
	Char.SetExtData(player, 'MP_REGEN', 0);
	Char.SetExtData(player, 'CRIT_RATE', 0);
	Char.SetExtData(player, 'CRIT_DMG', 0);
	Char.SetExtData(player, 'DOUBLE_HIT', 0);
	Char.SetExtData(player, 'STATUS', 0);
	Char.SetExtData(player, 'LOOT', 0);
	Char.SetExtData(player, 'EXECUTE', 0);
end
---------------------
-- 玩家剩餘的適性點數
function GetPlayerRemainAptitudePoint(player,lv)
	return (lv * 4) - GetPlayerUsedAptitudePoint(player)
end
-- 玩家適性已使用點數
function GetPlayerUsedAptitudePoint(player)
	local used = 0
	local aptTbl = GetPlayerAptitudeTable(player);

	for _, level in pairs(aptTbl) do
		used = used + GetAptitudeTotalCost(level);
	end

	return used
end
-- 計算某適性升到指定等級所需總點數
function GetAptitudeTotalCost(targetLevel)
	local cost = 0;
	for lv = 0, targetLevel do
		cost = cost + (AdventureAptitudeCost[lv] or 0);
	end
	return cost
end
-- 計算某適性實際效果值 critRate = GetAptitudeEffectRate("CRIT_RATE", 7)
function GetAptitudeEffectRate(aptitudeKey, level)
	local curveKey = AdventureAptitudeCurveMap[aptitudeKey];
	local curve = AptitudeCurves[curveKey];
	if not curve then return 0 end
	return curve[level] or 0
end


function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;