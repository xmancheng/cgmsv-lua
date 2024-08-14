---模块类
local Module = ModuleBase:createModule('demonSlayer')

local endlessBoss = {"無限城鬼", 14641, 1000,215,90}
local EnemySet = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local CharSet = {606038,606039,606040,606041,606042,606043,}

function SetEnemySet(Level)
	local xr = NLG.Rand(1,3);
	for i=1,#CharSet-1-xr do
		r = NLG.Rand(1,i+1+xr);
		temp=CharSet[r];
		CharSet[r]=CharSet[i];
		CharSet[i]=temp;
	end
	local ix=1;
	if Level<30 then    -- 初级
		for k=1,3 do
			EnemySet[k]=CharSet[ix];
			ix=ix+1;
		end
	elseif Level>=30 and Level<70 then    -- 高级
		for k=1,5 do
			EnemySet[k]=CharSet[ix];
			ix=ix+1;
		end
	elseif Level>70 then    -- 绝级
		for k=1,10 do
			EnemySet[k]=CharSet[ix];
			ix=ix+1;
		end
	end
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  endlessBossNPC = self:NPC_createNormal(endlessBoss[1], endlessBoss[2], { map = endlessBoss[3], x = endlessBoss[4], y = endlessBoss[5], direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(endlessBossNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_关闭 then
        return;
    end
    if seqno == 1 and data ==1 then
        local endlessBossLevel = tonumber(Field.Get(player, 'EndlessBossLevel')) or 0;
        local enemyLv = 30 + (endlessBossLevel * 2);
        if (enemyLv>=250) then
            enemyLv =250;
        end
        SetEnemySet(endlessBossLevel);
        local EnemyIdAr = EnemySet;
        local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
        local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/demonSlayer.lua", "endlessBossNPC_BattleWin", battleIndex);
    elseif seqno == 1 and data ==2 then
        Field.Set(player, 'EndlessBossLevel', 0);
        NLG.SystemMessage(player,"[系統]已重置無盡之塔討伐等級。");
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
                                             .."[　重置無限城鬼殺等級　]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, msg);
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
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(CharSet,enemyId)==true  then
			Char.SetTempData(enemy, '守住', endlessBossLevel);
			Char.SetTempData(enemy, '狂暴', endlessBossLevel);
			--Char.SetData(enemy, CONST.CHAR_形象, imageNumber[randImage]);
			--Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,108510);
			NLG.UpChar(enemy);
			if Char.GetData(player,CONST.对象_对战开关) == 1  then
				NLG.Say(player,-1,"【守住領域】【狂暴領域】",4,3);
			end
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
          if CheckInTable(CharSet,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '守住') or 0;
            local defDamage = 1 - (State*0.01);
            damage = damage * defDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(CharSet,enemyId)==true then
            local State = Char.GetTempData(charIndex, '狂暴') or 0;
            local attDamage = 1 + (State * 0.02);
            damage = damage * attDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(CharSet,enemyId)==true then
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
        {"四魂之玉小碎片",51071,1},
        {"四魂之玉小碎片",51071,1},
        {"四魂之玉小碎片",51071,2},
        {"四魂之玉小碎片",51071,2},
        {"四魂之玉中碎片",51072,1},
        {"四魂之玉中碎片",51072,1},
        {"四魂之玉中碎片",51072,2},
        {"四魂之玉中碎片",51072,2},
        {"四魂之玉大碎片",51073,1},
        {"四魂之玉大碎片",51073,1},
        {"四魂之玉大碎片",51073,1},
        {"四魂之玉大碎片",51073,1},
        {"神奇糖果",900504,100},
        {"寶可金幣",66668,5},
        {"寶可金幣",66668,10},
        {"彈珠",70053,5},
        {"彈珠",70053,10},
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
	if (endlessBossLevel>=100) then
		Field.Set(leader, 'EndlessBossLevel', 0);
	else
		Field.Set(leader, 'EndlessBossLevel', endlessBossLevel+1);
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
