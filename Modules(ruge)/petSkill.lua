---模块类
local Module = ModuleBase:createModule('petSkill')

local petMettleTable = {
             { MettleType=1, type=CONST.CHAR_EnemyBossFlg, info=CONST.Enemy_是否BOSS, skillId=9610 , val = 1.15},              --对BOSS对象增加伤害
             { MettleType=3, type=CONST.CHAR_地属性, info=CONST.属性_地, skillId=9611 , val = 1.05},              --对地属性对象增加伤害
             { MettleType=3, type=CONST.CHAR_水属性, info=CONST.属性_水, skillId=9612 , val = 1.05},              --对水属性对象增加伤害
             { MettleType=3, type=CONST.CHAR_火属性, info=CONST.属性_火, skillId=9613 , val = 1.05},              --对火属性对象增加伤害
             { MettleType=3, type=CONST.CHAR_风属性, info=CONST.属性_风, skillId=9614 , val = 1.05},              --对风属性对象增加伤害
             { MettleType=4, type=CONST.CHAR_地属性, info=CONST.属性_地, skillId=9615 , val = 0.95},              --减轻来自地属性对象伤害
             { MettleType=4, type=CONST.CHAR_水属性, info=CONST.属性_水, skillId=9616 , val = 0.95},              --减轻来自水属性对象伤害
             { MettleType=4, type=CONST.CHAR_火属性, info=CONST.属性_火, skillId=9617 , val = 0.95},              --减轻来自火属性对象伤害
             { MettleType=4, type=CONST.CHAR_风属性, info=CONST.属性_风, skillId=9618 , val = 0.95},              --减轻来自风属性对象伤害
             { MettleType=2, type=CONST.CHAR_EnemyBossFlg, info=CONST.Enemy_是否BOSS, skillId=9619 , val = 0.85},              --减轻来自BOSS对象伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_人型, skillId=9620 , val = 1.25},              --对人形系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_龙, skillId=9621 , val = 1.25},              --对龙族系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_不死, skillId=9622 , val = 1.25},              --对不死系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_飞行, skillId=9623 , val = 1.25},              --对飞行系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_昆虫, skillId=9624 , val = 1.25},              --对昆虫系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_植物, skillId=9625 , val = 1.25},              --对植物系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_野兽, skillId=9626 , val = 1.25},              --对野兽系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_特殊, skillId=9627 , val = 1.25},              --对特殊系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_金属, skillId=9628 , val = 1.25},              --对金属系对象增加伤害
             { MettleType=5, type=CONST.对象_种族, info=CONST.种族_邪魔, skillId=9629 , val = 1.05},              --对邪魔系对象增加伤害
}

local petStateTable = {
             { StateType=1, type=CONST.CHAR_BattleModPoison, skillId=1840 , val = 2.0},              --对中毒状态对象增加伤害
             { StateType=1, type=CONST.CHAR_BattleModPoison, skillId=1841 , val = 2.5},              --对中毒状态对象增加伤害
             { StateType=1, type=CONST.CHAR_BattleModStone, skillId=1842 , val = 2.0},              --对石化状态对象增加伤害
             { StateType=1, type=CONST.CHAR_BattleModStone, skillId=1843 , val = 2.5},              --对石化状态对象增加伤害
             { StateType=1, type=CONST.CHAR_BattleModConfusion, skillId=1844 , val = 2.0},              --对混乱状态对象增加伤害
             { StateType=1, type=CONST.CHAR_BattleModConfusion, skillId=1845 , val = 2.5},              --对混乱状态对象增加伤害
             { StateType=2, type='七罪侵蚀', skillId=310000 , val = 1.2},                                --对七罪侵蚀状态对象增加伤害
             { StateType=2, type='七罪侵蚀', skillId=310001 , val = 1.2},                                --对七罪侵蚀状态对象增加伤害
             { StateType=2, type='七罪侵蚀', skillId=310002 , val = 1.2},                                --对七罪侵蚀状态对象增加伤害
             { StateType=2, type='七罪侵蚀', skillId=310003 , val = 1.2},                                --对七罪侵蚀状态对象增加伤害
             { StateType=2, type='七罪侵蚀', skillId=310004 , val = 1.2},                                --对七罪侵蚀状态对象增加伤害
             { StateType=2, type='七罪侵蚀', skillId=310005 , val = 1.2},                                --对七罪侵蚀状态对象增加伤害
             { StateType=2, type='七罪侵蚀', skillId=310006 , val = 1.2},                                --对七罪侵蚀状态对象增加伤害
             { StateType=2, type='七罪侵蚀', skillId=310007 , val = 1.2},                                --对七罪侵蚀状态对象增加伤害
             { StateType=2, type='七罪侵蚀', skillId=310008 , val = 1.2},                                --对七罪侵蚀状态对象增加伤害
             { StateType=2, type='嘲讽侵蚀', skillId=310009 , val = 1.5},                                --对嘲讽侵蚀状态对象增加伤害
}

