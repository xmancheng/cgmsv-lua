---模块类
local Module = ModuleBase:createModule('pokeGym2')

local playerOFF = 0;
local EncountSet = {
    { Type=1, GymBoss={"阿楓", 14677, 7345,23,25}, dropMenu={"蟲之徽章",75003,1}, encountId_1st="3|0,20300,158,413||0|||||0|706001|||||", encountId_2nd=706002, EnId_1st= {706003,706003,706005,706006}, encountId_3rd=706004, EnId_2nd = {706005,706006,706006} },		--Bug(encountId)
    { Type=2, GymBoss={"寇沙", 14584, 7345,74,25}, dropMenu={"草之徽章",75004,1}, encountId_1st="3|0,20300,459,399||0|||||0|706007|||||", encountId_2nd=706008, EnId_1st= {706009,706009,706011,706012}, encountId_3rd=706010, EnId_2nd = {706011,706012,706012} },		--Grass(encountId)
    { Type=3, GymBoss={"奇樹", 14593, 7345,125,25}, dropMenu={"電之徽章",75005,1}, encountId_1st="3|0,20300,534,287||0|||||0|706013|||||", encountId_2nd=706014, EnId_1st= {706015,706015,706017,706018}, encountId_3rd=706016, EnId_2nd = {706017,706018,706018} },		--Electric(encountId)
    { Type=4, GymBoss={"海岱", 14568, 7345,23,94}, dropMenu={"水之徽章",75006,1}, encountId_1st="3|0,20300,221,241||0|||||0|706019|||||", encountId_2nd=706020, EnId_1st= {706021,706021,706023,706024}, encountId_3rd=706022, EnId_2nd = {706023,706024,706024} },		--Water(encountId)
    { Type=5, GymBoss={"青木", 14676, 7345,74,94}, dropMenu={"一般徽章",75007,1}, encountId_1st="3|0,20300,308,233||0|||||0|706025|||||", encountId_2nd=706026, EnId_1st= {706027,706027,706029,706030}, encountId_3rd=706028, EnId_2nd = {706029,706030,706030} },		--Normal(encountId)
    { Type=6, GymBoss={"萊姆", 14636, 7345,125,94}, dropMenu={"幽靈徽章",75008,1}, encountId_1st="3|0,20300,333,56||0|||||0|706031|||||", encountId_2nd=706032, EnId_1st= {706033,706033,706035,706036}, encountId_3rd=706034, EnId_2nd = {706035,706036,706036} },		--Ghost(encountId)
    { Type=7, GymBoss={"莉普", 14695, 7345,23,163}, dropMenu={"超能徽章",75009,1}, encountId_1st="3|0,20300,101,465||0|||||0|706037|||||", encountId_2nd=706038, EnId_1st= {706039,706039,706041,706042}, encountId_3rd=706040, EnId_2nd = {706041,706042,706042} },		--Psychic(encountId)
    { Type=8, GymBoss={"古魯夏", 14680, 7345,74,163}, dropMenu={"冰之徽章",75010,1}, encountId_1st="3|0,20300,386,88||0|||||0|706043|||||", encountId_2nd=706044, EnId_1st= {706045,706045,706047,706048}, encountId_3rd=706046, EnId_2nd = {706047,706048,706048} },		--Ice(encountId)
}

tbl_GymBossNPCIndex = tbl_GymBossNPCIndex or {}

local GymsEnemy = {
    120273,120022,120245,120170,120269,120357,	--虫属性
    120346,120328,120195,120296,120347,120369,	--草属性
    120208,120242,120012,120202,120336,120068,	--电属性
    120330,120254,120371,120220,120165,120388,	--水属性
    120179,120374,120355,120011,120222,120277,	--一般属性
    120175,120275,120311,120004,120020,120005,	--幽灵属性
    120008,120329,120096,120226,120351,120217,	--超能力属性
    120010,120188,120287,120017,120363,120001,	--冰属性
}	--ImageId

