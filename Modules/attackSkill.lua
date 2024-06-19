---模块类
local AttackSkill = ModuleBase:createModule('attackSkill')
local clearType = {
    { type=CONST.CHAR_BattleDamageAbsrob, name="攻擊吸收" },
    { type=CONST.CHAR_BattleDamageReflec, name="攻擊反彈" },
    { type=CONST.CHAR_BattleDamageVanish, name="攻擊無效" },
    { type=CONST.CHAR_BattleDamageMagicAbsrob, name="魔法吸收" },
    { type=CONST.CHAR_BattleDamageMagicReflec, name="魔法反彈" },
    { type=CONST.CHAR_BattleDamageMagicVanish, name="魔法無效" },
    { type=CONST.CHAR_BattleLpRecovery, name="恢復魔法" },
  }

--- 加载模块钩子
function AttackSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self))
end

function AttackSkill:WeaponDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         --大师武器增伤
         if Char.IsPlayer(charIndex) then
               local WeaponIndex = Char.GetWeapon(charIndex);                --左右手
               local Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字);
               local ShieldIndex = Char.GetShield(charIndex);
               local Shield_Name = Item.GetData(ShieldIndex, CONST.道具_名字);
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
               local JobLv = Char.GetData(charIndex,CONST.CHAR_职阶)+1;
               local JobLv_tbl = {200,310,340,370,400,430};
               if LvRate <= 50  then
                        LvRate = 1;
               else
                        LvRate = LvRate/50;
               end
               if Spirit <= 1200  then
                        SpRate = 1;
               else
                        SpRate = Spirit/1200;
               end
               if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Weapon_Name~=nil then
                 local wandId = Item.GetData(WeaponIndex, CONST.道具_ID);
                 local techList = {9519,25815,25816,25817,25818,25819,415,416,417,418,429}
                 if (wandId== 79250)  then
                        damage = damage * Agile/800 + Agile * 0.25 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.75;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【光明之力】！！",4,3);
                        end
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
                        return damage;
                 elseif (wandId== 79251)  then
                        damage = damage * Agile/800 + Agile * 0.25 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.75;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【黑暗之力】！！",4,3);
                        end
                        table.forEach(techList, function(e)
                        if com3 == e and NLG.Rand(1,4)==2  then
                               for  i=0, 19 do
                                   local player = Battle.GetPlayIndex(battleIndex, i)
                                   if player>=0 then
                                     if Char.IsPlayer(player) or Char.IsPet(player) then
                                       Char.SetData(player, CONST.CHAR_BattleDamageMagicAbsrob, 1);
                                       NLG.UpChar(player);
                                     end
                                   end
                               end
                        end
                        end)
                        return damage;
                 elseif (wandId== 79252)  then
                        damage = damage + Spirit * 1.2 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.5;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【狡猾戲法】！！",4,3);
                        end
                        if NLG.Rand(1,100)<=8  then
                               local debuff={CONST.CHAR_BattleModConfusion,CONST.CHAR_BattleModPoison,CONST.CHAR_BattleModSleep};
                               local rate = NLG.Rand(1,3);
                               Char.SetData(defCharIndex, debuff[rate], 3);
                               NLG.UpChar(defCharIndex);
                        end
                        return damage;
                 elseif (wandId== 79253)  then
                        damage = damage + Spirit * 1.2 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.5;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                             NLG.Say(leader,charIndex,"【奸智戲法】！！",4,3);
                        end
                        if NLG.Rand(1,100)<=8  then
                               local debuff={CONST.CHAR_BattleModConfusion,CONST.CHAR_BattleModDrunk,CONST.CHAR_BattleModAmnesia};
                               local rate = NLG.Rand(1,3);
                               Char.SetData(defCharIndex, debuff[rate], 3);
                               NLG.UpChar(defCharIndex);
                        end
                        return damage;
                 elseif (wandId== 79255)  then
                        local State = Char.GetTempData(defCharIndex, '弱點') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '弱點', State+1);
                            damage = damage * (1+State/100);
                        end
                        damage = damage * (1+(Avoid/1000)) + Defense * 1.15 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.2;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【戰神之怒】！！",4,3);
                        end
                        return damage;
                 elseif (wandId== 79256)  then
                        local State = Char.GetTempData(defCharIndex, '弱點') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '弱點', State+1);
                            damage = damage * (1+State/100);
                        end
                        damage = damage * (1+(Critical/1000)) + Defense * 1.15 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.2;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【戰神之怒】！！",4,3);
                        end
                        return damage;
                 elseif (wandId== 79257)  then
                        local State = Char.GetTempData(defCharIndex, '弱點') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '弱點', State+1);
                            damage = damage * (1+State/100);
                        end
                        damage = damage * (1+(Counter/1000)) + Defense * 1.15 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.2;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【戰神之怒】！！",4,3);
                        end
                        return damage;
                 elseif (wandId== 79213)  then
                        damage = damage + Attack * 0.25 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.25;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【空間魔法】！！",4,3);
                        end
                        return damage;
                 elseif (wandId== 79214)  then
                        damage = damage + Attack * 0.25 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.25;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【時間魔法】！！",4,3);
                        end
                        return damage;
                 end

               elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Shield_Name~=nil then
                 local wandId = Item.GetData(ShieldIndex, CONST.道具_ID);
                 if (wandId== 79254)  then
                        damage = damage + Blood * 0.15 + Mana * 0.15 + (Mattack+JobLv_tbl[JobLv])*0.5;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【鐵之身軀】！！",4,3);
                        end
                        if Blood>=Mana  then
                               Char.SetData(charIndex, CONST.CHAR_BattleDamageVanish, 1);
                               NLG.UpChar(charIndex);
                        elseif Blood<Mana  then
                               Char.SetData(charIndex, CONST.CHAR_BattleDamageMagicVanish, 1);
                               NLG.UpChar(charIndex);
                        end
                        return damage;
                 end
               end

         end
    return damage;