local techRateTable = {
             { TechType=1, skillId=1440, c_prob=8, c_val = 1.3, def_prob=8, def_val = 1.0},               --劍舞冥想.80%被动发动增加伤害
             { TechType=2, skillId=1441, c_prob=8, c_val = 1.0, def_prob=8, def_val = 0.7},               --鐵壁屏障.80%被动发动减轻伤害
             { TechType=3, skillId=1442, c_prob=9, c_val = 1.5, def_prob=9, def_val = 1.2},               --索隆.二剛力斬90%被动发动
             { TechType=4, skillId=1443, c_prob=9, c_val = 0.8, def_prob=9, def_val = 0.5},               --香吉士.漆黑隱伏90%被动发动
             { TechType=5, skillId=1444, c_prob=10, c_val = 1.2, def_prob=10, def_val = 0.8},             --魯夫.橡膠體質100%被动发动
             { TechType=6, skillId=1445, c_prob=10, c_val = 1.3, def_prob=10, def_val = 0.9},             --神樂.夜兔天人100%被动发动
             { TechType=7, skillId=1446, c_prob=9, c_val = 1.4, def_prob=9, def_val = 1.1},               --鳴人.仙人模式90%被动发动
             { TechType=8, skillId=1447, c_prob=9, c_val = 0.9, def_prob=9, def_val = 0.6},               --佐助.須佐能乎90%被动发动
             { TechType=9, skillId=1448, c_prob=7, c_val = 1.6, def_prob=7, def_val = 1.3},               --鼬.寫輪眼70%被动发动
             { TechType=10, skillId=1449, c_prob=7, c_val = 0.7, def_prob=7, def_val = 0.4},              --綱手.掌仙術70%被动发动
             { TechType=11, skillId=1450, c_prob=5, c_val = 1.8, def_prob=5, def_val = 1.5},              --超賽三.賽亞人50%被动发动
             { TechType=12, skillId=1451, c_prob=5, c_val = 0.5, def_prob=5, def_val = 0.2},              --18號.人造人50%被动发动
             { TechType=13, skillId=1452, c_prob=10, c_val = 1.1, def_prob=10, def_val = 0.7},            --八神庵.屑風100%被动发动
             { TechType=14, skillId=1453, c_prob=10, c_val = 1.1, def_prob=10, def_val = 0.7},            --不知火舞.花嵐100%被动发动
             { TechType=15, skillId=310000, c_prob=8, c_val = 1.2, def_prob=8, def_val = 0.9},              --嫉妒之权能80%发动增伤20%、80%被击减伤10%
             { TechType=16, skillId=310001, c_prob=9, c_val = 0.9, def_prob=9, def_val = 0.9},              --怠惰之权能90%发动减伤10%、90%被击减伤10%
             { TechType=17, skillId=310002, c_prob=10, c_val = 1.4, def_prob=8, def_val = 1.3},             --傲慢之权能100%发动增伤40%、80%被击增伤30%
             { TechType=18, skillId=310003, c_prob=9, c_val = 1.1, def_prob=9, def_val = 0.9},              --暴食之权能90%发动增伤10%、90%被击减伤10%
             { TechType=19, skillId=310004, c_prob=5, c_val = 0.9, def_prob=7, def_val = 1.1},              --色欲之权能50%发动减伤10%、70%被击增伤10%
             { TechType=20, skillId=310005, c_prob=9, c_val = 1.7, def_prob=10, def_val = 1.2},             --愤怒之权能90%发动增伤70%、100%被击增伤20%
             { TechType=21, skillId=310006, c_prob=8, c_val = 0.7, def_prob=10, def_val = 0.8},             --强欲之权能80%发动减伤30%、100%被击减伤20%
             { TechType=22, skillId=310007, c_prob=10, c_val = 0.8, def_prob=7, def_val = 0.5},             --虚饰之权能100%发动减伤20%、70%被击减伤50%
             { TechType=23, skillId=310008, c_prob=10, c_val = 0.8, def_prob=7, def_val = 0.5},             --忧郁之权能100%发动减伤20%、70%被击减伤50%
             { TechType=24, skillId=310009, c_prob=5, c_val = 2.0, def_prob=5, def_val = 0.3},              --嘲讽之魔女50%发动增伤100%、50%被击减伤70%
}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
end

