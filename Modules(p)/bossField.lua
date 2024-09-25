---模块类
local Module = ModuleBase:createModule('bossField')

local RaceRatelist = {}

local PhyVoid = {406199}  --物理无效enemyid
local MagicVoid = {406198} --魔法无效enemyid
local ElmTech = {} or nil
local damage_Max = 99999;
------------------------------------------------------
local Arcobaleno = { 315163, }	--EnemyId
local boxAnimals = { 2039,2139,2239, }	--TechId

local restraintMap_Tech_First = {
    {  },	--大空属性
    { 2139, },	--岚属性
    { 2039, },	--雨属性
    { 2239, },	--云属性
    {  },	--晴属性
    {  },	--雷属性
    {  },	--雾属性
  }	--TechId
local restraintMap_Enemy_First = {
    {  },	--大空属性
    { 315163, },	--岚属性
    {  },	--雨属性
    {  },	--云属性
    {  },	--晴属性
    {  },	--雷属性
    {  },	--雾属性
  }	--EnemyId

local restraintMap_Tech_Second = {
    {  },	--大空属性
    { 2139, },	--岚属性
    { 2039, },	--雨属性
    { 2239, },	--云属性
    {  },	--晴属性
    {  },	--雷属性
    {  },	--雾属性
  }	--TechId
local restraintMap_Enemy_Second = {
    {  },	--大空属性
    {  },	--岚属性
    {  },	--雨属性
    { 315163, },	--云属性
    {  },	--晴属性
    {  },	--雷属性
    {  },	--雾属性
  }	--EnemyId

  local attr = {
    { 2, 1, 1, 1, 1, 1, 1 },
    { 0.5, 1, 0.5, 1, 1, 2, 0.5 },
    { 0.5, 2, 1, 0.5, 1, 1, 0.5 },
    { 0.5, 1, 2, 1, 1, 0.5, 0.5 },
    { 0.5, 1, 1, 1, 1, 1, 1 },
    { 0.5, 0.5, 1, 2, 1, 1, 0.5 },
    { 0.5, 1, 1, 1, 0.5, 1, 2 },
  }
------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self))
end

function Module:OnbattleStartEventCallback(battleIndex)
         for i=10, 19 do
              local enemy = Battle.GetPlayIndex(battleIndex, i)
              local player = Battle.GetPlayIndex(battleIndex, i-10)
               --print(enemy, player)
              local enemyId = Char.GetData(enemy, CONST.对象_ENEMY_ID);
              if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(Arcobaleno,enemyId)==false then
                  Char.SetTempData(enemy, '守住', 3);
                  Char.SetTempData(enemy, '狂暴', 3);
                  if Char.GetData(player,CONST.对象_对战开关) == 1  then
                     NLG.Say(player,-1,"【守住領域】【狂暴領域】",4,3);
                 end
              elseif enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(Arcobaleno,enemyId)==true then
                  Char.SetTempData(enemy, '狂暴', 2);
                  Char.SetTempData(enemy, '彩虹属性', 1);
                  if Char.GetData(player,CONST.对象_对战开关) == 1  then
                     NLG.Say(player,-1,"【阿爾柯巴雷諾詛咒】",4,3);
                 end
              end
         end
end

function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local Target_FloorId = Char.GetData(leader,CONST.CHAR_地图);
	if (Target_FloorId==25013) then
		FieldEffect = 1;
	end
	for i = 0, 9 do
		local player = Battle.GetPlayer(battleIndex, i);
		if (player>=0 and math.fmod(Round, 2)==0 and FieldEffect==1)  then
			local playerHP = Char.GetData(player, CONST.CHAR_血);
			if (playerHP>=500) then
				Char.SetData(player, CONST.CHAR_血, playerHP*0.7);
			end
			--if Char.GetData(player,CONST.对象_对战开关) == 1  then
				NLG.Say(player,-1,"受到【誅伏賜死】領域影響每回合都會減少30%生命。",4,3);
			--end
		end
	end
	FieldEffect = 0;
end

