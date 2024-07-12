---模块类
local Module = ModuleBase:createModule('powerLinked')

local Linked_Tbl = {}
local linkTechList = {9630,9631,9632,9633,9634,9635,9636,9637,9638,9639,9640,9641,9642,9643,9644,9645,9646,9647,9648,9649}
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

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self))
end

function Module:OnBeforeBattleTurnCommand(battleIndex)
         local Round = Battle.GetTurn(battleIndex);
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         --重置状态
         Linked_Tbl = {}
         --计算增益数量
         for i = 0, 9 do
               local playerPet = Battle.GetPlayIndex(battleIndex, i);
               if (playerPet >= 0 and Char.GetData(leader,CONST.对象_战斗Side)==0 and Battle.GetType(battleIndex)==1) then
                   if (Char.GetData(playerPet, CONST.CHAR_类型) == CONST.对象类型_宠)  then
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

function Module:LinkedEffect(charIndex, defCharIndex, damage, battleIndex, com3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if Char.IsPlayer(charIndex) then
               --基本資訊
               local LvRate = Char.GetData(charIndex,CONST.CHAR_等级);
               local Attack = Char.GetData(charIndex,CONST.CHAR_攻击力);
               local Defense = Char.GetData(charIndex,CONST.CHAR_防御力);
               local Avoid = Char.GetData(charIndex,CONST.对象_闪躲);
               local Critical = Char.GetData(charIndex,CONST.对象_必杀);
               local Counter = Char.GetData(charIndex,CONST.对象_反击);
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

                        local State = Char.GetTempData(defCharIndex, '弱點') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '弱點', State+1);
                            damage = damage * (1+State/100);
                        end

                        if Blood>=Mana  then
                               Char.SetData(charIndex, CONST.CHAR_BattleDamageVanish, 1);
                               NLG.UpChar(charIndex);
                        elseif Blood<Mana  then
                               Char.SetData(charIndex, CONST.CHAR_BattleDamageMagicVanish, 1);
                               NLG.UpChar(charIndex);
                        end
               end

         end
    return damage;
end

