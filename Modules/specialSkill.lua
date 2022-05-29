---模块类
local SpecialSkill = ModuleBase:createModule('specialSkill')

Equipment ={}
for eee = 0,799 do
	Equipment[eee] = {}
	Equipment[eee][0] = 0  --初始化回合数
	Equipment[eee][1] = 0  --初始化打击数
end


--- 加载模块钩子
function SpecialSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
end


function SpecialSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg ~= CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               local RaceType = Char.GetData(charIndex,CONST.CHAR_种族);
               if ( RaceType == CONST.种族_人型 ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 if (battleturn == 0) then
                     Equipment[charIndex][0] = battleturn;
                     Equipment[charIndex][1] = 0;
                 elseif (battleturn > Equipment[charIndex][0]) then
                     Equipment[charIndex][0] = battleturn;
                     Equipment[charIndex][1] = 0;
                 end
                 Equipment[charIndex][1] = Equipment[charIndex][1] + 1;
                 local cj= 1 + (Equipment[charIndex][1]*0.015);
                 if Equipment[charIndex][1]>=3 then
                          Char.SetData(charIndex, CONST.CHAR_BattleDamageReflec, 1);
                          if Equipment[charIndex][1]>=5 then
                                   Char.SetData(defCharIndex, CONST.CHAR_BattleModDrunk, 3);
                                   if Equipment[charIndex][1]>=20 then
                                            cj = 1.3;
                                   end
                          end
                 end
                 local damage = damage * cj;
                 print(damage)
                 Equipment[charIndex][1] = turnhit;
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【寸勁】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"人型系人物在战斗中每次打击伤害提升1.5%，达次数得到额外效果，每回合重置次数",4,3);
                 return damage;
               end
               if ( RaceType == CONST.种族_飞行 ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHpE = Char.GetData(defCharIndex,CONST.CHAR_血);
                 local defHpEM = Char.GetData(defCharIndex,CONST.CHAR_最大血);
                 local HpE05 = defHpE/defHpEM;
                 if HpE05<=0.5  then
                        yy = 1.2;
                 else
                        yy = 1;
                 end
                 if NLG.Rand(1,10)>=8  then
                        damage = damage * yy;
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 2);
                        if Char.GetData(leader,%对象_队聊开关%) == 1  then
                               NLG.Say(charIndex,charIndex,"【羽翼】！！",4,3);
                        end
                 else
                        damage = damage;
                 end
                 print(damage)
                 --NLG.Say(-1,-1,"飞行系人物每次造成伤害时，有30%的几率使目标石化2回合，对当前生命值少于50%的目标伤害提高20%",4,3);
                 return damage;
               end
               if ( RaceType == CONST.种族_昆虫 ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHpE = Char.GetData(defCharIndex,CONST.CHAR_血);
                 local dy = defHpE*0.5;
                 if dy>=damage  then
                        dy = damage;
                 end
                 if NLG.Rand(1,10)>=8  then
                        damage = damage + dy;
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModPoison, 3);
                        if Char.GetData(leader,%对象_队聊开关%) == 1  then
                               NLG.Say(charIndex,charIndex,"【毒液】！！",4,3);
                        end
                 else
                        damage = damage;
                 end
                 print(damage)
                 --NLG.Say(-1,-1,"昆虫系人物每次造成伤害时，有30%的几率对目标造成额外的等同于目标当前生命值一半的伤害并中毒3回合",4,3);
                 return damage;
               end
               if ( RaceType == CONST.种族_野兽 ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHp = Char.GetData(charIndex,CONST.CHAR_血);
                 local defHpM = Char.GetData(charIndex,CONST.CHAR_最大血);
                 local Hp02 = defHp/defHpM;
                 if Hp02<=0.2  then
                        Char.SetData(charIndex, CONST.CHAR_BattleDamageAbsrob, 2);
                 end
                 local defHpEM = Char.GetData(defCharIndex,CONST.CHAR_最大血);
                 local damage = damage + (defHpEM*0.1);
                 if NLG.Rand(1,10)>=8  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModSleep, 1);
                 end
                 print(damage)
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【撕裂】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"野兽系人物当最大血量低于20%，自身攻吸状态2回合。每次造成伤害时使目标受到最大生命值10%的出血伤害，30%的几率昏睡1回合",4,3);
                 return damage;
               end
               if ( RaceType == CONST.种族_特殊 ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHp = Char.GetData(charIndex,CONST.CHAR_血);
                 local defHpM = Char.GetData(charIndex,CONST.CHAR_最大血);
                 local Hp05 = defHp/defHpM;
                 if Hp05<=0.5  then
                        fc = 1+(1-Hp05);
                        damage = damage * fc;
                        Char.SetData(charIndex, CONST.CHAR_BattleDamageVanish, 1);
                        if Char.GetData(leader,%对象_队聊开关%) == 1  then
                               NLG.Say(charIndex,charIndex,"【復仇】！！",4,3);
                        end
                 else
                        damage = damage;
                        Char.SetData(charIndex, CONST.CHAR_BattleLpRecovery, 2);
                        if Char.GetData(leader,%对象_队聊开关%) == 1  then
                               NLG.Say(charIndex,charIndex,"【自癒】！！",4,3);
                        end
                 end
                 print(damage)
                 --NLG.Say(-1,-1,"特殊系人物当最大血量高于50%，自身恢复状态2回合。当最大血量低于50%，自身攻无状态1回合，对目标造成损失血量%的复仇伤害",4,3);
                 return damage;
               end
               if ( RaceType == CONST.种族_金属 ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHpM = Char.GetData(charIndex,CONST.CHAR_最大血);
                 local zb = defHpM*0.045;
                 local damage = damage + zb;
                 if NLG.Rand(1,10)>=6  then
                        Char.SetData(defCharIndex, CONST.CHAR_BattleModConfusion, 3);
                 end
                 print(damage)
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【障壁】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"金属系人物造成伤害时，额外对目标造成相当于最大血量4.5%的伤害，50%的几率混乱3回合",4,3);
                 return damage;
               end
         else
         end
  return damage;
end


function SpecialSkill:OnTechOptionEventCallBack(charIndex, option, techID, val)
      --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
      local battleIndex = Char.GetBattleIndex(charIndex)
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
            leader = leader2
      end
      if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
            local NEN = Char.GetData(charIndex,CONST.CHAR_种族);
            local JL1 = NLG.Rand(1,4);
            --print(NEN)
            --print(JL1)
            if JL1 >= 1 then
                  local item2 = Char.GetItemIndex(charIndex, 2);
                  local item2_Id = Item.GetData(item2, CONST.道具_ID);
                  local item3 = Char.GetItemIndex(charIndex, 3);
                  local item3_Id = Item.GetData(item3, CONST.道具_ID);
                  if techID >= 2730 and techID <= 2739 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              if Char.GetData(leader,%对象_队聊开关%) == 1  then
                                  NLG.Say(leader,charIndex,"【强击】！！",4,3);
                              end
                              --NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【陨石强击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2730 and techID <= 2739 and NEN == CONST.种族_飞行  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【陨石强击数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 2830 and techID <= 2839 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【冰冻强击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2830 and techID <= 2839 and NEN == CONST.种族_飞行  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【冰冻强击数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 2930 and techID <= 2939 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【火焰强击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2930 and techID <= 2939 and NEN == CONST.种族_飞行  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【火焰强击数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 3030 and techID <= 3039 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【风刃强击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 3030 and techID <= 3039 and NEN == CONST.种族_飞行  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【风刃强击数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 25710 and techID <= 25719 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【苦无乱舞威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25710 and techID <= 25719 and NEN == CONST.种族_飞行  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【苦无乱舞数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 110 and techID <= 119 and NEN == CONST.种族_龙  then
                        if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【忍刀乱舞威力增加10%】");
                              return val+10;
                        end
                        return val
                  end
                  if techID >= 26010 and techID <= 26019 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【冲击波动威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 26010 and techID <= 26019 and NEN == CONST.种族_昆虫  then
                        if option == 'SR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【冲击波动倍率增加50%】");
                              return val+50;
                        end
                        return val
                  end
                  if techID >= 10505 and techID <= 10509 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【狙杀瞄准威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 10505 and techID <= 10509 and NEN == CONST.种族_飞行  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【狙杀瞄准数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 515 and techID <= 519 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【炸裂猛攻威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25815 and techID <= 25819 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【锐利射击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 5019 and techID <= 5319 and NEN == CONST.种族_特殊  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【陷阱特殊增加200%】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 200510 and techID <= 200518 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【铁沙掌威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 200510 and techID <= 200518 and NEN == CONST.种族_飞行  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【铁沙掌数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 529 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【阿修罗霸凰拳威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25880 and techID <= 25885 and NEN == CONST.种族_飞行  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【六合拳数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 11105 and techID <= 11109 and NEN == CONST.种族_龙  then
                        if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【回旋刀刃威力增加10%】");
                              return val+10;
                        end
                        return val
                  end
                  if techID >= 200705 and techID <= 200709 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【反射伤害威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 8105 and techID <= 8109 and NEN == CONST.种族_野兽  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【舍命攻击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID == 5919 and NEN == CONST.种族_金属  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【天使之击持续增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6019 and NEN == CONST.种族_金属  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【天使之护持续增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6619 and NEN == CONST.种族_金属  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【神圣降临持续增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6219 and NEN == CONST.种族_特殊  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【神圣祈祷特殊增加200%】");
                              return val+200;
                        end
                        return val
                  end
                  if techID == 6329 and NEN == CONST.种族_特殊  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【神圣祈祷特殊增加200%】");
                              return val+200;
                        end
                        return val
                  end
                  if techID >= 10628 and techID <= 10629 and NEN == CONST.种族_龙  then
                              if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【瞬身之术威力增加10%】");
                              return val+10;
                        end
                        return val
                  end
                  if techID == 200607 and NEN == CONST.种族_特殊  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【雷遁．千鸟流特殊增加200%】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201408 and NEN == CONST.种族_特殊  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【火遁．灰积烧特殊增加200%】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201209 and NEN == CONST.种族_特殊  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【土遁．土流波特殊增加200%】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201919 and NEN == CONST.种族_特殊  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【秽土转生特殊增加200%】");
                              return val+200;
                        end
                        return val
                  end
            end
      end
end

function pequipitemZS(index,itemid)  ---左手
      
 for k=2,2 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %道具_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemYS(index,itemid)  --右手
      
 for k=3,3 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %道具_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemT(index,itemid)  ---头部
      
 for k=0,0 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %道具_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemS(index,itemid)  ---身
      
 for k=1,1 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %道具_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemX(index,itemid)  ---鞋
      
 for k=4,4 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %道具_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemSS1(index,itemid) --饰品1
      
 for k=5,5 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %道具_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemSS2(index,itemid) --饰品2
      
 for k=6,6 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %道具_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemSJ(index,itemid) --水晶
      
 for k=7,7 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %道具_ID%))then
        return true;
     end
 end
 return false;

end

--- 卸载模块钩子
function SpecialSkill:onUnload()
  self:logInfo('unload')
end

return SpecialSkill;
