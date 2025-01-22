---模块类
local Module = ModuleBase:createModule('pokeRuge')

local rugeBoss = {}
rugeBoss[1] = {"Ruge輪迴啟動", 99453, 7351,9,29}
rugeBoss[2] = {"Ruge切磋對戰", 14642, 7351,67,42}
rugeBoss[3] = {"Ruge隨機獎品", 0, 7351,67,13}
rugeBoss[4] = {"Ruge隨機獎品", 0, 7351,72,11}
rugeBoss[5] = {"Ruge隨機獎品", 0, 7351,61,12}

local EnemySet = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local MobsSet = {102100,102104,102105,102106,102109,102110,102114,102121,102125,102152,}	--杂兵
local BossSet = {102154,102155,102156,102157,103257,103261,103262,103263,}		--头目

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
	--每5级1号位放入BOSS
	if (math.fmod(Level, 10)==4 or math.fmod(Level, 10)==9) then
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
  RugeNPC = self:NPC_createNormal(rugeBoss[1][1], rugeBoss[1][2], { map = rugeBoss[1][3], x = rugeBoss[1][4], y = rugeBoss[1][5], direction = 0, mapType = 0 })
  Char.SetData(RugeNPC,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_关闭 then
        return;
    end
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    if seqno == 1 and data ==1 then
        Field.Set(player, 'RugeBossLevel', 0);
		Char.Warp(player,0,7351,25,29);
    end
  end)
  self:NPC_regTalkedEvent(RugeNPC, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "4\\n@c★魔力寶可夢肉鴿★"
                                             .."\\n歸零所有進度◇每次都是全新的開始◇\\n"
                                             .."\\n　　════════════════════\\n"
                                             .."[　肉鴿輪迴試煉啟動　]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, msg);
    end
    return
  end)


  RugeNPC2 = self:NPC_createNormal(rugeBoss[2][1], rugeBoss[2][2], { map = rugeBoss[2][3], x = rugeBoss[2][4], y = rugeBoss[2][5], direction = 0, mapType = 0 })
  Char.SetData(RugeNPC2,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeNPC2, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_否 then
        return;
    elseif seqno == 2 and select == CONST.BUTTON_是 then
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        local enemyLv = 30 + (rugeBossLevel * 2);
        if (enemyLv>=250) then
            enemyLv =250;
        end
        local EnemyIdAr = SetEnemySet(rugeBossLevel);
        local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
        local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/pokeRuge.lua", "RugeNPC_BattleWin", battleIndex);
    end
  end)
  self:NPC_regTalkedEvent(RugeNPC2, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c★魔力寶可夢肉鴿★"
                                             .."\\n進度層數: "..nowLevel.."\\n"
                                             .."\\n　　════════════════════\\n"
                                             .."[　開始切磋對戰　]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 2, msg);
    end
    return
  end)

  RugeprizeNPC1 = self:NPC_createNormal(rugeBoss[3][1], rugeBoss[3][2], { map = rugeBoss[3][3], x = rugeBoss[3][4], y = rugeBoss[3][5], direction = 0, mapType = 0 })
  Char.SetData(RugeprizeNPC1,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeprizeNPC1, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_否 then
        return;
    elseif seqno == 2 and select == CONST.BUTTON_是 then
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
		Char.Warp(player,0,7351,25,29);
    end
  end)
  self:NPC_regTalkedEvent(RugeprizeNPC1, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c★魔力寶可夢肉鴿★"
                                             .."\\n獎品說明: "..nowLevel.."\\n"
                                             .."\\n　　════════════════════\\n"
                                             .."[　領取這個特別的獎勵　]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 2, msg);
    end
    return
  end)

  --全隊補血
  RugehealNPC = self:NPC_createNormal('資深喬伊', 231052, { x = 39, y = 34, mapType = 0, map = 7351, direction = 0 });
  Char.SetData(RugehealNPC,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regTalkedEvent(RugehealNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c回復魔法值（+等量生命值）\\n\\n回復生命值\\n\\n回復寵物的生命值和魔法值\\n\\n一鍵回復全隊人物和寵物魔法、生命\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定关闭, 3, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(RugehealNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 3 and select == CONST.按钮_确定 then
        gold = Char.GetData(player, CONST.对象_金币);
        totalGold = 0;
        FpGold = 0;
        LpGold = 0;
        --計算回復總金額
        if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
          for slot = 0,4 do
            local p = Char.GetPartyMember(player,slot)
            if(p>=0) then
                local lp = Char.GetData(p, CONST.对象_血)
                local maxLp = Char.GetData(p, CONST.对象_最大血)
                local fp = Char.GetData(p, CONST.对象_魔)
                local maxFp = Char.GetData(p, CONST.对象_最大魔)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
            end
          end
        else
                local lp = Char.GetData(player, CONST.对象_血)
                local maxLp = Char.GetData(player, CONST.对象_最大血)
                local fp = Char.GetData(player, CONST.对象_魔)
                local maxFp = Char.GetData(player, CONST.对象_最大魔)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
        end
        print(FpGold,LpGold)
        if FpGold*0.5 >= LpGold then
          totalGold = FpGold;
        else
          totalGold = FpGold + LpGold - FpGold*0.5;
        end
        local msg = "\\n\\n@c全隊回復需要花費"..totalGold.."個金幣\\n\\n現有金錢是"..gold.."個金幣\\n\\n\\n要回復嗎？\\n";
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 31, msg);
      --人物寵物補血魔
      elseif seqno == 31 and select == CONST.按钮_是 then
        if gold < totalGold then
                NLG.SystemMessage(player, '金幣不足無法回復');
                return
        else
                if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
                    for slot = 0,4 do
                       local p = Char.GetPartyMember(player,slot);
                       if(p>=0) then
                           local maxLp = Char.GetData(p, CONST.对象_最大血);
                           local maxFp = Char.GetData(p, CONST.对象_最大魔);
                           Char.SetData(p, CONST.对象_血, maxLp);
                           Char.SetData(p, CONST.对象_魔, maxFp);
                           NLG.UpChar(p);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(p,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
                                  local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
                                  Char.SetData(petIndex, CONST.对象_血, maxLp);
                                  Char.SetData(petIndex, CONST.对象_魔, maxFp);
                                  Pet.UpPet(p, petIndex);
                              end
                           end
                       end
                    end
                    Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                else
                           local maxLp = Char.GetData(player, CONST.对象_最大血);
                           local maxFp = Char.GetData(player, CONST.对象_最大魔);
                           Char.SetData(player, CONST.对象_血, maxLp);
                           Char.SetData(player, CONST.对象_魔, maxFp);
                           NLG.UpChar(player);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(player,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
                                  local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
                                  Char.SetData(petIndex, CONST.对象_血, maxLp);
                                  Char.SetData(petIndex, CONST.对象_魔, maxFp);
                                  Pet.UpPet(player, petIndex);
                              end
                           end
                    Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                    --NLG.SystemMessage(player, '隊長才可使用！');
                end
        end

      end
    end
  end)


end

function Module:OnbattleStartEventCallback(battleIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		 --print(enemy, player)
                                        --local randImage = NLG.Rand(1, #imageNumber);
		local enemyId = Char.GetData(enemy, CONST.对象_ENEMY_ID);
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(MobsSet,enemyId)==true  then
			Char.SetTempData(enemy, '守住', rugeBossLevel);
			Char.SetTempData(enemy, '狂暴', rugeBossLevel);
			--Char.SetData(enemy, CONST.CHAR_形象, imageNumber[randImage]);
			--Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,108510);
			NLG.UpChar(enemy);
			if Char.GetData(player,CONST.对象_对战开关) == 1  then
				NLG.Say(player,-1,"【守住領域】【狂暴領域】",4,3);
			end
		elseif enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(BossSet,enemyId)==true  then
			Char.SetTempData(enemy, '守住', rugeBossLevel);
			Char.SetTempData(enemy, '狂暴', rugeBossLevel);
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
      local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
      --print(Round)
      if Char.IsEnemy(defCharIndex) then
          local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(MobsSet,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '守住') or 0;
            local defDamage = 1 - (State*0.001);
            damage = damage * defDamage;
            return damage;
          end
          if CheckInTable(BossSet,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '守住') or 0;
            local defDamage = 1 - (State*0.001);
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
        {"小伏特能量箱",631093,1},         --每10级掉落，10级以下无奖励
        {"小伏特能量箱",631093,2},
        {"飾品石板",73896,1},
        {"中伏特能量箱",631094,2},
        {"飾品石板",73897,1},
        {"大伏特能量箱",631095,2},
        {"水晶石板",73898,1},
        {"王者守护神",34638,1},
        {"天使之祝福",45953,1},
        {"水龙护身符",45993,1},
}
function RugeNPC_BattleWin(battleIndex, charIndex)
	--计算等第
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
	local m = rugeBossLevel+1;

	local lv = math.floor(m);
	local lvRank = math.floor(lv/10);
	local lvdrop = math.fmod(lv,10);

	if (Char.GetData(charIndex, CONST.CHAR_地图)==7351) then
--[[
	--依等第分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(0,2);
		if player>=0 and Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人 then
			--print(lv,lvRank,drop)
			for k, v in ipairs(dropMenu) do
				if k==lvRank and lvdrop==0  then
					Char.GiveItem(player, dropMenu[k][2], dropMenu[k][3]*drop);
				end
			end
			--if (rugeBossLevel>=99) then
			--	local dropPet = math.random(1,5);
			--	local PetIDMenu = {900007,900008,900009}
			--	if (dropPet<=3) then
			--		Char.AddPet(player,PetIDMenu[dropPet]);
			--	end
			--end
		end
	end
]]
	if (rugeBossLevel>=99) then
		Field.Set(leader, 'RugeBossLevel', 0);
		Char.Warp(charIndex,0,1000,225,86);
	else
		Field.Set(leader, 'RugeBossLevel', rugeBossLevel+1);
		Char.Warp(charIndex,0,7351,67,22);
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
