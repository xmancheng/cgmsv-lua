---模块类
local AttackSkill = ModuleBase:createModule('attackSkill')

--- 加载模块钩子
function AttackSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
end

function AttackSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
--抓寵技能刀背攻擊
               if com3 == 8137  then
                 local defLvE = Char.GetData(defCharIndex,CONST.CHAR_等级);
                 local defHpE = Char.GetData(defCharIndex,CONST.CHAR_血);
                 local defHpEM = Char.GetData(defCharIndex,CONST.CHAR_最大血);
                 if defLvE<=1  then
                         if defHpE<=10  then
                             damage = damage*0;
                         else
                             damage = damage*0 + defHpE - 10;
                         end
                 else
                         damage = damage;
                 end
                 --print(defHpE,damage)
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                         NLG.Say(charIndex,charIndex,"【刀背攻擊】傷害前目標剩餘血量".. defHpE .."！！",4,3);
                 end
                 return damage;
               end

--[[法術附加30%狀態
               local LvRate = Char.GetData(charIndex,CONST.CHAR_等级);
               local Spirit = Char.GetData(charIndex,CONST.CHAR_精神);
               local Mattack = Char.GetData(charIndex,CONST.CHAR_魔攻);
               local JobLv = Char.GetData(charIndex,CONST.CHAR_职阶)+1;
               local JobLv_tbl = {200,310,340,370,400,430};
               if LvRate <= 50  then
                        LvRate = 1;
               else
                        LvRate = LvRate/50;
               end
               if Spirit <= 800  then
                        SpRate = 1;
               else
                        SpRate = Spirit/800;
               end
               if (com3 >= 1900 and com3 <= 1909) or (com3 >= 2300 and com3 <= 2309) or (com3 >= 2700 and com3 <= 2709)  then    --隕石魔法
                 if com3 >= 1900 and com3 <= 1909  then
                        damage = damage * SpRate + Spirit * 0.5 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.5;
                 elseif com3 >= 2300 and com3 <= 2309  then
                        damage = damage * SpRate + Spirit * 0.25 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.25;
                 elseif com3 >= 2700 and com3 <= 2709  then
                        damage = damage * SpRate + Spirit * 0.125 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.125;
                 end
                 if NLG.Rand(1,10)>=8  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModConfusion, 2);
                 end
                 return damage;
               end
               if (com3 >= 2000 and com3 <= 2009) or (com3 >= 2400 and com3 <= 2409) or (com3 >= 2800 and com3 <= 2809)  then    --冰凍魔法
                 if com3 >= 2000 and com3 <= 2009  then
                        damage = damage * SpRate + Spirit * 0.5 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.5;
                 elseif com3 >= 2400 and com3 <= 2409  then
                        damage = damage * SpRate + Spirit * 0.25 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.25;
                 elseif com3 >= 2800 and com3 <= 2809  then
                        damage = damage * SpRate + Spirit * 0.125 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.125;
                 end
                 if NLG.Rand(1,10)>=8  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModDrunk, 2);
                 end
                 return damage;
               end
               if (com3 >= 2100 and com3 <= 2109) or (com3 >= 2500 and com3 <= 2509) or (com3 >= 2900 and com3 <= 2909)  then    --火焰魔法
                 if com3 >= 2100 and com3 <= 2109  then
                        damage = damage * SpRate + Spirit * 0.5 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.5;
                 elseif com3 >= 2500 and com3 <= 2509  then
                        damage = damage * SpRate + Spirit * 0.25 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.25;
                 elseif com3 >= 2900 and com3 <= 2909  then
                        damage = damage * SpRate + Spirit * 0.125 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.125;
                 end
                 if NLG.Rand(1,10)>=8  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModPoison, 2);
                 end
                 return damage;
               end
               if (com3 >= 2200 and com3 <= 2209) or (com3 >= 2600 and com3 <= 2609) or (com3 >= 3000 and com3 <= 3009)  then    --風刃魔法
                 if com3 >= 2200 and com3 <= 2209  then
                        damage = damage * SpRate + Spirit * 0.5 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.5;
                 elseif com3 >= 2600 and com3 <= 2609  then
                        damage = damage * SpRate + Spirit * 0.25 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.25;
                 elseif com3 >= 3000 and com3 <= 3009  then
                        damage = damage * SpRate + Spirit * 0.125 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.125;
                 end
                 if NLG.Rand(1,10)>=8  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 2);
                 end
                 return damage;
               end
]]
--單體50%狀態大攻擊
               if (com3 >= 7510 and com3 <= 7519)  then    --蓋棺鐵圍山
                 if NLG.Rand(1,10)>=6  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModPoison, 2);
                 end
                 return damage;
               end
               if (com3 >= 7810 and com3 <= 7819)  then    --蕩蘊平線
                 if NLG.Rand(1,10)>=6  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModDrunk, 2);
                 end
                 return damage;
               end
               if (com3 >= 7910 and com3 <= 7919)  then    --自閉圓頓裹
                 if NLG.Rand(1,10)>=6  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModConfusion, 2);
                 end
                 return damage;
               end
               if (com3 >= 8010 and com3 <= 8019)  then    --祭森供花
                 if NLG.Rand(1,10)>=6  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModAmnesia, 2);
                 end
                 return damage;
               end

--合擊狀態增傷
               if flg == CONST.DamageFlags.Combo  then
                 if  Char.GetData(defCharIndex, CONST.CHAR_BattleModConfusion)>=1  then
                        damage = damage * 1.01;
                        print(damage)
                        --NLG.Say(leader,charIndex,"【对混乱目标伤害提高1%】！！",4,3);
                        return damage;
                 end
                 if  Char.GetData(defCharIndex, CONST.CHAR_BattleModDrunk)>=1  then
                        damage = damage * 1.01;
                        print(damage)
                        --NLG.Say(leader,charIndex,"【对酒醉目标伤害提高1%】！！",4,3);
                        return damage;
                 end
                 if  Char.GetData(defCharIndex, CONST.CHAR_BattleModPoison)>=1  then
                        damage = damage * 1.01;
                        print(damage)
                        --NLG.Say(leader,charIndex,"【对中毒目标伤害提高1%】！！",4,3);
                        return damage;
                 end
                 if  Char.GetData(defCharIndex, CONST.CHAR_BattleModSleep)>=1  then
                        damage = damage * 1.01;
                        print(damage)
                        --NLG.Say(leader,charIndex,"【对昏睡目标伤害提高1%】！！",4,3);
                        return damage;
                 end
                 if  Char.GetData(defCharIndex, CONST.CHAR_BattleModStone)>=1  then
                        damage = damage * 1.01;
                        print(damage)
                        --NLG.Say(leader,charIndex,"【对石化目标伤害提高1%】！！",4,3);
                        return damage;
                 end
                 if  Char.GetData(defCharIndex, CONST.CHAR_BattleModAmnesia)>=1  then
                        damage = damage * 1.01;
                        print(damage)
                        --NLG.Say(leader,charIndex,"【对遗忘目标伤害提高1%】！！",4,3);
                        return damage;
                 end
               end

         else
         end
  return damage;
end

--- 卸载模块钩子
function AttackSkill:onUnload()
  self:logInfo('unload')
end

return AttackSkill;