---模块类
local YbPetSkill = ModuleBase:createModule('ybPetSkill')

--- 加载模块钩子
function YbPetSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
end


function YbPetSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
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
                        NLG.Say(leader,defCharIndex,"【隱忍自重】！！",4,3);
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
                        NLG.Say(leader,defCharIndex,"【威風凜凜】！！",4,3);
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
                        NLG.Say(leader,defCharIndex,"【萬念皆空】！！",4,3);
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
                        NLG.Say(leader,defCharIndex,"【威風凜凜】！！",4,3);
                 end
                 --NLG.Say(-1,-1,"进入战斗时降低受到的物理伤害0%，此效果在战斗中每回合提高3%，最高30%",4,3);
                 return damage;
               end
           end
         elseif  flg == CONST.DamageFlags.Normal and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then  ---宠物为攻击方事件，被动技能只能二选一
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
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then
               local LvRate = Char.GetData(charIndex,CONST.CHAR_等级);
               local Spirit = Char.GetData(charIndex,CONST.CHAR_精神);
               if LvRate <= 50  then
                        LvRate = 1;
               else
                        LvRate = LvRate/50;
               end
               if Spirit <= 200  then
                        SpRate = 1;
               else
                        SpRate = Spirit/200;
               end
               local damage = damage * SpRate + Spirit * 0.5 * LvRate ;
               print(damage)
               --if Char.GetData(leader,%对象_队聊开关%) == 1  then
                      --NLG.Say(leader,charIndex,"【魔法導力】！！",4,3);
               --end
              return damage;

         end
  return damage;
end


function YbPetSkill:OnTechOptionEventCallBack(charIndex, option, techID, val)
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
                  if techID >= 1260 and techID <= 1269 and item5_Id == 900330  then
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
      end
end

--- 卸载模块钩子
function YbPetSkill:onUnload()
  self:logInfo('unload')
end

return YbPetSkill;
