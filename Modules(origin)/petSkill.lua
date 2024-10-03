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
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_邪魔, skillId=9629 , val = 1.05},              --对邪魔系对象增加伤害
}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
end

function Module:tempDamage(charIndex, defCharIndex, damage, battleIndex)
        for k, v in ipairs(petMettleTable) do
           if (v.MettleType==1 and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then           --攻方BOSS宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       --print("性格傷害:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==2 and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then     --受方BOSS宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       --print("性格傷害:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==3 and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then            --攻方四属性相关宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       --print("性格傷害:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==4 and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then     --受方四属性相关宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       --print("性格傷害:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==5 and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then           --攻方种族宠物性格
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

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if  flg == CONST.DamageFlags.Combo and Char.IsEnemy(defCharIndex) and Char.IsPlayer(charIndex) then
            local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
            if (enemyId==400021) then
                    Char.GiveItem(charIndex, 40844, 1);
                    NLG.SortItem(charIndex);

            end
            return damage;
         end
         if  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then
           --宠物加成
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
           return damage;
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then
           --宠物加成
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
           return damage;
         elseif  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then
           --宠物加成
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
           return damage;
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then
           --宠物加成
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
           --local damage = damage * 1.05 ;
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


function Conver_240(Num)
	if Num >= 240 then
		local a = math.floor((Num - 240 ) * 0.3 + 240)
		return a
	else
		return Num
	end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
