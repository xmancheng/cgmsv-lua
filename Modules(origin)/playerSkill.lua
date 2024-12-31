---模块类
local Module = ModuleBase:createModule('playerSkill')

--连结技能基础设置
local Linked_Tbl = {}
local linkTechList = {9620,9621,9622,9623,9624,9625,9626,9627,9628,9629,9630,9631,9632,9633,9634,9635,9636,9637,9638,9639}
local petMettleTable = {
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_人型, skillId=9630 , buff = 0.10},              --对人形系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_龙, skillId=9631 , buff = 0.10},              --对龙族系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_不死, skillId=9632 , buff = 0.10},              --对不死系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_飞行, skillId=9633 , buff = 0.10},              --对飞行系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_昆虫, skillId=9634 , buff = 0.10},              --对昆虫系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_植物, skillId=9635 , buff = 0.10},              --对植物系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_野兽, skillId=9636 , buff = 0.10},              --对野兽系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_特殊, skillId=9637 , buff = 0.10},              --对特殊系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_金属, skillId=9638 , buff = 0.10},              --对金属系对象增加伤害
             { MettleType=5, type=CONST.CHAR_种族, info=CONST.种族_邪魔, skillId=9639 , buff = 0.05},              --对邪魔系对象增加伤害

             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_人型, skillId=9640 , buff = 0.10},              --减轻来自人形系对象伤害
             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_龙, skillId=9641 , buff = 0.10},              --减轻来自龙族系对象伤害
             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_不死, skillId=9642 , buff = 0.10},              --减轻来自不死系对象伤害
             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_飞行, skillId=9643 , buff = 0.10},              --减轻来自飞行系对象伤害
             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_昆虫, skillId=9644 , buff = 0.10},              --减轻来自昆虫系对象伤害
             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_植物, skillId=9645 , buff = 0.10},              --减轻来自植物系对象伤害
             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_野兽, skillId=9646 , buff = 0.10},              --减轻来自野兽系对象伤害
             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_特殊, skillId=9647 , buff = 0.10},              --减轻来自特殊系对象伤害
             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_金属, skillId=9648 , buff = 0.10},              --减轻来自金属系对象伤害
             { MettleType=6, type=CONST.CHAR_种族, info=CONST.种族_邪魔, skillId=9649 , buff = 0.05},              --减轻来自邪魔系对象伤害
}

--形象增减伤设置
local imageRateTable = {
             { ImageType=1, imageId=106452, ac_val=1.05, mc_val=1.00, adef_val=1.00, mdef_val=1.00},           --增加物理伤害5%
             { ImageType=2, imageId=106627, ac_val=1.00, mc_val=1.05, adef_val=1.00, mdef_val=1.00},           --增加魔法伤害5%
             { ImageType=3, imageId=106552, ac_val=1.00, mc_val=1.00, adef_val=0.95, mdef_val=1.00},           --减轻物理伤害5%
             { ImageType=4, imageId=106727, ac_val=1.00, mc_val=1.00, adef_val=1.00, mdef_val=0.95},           --减轻魔法伤害5%
}

---------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LoginGateEvent', Func.bind(self.onLogbattleOverEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogbattleOverEvent, self));
  self:regCallback('TribeRateEvent', Func.bind(self.onTribeRateEvent, self));
end

function Module:onTribeRateEvent(charIndex, defCharIndex, rate)
         --print(charIndex, defCharIndex, rate)
    return rate;
end
--特殊技能效果
function Module:SpecialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         --特殊计算公式技能
         if Char.IsPlayer(charIndex)==true then
               --基本資訊
               local Agile = Char.GetData(charIndex,CONST.CHAR_敏捷);
               local Blood = Char.GetData(charIndex,CONST.CHAR_血);
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
               if (com3 == 3030 or com3 == 2930 or com3 == 2830) then		--ninja
                   local damage = math.floor( (Agile * 0.75)* AttRate * RaceRate * RndRate)
                   if com3 == 2930 and NLG.Rand(1,3)==3 then
                       Char.SetData(defCharIndex, CONST.CHAR_BattleModPoison, 3);
                       NLG.UpChar(defCharIndex);
                   elseif com3 == 2830 and NLG.Rand(1,3)==3 then
                       Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 1);
                       NLG.UpChar(defCharIndex);
                   elseif com3 == 3030 and NLG.Rand(1,3)==3 then
                       Char.SetData(defCharIndex, CONST.CHAR_BattleModConfusion, 2);
                       NLG.UpChar(defCharIndex);
                   end
                   return damage;
               elseif (com3 == 2730) then					--knight
                   local damage = math.floor( (Blood * 0.45)* AttRate * RaceRate * RndRate)
                   if NLG.Rand(1,4)>=3 then
                       Char.SetData(charIndex, CONST.CHAR_BattleDamageVanish, 3);
                       NLG.UpChar(charIndex);
                   end
                   return damage;
               end
               return damage;
         end
    return damage;
