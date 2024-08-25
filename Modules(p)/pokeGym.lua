---模块类
local Module = ModuleBase:createModule('pokeGym')

local EncountSet = {
    { Type=1, GymBoss={"阿楓", 14641, 1000,226,88}, dropMenu={"四魂之玉小碎片",51071,1}, encountId_1st="3|0,1000,225,88||0|||||0|600082|||||", encountId_2nd=600083, EnId_1st= {600084,600084,600086,600087}, encountId_3rd=600085, EnId_2nd = {600086,600087,600087} },	--Bug(encountId)
}

tbl_GymBossNPCIndex = tbl_GymBossNPCIndex or {}

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
 for k,v in pairs(EncountSet) do
 if tbl_GymBossNPCIndex[k] == nil then
  local GymBossNPC = self:NPC_createNormal(v.GymBoss[1], v.GymBoss[2], { map =v.GymBoss[3], x = v.GymBoss[4], y = v.GymBoss[5], direction = 0, mapType = 0 })
  tbl_GymBossNPCIndex[k] = GymBossNPC
  self:NPC_regWindowTalkedEvent(tbl_GymBossNPCIndex[k], function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_关闭 then
        return;
    end
    local gymBoss = tonumber(Field.Get(player, 'GymBoss')) or 0;
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
        Field.Set(player, 'GymBoss', k);
        Field.Set(player, 'GymBossLevel', 0);
        local Type = tonumber(Field.Get(player, 'GymBoss'));
        if (Type==v.Type) then
            local encountId = v.encountId_1st;
            print(encountId)
            local battleIndex = Battle.Encount(npc, player, encountId);
            Battle.SetWinEvent("./lua/Modules/pokeGym.lua", "gymBossNPC_BattleWin", battleIndex);
        end
    elseif seqno == 1 and data ==2 then
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
        Field.Set(player, 'GymBoss', k);
        Field.Set(player, 'GymBossLevel', 1);
        local Type = tonumber(Field.Get(player, 'GymBoss'));
        if (Type==v.Type) then
            local encountId = v.encountId_1st;
            local battleIndex = Battle.Encount(npc, player, encountId);
            Battle.SetWinEvent("./lua/Modules/pokeGym.lua", "gymBossNPC_BattleWin", battleIndex);
        end
    end
  end)
  self:NPC_regTalkedEvent(tbl_GymBossNPCIndex[k], function(npc, player)
    local gymBoss = tonumber(Field.Get(player, 'GymBoss')) or 0;
    local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    local nowGym = k;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "4\\n@c★每週巡迴八道館任務★"
                                             .."\\n目前關卡:  第"..nowGym.."道館\\n"
                                             .."\\n　　════════════════════\\n"
                                             .."[　新手嘗試道館挑戰　]\\n"
                                             .."[　資深加速道館挑戰　]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, msg);
    end
    return
  end)
 end
 end

end

function Module:OnbattleStartEventCallback(battleIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		local enemyId = Char.GetData(enemy, CONST.对象_ENEMY_ID);
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(GymsEnemy,enemyId)==true  then
			Char.SetTempData(enemy, '克制', gymBoss);
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
      local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
      local encountId = Data.GetEncountData(flg, CONST.ENCOUNT_INDEX)
      --print(encountId, flg)
      for k,v in pairs(EncountSet) do
          if (gymBoss==v.Type and encountId==v.encountId_2nd) then
              local Boss_EnId = v.EnId_1st;
              local roundRand = NLG.Rand(1,4);
              local encountIndex = Data.GetEncountIndex(Boss_EnId[roundRand])
              Battle.SetNextBattle(battleIndex,encountIndex, Boss_EnId[roundRand])
          elseif (gymBoss==v.Type and encountId==v.encountId_3rd) then
              local Boss_EnId = v.EnId_2nd;
              local roundRand = NLG.Rand(1,3);
              local encountIndex = Data.GetEncountIndex(Boss_EnId[roundRand])
              Battle.SetNextBattle(battleIndex,encountIndex, Boss_EnId[roundRand])
          end
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
      local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
      local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;
      if gymBossLevel==0 then
          speedRate=1;
      elseif gymBossLevel==1 then
          speedRate=2;
      end
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
            if gymBoss>=0 then
                local a,b = checkRestraint_def(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b] * speedRate;
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
            if gymBoss>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b] * speedRate;
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
            if gymBoss>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b] * 0.8 * speedRate;
                end
            end
            return damage;
          end

       end
  return damage;
end

function gymBossNPC_BattleWin(battleIndex, charIndex)
	--计算等第
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
	local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;

	if (Char.GetData(charIndex, CONST.CHAR_地图)==20300) then
	--分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(0,2);
		if player>=0 and Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人 then
			for k, v in ipairs(EncountSet) do
				if (gymBoss==v.Type) then
					Char.GiveItem(player, v.dropMenu[2], v.dropMenu[3]*drop);
				end
			end
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