function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if (com3==6339)  then    --君主領域(固定量超補附加恢復魔法補量固定增益)
               if Char.GetData(charIndex,CONST.对象_对战开关) == 1  then
                   NLG.Say(charIndex,charIndex,"【君主領域】！！",4,3);
               end
               local restore = Char.GetData(charIndex,CONST.CHAR_回复);
               local defRestore = Char.GetData(defCharIndex,CONST.CHAR_回复);
               print(restore,defRestore)
               if (defRestore < restore) then
                 Char.SetTempData(defCharIndex, '恢复增益', restore);
                 heal = heal+restore;
                 --NLG.Say(-1,-1,"【君主領域】無視被治癒者回復的補血術！！",4,3);
               else
                 heal = heal;
               end
               return heal;
         end
         if (flg==CONST.HealDamageFlags.Heal)  then    --補血治療魔法
               local deBuff = Char.GetTempData(defCharIndex, '回复减益') or 0;
               if (deBuff > 0)  then
                       if (deBuff==2)  then
                           heal = heal * 0.5;
                           Char.SetTempData(defCharIndex, '回复减益', 1);
                       elseif (deBuff==1)  then
                           heal = heal * 0.5;
                           Char.SetTempData(defCharIndex, '回复减益', 0);
                       end
               else
                       heal = heal;
               end
               return heal;
         elseif (flg==CONST.HealDamageFlags.Recovery)  then    --恢復魔法
               local deBuff = Char.GetTempData(defCharIndex, '回复减益') or 0;
               local Buff = Char.GetTempData(defCharIndex, '恢复增益') or 0;
               if (Buff > 0)  then
                   if (deBuff>0)  then
                      local HpHeal = Buff * 0.5;
                      heal = heal * 0.5+HpHeal;
                      Char.SetTempData(defCharIndex, '恢复增益', HpHeal);
                   else
                      local HpHeal = Buff * 0.5;
                      heal = heal+HpHeal;
                      Char.SetTempData(defCharIndex, '恢复增益', HpHeal);
                   end
               elseif (Buff <= 0)  then
                   if (deBuff>0)  then
                      heal = heal * 0.5;
                   else
                      heal = heal;
                   end
               else
                   heal = heal;
               end
               return heal;
         elseif (flg==CONST.HealDamageFlags.Consentration)  then    --明鏡止水
               Char.SetTempData(defCharIndex, '傷口', 0);
               Char.SetTempData(defCharIndex, '猛毒', 0);
               local deBuff = Char.GetTempData(defCharIndex, '回复减益') or 0;
               if (deBuff > 0)  then
                       heal = heal * 0.1;
                       Char.SetTempData(defCharIndex, '回复减益', 0);
               else
                       heal = heal;
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
         print("增加傷害"..damage_A.."%","減少傷害"..damage_D.."%")

         if (flg==CONST.DamageFlags.Poison)  then    --中毒傷害
               local deBuff = Char.GetTempData(defCharIndex, '猛毒') or 0;
               if (deBuff > 0)  then
                       if (deBuff==2)  then
                           damage = damage * 2;
                           Char.SetTempData(defCharIndex, '猛毒', 1);
                       elseif (deBuff==1)  then
                           damage = damage * 2;
                           Char.SetTempData(defCharIndex, '猛毒', 0);
                       end
               else
                       damage = damage;
               end
               return damage;
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               if (defCom1==2502)  then    --0x9C6不死不壞/defCom1==43聖盾(無限抵擋死亡)
                     if Char.GetData(defCharIndex,CONST.对象_对战开关) == 1  then
                         NLG.Say(defCharIndex,defCharIndex,"【不死不壞】！！",4,3);
                     end
                     local defHpE = Char.GetData(defCharIndex,CONST.CHAR_血);
                     if damage>=defHpE-1 then
                       Char.SetData(defCharIndex, CONST.CHAR_血, defHpE+damage*0.1);
                       Char.SetData(defCharIndex, CONST.CHAR_受伤, 0);
                       Char.SetData(defCharIndex, CONST.CHAR_BattleLpRecovery, 2);
                       Char.UpCharStatus(defCharIndex);
                       NLG.UpChar(defCharIndex);
                       damage = damage*0;
                       --NLG.Say(-1,-1,"【不死不壞】抵銷了致命的傷害！！",4,3);
                     else
                       damage = damage;
                     end
                     return damage;
               end
               return damage;
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg ~= CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               if (com3 == 10539)  then    --10539晴天大征
                     if Char.GetData(charIndex,CONST.对象_对战开关) == 1  then
                         NLG.Say(charIndex,charIndex,"【晴天大征】！！",4,3);
                     end
                     local State = Char.GetTempData(defCharIndex, '傷口') or 0;
                     if (State>0) then
                             if (State==2)  then
                                 Char.SetTempData(defCharIndex, '傷口', 1);
                                 damage = damage*1.2;
                                 --NLG.Say(-1,-1,"【晴天大征】攻擊傷口部位暴擊增加傷害20%，剩下1處傷口！！",4,3);
                             elseif (State==1)  then
                                 Char.SetTempData(defCharIndex, '傷口', 0);
                                 damage = damage*1.2;
                                 --NLG.Say(-1,-1,"【晴天大征】攻擊傷口部位暴擊增加傷害20%，對象將無傷口！！",4,3);
                             end
                     else
                             Char.SetTempData(defCharIndex, '傷口', 2);
                             damage = damage*0.7;
                             --NLG.Say(-1,-1,"【晴天大征】攻擊非傷口部位降低傷害30%，但造成2處傷口！！",4,3);
                     end
                     return damage;
               elseif (com3==26039)  then    --日光槍尖
                     if Char.GetData(charIndex,CONST.对象_对战开关) == 1  then
                         NLG.Say(charIndex,charIndex,"【日光槍尖】！！",4,3);
                     end
                     local deBuff = Char.GetTempData(defCharIndex, '回复减益') or 0;
                     if (deBuff==0) then
                       Char.SetTempData(defCharIndex, '回复减益', 2);
                       damage = damage;
                       --NLG.Say(-1,-1,"【日光槍尖】給予對象治療、恢復、明鏡補量減益2層！！",4,3);
                     end
                     return damage;
               elseif (com3==11139)  then    --虛數空間
                     if Char.GetData(charIndex,CONST.对象_对战开关) == 1  then
                         NLG.Say(charIndex,charIndex,"【虛數空間】！！",4,3);
                     end
                     local defMp = Char.GetData(defCharIndex, CONST.CHAR_魔);
                     local deBuff = Char.GetTempData(defCharIndex, '猛毒') or 0;
                     Char.SetData(defCharIndex, CONST.CHAR_魔, defMp*0.8);
                     NLG.UpChar(defCharIndex);
                     if (deBuff==0) then
                       Char.SetTempData(defCharIndex, '猛毒', 2);
                       damage = damage;
                       --NLG.Say(-1,-1,"【虛數空間】對象當前FP削減20%，並給予中毒時猛毒傷害2回次！！",4,3);
                     end
                     return damage;
               end

         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg == CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               if Char.IsPlayer(charIndex) then
                 local LvRate = Char.GetData(charIndex,CONST.CHAR_等级);
                 local Spirit = Char.GetData(charIndex,CONST.CHAR_精神);
                 local Mattack = Char.GetData(charIndex,CONST.CHAR_魔攻);
                 local Amnd_R = Char.GetData(charIndex, CONST.CHAR_精神);
                 local Amnd = math.max(Conver_800(Amnd_R * 1),1);
                 local Dmnd_R = math.max(Char.GetData(defCharIndex, CONST.CHAR_精神), 100);
                 local Dmnd = Conver_800(Dmnd_R * 1);
                 local SpRate = math.floor( (Amnd / (0.67 + Dmnd / Amnd)) ) * 0.01;
                 damage = damage * SpRate + Spirit * 0.75 * 1.2 + (Mattack+400)*0.75;
                 print(damage)
                 return damage;
               end

         else
         end
  return damage;
end

function Conver_800(Num)
	if Num >= 240 then
		if Num >= 800 then
			local a = math.floor((Num - 800 ) * 0.08 + 168 + 240)
			return a
		else
			local a = math.floor((Num - 240 ) * 0.3 + 240)
			return a
		end
	else
		return Num
	end
end
--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
