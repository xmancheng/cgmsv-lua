---模块类
local Module = ModuleBase:createModule('pokeBattle')

local playerOFF = 0;
local EncountSet = {
    { Type=1, GymBoss={"小剛", 14640, 20252,7,4}, dropMenu={74121,74122}, nowEvent={"深灰市(前伊爾村)",94}, EnemySet = {416322, 0, 0, 0, 0, 416295, 416290, 416290, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=2, GymBoss={"小霞", 14679, 20253,7,2}, dropMenu={74118,74119}, nowEvent={"華藍市(前聖拉魯卡村)",95}, EnemySet = {416300, 416299, 416299, 0, 0, 416215, 0, 0, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=3, GymBoss={"馬志士", 14638, 20254,7,2}, dropMenu={74115,74116}, nowEvent={"枯葉市(前亞留特村)",96}, EnemySet = {416330, 0, 0, 416213, 416213, 416212, 416212, 416212, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=4, GymBoss={"莉佳", 14680, 20255,7,3}, dropMenu={74124,74125}, nowEvent={"玉虹市(前维诺亞村)",97}, EnemySet = {416288, 0, 0, 416241, 416241, 416204, 0, 0, 416204, 416204}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=5, GymBoss={"阿桔", 14691, 20256,6,10}, dropMenu={74127,74128}, nowEvent={"浅紅市(前奇利村)",98}, EnemySet = {0, 416276, 416276, 416272, 416272, 416269, 416269, 416269, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=6, GymBoss={"娜姿", 14636, 20257,12,10}, dropMenu={74109,74110}, nowEvent={"金黃市(前加納村)",99}, EnemySet = {0, 416351, 416351, 0, 416217, 416266, 416266, 416266, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=7, GymBoss={"夏伯", 14578, 20258,4,3}, dropMenu={74112,74113}, nowEvent={"紅蓮鎮(前傑诺瓦鎮)",100}, EnemySet = {416234, 416233, 416233, 0, 0, 416233, 0, 0, 416336, 416336}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=8, GymBoss={"坂木", 14676, 20259,4,3}, dropMenu={74106,74107}, nowEvent={"常青市(前蒂娜村)",101}, EnemySet = {416252, 0, 0, 0, 0, 416279, 416278, 416278, 416279, 416279}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
}

tbl_GymBossNPCIndex = tbl_GymBossNPCIndex or {}

local GymsEnemy = {
    123092,123097,123124,	--岩石属性
    123017,123101,123102,	--水属性
    123014,123015,123132,	--电属性
    123006,123043,123090,	--草属性
    123071,123074,123078,	--毒属性
    123019,123068,123153,	--超能力属性
    123138,123035,123036,	--火属性
    123080,123081,123050,	--地面属性
}	--ImageId

local restraintMap = {
    { 123022,123023,123089,123090,123091, },	--虫属性
    { 123005,123006,123042,123043,123044,123045,123152,123153, },	--草属性
    { 123013,123014,123015,123016,123058,123059,123060,123130,123131,123132, },	--电属性
    { 123009,123010,123011,123017,123046,123047,123048,123049,123100,123101,123106,123107,123108,123112,123113,123114,123121,123122,123123, },	--水属性
    { 123024,123025,123026,123027,123146,123147,123148,123149,123150, },	--一般属性
    { 123018,123019,123020,123021,123115,123116,123117, },	--幽灵属性
    { 123050,123051,123052,123067,123068,123151,123154, },	--超能力属性
    { 123061,123062,123094,123095,123096, },	--冰属性
    { 123000,123001,123002,123004,123034,123035,123036,123037,123038,123039,123118,123119,123120,123137,123138,123139, },	--火属性
    { 123028,123029,123030,123066,123076,123077,123102, },	--飞行属性
    { 123040,123041,123085,123086,123087,123088,123134,123135,123136, },	--格斗属性
    { 123092,123093,123097,123098,123099,123124,123125,123126, },	--岩石属性
    { 123079,123080,123081,123082,123103,123104,123105,123140, },	--地面属性
    { 123031,123032,123033,123069,123127,123128,123129, },	--妖精属性
    { 123109,123110,123111,123143,123144,123145, },	--钢属性
    { 123003,123055,123056,123057,123063,123064,123065,123083,123084,123133,123141,123142, },	--龙属性
    { 123053,123054,123072,123075,123078, },	--恶属性
    { 123007,123008,123070,123071,123073,123074, },	--毒属性
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

        Field.Set(player, 'GymBoss', k);
        Field.Set(player, 'GymBossLevel', 0);
        local Type = tonumber(Field.Get(player, 'GymBoss'));
        if (Type==v.Type) then
            local EnemyIdAr = v.EnemySet;
            local BaseLevelAr = v.EnemyLevel;
            local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
            Battle.SetWinEvent("./lua/Modules/pokeBattle.lua", "gymBossNPC_BattleWin", battleIndex);
            --local encountId = v.encountId_1st;
            --local battleIndex = Battle.Encount(npc, player, encountId);
        end
    elseif seqno == 1 and data ==2 then
        Field.Set(player, 'GymBoss', k);
        Field.Set(player, 'GymBossLevel', 1);
        local Type = tonumber(Field.Get(player, 'GymBoss'));
        if (Type==v.Type) then
            local EnemyIdAr = v.EnemySet;
            local BaseLevelAr = v.EnemyLevel;
            local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
            Battle.SetWinEvent("./lua/Modules/pokeBattle.lua", "gymBossNPC_BattleWin", battleIndex);
            --local encountId = v.encountId_1st;
            --local battleIndex = Battle.Encount(npc, player, encountId);
        end
    end
  end)
  self:NPC_regTalkedEvent(tbl_GymBossNPCIndex[k], function(npc, player)
    local gymBoss = tonumber(Field.Get(player, 'GymBoss')) or 0;
    local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    local nowGym = k;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "4\\n@c★道館挑戰★"
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
               if (playerOFF==1 and (Char.GetData(charIndex, CONST.对象_地图)==20252 or Char.GetData(charIndex, CONST.对象_地图)==20253 or Char.GetData(charIndex, CONST.对象_地图)==20254 or Char.GetData(charIndex, CONST.对象_地图)==20255 or Char.GetData(charIndex, CONST.对象_地图)==20256 or Char.GetData(charIndex, CONST.对象_地图)==20257 or Char.GetData(charIndex, CONST.对象_地图)==20258 or Char.GetData(charIndex, CONST.对象_地图)==20259)) then
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
               if (Char.GetData(charIndex, CONST.对象_地图)==20252 or Char.GetData(charIndex, CONST.对象_地图)==20253 or Char.GetData(charIndex, CONST.对象_地图)==20254 or Char.GetData(charIndex, CONST.对象_地图)==20255 or Char.GetData(charIndex, CONST.对象_地图)==20256 or Char.GetData(charIndex, CONST.对象_地图)==20257 or Char.GetData(charIndex, CONST.对象_地图)==20258 or Char.GetData(charIndex, CONST.对象_地图)==20259) then
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
               if (Char.GetData(charIndex, CONST.对象_地图)==20252 or Char.GetData(charIndex, CONST.对象_地图)==20253 or Char.GetData(charIndex, CONST.对象_地图)==20254 or Char.GetData(charIndex, CONST.对象_地图)==20255 or Char.GetData(charIndex, CONST.对象_地图)==20256 or Char.GetData(charIndex, CONST.对象_地图)==20257 or Char.GetData(charIndex, CONST.对象_地图)==20258 or Char.GetData(charIndex, CONST.对象_地图)==20259) then
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

	if (Char.GetData(charIndex, CONST.对象_地图)==20252 or Char.GetData(charIndex, CONST.对象_地图)==20253 or Char.GetData(charIndex, CONST.对象_地图)==20254 or Char.GetData(charIndex, CONST.对象_地图)==20255 or Char.GetData(charIndex, CONST.对象_地图)==20256 or Char.GetData(charIndex, CONST.对象_地图)==20257 or Char.GetData(charIndex, CONST.对象_地图)==20258 or Char.GetData(charIndex, CONST.对象_地图)==20259) then
	--分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = {0,0,0,0,0,0,0,1,1,1,}
		local rand = drop[NLG.Rand(1,10)];
		if player>=0 and Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
			for k, v in ipairs(EncountSet) do
				if (gymBoss==v.Type) then
					Char.NowEvent(player, v.nowEvent[2], 1);
					Char.GiveItem(player, v.dropMenu[NLG.Rand(1,2)], rand);
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
