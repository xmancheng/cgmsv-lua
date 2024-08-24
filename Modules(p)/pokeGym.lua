---模块类
local Module = ModuleBase:createModule('pokeGym')

local gymBoss = {}
gymBoss[1] = {"阿楓", 14641, 1000,226,88}

local EncountSet = {
    { Type=1, encountId_1st=600082, encountId_2nd=600083, EnId_1st= {600084,600084,600086,600087}, encountId_3rd=600085, EnId_2nd = {600086,600087,600087} },	--Bug(encountId)
}

local GymsEnemy = {600082,600083,600084,600085,600086,600087,}	--EnemyId
local restraintMap = {
    { 600019,600082,600083,600084,600085,600086,600087 },	--虫属性
    { 600028,600069,600070 },	--草属性
    { 606033 },	--电属性
    { 600030,600072 },	--水属性
    { 600074,600077 },	--一般属性
    { 600018, },	--幽灵属性
    { 600073 },	--超能力属性
    { 606030 },	--冰属性
    { 600029,606036,600071 },	--火属性
    { 600068,600075,600081 },	--飞行属性
    { 600078,600080 },	--格斗属性
    { 600076,600079 },	--岩石属性
  }
  local attr = {
    { 1, 2, 1, 1, 1, 0.5, 1, 1, 0.5, 0.5, 0.5, 1 },
    { 0.5, 0.5, 1, 2, 1, 1, 1, 1, 0.5, 0.5, 1, 2 },
    { 1, 0.5, 0.5, 2, 1, 1, 1, 1, 1, 2, 1, 1 },
    { 1, 0.5, 1, 0.5, 1, 1, 1, 1, 2, 1, 1, 2 },
    { 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0.5 },
    { 1, 1, 1, 1, 0, 2, 2, 1, 1, 1, 1, 1 },
    { 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 2, 1 },
    { 1, 1, 1, 0.5, 1, 1, 1, 0.5, 0.5, 2, 1, 1 },
    { 2, 2, 1, 0.5, 1, 1, 1, 2, 0.5, 1, 1, 0.5 },
    { 2, 2, 0.5, 1, 1, 1, 1, 1, 1, 1, 2, 0.5 },
    { 0.5, 1, 1, 1, 2, 0, 0.5, 2, 1, 0.5, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 2, 2, 2, 0.5, 1 },
  }