function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if (com3==6219 or com3==6319 )  then
             if Char.IsEnemy(defCharIndex) then
                 local Buff1 = Char.GetTempData(defCharIndex, '守住') or 0;
                 local Buff2 = Char.GetTempData(defCharIndex, '狂暴') or 0;
                 if (Buff1 > 0 or Buff2 > 0)  then
                       if (Buff1>=2 or Buff2>=2)  then
                           Char.SetTempData(defCharIndex, '守住', 1);
                           Char.SetTempData(defCharIndex, '狂暴', 1);
                           if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                               NLG.Say(leader,-1,"【守住領域】【狂暴領域】降為1層",4,3);
                           end
                       elseif (Buff1==1 or Buff2==1)  then
                           Char.SetTempData(defCharIndex, '守住', 0);
                           Char.SetTempData(defCharIndex, '狂暴', 0);
                           if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                               NLG.Say(leader,-1,"【守住領域】【狂暴領域】降為0層",4,3);
                           end
                       end
                 end
             end
             return heal;
         end
         return heal;
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsEnemy(defCharIndex)  then
               --特殊怪物(物理無效)
               if CheckInTable(PhyVoid,Char.GetData(defCharIndex,CONST.对象_ENEMY_ID))==true and (flg == 0 or flg == 8 or flg == 1 or flg == 9) then
                              damage = 1;
               end
               --特殊怪物(魔法无效)
               if CheckInTable(MagicVoid,Char.GetData(defCharIndex,CONST.对象_ENEMY_ID))==true and flg == 5 then
                              damage = 1;
               end
               --領域守住
               local GTime = NLG.GetGameTime();
               if (GTime>=0)  then
                     local State = Char.GetTempData(defCharIndex, '守住') or 0;
                     if (damage>=999 and Char.GetData(defCharIndex, CONST.CHAR_ENEMY_ID) == 400125) then
                             if (State>0 and Char.IsEnemy(defCharIndex)) then
                                 damage = 999;
                                 return damage;
                             end
                     end
                     local Rainbow = Char.GetTempData(defCharIndex, '彩虹属性') or 0;
                     local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
                     if (GTime==0 and damage>=damage_Max and Char.GetData(defCharIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         if (State>0) then
                             if (State>=1)  then
                                 damage = damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【守住】怪物受到的傷害上限值為"..damage_Max.."，守住剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                             end
                         else
                             damage = damage;
                         end
                     elseif (Rainbow>=1 and CheckInTable(Arcobaleno,enemyId)==true) then		--彩虹之子怪物、BOSS
                         if (CheckInTable(boxAnimals,com3)==true) then		--使用属性技能
                             local a,b = checkRestraint_def_First(com3,defCharIndex);
                             local c,d = checkRestraint_def_Second(com3,defCharIndex);
                             if (a==0 or b==0) then
                                 attr_First = 1;
                             else
                                 attr_First = attr[a][b];		--技能对怪物之第一属性倍率
                             end
                             if (c==0 or d==0) then
                                 attr_Second = 1;
                             else
                                 attr_Second = attr[c][d];		--技能对怪物之第二属性倍率
                             end
                             print('第'..a..'列','第'..b..'欄','倍率:'..attr_First,'第'..c..'列','第'..d..'欄','倍率:'..attr_Second)
                             damage = damage * attr_First * attr_Second;
                         else						--非属性技能完美抵挡
                                 damage = 1;
                         end
                     else
                         damage = damage;
                     end
               else
               end
               return damage;
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg ~= CONST.DamageFlags.Magic and Char.IsEnemy(charIndex)  then
               local GTime = NLG.GetGameTime();
               if (GTime==2)  then
                     local State = Char.GetTempData(charIndex, '狂暴') or 0;
                     if (Char.GetData(charIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         local d1= Char.GetData(charIndex, CONST.CHAR_攻击力);
                         local d2= Char.GetData(defCharIndex, CONST.CHAR_攻击力);
                         local d3= Char.GetData(defCharIndex, CONST.CHAR_防御力);
                         local d4= Char.GetData(defCharIndex, CONST.CHAR_精神);
                         if (State>0) then
                            if d2>=500 and d2<=4000 then
                                 local damage_Max = (d1*0.8)-(d3-120)*10+(d4*State/100);
                                 if damage_Max<=9 then damage_Max = 9; end
                                 if damage_Max>=99 then damage_Max = 99; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            elseif d2>=4001 and d2<=9999 then
                                 local damage_Max = (d1*0.8)-(d3-180)*10+(d4*State/10);
                                 if damage_Max<=99 then damage_Max = 99; end
                                 if damage_Max>=999 then damage_Max = 999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            elseif d2>=10000 then
                                 local damage_Max = (d1*0.8)-(d3-240)*10+(d4*State/1);
                                 if damage_Max<=999 then damage_Max = 999; end
                                 if damage_Max>=9999 then damage_Max = 9999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            else
                                 damage = damage;
                                 return damage;
                            end
                         end
                     end
               end
               return damage;
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg == CONST.DamageFlags.Magic and Char.IsEnemy(charIndex)  then
               local StatsRate_Mind = 1;  --异常状态对精神影响比例(不影响必杀公式里的精神)
               local StatsRate_critical = 1; --异常状态对必杀几率的影响比例
               local StatsRate_dmg = 1; --异常状态对伤害(非必杀)的影响比例
               local StatsRate_Cdmg = 1; --异常状对伤害(必杀)的影响比例
               local ServerRate = 0.5;
               local Amnd_R = Char.GetData(charIndex, CONST.CHAR_精神);
               local Amnd = math.max(Conver_240(Amnd_R * StatsRate_Mind),1);
               local TechRate = (Battle.GetTechOption(charIndex,"AR:") + Battle.GetTechOption(charIndex,"D1:"))/60 + 0.5;
               print("TechRate:"..TechRate)

               local Dmnd_R = math.max(Char.GetData(defCharIndex, CONST.CHAR_精神),100);
               local Dmnd = Conver_240(Dmnd_R * StatsRate_Mind);

               local dp = {}
               dp[1] = Char.GetData(defCharIndex, CONST.CHAR_地属性);
               dp[2] = Char.GetData(defCharIndex, CONST.CHAR_水属性);
               dp[3] = Char.GetData(defCharIndex, CONST.CHAR_火属性);
               dp[4] = Char.GetData(defCharIndex, CONST.CHAR_风属性);
               local AttRate_1 = 1;
               if ElmTech[com3] ~= nil then
                              AttRate_1 = Battle.CalcPropScore(ElmTech[com3], dp);
               end
               local AttRate_2 = Battle.CalcAttributeDmgRate(charIndex, defCharIndex);
               local AttRate = (AttRate_1 - 1) + (AttRate_2 - 1) * 0.5 + 1;
               local RaceRate = Battle.CalcTribeDmgRate(charIndex, defCharIndex) + 1;
               local RndRate = NLG.Rand(90,110) / 100;

               local dmg = math.floor( ((Amnd / (0.67 + Dmnd / Amnd))* TechRate )* AttRate * RaceRate * RndRate * StatsRate_dmg * ServerRate);
               --print("Amnd_R:"..Amnd_R.." Dmnd_R:"..Dmnd_R.." Matk:"..Matk.." AttRate:"..AttRate.." RaceRate"..RaceRate.." RndRate"..RndRate);
               print("Amnd_R:"..Amnd_R.." Dmnd_R:"..Dmnd_R.." AttRate:"..AttRate.." RaceRate"..RaceRate.." RndRate"..RndRate);

               --暴击部分
               local criticalDmg = 0;
               local criticalRate = NLG.Rand(1,200);
               local char_cr = math.floor((Char.GetData(charIndex, CONST.对象_必杀) - Char.GetData(defCharIndex, CONST.对象_必杀)) * StatsRate_critical);
               print("char_cr:"..char_cr)
               if criticalRate <= char_cr then
                              criticalDmg = math.floor(Dmnd_R * 1 * Char.GetData(charIndex, CONST.CHAR_等级) / Char.GetData(defCharIndex, CONST.CHAR_等级) * StatsRate_Cdmg);
               end		
               damage = dmg + criticalDmg;
               --領域加強
               local GTime = NLG.GetGameTime();
               if (GTime==2)  then
                     local State = Char.GetTempData(charIndex, '狂暴') or 0;
                     if (Char.GetData(charIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         local d1= Char.GetData(charIndex, CONST.CHAR_精神);
                         local d2= Char.GetData(defCharIndex, CONST.CHAR_精神);
                         local d3= Char.GetData(defCharIndex, CONST.CHAR_魔抗);
                         local d4= Char.GetData(defCharIndex, CONST.CHAR_攻击力);
                         if (State>0) then
                            if (com3 == 2729)  then    --千鈞石箭-SE
                                if NLG.Rand(1,10)>=8  then
                                    Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 2);
                                    NLG.UpChar(defCharIndex);
                                end
                            end
                            if d2>=500 and d2<=2000 then
                                 local damage_Max = (d1*0.8)-(d3-50)*10+(d4*State/100);
                                 if damage_Max<=9 then damage_Max = 9; end
                                 if damage_Max>=99 then damage_Max = 99; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            elseif d2>=2001 and d2<=9999 then
                                 local damage_Max = (d1*0.8)-(d3-100)*10+(d4*State/10);
                                 if damage_Max<=99 then damage_Max = 99; end
                                 if damage_Max>=999 then damage_Max = 999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            elseif d2>=10000 then
                                 local damage_Max = (d1*0.8)-(d3-240)*10+(d4*State/1);
                                 if damage_Max<=999 then damage_Max = 999; end
                                 if damage_Max>=9999 then damage_Max = 9999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            else
                                 damage = damage;
                                 return damage;
                            end
                         end
                     end
               end
               return damage;
         else
         end
  return damage;
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function Conver_240(Num)
	if Num >= 240 then
		local a = math.floor((Num - 240 ) * 0.3 + 240)
		return a
	else
		return Num
	end
end

--我方攻charIndex,怪方守defCharIndex
function checkRestraint_def_First(com3,bIndex)
          local a=0;
          local b=0;
          local techId_a = com3;
          local enemyId_b = Char.GetData(bIndex, CONST.对象_ENEMY_ID);
          for i, v in ipairs(restraintMap_Tech_First) do
              for k, techId in ipairs(v) do
                    if (v[k]==techId_a) then
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap_Enemy_First) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_b) then
                        b = j;
                    end
              end
           end
           return a,b;
end
function checkRestraint_def_Second(com3,bIndex)
          local c=0;
          local d=0;
          local techId_c = com3;
          local enemyId_d = Char.GetData(bIndex, CONST.对象_ENEMY_ID);
          for i, v in ipairs(restraintMap_Tech_Second) do
              for k, techId in ipairs(v) do
                    if (v[k]==techId_c) then
                        c = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap_Enemy_Second) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_d) then
                        d = j;
                    end
              end
           end
           return c,d;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
