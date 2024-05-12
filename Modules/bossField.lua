---ģ����
local Module = ModuleBase:createModule('bossField')

local damage_Max = 99999;

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self))
end

function Module:OnbattleStartEventCallback(battleIndex)
         for i=10, 19 do
              local enemy = Battle.GetPlayIndex(battleIndex, i)
              local player = Battle.GetPlayIndex(battleIndex, i-10)
               --print(enemy, player)
              if enemy>=0 and Char.IsEnemy(enemy) then
                  Char.SetTempData(enemy, '��ס', 3);
                  Char.SetTempData(enemy, '��', 3);
                  if Char.GetData(player,CONST.����_��ս����) == 1  then
                     NLG.Say(player,-1,"����ס�I�򡿡����I��",4,3);
                 end
              end
         end
end

function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if (com3==6219 or com3==6319 )  then
             if Char.IsEnemy(defCharIndex) then
                 local Buff1 = Char.GetTempData(defCharIndex, '��ס') or 0;
                 local Buff2 = Char.GetTempData(defCharIndex, '��') or 0;
                 if (Buff1 > 0 or Buff2 > 0)  then
                       if (Buff1>=2 or Buff2>=2)  then
                           Char.SetTempData(defCharIndex, '��ס', 1);
                           Char.SetTempData(defCharIndex, '��', 1);
                           if Char.GetData(leader,CONST.����_��ս����) == 1  then
                               NLG.Say(leader,-1,"����ס�I�򡿡����I�򡿽���1��",4,3);
                           end
                       elseif (Buff1==1 or Buff2==1)  then
                           Char.SetTempData(defCharIndex, '��ס', 0);
                           Char.SetTempData(defCharIndex, '��', 0);
                           if Char.GetData(leader,CONST.����_��ս����) == 1  then
                               NLG.Say(leader,-1,"����ס�I�򡿡����I�򡿽���0��",4,3);
                           end
                       end
                 end
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
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsEnemy(defCharIndex)  then
               local GTime = NLG.GetGameTime();
               if (GTime>=0)  then
                     local State = Char.GetTempData(defCharIndex, '��ס') or 0;
                     if (damage>=damage_Max) then
                         if (State>0) then
                             if (State>=1)  then
                                 Char.SetTempData(defCharIndex, '��ס', 2);
                                 damage = damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"����ס�������ܵ��Ă�������ֵ��"..damage_Max.."����סʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                             end
                         else
                             damage = damage;
                         end
                     else
                         damage = damage;
                     end
               end
               return damage;
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg ~= CONST.DamageFlags.Magic and Char.IsEnemy(charIndex)  then
               local GTime = NLG.GetGameTime();
               if (GTime<=3)  then
                     local State = Char.GetTempData(charIndex, '��') or 0;
                     if (Char.GetData(charIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         local d1= Char.GetData(charIndex, CONST.CHAR_������);
                         local d2= Char.GetData(defCharIndex, CONST.CHAR_������);
                         local d3= Char.GetData(defCharIndex, CONST.CHAR_������);
                         local d4= Char.GetData(defCharIndex, CONST.CHAR_����);
                         if (State>0) then
                            if d2>=500 and d2<=4000 then
                                 local damage_Max = (d1*0.8)-(d3-120)*10+(d4*State/100);
                                 if damage_Max<=9 then damage_Max = 9; end
                                 if damage_Max>=99 then damage_Max = 99; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            elseif d2>=4001 and d2<=9999 then
                                 local damage_Max = (d1*0.8)-(d3-180)*10+(d4*State/10);
                                 if damage_Max<=99 then damage_Max = 99; end
                                 if damage_Max>=999 then damage_Max = 999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            elseif d2>=10000 then
                                 local damage_Max = (d1*0.8)-(d3-240)*10+(d4*State/1);
                                 if damage_Max<=999 then damage_Max = 999; end
                                 if damage_Max>=9999 then damage_Max = 9999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            else
                                 damage = damage;
                                 return damage;
                            end
                         end
                     end
               end
               return damage;
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg == CONST.DamageFlags.Magic and Char.IsEnemy(charIndex)  then
               local GTime = NLG.GetGameTime();
               if (GTime<=3)  then
                     local State = Char.GetTempData(charIndex, '��') or 0;
                     if (Char.GetData(charIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         local d1= Char.GetData(charIndex, CONST.CHAR_����);
                         local d2= Char.GetData(defCharIndex, CONST.CHAR_����);
                         local d3= Char.GetData(defCharIndex, CONST.CHAR_ħ��);
                         local d4= Char.GetData(defCharIndex, CONST.CHAR_������);
                         if (State>0) then
                            if d2>=500 and d2<=2000 then
                                 local damage_Max = (d1*0.8)-(d3-50)*10+(d4*State/100);
                                 if damage_Max<=9 then damage_Max = 9; end
                                 if damage_Max>=99 then damage_Max = 99; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            elseif d2>=2001 and d2<=9999 then
                                 local damage_Max = (d1*0.8)-(d3-100)*10+(d4*State/10);
                                 if damage_Max<=99 then damage_Max = 99; end
                                 if damage_Max>=999 then damage_Max = 999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            elseif d2>=10000 then
                                 local damage_Max = (d1*0.8)-(d3-240)*10+(d4*State/1);
                                 if damage_Max<=999 then damage_Max = 999; end
                                 if damage_Max>=9999 then damage_Max = 9999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            else
                                 damage = damage;
                                 return damage;
                            end
                         end
                     end
               end
               return damage;
         else
         end
  return damage;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;