---模块类
local YbNenSkill = ModuleBase:createModule('ybNenSkill')

--- 加载模块钩子
function YbNenSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
end


function YbNenSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if  flg == CONST.DamageFlags.Normal and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then  ---宠物为物理受攻方事件，被动技能只能二选一
           for i=0,9 do
               local skillId = Pet.GetSkill(defCharIndex, i)
               if (skillId == 1319) then  --宠物被动【隱忍自重】
                 local battleturn= Battle.GetTurn(battleIndex);
                 local yrzz= 0.75 + (battleturn*0.05);
                 if battleturn>=10 then
                          yrzz = 1.25;
                 end
                 local damage = damage * yrzz;
                 print(damage)
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(leader,charIndex,"【隱忍自重】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"进入战斗时降低受到的物理伤害25%，此效果在战斗中每回合减少5%，最多减少至50%",4,3);
                 return damage;
               end
               if (skillId == 1519) then  --宠物被动【威风凛凛】
                 local battleturn= Battle.GetTurn(battleIndex);
                 local wfll= 1 - (battleturn*0.03);
                 if battleturn>=10 then
                          wfll = 0.7;
                 end
                 local damage = damage * wfll;
                 print(damage)
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(leader,charIndex,"【威風凜凜】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"进入战斗时降低受到的魔法伤害0%，此效果在战斗中每回合提高3%，最高30%",4,3);
                 return damage;
               end
           end
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then  ---宠物为魔法受攻方事件，被动技能只能二选一
           for i=0,9 do
               local skillId = Pet.GetSkill(defCharIndex, i)
               if (skillId == 1419) then  --宠物被动【萬念皆空】
                 local battleturn= Battle.GetTurn(battleIndex);
                 local wnjk= 0.75 + (battleturn*0.05);
                 if battleturn>=10 then
                          wnjk = 1.25;
                 end
                 local damage = damage * wnjk;
                 print(damage)
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(leader,charIndex,"【萬念皆空】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"进入战斗时降低受到的魔法伤害25%，此效果在战斗中每回合减少5%，最多减少至50%",4,3);
                 return damage;
               end
               if (skillId == 1519) then  --宠物被动【威风凛凛】
                 local battleturn= Battle.GetTurn(battleIndex);
                 local wfll= 1 - (battleturn*0.03);
                 if battleturn>=10 then
                          wfll = 0.7;
                 end
                 local damage = damage * wfll;
                 print(damage)
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(leader,charIndex,"【威風凜凜】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"进入战斗时降低受到的物理伤害0%，此效果在战斗中每回合提高3%，最高30%",4,3);
                 return damage;
               end
           end
         elseif  Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then  ---宠物为攻击方事件，被动技能只能二选一
           for i=0,9 do
               local skillId = Pet.GetSkill(charIndex, i)
               if (skillId == 1619) then  --宠物被动【大胆无畏】
                 local battleturn= Battle.GetTurn(battleIndex);
                 local ddww= 1.3 - (battleturn*0.06);
                 if battleturn>=5 then
                          ddww = 1;
                 end
                 local damage = damage * ddww;
                 print(damage)
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(leader,charIndex,"【大膽無畏】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"进入战斗时提高造成的所有伤害30%，此效果在战斗中每回合降低6%",4,3);
                 return damage;
               end
               if (skillId == 1719) then  --宠物被动【百战磨练】
                 local battleturn= Battle.GetTurn(battleIndex);
                 local bzml= 1 + (battleturn*0.06);
                 if battleturn>=5 then
                          bzml = 1.3;
                 end
                 local damage = damage * bzml;
                 print(damage)
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(leader,charIndex,"【百戰磨練】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"进入战斗时提高造成的所有伤害0%，此效果在战斗中每回合上升6%，最高30%",4,3);
                 return damage;
               end
           end
         end
  return damage;
end


function YbNenSkill:OnTechOptionEventCallBack(charIndex, option, techID, val)
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
                  local item5 = Char.GetItemIndex(charIndex, 5);
                  local item5_Id = Item.GetData(item5, CONST.道具_ID);
                  local item6 = Char.GetItemIndex(charIndex, 6);
                  local item6_Id = Item.GetData(item6, CONST.道具_ID);
                  if techID >= 400 and techID <= 409 and item6_Id == 900333  then
                        if option == 'DD:' then
                              if Char.GetData(leader,%对象_队聊开关%) == 1  then
                                  NLG.Say(leader,charIndex,"【聚氣】！！",4,3);
                              end
                              --NLG.Say(-1,-1,"佣兵技能强化效果加成已发动！【气功弹威力增加30%】",4,3);
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 9500 and techID <= 9509 and item6_Id == 900333  then
                        if option == 'AM:' then
                              if Char.GetData(leader,%对象_队聊开关%) == 1  then
                                  NLG.Say(leader,charIndex,"【驟雨】！！",4,3);
                              end
                              --NLG.Say(-1,-1,"佣兵技能强化效果加成已发动！【乱射数量增加3】",4,3);
                              return val+3;
                        end
                        return val
                  end
                  if techID >= 6600 and techID <= 6609 and item5_Id == 900330 then
                        if option == 'RR:' then
                              if Char.GetData(leader,%对象_队聊开关%) == 1  then
                                  NLG.Say(leader,charIndex,"【聖魂】！！",4,3);
                              end
                              --NLG.Say(-1,-1,"佣兵技能强化效果加成已发动！【超恢特殊增加100%】",4,3);
                              return val+100;
                        end
                        return val
                  end
                  if techID >= 1260 and techID <= 1269 and item5_Id == 900329  then
                        if option == 'D2:' then
                              if Char.GetData(leader,%对象_队聊开关%) == 1  then
                                  NLG.Say(leader,charIndex,"【靈光】！！",4,3);
                              end
                              --NLG.Say(-1,-1,"佣兵技能强化效果加成已发动！【明净特殊增加100%】",4,3);
                              return val+100;
                        end
                        return val
                  end
            end
            if JL1 >= 1 then
                  if techID >= 2730 and techID <= 2739 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【陨石强击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2730 and techID <= 2739 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【陨石强击数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 2830 and techID <= 2839 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【冰冻强击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2830 and techID <= 2839 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【冰冻强击数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 2930 and techID <= 2939 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【火焰强击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2930 and techID <= 2939 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【火焰强击数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 3030 and techID <= 3039 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【风刃强击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 3030 and techID <= 3039 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【风刃强击数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 25710 and techID <= 25719 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【苦无乱舞威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25710 and techID <= 25719 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【苦无乱舞数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 110 and techID <= 119 and NEN == 1  then
                        if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【忍刀乱舞威力增加10%】");
                              return val+10;
                        end
                        return val
                  end
                  if techID >= 26010 and techID <= 26019 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【冲击波动威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 26010 and techID <= 26019 and NEN == 4  then
                        if option == 'SR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【冲击波动倍率增加50%】");
                              return val+50;
                        end
                        return val
                  end
                  if techID >= 10505 and techID <= 10509 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【狙杀瞄准威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 10505 and techID <= 10509 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【狙杀瞄准数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 515 and techID <= 519 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【炸裂猛攻威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25815 and techID <= 25819 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【锐利射击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 5019 and techID <= 5319 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【陷阱特殊增加200%】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 200510 and techID <= 200518 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【铁沙掌威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 200510 and techID <= 200518 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【铁沙掌数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 529 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【阿修罗霸凰拳威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25880 and techID <= 25885 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【六合拳数量增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 11105 and techID <= 11109 and NEN == 1  then
                        if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【回旋刀刃威力增加10%】");
                              return val+10;
                        end
                        return val
                  end
                  if techID >= 200705 and techID <= 200709 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【反射伤害威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 8105 and techID <= 8109 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【舍命攻击威力增加30%】");
                              return val+30;
                        end
                        return val
                  end
                  if techID == 5919 and NEN == 8  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【天使之击持续增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6019 and NEN == 8  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【天使之护持续增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6619 and NEN == 8  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【神圣降临持续增加2】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6219 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【神圣祈祷特殊增加200%】");
                              return val+200;
                        end
                        return val
                  end
                  if techID == 6329 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【神圣祈祷特殊增加200%】");
                              return val+200;
                        end
                        return val
                  end
                  if techID >= 10628 and techID <= 10629 and NEN == 1  then
                              if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【瞬身之术威力增加10%】");
                              return val+10;
                        end
                        return val
                  end
                  if techID == 200607 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【雷遁．千鸟流特殊增加200%】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201408 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【火遁．灰积烧特殊增加200%】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201209 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"专属念能力效果加成已发动！【土遁．土流波特殊增加200%】");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201919 and NEN == 7  then
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
function YbNenSkill:onUnload()
  self:logInfo('unload')
end

return YbNenSkill;
