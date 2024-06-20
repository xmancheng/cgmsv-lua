---模块类
local YbPetSkill = ModuleBase:createModule('ybPetSkill')

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
function YbPetSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
end

--获取宠物装备-水晶
Pet.GetCrystal = function(petIndex)
  local ItemIndex = Char.GetItemIndex(petIndex, CONST.宠道栏_水晶);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.道具类型_宠物水晶 then
    return ItemIndex,CONST.宠道栏_水晶;
  end
  return -1,-1;
end

function YbPetSkill:AwakenEvoDamage(charIndex, defCharIndex, damage, battleIndex, flg)
        if Char.IsPet(charIndex) then
            local PetCrystalIndex = Pet.GetCrystal(charIndex);                --左右手
            local PetCrystal_Name = Item.GetData(PetCrystalIndex, CONST.道具_名字);
            local Attack = Char.GetData(charIndex,CONST.CHAR_攻击力);
            local Defense = Char.GetData(charIndex,CONST.CHAR_防御力);
            local Agile = Char.GetData(charIndex,CONST.CHAR_敏捷);
            local Spirit = Char.GetData(charIndex,CONST.CHAR_精神);
            local Recover = Char.GetData(charIndex,CONST.CHAR_回复);
            if PetCrystal_Name~=nil then
                 local wandId = Item.GetData(PetCrystalIndex, CONST.道具_ID);
                 local bindId = Item.GetData(PetCrystalIndex, CONST.道具_特殊类型);
                 local typeId = Item.GetData(PetCrystalIndex, CONST.道具_子参一);
                 local typeLv = Item.GetData(PetCrystalIndex, CONST.道具_子参二);
                 local Slot = Char.HavePet(Pet.GetOwner(charIndex), bindId);
                 local EnemyId = Char.GetPet(Pet.GetOwner(charIndex), Slot);
                 local typeList = { {0.2,0.5,0.5,0.5,0.8}, {0.8,0.5,0.5,0.5,0.2}, {0.5,0.8,0.5,0.3,0.3}, {0.3,0.5,0.8,0.3,0.5}, {0.5,0.3,0.3,0.8,0.5}, {0.5,0.5,0.5,0.5,0.5}}
                 if (wandId==69031 or wandId==69040)  then
                        table.forEach(typeList, function(e)
                            for k, v in ipairs(typeList) do
                                if (EnemyId==charIndex and Char.GetData(charIndex,CONST.PET_DepartureBattleStatus)==CONST.PET_STATE_战斗 and typeId>0 and typeId==k) then
                                    if flg==CONST.DamageFlags.Normal or flg==CONST.DamageFlags.Critical then
                                        if (typeId==1 or typeId==2 or typeId==4 or typeId==6) then
                                            if typeLv<10 then typeLvRate=1.1;
                                            elseif typeLv>=10 and typeLv<20  then typeLvRate=1.2;
                                            elseif typeLv>=20 then typeLvRate=1.3; end
                                            damage = damage + typeLvRate * (Attack * v[1] + Defense * v[2] + Agile * v[3] + Spirit * v[4] + Recover * v[5]);
                                            --NLG.Say(-1,-1,"【覺醒之念能力】！！",4,3);
                                            return damage;
                                        end
                                    elseif flg==CONST.DamageFlags.Magic then
                                        if (typeId==3 or typeId==5 or typeId==6) then
                                            if typeLv<10 then typeLvRate=3;
                                            elseif typeLv>=10 and typeLv<20  then typeLvRate=3.1;
                                            elseif typeLv>=20 then typeLvRate=3.2; end
                                            damage = damage + typeLvRate * (Attack * v[1] + Defense * v[2] + Agile * v[3] + Spirit * v[4] + Recover * v[5]);
                                            --NLG.Say(-1,-1,"【覺醒之念能力】！！",4,3);
                                            return damage;
                                        end
                                    end
                                end
                            end
                        end)
                 end
            end
        end
    return damage;
end

function YbPetSkill:tempDamage(charIndex, defCharIndex, damage, battleIndex)
        for k, v in ipairs(petMettleTable) do
           if (v.MettleType==1 and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then           --攻方BOSS宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       return damage;
                   end
               end
           elseif (v.MettleType==2 and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then     --受方BOSS宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       return damage;
                   end
               end
           elseif (v.MettleType==3 and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then            --攻方四属性相关宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       return damage;
                   end
               end
           elseif (v.MettleType==4 and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then     --受方四属性相关宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       return damage;
                   end
               end
           elseif (v.MettleType==5 and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠)  then           --攻方种族宠物性格
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == v.info) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"宠物性格被动效果发动",4,3);
                       return damage;
                   end
               end
           end

         end
    return damage;
end

function YbPetSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then  ---宠物为物理受攻方事件，被动技能只能二选一
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
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
                 --NLG.Say(-1,-1,"进入战斗时降低受到的物理伤害0%，此效果在战斗中每回合提高3%，最高30%",4,3);
                 return damage;
               end
           end
           return damage;
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then  ---宠物为魔法受攻方事件，被动技能只能二选一
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
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
                 --NLG.Say(-1,-1,"进入战斗时降低受到的魔法伤害0%，此效果在战斗中每回合提高3%，最高30%",4,3);
                 return damage;
               end
           end
           return damage;
         elseif  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then  ---宠物为攻击方事件，被动技能只能二选一
           --大师角色加成
           if (Char.GetData(charIndex,CONST.对象_战斗Side)==0 and Battle.GetType(battleIndex)==1) then
               claws = Char.GetTempData(leader, '白虎爪') or 0;
               teeth = Char.GetTempData(leader, '黑豹牙') or 0;
               horns = Char.GetTempData(leader, '黄蛇角') or 0;
               damage = damage*math.floor( (1+(claws+teeth+horns)/10) );
           end
           --宠物加成
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage_TA = damage_temp + self:AwakenEvoDamage(charIndex, defCharIndex, damage, battleIndex, flg);
           local damage = math.floor(damage_TA*0.5);
           --print(damage_temp,damage_TA,damage)
           --宠物特技
           if (com3 == 9509)  then    --疾風迅雷
               local State = Char.GetTempData(defCharIndex, '穿透') or 0;
               --print(State)
               if (State>=0 and State<=12) then
                   Char.SetTempData(defCharIndex, '穿透', State+1);
                   damage = damage * ((State+1)/12);
                   return damage;
               elseif (State>=13)  then
                   Char.SetTempData(defCharIndex, '穿透', 0);
                   damage = damage * 1;
                   return damage;
               end
           end
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
           return damage;
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠  then
           --大师角色加成
           if (Char.GetData(charIndex,CONST.对象_战斗Side)==0 and Battle.GetType(battleIndex)==1) then
               claws = Char.GetTempData(leader, '白虎爪') or 0;
               teeth = Char.GetTempData(leader, '黑豹牙') or 0;
               horns = Char.GetTempData(leader, '黄蛇角') or 0;
               damage = damage*math.floor( (1+(claws+teeth+horns)/10) );
           end
           --宠物加成
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage_TA = damage_temp + self:AwakenEvoDamage(charIndex, defCharIndex, damage, battleIndex, flg);
           local damage = math.floor(damage_TA*0.5);
           --宠物特技
           if (com3 == 2729)  then    --千鈞石箭-SE
               if NLG.Rand(1,10)>=10  then
                   Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 2);
                   NLG.UpChar(defCharIndex);
               end
           end
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
      if Char.IsDummy(charIndex) then
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
end

--- 卸载模块钩子
function YbPetSkill:onUnload()
  self:logInfo('unload')
end

return YbPetSkill;