function Module:tempDamage(charIndex, defCharIndex, damage, battleIndex)
        for k, v in ipairs(petMettleTable) do
           if (v.MettleType==1 and Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_宠)  then           --攻方BOSS宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       --print("性格傷害:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==2 and Char.GetData(defCharIndex, CONST.对象_类型) == CONST.对象类型_宠)  then     --受方BOSS宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       --print("性格傷害:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==3 and Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_宠)  then            --攻方四属性相关宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       --print("性格傷害:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==4 and Char.GetData(defCharIndex, CONST.对象_类型) == CONST.对象类型_宠)  then     --受方四属性相关宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       --print("性格傷害:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==5 and Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_宠)  then           --攻方种族宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == v.info) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       --print("性格傷害:"..damage)
                       return damage;
                   end
               end
           end

         end
    return damage;
end

function Module:specialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg)
         --特殊计算公式技能
         if Char.IsPet(charIndex) == true then
               if (com3 == 3031 or com3 == 2931 or com3 == 2831) then
                   --基本資訊
                   local Amnd_R = Char.GetData(charIndex, CONST.CHAR_攻击力);
                   local Amnd = math.max( Conver_240(Amnd_R), 1);
                   local Dmnd_R = Char.GetData(defCharIndex, CONST.CHAR_防御力);
                   local Dmnd = math.max( Conver_240(Dmnd_R), 100)
                   local dp = {}
                   dp[1] = Char.GetData(defCharIndex, CONST.CHAR_地属性)
                   dp[2] = Char.GetData(defCharIndex, CONST.CHAR_水属性)
                   dp[3] = Char.GetData(defCharIndex, CONST.CHAR_火属性)
                   dp[4] = Char.GetData(defCharIndex, CONST.CHAR_风属性)
                   local AttRate_2 = Battle.CalcAttributeDmgRate(charIndex, defCharIndex)
                   local AttRate = (AttRate_2 - 1) * 0.5 + 1
                   local RaceRate = Battle.CalcTribeDmgRate(charIndex, defCharIndex) + 1
                   local RndRate = NLG.Rand(90,110) / 100
                   --print(com3,AttRate,RaceRate,RndRate)
                   local damage = math.floor( ((Amnd / (0.67 + Dmnd / Amnd))* 2)* AttRate * RaceRate * RndRate)
                   local Spirit = Char.GetData(charIndex, CONST.CHAR_精神);
                   local damage = math.ceil(  damage * ( math.max( Conver_240(Spirit), 100) / 60 )  );
                   if com3 == 2931 and NLG.Rand(1,3)==3 then
                       Char.SetData(defCharIndex, CONST.CHAR_BattleModPoison, 3);
                       NLG.UpChar(defCharIndex);
                   elseif com3 == 2831 and NLG.Rand(1,3)==3 then
                       Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 1);
                       NLG.UpChar(defCharIndex);
                   elseif com3 == 3031 and NLG.Rand(1,3)==3 then
                       Char.SetData(defCharIndex, CONST.CHAR_BattleModConfusion, 2);
                       NLG.UpChar(defCharIndex);
                   end
                   return damage;
               elseif (com3 == 310000 or com3 == 310001 or com3 == 310002 or com3 == 310003 or com3 == 310004 or com3 == 310005 or com3 == 310006 or com3 == 310007 or com3 == 310008 or com3 == 310009) then
                   if com3 == 310000 or com3 == 310001 or com3 == 310002 or com3 == 310003 or com3 == 310004 or com3 == 310005 or com3 == 310006 or com3 == 310007 or com3 == 310008 then
                       Char.SetTempData(defCharIndex, '七罪侵蚀', 1);
                       NLG.UpChar(defCharIndex);
                   elseif com3 == 310009 then
                       Char.SetTempData(defCharIndex, '嘲讽侵蚀', 1);
                       NLG.UpChar(defCharIndex);
                   end
                   return damage;
               end
               return damage;
         end
    return damage;