end
--连结效果(范例)
function Module:LinkedEffect(charIndex, defCharIndex, damage, battleIndex, com3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if Char.IsPlayer(charIndex) then
               --基本資訊
               local LvRate = Char.GetData(charIndex,CONST.CHAR_等级);
               local Attack = Char.GetData(charIndex,CONST.CHAR_攻击力);
               local Defense = Char.GetData(charIndex,CONST.CHAR_防御力);
               local Avoid = Char.GetData(charIndex,CONST.CHAR_闪躲);
               local Critical = Char.GetData(charIndex,CONST.CHAR_必杀);
               local Counter = Char.GetData(charIndex,CONST.CHAR_反击);
               local Agile = Char.GetData(charIndex,CONST.CHAR_敏捷);
               local Spirit = Char.GetData(charIndex,CONST.CHAR_精神);
               local Blood = Char.GetData(charIndex,CONST.CHAR_血);
               local Mana = Char.GetData(charIndex,CONST.CHAR_魔);
               local Mattack = Char.GetData(charIndex,CONST.CHAR_魔攻);
               if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Weapon_Name~=nil then

                 local techList = {9519,25815,25816,25817,25818,25819,415,416,417,418,429}
                        table.forEach(techList, function(e)
                        if com3 == e and NLG.Rand(1,4)==2  then
                               for  i=0, 19 do
                                   local player = Battle.GetPlayIndex(battleIndex, i)
                                   if player>=0 then
                                     if Char.IsPlayer(player) or Char.IsPet(player) then
                                       Char.SetData(player, CONST.CHAR_BattleDamageAbsrob, 1);
                                       NLG.UpChar(player);
                                     end
                                   end
                               end
                        end
                        end)
               end

         end
    return damage;
end
--治愈事件
function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if (flg==CONST.HealDamageFlags.Heal)  then    --补血治疗魔法
            if (com3==6300 or com3==6301 or com3==6302)  then
               if (Char.IsPlayer(defCharIndex)==true or Char.IsPet(defCharIndex)==true) then
                   local D_Buff = Char.GetTempData(defCharIndex, '防御增益') or 0;
                   if (D_Buff<=5)  then
                       heal = 666;
                       Char.SetTempData(defCharIndex, '防御增益', 5);
                   end
               end
            end
            return heal;
         elseif (flg==CONST.HealDamageFlags.Recovery)  then    --恢复魔法
               return heal;
         elseif (flg==CONST.HealDamageFlags.Consentration)  then    --明镜止水
            if (com3==1200 or com3==1201 or com3==1202)  then
               if (Char.IsPlayer(defCharIndex)==true or Char.IsPet(defCharIndex)==true) then
                   local A_Buff = Char.GetTempData(defCharIndex, '攻击增益') or 0;
                   if (A_Buff<=3)  then
                       heal = 350;
                       Char.SetTempData(defCharIndex, '攻击增益', 3);
                   end
               end
            end
            return heal;
         end
         return heal;
end
--伤害事件
function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
               leader = leader2
         end
		 
         local damage_A=0;
         local damage_D=0;
         local Linked_Tbl = Linked_Tbl;
         for i=1,#Linked_Tbl do
              for k, v in ipairs(petMettleTable) do
                  if (v.MettleType==5 and v.skillId==Linked_Tbl[i][1] and Char.GetData(defCharIndex, v.type) == v.info) then
                     damage_A = (1+ (Linked_Tbl[i][2] * v.buff))*100;
                     damage = damage*(1+ (Linked_Tbl[i][2] * v.buff));
                  elseif (v.MettleType==6 and v.skillId==Linked_Tbl[i][1] and Char.GetData(charIndex, v.type) == v.info) then
                     damage_D = (1- (Linked_Tbl[i][2] * v.buff))*100;
                     damage = damage*(1- (Linked_Tbl[i][2] * v.buff));
                  else
                     damage = damage;
                  end
              end
         end
       --print("增加傷害"..damage_A.."%","減少傷害"..damage_D.."%")

        --形象增减係数
        local ac_val, mc_val, adef_val, mdef_val = self:ImageRate(charIndex, defCharIndex, damage, battleIndex);
       --print(ac_val, mc_val, adef_val, mdef_val)

         if  flg == CONST.DamageFlags.Combo and Char.IsEnemy(defCharIndex) == true and Char.IsPlayer(charIndex) == true then
            local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
            if (enemyId==400021) then
                    Char.GiveItem(charIndex, 40844, 1);
                    NLG.SortItem(charIndex);
            end
		 end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPlayer(defCharIndex)==true  then
           if  flg == CONST.DamageFlags.Normal or flg == CONST.DamageFlags.Critical  then
               local damage = damage * adef_val;		--形象增减伤
               local D_Buff = Char.GetTempData(defCharIndex, '防御增益') or 0;
               if (D_Buff >= 1)  then
                   local damage = math.floor(damage * 0.8);
                   --print(oriDamage,damage);
                   Char.SetTempData(defCharIndex, '防御增益', D_Buff - 1);
                   return damage;
               end
               return damage;
           elseif flg == CONST.DamageFlags.Magic  then
               local damage = damage * mdef_val;		--形象增减伤
               local D_Buff = Char.GetTempData(defCharIndex, '防御增益') or 0;
               if (D_Buff >= 1)  then
                   local damage = math.floor(damage * 0.8);
                   --print(oriDamage,damage);
                   Char.SetTempData(defCharIndex, '防御增益', D_Buff - 1);
                   return damage;
               end
               return damage;
           end
           return damage;
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPlayer(charIndex)==true  then
           if  flg == CONST.DamageFlags.Normal or flg == CONST.DamageFlags.Critical  then
               local damage = damage * ac_val;		--形象增减伤
               local damage = self:SpecialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg);
               local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
               if (A_Buff >= 1)  then
                   local damage = math.floor(damage * 1.35);
                   --print(oriDamage,damage);
                   Char.SetTempData(charIndex, '攻击增益', A_Buff - 1);
                   return damage;
               end
               return damage;
           elseif flg == CONST.DamageFlags.Magic  then
               local damage = damage * mc_val;		--形象增减伤
               local damage = self:SpecialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg);
               local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
               if (A_Buff >= 1)  then
                   local damage = math.floor(damage * 1.35);
                   --print(oriDamage,damage);
                   Char.SetTempData(charIndex, '攻击增益', A_Buff - 1);
                   return damage;
               end
               return damage;
           end
           return damage;
         end
  return damage;
