---ģ����
local Module = ModuleBase:createModule('powerLinked')

local Linked_Tbl = {}
local linkTechList = {9620,9621,9622,9623,9624,9625,9626,9627,9628,9629,9630,9631,9632,9633,9634,9635,9636,9637,9638,9639}
local petMettleTable = {
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9630 , buff = 0.10},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_��, skillId=9631 , buff = 0.10},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9632 , buff = 0.10},              --�Բ���ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9633 , buff = 0.10},              --�Է���ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9634 , buff = 0.10},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_ֲ��, skillId=9635 , buff = 0.10},              --��ֲ��ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_Ұ��, skillId=9636 , buff = 0.10},              --��Ұ��ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9637 , buff = 0.10},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9638 , buff = 0.10},              --�Խ���ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_аħ, skillId=9639 , buff = 0.05},              --��аħϵ���������˺�

             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_����, skillId=9640 , buff = 0.10},              --������������ϵ�����˺�
             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_��, skillId=9641 , buff = 0.10},              --������������ϵ�����˺�
             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_����, skillId=9642 , buff = 0.10},              --�������Բ���ϵ�����˺�
             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_����, skillId=9643 , buff = 0.10},              --�������Է���ϵ�����˺�
             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_����, skillId=9644 , buff = 0.10},              --������������ϵ�����˺�
             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_ֲ��, skillId=9645 , buff = 0.10},              --��������ֲ��ϵ�����˺�
             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_Ұ��, skillId=9646 , buff = 0.10},              --��������Ұ��ϵ�����˺�
             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_����, skillId=9647 , buff = 0.10},              --������������ϵ�����˺�
             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_����, skillId=9648 , buff = 0.10},              --�������Խ���ϵ�����˺�
             { MettleType=6, type=CONST.CHAR_����, info=CONST.����_аħ, skillId=9649 , buff = 0.05},              --��������аħϵ�����˺�
}