end

function Module:StateDamage(charIndex, defCharIndex, damage, battleIndex)
        for k, v in ipairs(petStateTable) do
           if (v.StateType==1)  then
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i);
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) > 1) then
                       damage = damage * v.val;
                       return damage;
                   end
               end
           elseif (v.StateType==2)  then
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i);
                   local state= Char.GetTempData(defCharIndex, v.type) or 0;
                   if (skillId == v.skillId and state>= 1) then
                       damage = damage * v.val;
                       return damage;
                   end
               end
           end
         end
    return damage;
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if Char.IsDummy(charIndex) then
           return
         end

         --宝可特技
         local damage = self:specialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg);

         if  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPet(defCharIndex) == true  then
           if  flg == CONST.DamageFlags.Normal or flg == CONST.DamageFlags.Critical  then
             --宠物加成
             local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage_temp;
             --技能增减係数
             local c_techRate,def_techRate = self:TechRate(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage * def_techRate;
               local D_Buff = Char.GetTempData(defCharIndex, '防御增益') or 0;
               if (D_Buff >= 1)  then
                   damage = math.floor(damage * 0.8);
                   Char.SetTempData(defCharIndex, '防御增益', D_Buff - 1);
                   return damage;
               end
             return damage;
           elseif  flg == CONST.DamageFlags.Magic  then
             --宠物加成
             local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage_temp;
             --技能增减係数
             local c_techRate,def_techRate = self:TechRate(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage * def_techRate;
               local D_Buff = Char.GetTempData(defCharIndex, '防御增益') or 0;
               if (D_Buff >= 1)  then
                   damage = math.floor(damage * 0.8);
                   Char.SetTempData(defCharIndex, '防御增益', D_Buff - 1);
                   return damage;
               end
             return damage;
           end
           return damage;
         elseif  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPet(charIndex) == true  then
           if  flg == CONST.DamageFlags.Normal or flg == CONST.DamageFlags.Critical  then
             --状态弱点加成
             local damage = self:StateDamage(charIndex, defCharIndex, damage, battleIndex);
             --宠物加成
             local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage_temp;
             --技能增减係数
             local c_techRate,def_techRate = self:TechRate(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage * c_techRate;
               local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
               if (A_Buff >= 1)  then
                   damage = math.floor(damage * 1.35);
                   Char.SetTempData(charIndex, '攻击增益', A_Buff - 1);
                   return damage;
               end
             return damage;
           elseif  flg == CONST.DamageFlags.Magic  then
             --宠物加成
             local ASpirit = Char.GetData(charIndex, CONST.CHAR_精神);
             local DSpirit = Char.GetData(defCharIndex, CONST.CHAR_精神);
             local RegulateRate = Conver_303(ASpirit/DSpirit);
             local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage_temp;
             local damage = math.ceil(  damage * RegulateRate * ( math.max( Conver_240(ASpirit), 303) / 120 )  );
             --技能增减係数
             local c_techRate,def_techRate = self:TechRate(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage * c_techRate;
               local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
               if (A_Buff >= 1)  then
                   damage = math.floor(damage * 1.35);
                   Char.SetTempData(charIndex, '攻击增益', A_Buff - 1);
                   return damage;
               end
             if (com3 >= 26700 and com3 <= 26720)  then
                local TechLv = math.fmod(com3,26700)+1;
                local Amnd_R = Char.GetData(charIndex, CONST.CHAR_攻击力);
                local Amnd = math.max( Conver_240(Amnd_R), 1);
                local Dmnd_R = Char.GetData(defCharIndex, CONST.CHAR_防御力);
                local Dmnd = math.max( Conver_240(Dmnd_R), 100)
                local dp = {}
                dp[1] = Char.GetData(defCharIndex, CONST.CHAR_地属性)
                dp[2] = Char.GetData(defCharIndex, CONST.CHAR_水属性)
                dp[3] = Char.GetData(defCharIndex, CONST.CHAR_火属性)
                dp[4] = Char.GetData(defCharIndex, CONST.CHAR_风属性)
                local AttRate_2 = Battle.CalcAttributeDmgRate(charIndex, defCharIndex)
                local AttRate = (AttRate_2 - 1) * 0.5 + 1
                local RaceRate = Battle.CalcTribeDmgRate(charIndex, defCharIndex) + 1
                local RndRate = NLG.Rand(90,110) / 100
                local damage = math.floor( ((Amnd / (0.67 + Dmnd / Amnd))* TechLv * 0.5)* AttRate * RaceRate * RndRate)
                return damage;
             end
             return damage;
           end
           return damage;
         end
  return damage;
end


function Conver_240(Num)
	if Num >= 240 then
		local a = math.floor((Num - 240 ) * 0.3 + 240)
		return a
	else
		return Num
	end
end

function Conver_303(Rate)
    local Rate = Rate*100;
	if Rate >= 120 then
		return 1
	elseif Rate >= 114 and Rate < 120 then
		local Num = 10/9;
		return Num
	elseif Rate >= 105 and Rate < 114 then
		local Num = 10/8.2;
		return Num
	elseif Rate >= 102 and Rate < 105 then
		local Num = 10/6.3;
		return Num
	elseif Rate >= 98 and Rate < 102 then
		local Num = 10/5;
		return Num
	elseif Rate >= 90 and Rate < 98 then
		local Num = 10/5.5;
		return Num
	elseif Rate >= 80 and Rate < 90 then
		local Num = 10/3.6;
		return Num
	elseif Rate >= 70 and Rate < 80 then
		local Num = 10/2.7;
		return Num
	elseif Rate < 70 then
		local Num = 10/0.9;
		return Num
	end
end

function Module:TechRate(charIndex, defCharIndex, damage, battleIndex)
        local c_val_Rate = 1;
        local def_val_Rate = 1;
        if Char.IsPet(charIndex) == true and Char.IsPet(defCharIndex) == false then
          for i=0,9 do
            local skillId = Pet.GetSkill(charIndex, i)
            for k, v in ipairs(techRateTable) do
               if (skillId == v.skillId) then
                  if (NLG.Rand(1,10) <= v.c_prob) then
                     c_val_Rate = c_val_Rate * v.c_val;
                     def_val_Rate = def_val_Rate * v.def_val;
                  else
                     c_val_Rate = c_val_Rate;
                     def_val_Rate = def_val_Rate;
                  end
               end
            end
          end
          return c_val_Rate, def_val_Rate;
        elseif Char.IsPet(defCharIndex) == true and Char.IsPet(charIndex) == false then
          for i=0,9 do
            local skillId = Pet.GetSkill(defCharIndex, i)
            for k, v in ipairs(techRateTable) do
               if (skillId == v.skillId) then
                  if (NLG.Rand(1,10) <= v.def_prob) then
                     c_val_Rate = c_val_Rate * v.c_val;
                     def_val_Rate = def_val_Rate * v.def_val;
                  else
                     c_val_Rate = c_val_Rate;
                     def_val_Rate = def_val_Rate;
                  end
               end
            end
          end
          return c_val_Rate, def_val_Rate;
        elseif Char.IsPet(charIndex) == true and Char.IsPet(defCharIndex) == true then
          local temp_c_1 = 1;
          local temp_def_1 = 1;
          for i=0,9 do
            local skillId = Pet.GetSkill(charIndex, i)
            for k, v in ipairs(techRateTable) do
               if (skillId == v.skillId) then
                  if (NLG.Rand(1,10) <= v.c_prob) then
                     temp_c_1 = temp_c_1 * v.c_val;
                     temp_def_1 = temp_def_1 * v.def_val;
                  else
                     temp_c_1 = temp_c_1;
                     temp_def_1 = temp_def_1;
                  end
               end
            end
          end
          local temp_c_2 = 1;
          local temp_def_2 = 1;
          for i=0,9 do
            local skillId = Pet.GetSkill(defCharIndex, i)
            for k, v in ipairs(techRateTable) do
               if (skillId == v.skillId) then
                  if (NLG.Rand(1,10) <= v.def_prob) then
                     temp_c_2 = temp_c_2 * v.c_val;
                     temp_def_2 = temp_def_2 * v.def_val;
                  else
                     temp_c_2 = temp_c_2;
                     temp_def_2 = temp_def_2;
                  end
               end
            end
          end
          c_val_Rate = temp_c_1 * temp_def_2;
          def_val_Rate = temp_def_1 * temp_c_2;
          return c_val_Rate, def_val_Rate;
        end
    return 1,1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