end

function AttackSkill:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
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

function AttackSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
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
         if (com3==11201)  then    --獅子吼
                     if Char.GetData(charIndex,CONST.对象_对战开关) == 1  then
                         NLG.Say(charIndex,charIndex,"【霸王色霸氣】！！",4,3);
                     end
                     local enemyHp = Char.GetData(defCharIndex, CONST.CHAR_血);
                     local playHP = Char.GetData(charIndex, CONST.CHAR_血);
                     if (playHP>=enemyHp) then
                       damage = 9999999;
                       NLG.Say(-1,-1,"【霸王色霸氣】對象受到強烈衝擊"..damage.."暈過去！！",4,3);
                     end
                     return damage;
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg ~= CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               if (Char.GetData(charIndex,CONST.对象_战斗Side)==0 and Battle.GetType(battleIndex)==1) then
                   claws = Char.GetTempData(leader, '白虎爪') or 0;
                   teeth = Char.GetTempData(leader, '黑豹牙') or 0;
                   horns = Char.GetTempData(leader, '黄蛇角') or 0;
                   damage = damage*math.floor( (1+(claws+teeth+horns)/10) );
               end
               local damage_TA = damage + self:WeaponDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg);
               local damage = math.floor(damage_TA*0.8);
               --print(damage,damage_TA,damage)
               if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                   NLG.Say(leader,leader,"【近戰領域】白虎爪"..claws.."層.黑豹牙"..teeth.."層.黃蛇角"..horns.."層",4,3);
               end
               if (com3 == 200539)  then    --200539無量空處/200500~200509追月(消除巫術)
                     if Char.GetData(charIndex,CONST.对象_对战开关) == 1  then
                         NLG.Say(charIndex,charIndex,"【無量空處】！！",4,3);
                     end
                     for k, v in ipairs(clearType) do
                       local sorcery = Char.GetData(defCharIndex, v.type);
                       if sorcery>=1 then
                               Char.SetData(defCharIndex, v.type, 0);
                               damage = damage*0;
                               --NLG.Say(-1,-1,"【無量空處】消除了"..v.name.."！！",4,3);
                       else
                               damage = damage;
                       end
                     end
                     return damage;
               elseif (com3 == 26739)  then    --26739肌肉魔法/26700~26709精神衝擊波(攻擊力補正)
                     if Char.GetData(charIndex,CONST.对象_对战开关) == 1  then
                         NLG.Say(charIndex,charIndex,"【肌肉魔法】！！",4,3);
                     end
                     local defHp = Char.GetData(charIndex,CONST.CHAR_血);
                     local defHpM = Char.GetData(charIndex,CONST.CHAR_最大血);
                     local Hp08 = defHp/defHpM;
                     local Attack = Char.GetData(charIndex,CONST.CHAR_攻击力);
                     if Hp08>0.8 then
                             local AC = Attack * 1.5;
                             damage = damage + AC;
                             --NLG.Say(-1,-1,"【肌肉魔法】血量80%以上傷害取決於攻擊力，10%使對象機率混亂！！",4,3);
                             if NLG.Rand(1,10)>=10  then
                                    Char.SetData(defCharIndex, CONST.CHAR_BattleModConfusion, 1);
                                    Char.UpCharStatus(defCharIndex);
                             end
                     else
                             damage = damage;
                     end
                     return damage;
               elseif (com3 == 10539)  then    --10539晴天大征
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
                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                         NLG.Say(charIndex,charIndex,"【刀背攻擊】傷害前目標剩餘血量".. defHpE .."！！",4,3);
                 end
                 return damage;
               end

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
               return damage;