--- ����ģ�鹳��
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
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         --����״̬
         Linked_Tbl = {}
         --������������
         for i = 0, 9 do
               local playerPet = Battle.GetPlayIndex(battleIndex, i);
               if (playerPet >= 0 and Char.GetData(leader,CONST.����_ս��Side)==0 and Battle.GetType(battleIndex)==1) then
                   if (Char.GetData(playerPet, CONST.CHAR_����) == CONST.��������_��)  then
                       for slot=0,9 do
                           local linkTechId = Pet.GetSkill(playerPet, slot);
                           table.forEach(linkTechList, function(e)
                               if (linkTechId == e) then
                                   --ȷ����������
                                   local boxCheck = 0;
                                   for i=1,#Linked_Tbl do
                                       if (Linked_Tbl[i][1]==e) then
                                           boxCheck=i;
                                       end
                                   end
                                   --���������
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
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if Char.IsPlayer(charIndex) then
               --�����YӍ
               local LvRate = Char.GetData(charIndex,CONST.CHAR_�ȼ�);
               local Attack = Char.GetData(charIndex,CONST.CHAR_������);
               local Defense = Char.GetData(charIndex,CONST.CHAR_������);
               local Avoid = Char.GetData(charIndex,CONST.����_����);
               local Critical = Char.GetData(charIndex,CONST.����_��ɱ);
               local Counter = Char.GetData(charIndex,CONST.����_����);
               local Agile = Char.GetData(charIndex,CONST.CHAR_����);
               local Spirit = Char.GetData(charIndex,CONST.CHAR_����);
               local Blood = Char.GetData(charIndex,CONST.CHAR_Ѫ);
               local Mana = Char.GetData(charIndex,CONST.CHAR_ħ);
               local Mattack = Char.GetData(charIndex,CONST.CHAR_ħ��);
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

                        local State = Char.GetTempData(defCharIndex, '���c') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '���c', State+1);
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
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if (com3==6339)  then    --�����I��(�̶������a���ӻ֏�ħ���a���̶�����)
               if Char.GetData(charIndex,CONST.����_��ս����) == 1  then
                   NLG.Say(charIndex,charIndex,"�������I�򡿣���",4,3);
               end
               local restore = Char.GetData(charIndex,CONST.CHAR_�ظ�);
               local defRestore = Char.GetData(defCharIndex,CONST.CHAR_�ظ�);
             --print(restore,defRestore)
               if (defRestore < restore) then
                 Char.SetTempData(defCharIndex, '�ָ�����', restore);
                 heal = heal+restore;
                 --NLG.Say(-1,-1,"�������I�򡿟oҕ���ΰK�߻؏͵��aѪ�g����",4,3);
               else
                 heal = heal;
               end
               return heal;
         end
         if (flg==CONST.HealDamageFlags.Heal)  then    --�aѪ�ί�ħ��
               local deBuff = Char.GetTempData(defCharIndex, '�ظ�����') or 0;
               if (deBuff > 0)  then
                       if (deBuff==2)  then
                           heal = heal * 0.5;
                           Char.SetTempData(defCharIndex, '�ظ�����', 1);
                       elseif (deBuff==1)  then
                           heal = heal * 0.5;
                           Char.SetTempData(defCharIndex, '�ظ�����', 0);
                       end
               else
                       heal = heal;
               end
               return heal;
         elseif (flg==CONST.HealDamageFlags.Recovery)  then    --�֏�ħ��
               local deBuff = Char.GetTempData(defCharIndex, '�ظ�����') or 0;
               local Buff = Char.GetTempData(defCharIndex, '�ָ�����') or 0;
               if (Buff > 0)  then
                   if (deBuff>0)  then
                      local HpHeal = Buff * 0.5;
                      heal = heal * 0.5+HpHeal;
                      Char.SetTempData(defCharIndex, '�ָ�����', HpHeal);
                   else
                      local HpHeal = Buff * 0.5;
                      heal = heal+HpHeal;
                      Char.SetTempData(defCharIndex, '�ָ�����', HpHeal);
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
         elseif (flg==CONST.HealDamageFlags.Consentration)  then    --���Rֹˮ
               Char.SetTempData(defCharIndex, '����', 0);
               Char.SetTempData(defCharIndex, '�Ͷ�', 0);
               local deBuff = Char.GetTempData(defCharIndex, '�ظ�����') or 0;
               if (deBuff > 0)  then
                       heal = heal * 0.1;
                       Char.SetTempData(defCharIndex, '�ظ�����', 0);
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
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
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
       --print("���ӂ���"..damage_A.."%","�p�ق���"..damage_D.."%")

         if (flg==CONST.DamageFlags.Poison)  then    --�ж�����
               local deBuff = Char.GetTempData(defCharIndex, '�Ͷ�') or 0;
               if (deBuff > 0)  then
                       if (deBuff==2)  then
                           damage = damage * 2;
                           Char.SetTempData(defCharIndex, '�Ͷ�', 1);
                       elseif (deBuff==1)  then
                           damage = damage * 2;
                           Char.SetTempData(defCharIndex, '�Ͷ�', 0);
                       end
               else
                       damage = damage;
               end
               return damage;
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then
               if (defCom1==2502)  then    --0x9C6��������/defCom1==43�}��(�o�޵֓�����)
                     if Char.GetData(defCharIndex,CONST.����_��ս����) == 1  then
                         NLG.Say(defCharIndex,defCharIndex,"���������ġ�����",4,3);
                     end
                     local defHpE = Char.GetData(defCharIndex,CONST.CHAR_Ѫ);
                     if damage>=defHpE-1 then
                       Char.SetData(defCharIndex, CONST.CHAR_Ѫ, defHpE+damage*0.1);
                       Char.SetData(defCharIndex, CONST.CHAR_����, 0);
                       Char.SetData(defCharIndex, CONST.CHAR_BattleLpRecovery, 2);
                       Char.UpCharStatus(defCharIndex);
                       NLG.UpChar(defCharIndex);
                       damage = damage*0;
                       --NLG.Say(-1,-1,"���������ġ����N�������Ă�������",4,3);
                     else
                       damage = damage;
                     end
                     return damage;
               end
               return damage;
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg ~= CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
               if (com3 == 10539)  then    --10539�������
                     if Char.GetData(charIndex,CONST.����_��ս����) == 1  then
                         NLG.Say(charIndex,charIndex,"���������������",4,3);
                     end
                     local State = Char.GetTempData(defCharIndex, '����') or 0;
                     if (State>0) then
                             if (State==2)  then
                                 Char.SetTempData(defCharIndex, '����', 1);
                                 damage = damage*1.2;
                                 --NLG.Say(-1,-1,"�����������������ڲ�λ�������ӂ���20%��ʣ��1̎���ڣ���",4,3);
                             elseif (State==1)  then
                                 Char.SetTempData(defCharIndex, '����', 0);
                                 damage = damage*1.2;
                                 --NLG.Say(-1,-1,"�����������������ڲ�λ�������ӂ���20%�����󌢟o���ڣ���",4,3);
                             end
                     else
                             Char.SetTempData(defCharIndex, '����', 2);
                             damage = damage*0.7;
                             --NLG.Say(-1,-1,"����������������ǂ��ڲ�λ���͂���30%�������2̎���ڣ���",4,3);
                     end
                     return damage;
               elseif (com3==26039)  then    --�չ☌��
                     if Char.GetData(charIndex,CONST.����_��ս����) == 1  then
                         NLG.Say(charIndex,charIndex,"���չ☌�⡿����",4,3);
                     end
                     local deBuff = Char.GetTempData(defCharIndex, '�ظ�����') or 0;
                     if (deBuff==0) then
                       Char.SetTempData(defCharIndex, '�ظ�����', 2);
                       damage = damage;
                       --NLG.Say(-1,-1,"���չ☌�⡿�o�茦���ί����֏͡����R�a���p��2�ӣ���",4,3);
                     end
                     return damage;
               elseif (com3==11139)  then    --̓�����g
                     if Char.GetData(charIndex,CONST.����_��ս����) == 1  then
                         NLG.Say(charIndex,charIndex,"��̓�����g������",4,3);
                     end
                     local defMp = Char.GetData(defCharIndex, CONST.CHAR_ħ);
                     local deBuff = Char.GetTempData(defCharIndex, '�Ͷ�') or 0;
                     Char.SetData(defCharIndex, CONST.CHAR_ħ, defMp*0.8);
                     NLG.UpChar(defCharIndex);
                     if (deBuff==0) then
                       Char.SetTempData(defCharIndex, '�Ͷ�', 2);
                       damage = damage;
                       --NLG.Say(-1,-1,"��̓�����g������ǰFP���p20%���K�o���ж��r�Ͷ�����2�شΣ���",4,3);
                     end
                     return damage;
               end

         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg == CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
               if Char.IsPlayer(charIndex) then
                 local LvRate = Char.GetData(charIndex,CONST.CHAR_�ȼ�);
                 local Spirit = Char.GetData(charIndex,CONST.CHAR_����);
                 local Mattack = Char.GetData(charIndex,CONST.CHAR_ħ��);
                 local Amnd_R = Char.GetData(charIndex, CONST.CHAR_����);
                 local Amnd = math.max(Conver_800(Amnd_R * 1),1);
                 local Dmnd_R = math.max(Char.GetData(defCharIndex, CONST.CHAR_����), 100);
                 local Dmnd = Conver_800(Dmnd_R * 1);
                 local SpRate = math.floor( (Amnd / (0.67 + Dmnd / Amnd)) ) * 0.01;
                 damage = damage * SpRate + Spirit * 0.25 * 1.2 + (Mattack+400)*0.08;
               --print(damage)
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
--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;