end

---------------------------------------------------------------------------
------功能函数
--连结数计算
function Module:OnbattleStarCommand(battleIndex)
    for i=0, 19 do
        local charIndex = Battle.GetPlayIndex(battleIndex, i)
        if (charIndex>=0 and Char.IsPlayer(charIndex)==true) then
            local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
            if (A_Buff >= 1) then
                    NLG.SetHeadIcon(charIndex, 119646);
            else
                    NLG.SetHeadIcon(charIndex, 1);
            end
        end
    end
         local Round = Battle.GetTurn(battleIndex);
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         --重置状态
         Linked_Tbl = {}
         --计算增益数量
         for i = 0, 9 do
               local playerPet = Battle.GetPlayIndex(battleIndex, i);
               if (playerPet >= 0 and Char.GetData(leader,CONST.对象_战斗Side)==0 and Battle.GetType(battleIndex)==1) then
                   if (Char.GetData(playerPet, CONST.对象_类型) == CONST.对象类型_宠)  then
                       for slot=0,9 do
                           local linkTechId = Pet.GetSkill(playerPet, slot);
                           table.forEach(linkTechList, function(e)
                               if (linkTechId == e) then
                                   --确认有无数据
                                   local boxCheck = 0;
                                   for i=1,#Linked_Tbl do
                                       if (Linked_Tbl[i][1]==e) then
                                           boxCheck=i;
                                       end
                                   end
                                   --增益放入表格
                                   if (boxCheck>0) then
                                       Linked_Tbl[boxCheck][2] = Linked_Tbl[boxCheck][2]+1;
                                   elseif (boxCheck==0) then
                                       local Linked_data = { e, 1};
                                       table.insert(Linked_Tbl, Linked_data);
                                   end
                               end
                           end)
                       end
                   end
               end
         end
end

--结束、注销初始化
function Module:battleOverEventCallback(battleIndex)
  for i = 0, 19 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
              local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
              local D_Buff = Char.GetTempData(charIndex, '防御增益') or 0;
              if (A_Buff >= 1) then
                 Char.SetTempData(charIndex, '攻击增益', 0);
              end
              if (D_Buff >= 1) then
                 Char.SetTempData(charIndex, '防御增益', 0);
              end
        end
  end
end
function Module:onLogbattleOverEvent(charIndex)
	local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
	local D_Buff = Char.GetTempData(charIndex, '防御增益') or 0;
	if (A_Buff >= 1) then
		Char.SetTempData(charIndex, '攻击增益', 0);
	end
	if (D_Buff >= 1) then
		Char.SetTempData(charIndex, '防御增益', 0);
	end