local restraintMap = {
    { 120273,120022,120245,120170,120269,120357,120401,120402,120325,120097, },	--虫属性
    { 120346,120328,120195,120296,120347,120369,120032,120265,120044,120310,120312,120284,120043,120057,120192,120276, },	--草属性
    { 120208,120242,120012,120202,120336,120068,120244,120238,120181,120303,120069,120378,120332, },	--电属性
    { 120330,120254,120371,120220,120165,120388,120289,120250,120309,120227,120246,120237,120085,120209,120162,120185,120319,120292,120027, },	--水属性
    { 120179,120374,120355,120011,120222,120277,120067,120258,120040,120182,120014,120379, },	--一般属性
    { 120175,120275,120311,120004,120020,120005,120211,120373,120098,120157,120340,120026, },	--幽灵属性
    { 120008,120329,120096,120226,120351,120217,120037,120252,120229,120051,120050,120008,120403,120076,120052,120317,120216,120019,120219,120218,120061,120024, },	--超能力属性
    { 120010,120188,120287,120017,120363,120001,120158,120257,120186,120086, },	--冰属性
    { 120042,120197,120054,120306,120045,120301,120081,120082,120207,120075,120349,120324,120321, },	--火属性
    { 120083,120201,120173,120307,120064,120304,120159,120041, },	--飞行属性
    { 120264,120048,120302,120323,120184,120384,120199,120200,120372,120036,120028, },	--格斗属性
    { 120189,120259,120263,120314,120342,120290,120063, },	--岩石属性
    { 120164,120399,120187,120231,120230,120095,120380,120358,120392,120079, },	--地面属性
    { 120033,120271,120331,120299,120300,120297,120298,120009,120212,120213, },	--妖精属性
    { 120286,120260,120169,120387,120385,120278,120038,120183,120214,120205, },	--钢属性
    { 120018,120099,120256,120393,120190,120191,120062,120239,120335,120261,120084,120160,120168, },	--龙属性
    { 120338,120272,120055,120333,120390,120368,120375,120176,120361, },	--恶属性
    { 120053,120078,120320,120035,120023, },	--毒属性
  }
  local attr = {
    { 1, 2, 1, 1, 1, 0.5, 2, 1, 0.5, 0.5, 0.5, 1, 1,0.5, 0.5, 1, 2, 0.5 },
    { 0.5, 0.5, 1, 2, 1, 1, 1, 1, 0.5, 0.5, 1, 2, 2, 1, 0.5, 0.5, 1, 0.5 },
    { 1, 0.5, 0.5, 2, 1, 1, 1, 1, 1, 2, 1, 1, 0, 1, 1, 0.5, 1, 1 },
    { 1, 0.5, 1, 0.5, 1, 1, 1, 1, 2, 1, 1, 2, 2, 1, 1, 0.5, 1, 1 },
    { 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0.5, 1, 1, 0.5, 1, 1, 1 },
    { 1, 1, 1, 1, 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1 },
    { 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 2, 1, 1, 1, 0.5, 1, 0, 2 },
    { 1, 1, 1, 0.5, 1, 1, 1, 0.5, 0.5, 2, 1, 1, 2, 1, 0.5, 2, 1, 1 },
    { 2, 2, 1, 0.5, 1, 1, 1, 2, 0.5, 1, 1, 0.5, 1, 1, 2, 0.5, 1, 1 },
    { 2, 2, 0.5, 1, 1, 1, 1, 1, 1, 1, 2, 0.5, 1, 1, 0.5, 1, 1, 1 },
    { 0.5, 1, 1, 1, 2, 0, 0.5, 2, 1, 0.5, 1, 2, 1, 0.5, 2, 1, 2, 0.5 },
    { 2, 1, 1, 1, 1, 1, 1, 2, 2, 2, 0.5, 1, 0.5, 1, 0.5, 1, 1, 1 },
    { 0.5, 0.5, 2, 1, 1, 1, 1, 1, 2, 0, 1, 2, 1, 1, 2, 1, 1, 2 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 2, 1, 1, 1, 0.5, 2, 2, 0.5 },
    { 1, 1, 0.5, 0.5, 1, 1, 1, 2, 0.5, 1, 1, 2, 1, 2, 0.5, 1, 1, 1 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0.5, 2, 1, 1 },
    { 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 0.5, 1, 1, 0.5, 1, 1, 0.5, 1 },
    { 1, 2, 1, 1, 1, 0.5, 1, 1, 1, 1, 1, 0.5, 0.5, 2, 0, 1, 1, 0.5 },
  }

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleNextEnemyInitEvent', Func.bind(self.OnBattleNextEnemyInitCallBack, self))
 for k,v in pairs(EncountSet) do
 if tbl_GymBossNPCIndex[k] == nil then
  local GymBossNPC = self:NPC_createNormal(v.GymBoss[1], v.GymBoss[2], { map =v.GymBoss[3], x = v.GymBoss[4], y = v.GymBoss[5], direction = 4, mapType = 0 })
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
        if (PartyNum>5) then
            NLG.SystemMessage(player,"[系統]隊伍成員不能超過5人。");
            return;
        elseif (PartyNum==-1) then
            NLG.SystemMessage(player,"[系統]道館戰只靠1隻寵物會有點困難。");
            return;
        elseif (PartyNum>=1 and PartyNum<=5) then
            for Slot=1,4 do
                local TeamPlayer = Char.GetPartyMember(player,Slot);
                if Char.IsDummy(TeamPlayer)==false then
                    NLG.SystemMessage(player,"[系統]其餘4位成員只能是召喚的夥伴。");
                    return;
                end
            end
        end
        Field.Set(player, 'GymBoss', k);
        Field.Set(player, 'GymBossLevel', 0);
        local Type = tonumber(Field.Get(player, 'GymBoss'));
        if (Type==v.Type) then
            local encountId = v.encountId_1st;
            --print(encountId)
            local battleIndex = Battle.Encount(npc, player, encountId);
            --Battle.SetWinEvent("./lua/Modules/pokeGym2.lua", "gymBossNPC_BattleWin", battleIndex);
        end
    elseif seqno == 1 and data ==2 then
        local PartyNum = Char.PartyNum(player);
        if (PartyNum>5) then
            NLG.SystemMessage(player,"[系統]隊伍成員不能超過5人。");
            return;
        elseif (PartyNum==-1) then
            NLG.SystemMessage(player,"[系統]道館戰只靠1隻寵物會有點困難。");
            return;
        elseif (PartyNum>=1 and PartyNum<=5) then
            for Slot=1,4 do
                local TeamPlayer = Char.GetPartyMember(player,Slot);
                if Char.IsDummy(TeamPlayer)==false then
                    NLG.SystemMessage(player,"[系統]其餘4位成員只能是召喚的夥伴。");
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
            --Battle.SetWinEvent("./lua/Modules/pokeGym2.lua", "gymBossNPC_BattleWin", battleIndex);
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
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
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
	if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		--local enemyId = Char.GetData(enemy, CONST.对象_ENEMY_ID);
		local ImageId = Char.GetData(enemy, CONST.对象_形象);
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(GymsEnemy,ImageId)==true  then
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
      if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
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
              Battle.SetWinEvent("./lua/Modules/pokeGym2.lua", "gymBossNPC_BattleWin", battleIndex);
          elseif (gymBoss==v.Type and encountId==v.encountId_3rd) then
              local Boss_EnId = v.EnId_2nd;
              local roundRand = NLG.Rand(1,3);
              local encountIndex = Data.GetEncountIndex(Boss_EnId[roundRand])
              Battle.SetNextBattle(battleIndex,encountIndex, Boss_EnId[roundRand])
              Battle.SetWinEvent("./lua/Modules/pokeGym2.lua", "gymBossNPC_BattleWin", battleIndex);
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
      if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
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
          --local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
          local ImageId = Char.GetData(defCharIndex, CONST.对象_形象);
          if CheckInTable(GymsEnemy,ImageId)==true then
            if Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false  then
               if (playerOFF==1 and Char.GetData(charIndex, CONST.对象_地图)==7345) then
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
                    --print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b] * speedRate;
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          --local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          local ImageId = Char.GetData(charIndex, CONST.对象_形象);
          if CheckInTable(GymsEnemy,ImageId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(defCharIndex, CONST.对象_地图)==7345) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '克制') or 0;
            if gymBoss>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = damage;
                else
                    --print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b] * speedRate;
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          --local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          local ImageId = Char.GetData(charIndex, CONST.对象_形象);
          if CheckInTable(GymsEnemy,ImageId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(defCharIndex, CONST.对象_地图)==7345) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '克制') or 0;
            if gymBoss>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = damage;
                else
                    --print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
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

	if (Char.GetData(charIndex, CONST.对象_地图)==20300 or Char.GetData(charIndex, CONST.对象_地图)==7345) then
	--分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(0,2);
		if player>=0 and Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
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
          --local enemyId_a = Char.GetData(aIndex,CONST.PET_PetID);
          local ImageId_a = Char.GetData(aIndex, CONST.对象_形象);
          if Char.IsDummy(aIndex)==true  then
              --enemyId_a = Char.GetData(aIndex, CONST.对象_金币);
              ImageId_a = Char.GetData(aIndex, CONST.对象_形象);
          end
          --local enemyId_b = Char.GetData(bIndex, CONST.对象_ENEMY_ID);
          local ImageId_b = Char.GetData(bIndex, CONST.对象_形象);
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_a) then
                        --print(v[k], ImageId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_b) then
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
          --local enemyId_a = Char.GetData(aIndex, CONST.对象_ENEMY_ID);
          --local enemyId_b = Char.GetData(bIndex,CONST.PET_PetID);
          local ImageId_a = Char.GetData(aIndex, CONST.对象_形象);
          local ImageId_b = Char.GetData(bIndex, CONST.对象_形象);
          if Char.IsDummy(bIndex)==true  then
              --enemyId_b = Char.GetData(bIndex, CONST.对象_金币);
              ImageId_b = Char.GetData(bIndex, CONST.对象_形象);
          end
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_a) then
                        --print(v[k], ImageId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_b) then
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