--合擊狀態增傷
--[[
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
]]

         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg == CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               if (Char.GetData(charIndex,CONST.对象_战斗Side)==0 and Battle.GetType(battleIndex)==1) then
                   claws = Char.GetTempData(leader, '白虎爪') or 0;
                   teeth = Char.GetTempData(leader, '黑豹牙') or 0;
                   horns = Char.GetTempData(leader, '黄蛇角') or 0;
                   damage = damage*math.floor( (1+(claws+teeth+horns)/10) );
               end
               --local damage_TA = damage + self:WeaponDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg);
               --local damage = math.floor(damage_TA*0.5);
               --print(damage_TA,damage)
               if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                   NLG.Say(leader,leader,"【近戰領域】白虎爪"..claws.."層.黑豹牙"..teeth.."層.黃蛇角"..horns.."層",4,3);
               end
               if (com3 >= 26700 and com3 <= 26720)  then    --26700~26709精神衝擊波(補正)
                     --NLG.Say(charIndex,charIndex,"【精神衝擊波】補正傷害公式！！",4,3);
                     local LvRate = Char.GetData(charIndex,CONST.CHAR_等级);
                     local Spirit = Char.GetData(charIndex,CONST.CHAR_精神);
                     local Mattack = Char.GetData(charIndex,CONST.CHAR_魔攻);
                     local TechLv = math.fmod(com3,26700)+1;
                     print(LvRate,Spirit,Mattack,TechLv)
                     if (Spirit>303 and Mattack>320) then
                             damage = (320+303*1.2)*TechLv*0.1+((Spirit-303)*2+(Mattack-320)*(LvRate*0.01))*0.5*TechLv*0.1;
                     else
                             damage = (Mattack+Spirit*1.2)*TechLv*0.1;
                     end
                     return damage;
               end
               if Char.IsPlayer(charIndex) then
                 local WeaponIndex = Char.GetWeapon(charIndex);                --左右手
                 local Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字);
                 if Weapon_Name~=nil then
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
                   local Amnd_R = Char.GetData(charIndex, CONST.CHAR_精神);
                   local Amnd = math.max(Conver_800(Amnd_R * 1),1);
                   local Dmnd_R = math.max(Char.GetData(defCharIndex, CONST.CHAR_精神), 100);
                   local Dmnd = Conver_800(Dmnd_R * 1);
                   local SpRate = math.floor( (Amnd / (0.67 + Dmnd / Amnd)) ) * 0.01;
                   local wandId = Item.GetData(WeaponIndex, CONST.道具_ID);
                   if (wandId== 79213)  then
                        damage = damage * SpRate + Spirit * 0.75 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.75;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【空間魔法】！！",4,3);
                        end
                        return damage;
                   elseif (wandId== 79214)  then
                        damage = damage * SpRate + Spirit * 0.5 * LvRate + (Mattack+JobLv_tbl[JobLv])*0.5;
                        if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                            NLG.Say(leader,charIndex,"【時間魔法】！！",4,3);
                        end
                        if NLG.Rand(1,100)<=8  then
                               local debuff={CONST.CHAR_BattleModConfusion,CONST.CHAR_BattleModDrunk,CONST.CHAR_BattleModPoison,CONST.CHAR_BattleModStone};
                               local rate = NLG.Rand(1,4);
                               Char.SetData(defCharIndex, debuff[rate], 3);
                               NLG.UpChar(defCharIndex);
                        end
                        return damage;
                   end
                 end
               end
               return damage;

--[[法術附加30%狀態
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

         else
         end
  return damage;
end

Char.GetShield = function(charIndex)
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.ITEM_TYPE_盾 then
    return ItemIndex,CONST.EQUIP_左手;
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手)
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.ITEM_TYPE_盾 then
    return ItemIndex,CONST.EQUIP_右手;
  end
  return -1,-1;
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
function AttackSkill:onUnload()
  self:logInfo('unload')
end

return AttackSkill;
