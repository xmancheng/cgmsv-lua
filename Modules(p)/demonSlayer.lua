---模块类
local Module = ModuleBase:createModule('demonSlayer')

local endlessBoss = {}
endlessBoss[1] = {"無限城鬼", 14641, 20300,290,454}
endlessBoss[2] = {"無限城鬼", 14641, 7342,18,25}
endlessBoss[3] = {"無限城鬼", 14641, 7343,17,25}

local EnemySet = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local MobsSet = {606102,606102,606102,606102,606102,606102,606100,606101,900003,900004,}	--杂兵
local BossSet = {900000,900001,900002,900005,900006,}		--头目

function SetEnemySet(Level)
	local xr = NLG.Rand(1,3);
	for i=1,#MobsSet-1-xr do
		r = NLG.Rand(1,i+1+xr);
		temp=MobsSet[r];
		MobsSet[r]=MobsSet[i];
		MobsSet[i]=temp;
	end
	local EnemySet = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	local ix=1;
	if Level<30 then    -- 初级
		EnemySet[1]=MobsSet[1];
		EnemySet[7]=MobsSet[2];
		EnemySet[8]=MobsSet[3];
	elseif Level>=30 and Level<70 then    -- 高级
		EnemySet[2]=MobsSet[1];
		EnemySet[3]=MobsSet[2];
		EnemySet[6]=MobsSet[3];
		EnemySet[9]=MobsSet[4];
		EnemySet[10]=MobsSet[5];
	elseif Level>=70 then    -- 绝级
		for k=1,10 do
			EnemySet[k]=MobsSet[ix];
			ix=ix+1;
		end
	end
	--每10级1号位放入BOSS
	if (math.fmod(Level, 10)==9) then
		local rand = NLG.Rand(1,#BossSet);
		EnemySet[1]=BossSet[rand];
	end
	return EnemySet;
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  endlessBossNPC = self:NPC_createNormal(endlessBoss[1][1], endlessBoss[1][2], { map = endlessBoss[1][3], x = endlessBoss[1][4], y = endlessBoss[1][5], direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(endlessBossNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_关闭 then
        return;
    end
    local endlessBossLevel = tonumber(Field.Get(player, 'EndlessBossLevel')) or 0;
    if seqno == 1 and data ==1 then
        local enemyLv = 30 + (endlessBossLevel * 2);
        if (enemyLv>=250) then
            enemyLv =250;
        end
        local EnemyIdAr = SetEnemySet(endlessBossLevel);
        local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
        local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/demonSlayer.lua", "endlessBossNPC_BattleWin", battleIndex);
    elseif seqno == 1 and data ==2 then
        if (endlessBossLevel>=29) then
                return;
        end
        if mykgold(player, 100000) then
                Field.Set(player, 'EndlessBossLevel', 29);
                NLG.SystemMessage(player,"[系統]已跳關無限城至討伐等級30。");
                return;
        else
                NLG.SystemMessage(player, "[系統]您的魔幣不夠。");
                return;
        end
    elseif seqno == 1 and data ==3 then
        if (endlessBossLevel>=49) then
                return;
        else
                if (endlessBossLevel<29) then
                    NLG.SystemMessage(player,"[系統]須先達到討伐等級30。");
                    return;
                end
        end
        if mykgold(player, 100000) then
                Field.Set(player, 'EndlessBossLevel', 49);
                NLG.SystemMessage(player,"[系統]已跳關無限城至討伐等級50。");
                return;
        else
                NLG.SystemMessage(player, "[系統]您的魔幣不夠。");
                return;
        end
    elseif seqno == 1 and data ==4 then
        if (endlessBossLevel>=69) then
                return;
        else
                if (endlessBossLevel<49) then
                    NLG.SystemMessage(player,"[系統]須先達到討伐等級50。");
                    return;
                end
        end
        if mykgold(player, 300000) then
                Field.Set(player, 'EndlessBossLevel', 69);
                NLG.SystemMessage(player,"[系統]已跳關無限城至討伐等級70。");
                return;
        else
                NLG.SystemMessage(player, "[系統]您的魔幣不夠。");
                return;
        end
    elseif seqno == 1 and data ==5 then
        Field.Set(player, 'EndlessBossLevel', 0);
        NLG.SystemMessage(player,"[系統]已重置無限城討伐等級。");
        return;
    end
  end)
  self:NPC_regTalkedEvent(endlessBossNPC, function(npc, player)
    local endlessBossLevel = tonumber(Field.Get(player, 'EndlessBossLevel')) or 0;
    local nowLevel = endlessBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "4\\n@c★無限城鬼殺隊任務★"
                                             .."\\n進度等級: "..nowLevel.."\\n"
                                             .."\\n　　════════════════════\\n"
                                             .."[　參加鬼舞辻無慘討伐　]\\n"
                                             .."[　跳關至30級資格10萬　]\\n"
                                             .."[　跳關至50級資格10萬　]\\n"
                                             .."[　跳關至70級資格30萬　]\\n"
                                             .."[　重置無限城鬼殺等級　]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, msg);
    end
    return
  end)


  endlessBossNPC2 = self:NPC_createNormal(endlessBoss[2][1], endlessBoss[2][2], { map = endlessBoss[2][3], x = endlessBoss[2][4], y = endlessBoss[2][5], direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(endlessBossNPC2, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_否 then
        return;
    elseif seqno == 2 and select == CONST.BUTTON_是 then
        local endlessBossLevel = tonumber(Field.Get(player, 'EndlessBossLevel')) or 0;
        local enemyLv = 30 + (endlessBossLevel * 2);
        if (enemyLv>=250) then
            enemyLv =250;
        end
        local EnemyIdAr = SetEnemySet(endlessBossLevel);
        local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
        local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/demonSlayer.lua", "endlessBossNPC_BattleWin", battleIndex);
    end
  end)
  self:NPC_regTalkedEvent(endlessBossNPC2, function(npc, player)
    local endlessBossLevel = tonumber(Field.Get(player, 'EndlessBossLevel')) or 0;
    local nowLevel = endlessBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c★無限城鬼殺隊任務★"
                                             .."\\n進度等級: "..nowLevel.."\\n"
                                             .."\\n　　════════════════════\\n"
                                             .."[　開始無限城殺鬼討伐　]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 2, msg);
    end
    return
  end)

  endlessBossNPC3 = self:NPC_createNormal(endlessBoss[3][1], endlessBoss[3][2], { map = endlessBoss[3][3], x = endlessBoss[3][4], y = endlessBoss[3][5], direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(endlessBossNPC3, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_否 then
        return;
    elseif seqno == 2 and select == CONST.BUTTON_是 then
        local endlessBossLevel = tonumber(Field.Get(player, 'EndlessBossLevel')) or 0;
        local enemyLv = 30 + (endlessBossLevel * 2);
        if (enemyLv>=250) then
            enemyLv =250;
        end
        local EnemyIdAr = SetEnemySet(endlessBossLevel);
        local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
        local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/demonSlayer.lua", "endlessBossNPC_BattleWin", battleIndex);
    end
  end)
  self:NPC_regTalkedEvent(endlessBossNPC3, function(npc, player)
    local endlessBossLevel = tonumber(Field.Get(player, 'EndlessBossLevel')) or 0;
    local nowLevel = endlessBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c★無限城鬼殺隊任務★"
                                             .."\\n進度等級: "..nowLevel.."\\n"
                                             .."\\n　　════════════════════\\n"
                                             .."[　開始無限城殺鬼討伐　]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 2, msg);
    end
    return
  end)

end

function Module:OnbattleStartEventCallback(battleIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local endlessBossLevel = tonumber(Field.Get(leader, 'EndlessBossLevel')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		 --print(enemy, player)
                                        --local randImage = NLG.Rand(1, #imageNumber);
		local enemyId = Char.GetData(enemy, CONST.对象_ENEMY_ID);
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(MobsSet,enemyId)==true  then
			Char.SetTempData(enemy, '守住', endlessBossLevel);
			Char.SetTempData(enemy, '狂暴', endlessBossLevel);
			--Char.SetData(enemy, CONST.CHAR_形象, imageNumber[randImage]);
			--Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,108510);
			NLG.UpChar(enemy);
			if Char.GetData(player,CONST.对象_对战开关) == 1  then
				NLG.Say(player,-1,"【守住領域】【狂暴領域】",4,3);
			end
		elseif enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(BossSet,enemyId)==true  then
			Char.SetTempData(enemy, '守住', endlessBossLevel);
			Char.SetTempData(enemy, '狂暴', endlessBossLevel);
			NLG.UpChar(enemy);
		end
	end
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local Round = Battle.GetTurn(battleIndex);
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
          leader = leader2
      end
      local endlessBossLevel = tonumber(Field.Get(leader, 'EndlessBossLevel')) or 0;
      --print(Round)
      if Char.IsEnemy(defCharIndex) then
          local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(MobsSet,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '守住') or 0;
            local defDamage = 1 - (State*0.01);
            damage = damage * defDamage;
            return damage;
          end
          if CheckInTable(BossSet,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '守住') or 0;
            local defDamage = 1 - (State*0.01);
            damage = damage * defDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(MobsSet,enemyId)==true then
            local State = Char.GetTempData(charIndex, '狂暴') or 0;
            local attDamage = 1 + (State * 0.02);
            damage = damage * attDamage;
            return damage;
          end
          if CheckInTable(BossSet,enemyId)==true then
            local State = Char.GetTempData(charIndex, '狂暴') or 0;
            local attDamage = 1 + (State * 0.02);
            damage = damage * attDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(MobsSet,enemyId)==true then
            local State = Char.GetTempData(charIndex, '狂暴') or 0;
            local attDamage = 1 + (State * 0.01);
            damage = damage * attDamage;
            return damage;
          end
          if CheckInTable(BossSet,enemyId)==true then
            local State = Char.GetTempData(charIndex, '狂暴') or 0;
            local attDamage = 1 + (State * 0.01);
            damage = damage * attDamage;
            return damage;
          end
       end
  return damage;
end

local dropMenu={
        {"四魂之玉小碎片",51071,1},         --每10级一个掉落区间，10级以下无奖励
        {"四魂之玉小碎片",51071,2},
        {"四魂之玉中碎片",51072,1},
        {"四魂之玉中碎片",51072,2},
        {"四魂之玉大碎片",51073,1},
        {"神奇糖果",900504,100},
        {"寶可金幣",66668,5},
        {"寶可金幣",66668,10},
        {"彈珠",70053,5},
        {"寵物招式學習機",75017,1},
}
function endlessBossNPC_BattleWin(battleIndex, charIndex)
	--计算等第
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local endlessBossLevel = tonumber(Field.Get(leader, 'EndlessBossLevel')) or 0;
	local m = endlessBossLevel+1;

	local lv = math.floor(m);
	local lvRank = math.floor(lv/10);
	--依等第分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(0,2);
		if player>=0 and Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人 then
			--print(lv,lvRank,drop)
			for k, v in ipairs(dropMenu) do
				if k==lvRank and lvRank>=1  then
					Char.GiveItem(player, dropMenu[k][2], dropMenu[k][3]*drop);
				end
			end
		end
	end
	if (endlessBossLevel>=99) then
		Field.Set(leader, 'EndlessBossLevel', 0);
		Char.Warp(charIndex,0,20300,293,456);
	else
		Field.Set(leader, 'EndlessBossLevel', endlessBossLevel+1);
		if (endlessBossLevel==0) then
			Char.Warp(charIndex,0,7342,4,32);
		elseif (endlessBossLevel==29) then
			Char.Warp(charIndex,0,7343,35,3);
		elseif (endlessBossLevel==49) then
			Char.Warp(charIndex,0,7342,24,41);
		elseif (endlessBossLevel==69) then
			Char.Warp(charIndex,0,7343,35,3);
		end
	end
	Battle.UnsetWinEvent(battleIndex);
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function mykgold(player,gold)
	local tjb = Char.GetData(player,CONST.对象_金币);
	tjb = tjb - gold; 
	if (tjb >= 0) then
		Char.SetData(player,CONST.对象_金币,tjb);
		NLG.UpChar(player);
		NLG.SystemMessage(player,"交出了"..gold.." G魔幣。");
		return true;
	end
	return false;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