end


--增减伤系数计算
function Module:ImageRate(charIndex, defCharIndex, damage, battleIndex)
        local ac_val_Rate = 1;
        local mc_val_Rate = 1;
        local adef_val_Rate = 1;
        local mdef_val_Rate = 1;
        if Char.IsPlayer(charIndex) == true and Char.IsPlayer(defCharIndex) == false then
            local imageId = Char.GetData(charIndex, CONST.对象_形象)
            for k, v in ipairs(imageRateTable) do
               if (imageId == v.imageId) then
                  if (NLG.Rand(1,10) <= 10) then
                     ac_val_Rate = ac_val_Rate * v.ac_val;
                     mc_val_Rate = mc_val_Rate * v.mc_val;
                     adef_val_Rate = adef_val_Rate * v.adef_val;
                     mdef_val_Rate = mdef_val_Rate * v.mdef_val;
                  else
                     ac_val_Rate = ac_val_Rate;
                     mc_val_Rate = mc_val_Rate;
                     adef_val_Rate = adef_val_Rate;
                     mdef_val_Rate = mdef_val_Rate;
                  end
               end
            end
          return ac_val_Rate, mc_val_Rate, adef_val_Rate, mdef_val_Rate;
        elseif Char.IsPlayer(defCharIndex) == true and Char.IsPlayer(charIndex) == false then
            local imageId = Char.GetData(defCharIndex, CONST.对象_形象)
            for k, v in ipairs(imageRateTable) do
               if (imageId == v.imageId) then
                  if (NLG.Rand(1,10) <= 10) then
                     ac_val_Rate = ac_val_Rate * v.ac_val;
                     mc_val_Rate = mc_val_Rate * v.mc_val;
                     adef_val_Rate = adef_val_Rate * v.adef_val;
                     mdef_val_Rate = mdef_val_Rate * v.mdef_val;
                  else
                     ac_val_Rate = ac_val_Rate;
                     mc_val_Rate = mc_val_Rate;
                     adef_val_Rate = adef_val_Rate;
                     mdef_val_Rate = mdef_val_Rate;
                  end
               end
            end
          return ac_val_Rate, mc_val_Rate, adef_val_Rate, mdef_val_Rate;
        elseif Char.IsPlayer(charIndex) == true and Char.IsPlayer(defCharIndex) == true then
          local temp_ac_1 = 1;
          local temp_mc_1 = 1;
          local temp_adef_1 = 1;
          local temp_mdef_1 = 1;
          local imageId = Char.GetData(charIndex, CONST.对象_形象)
          for k, v in ipairs(imageRateTable) do
               if (imageId == v.imageId) then
                  if (NLG.Rand(1,10) <= 10) then
                     temp_ac_1 = temp_ac_1 * v.ac_val;
                     temp_mc_1 = temp_mc_1 * v.mc_val;
                     temp_adef_1 = temp_adef_1 * v.adef_val;
                     temp_mdef_1 = temp_mdef_1 * v.mdef_val;
                  else
                     temp_ac_1 = temp_ac_1;
                     temp_mc_1 = temp_mc_1;
                     temp_adef_1 = temp_adef_1;
                     temp_mdef_1 = temp_mdef_1;
                  end
               end
          end
          local temp_ac_2 = 1;
          local temp_mc_2 = 1;
          local temp_adef_2 = 1;
          local temp_mdef_2 = 1;
          local imageId = Char.GetData(defCharIndex, CONST.对象_形象)
          for k, v in ipairs(imageRateTable) do
               if (imageId == v.imageId) then
                  if (NLG.Rand(1,10) <= 10) then
                     temp_ac_2 = temp_ac_2 * v.ac_val;
                     temp_mc_2 = temp_mc_2 * v.mc_val;
                     temp_adef_2 = temp_adef_2 * v.adef_val;
                     temp_mdef_2 = temp_mdef_2 * v.mdef_val;
                  else
                     temp_ac_2 = temp_ac_2;
                     temp_mc_2 = temp_mc_2;
                     temp_adef_2 = temp_adef_2;
                     temp_mdef_2 = temp_mdef_2;
                  end
               end
          end

          ac_val_Rate = temp_ac_1 * temp_adef_2;
          mc_val_Rate = temp_mc_1 * temp_mdef_2;
          adef_val_Rate = temp_adef_1 * temp_ac_2;
          mdef_val_Rate = temp_mdef_1 * temp_mc_2;
          return ac_val_Rate, mc_val_Rate, adef_val_Rate, mdef_val_Rate;
        end
    return 1,1,1,1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