--local 地面属性 = {}
--local 妖精属性 = {}
--local 钢属性 = {}
--local 龙属性 = {}
--local 恶属性 = {}
--local 毒属性 = {}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleNextEnemyInitEvent', Func.bind(self.OnBattleNextEnemyInitCallBack, self))

  gymBossNPC = self:NPC_createNormal(gymBoss[1][1], gymBoss[1][2], { map = gymBoss[1][3], x = gymBoss[1][4], y = gymBoss[1][5], direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(gymBossNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_关闭 then
        return;
    end
    local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    if seqno == 1 and data ==1 then
        local PartyNum = Char.PartyNum(player);
        if (PartyNum>3) then
            NLG.SystemMessage(player,"[系統]隊伍成員不能超過3人。");
            return;
        elseif (PartyNum==-1) then
            NLG.SystemMessage(player,"[系統]道館戰只靠1隻寵物會有點困難。");
            return;
        elseif (PartyNum>=1 and PartyNum<=3) then
            for Slot=1,2 do
                local TeamPlayer = Char.GetPartyMember(player,Slot);
                if Char.IsDummy(TeamPlayer)==false then
                    NLG.SystemMessage(player,"[系統]其餘2位成員只能是召喚的夥伴。");
                    return;
                end
            end
        end
        Field.Set(player, 'GymBossLevel', 1);
        local Type = tonumber(Field.Get(player, 'GymBossLevel'));
        local battleIndex = Battle.Encount(npc, player, "3|0,1000,225,88||0|||||0|600082|||||");
        Battle.SetWinEvent("./lua/Modules/pokeGym.lua", "gymBossNPC_BattleWin", battleIndex);
    elseif seqno == 1 and data ==2 then
        Field.Set(player, 'GymBossLevel', 0);
        NLG.SystemMessage(player,"[系統]已重置八屬性道館巡迴。");
        return;
    end
  end)
  self:NPC_regTalkedEvent(gymBossNPC, function(npc, player)
    local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    local nowLevel = gymBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "4\\n@c★每週巡迴八道館任務★"
                                             .."\\n挑戰進度:  第"..nowLevel.."道館\\n"
                                             .."\\n　　════════════════════\\n"
                                             .."[　參加八屬性道館挑戰　]\\n"
                                             .."[　重置八屬性道館巡迴　]\\n";
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
	local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		local enemyId = Char.GetData(enemy, CONST.对象_ENEMY_ID);
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(GymsEnemy,enemyId)==true  then
			Char.SetTempData(enemy, '克制', gymBossLevel);
			NLG.UpChar(enemy);
			if Char.GetData(player,CONST.对象_对战开关) == 1  then
				NLG.Say(player,-1,"【屬性剋制】",4,3);
			end
		end
	end
end

function Module:OnBattleNextEnemyInitCallBack(battleIndex, flg)
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
          leader = leader2
      end
      local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;
      local encountId = Data.GetEncountData(flg, CONST.ENCOUNT_INDEX)
      --print(encountId, flg)
      if (encountId==600083) then
          local Bug_EnId = {600084,600084,600086,600087}
          local roundRand = NLG.Rand(1,4);
          local encountIndex = Data.GetEncountIndex(Bug_EnId[roundRand])
          Battle.SetNextBattle(battleIndex,encountIndex, Bug_EnId[roundRand])
      elseif (encountId==600085) then
          local Bug_EnId = {600086,600087,600087}
          local roundRand = NLG.Rand(1,3);
          local encountIndex = Data.GetEncountIndex(Bug_EnId[roundRand])
          Battle.SetNextBattle(battleIndex,encountIndex, Bug_EnId[roundRand])
      end
  return flg;
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
      local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;
      --print(Round)
      if Char.IsEnemy(defCharIndex) then
          local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(GymsEnemy,enemyId)==true then
            if Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false  then
               if (Char.GetData(charIndex, CONST.CHAR_地图)==1000) then
                  damage = 1;
               else
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '克制') or 0;
            if gymBossLevel>=0 then
                local a,b = checkRestraint_def(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b];
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(GymsEnemy,enemyId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(defCharIndex, CONST.CHAR_地图)==1000) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '克制') or 0;
            if gymBossLevel>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b];
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(GymsEnemy,enemyId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(defCharIndex, CONST.CHAR_地图)==1000) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '克制') or 0;
            if gymBossLevel>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b] * 0.8;
                end
            end
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
function gymBossNPC_BattleWin(battleIndex, charIndex)
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

	if (Char.GetData(charIndex, CONST.CHAR_地图)==20300 or Char.GetData(charIndex, CONST.CHAR_地图)==7342 or Char.GetData(charIndex, CONST.CHAR_地图)==7343) then
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
			if (endlessBossLevel>=99) then
				local dropPet = math.random(1,5);
				local PetIDMenu = {900007,900008,900009}
				if (dropPet<=3) then
					Char.AddPet(player,PetIDMenu[dropPet]);
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

--我方攻charIndex,怪方守defCharIndex
function checkRestraint_def(aIndex,bIndex)
          local a=0;
          local b=0;
          local enemyId_a = Char.GetData(aIndex,CONST.PET_PetID);
          if Char.IsDummy(aIndex)==true  then
              enemyId_a = Char.GetData(aIndex, CONST.CHAR_金币);
          end
          local enemyId_b = Char.GetData(bIndex, CONST.对象_ENEMY_ID);
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_a) then
                        --print(v[k], enemyId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_b) then
                        b = j;
                    end
              end
           end
           return a,b;
end

--怪方攻charIndex,我方守defCharIndex
function checkRestraint_att(aIndex,bIndex)
          local a=0;
          local b=0;
          local enemyId_a = Char.GetData(aIndex, CONST.对象_ENEMY_ID);
          local enemyId_b = Char.GetData(bIndex,CONST.PET_PetID);
          if Char.IsDummy(aIndex)==true  then
              enemyId_b = Char.GetData(bIndex, CONST.CHAR_金币);
          end
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_a) then
                        --print(v[k], enemyId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_b) then
                        b = j;
                    end
              end
           end
           return a,b;
end
--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
