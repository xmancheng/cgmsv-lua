---ģ����
local Module = ModuleBase:createModule('playerSkill')

--���Ἴ�ܻ�������
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

--��������������
local imageRateTable = {
             { ImageType=1, imageId=106452, ac_val=1.05, mc_val=1.00, adef_val=1.00, mdef_val=1.00},           --���������˺�5%
             { ImageType=2, imageId=106627, ac_val=1.00, mc_val=1.05, adef_val=1.00, mdef_val=1.00},           --����ħ���˺�5%
             { ImageType=3, imageId=106552, ac_val=1.00, mc_val=1.00, adef_val=0.95, mdef_val=1.00},           --���������˺�5%
             { ImageType=4, imageId=106727, ac_val=1.00, mc_val=1.00, adef_val=1.00, mdef_val=0.95},           --����ħ���˺�5%
}

---------------------------------------------------------------------------
--- ����ģ�鹳��
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
--���⼼��Ч��
function Module:SpecialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.����_����) == CONST.��������_�� then
               leader = leader2
         end
         --������㹫ʽ����
         if Char.IsPlayer(charIndex)==true then
               --�����YӍ
               local Agile = Char.GetData(charIndex,CONST.CHAR_����);
               local Blood = Char.GetData(charIndex,CONST.CHAR_Ѫ);
               local dp = {}
               dp[1] = Char.GetData(defCharIndex, CONST.CHAR_������)
               dp[2] = Char.GetData(defCharIndex, CONST.CHAR_ˮ����)
               dp[3] = Char.GetData(defCharIndex, CONST.CHAR_������)
               dp[4] = Char.GetData(defCharIndex, CONST.CHAR_������)
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
--����Ч��(����)
function Module:LinkedEffect(charIndex, defCharIndex, damage, battleIndex, com3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.����_����) == CONST.��������_�� then
               leader = leader2
         end
         if Char.IsPlayer(charIndex) then
               --�����YӍ
               local LvRate = Char.GetData(charIndex,CONST.CHAR_�ȼ�);
               local Attack = Char.GetData(charIndex,CONST.CHAR_������);
               local Defense = Char.GetData(charIndex,CONST.CHAR_������);
               local Avoid = Char.GetData(charIndex,CONST.CHAR_����);
               local Critical = Char.GetData(charIndex,CONST.CHAR_��ɱ);
               local Counter = Char.GetData(charIndex,CONST.CHAR_����);
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
               end

         end
    return damage;
end
--�����¼�
function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.����_����) == CONST.��������_�� then
               leader = leader2
         end
         if Char.IsDummy(charIndex) then
           return
         end
         if (flg==CONST.HealDamageFlags.Heal)  then    --��Ѫ����ħ��
            if (com3==6300 or com3==6301 or com3==6302)  then
               if (Char.IsPlayer(defCharIndex)==true or Char.IsPet(defCharIndex)==true) then
                   local D_Buff = Char.GetTempData(defCharIndex, '��������') or 0;
                   if (D_Buff<=5)  then
                       heal = 666;
                       Char.SetTempData(defCharIndex, '��������', 5);
                   end
               end
            end
            return heal;
         elseif (flg==CONST.HealDamageFlags.Recovery)  then    --�ָ�ħ��
               return heal;
         elseif (flg==CONST.HealDamageFlags.Consentration)  then    --����ֹˮ
            if (com3==1200 or com3==1201 or com3==1202)  then
               if (Char.IsPlayer(defCharIndex)==true or Char.IsPet(defCharIndex)==true) then
                   local A_Buff = Char.GetTempData(defCharIndex, '��������') or 0;
                   if (A_Buff<=3)  then
                       heal = 350;
                       Char.SetTempData(defCharIndex, '��������', 3);
                   end
               end
            end
            return heal;
         end
         return heal;
end
--�˺��¼�
function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         if Char.IsDummy(charIndex) then
           return
         end
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.����_����) == CONST.��������_�� then
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

        --���������S��
        local ac_val, mc_val, adef_val, mdef_val = self:ImageRate(charIndex, defCharIndex, damage, battleIndex);
       --print(ac_val, mc_val, adef_val, mdef_val)

         if  flg == CONST.DamageFlags.Combo and Char.IsEnemy(defCharIndex) == true and Char.IsPlayer(charIndex) == true then
            local enemyId = Char.GetData(defCharIndex, CONST.����_ENEMY_ID);
            if (enemyId==400021) then
                    Char.GiveItem(charIndex, 40844, 1);
                    NLG.SortItem(charIndex);
            end
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPlayer(defCharIndex)==true  then
           if  flg == CONST.DamageFlags.Normal or flg == CONST.DamageFlags.Critical  then
               local damage = damage * adef_val;		--����������
               local D_Buff = Char.GetTempData(defCharIndex, '��������') or 0;
               if (D_Buff >= 1)  then
                   local damage = math.floor(damage * 0.8);
                   --print(oriDamage,damage);
                   Char.SetTempData(defCharIndex, '��������', D_Buff - 1);
                   return damage;
               end
               return damage;
           elseif flg == CONST.DamageFlags.Magic  then
               local damage = damage * mdef_val;		--����������
               local D_Buff = Char.GetTempData(defCharIndex, '��������') or 0;
               if (D_Buff >= 1)  then
                   local damage = math.floor(damage * 0.8);
                   --print(oriDamage,damage);
                   Char.SetTempData(defCharIndex, '��������', D_Buff - 1);
                   return damage;
               end
               return damage;
           end
           return damage;
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPlayer(charIndex)==true  then
           if  flg == CONST.DamageFlags.Normal or flg == CONST.DamageFlags.Critical  then
               local damage = damage * ac_val;		--����������
               local damage = self:SpecialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg);
               local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
               if (A_Buff >= 1)  then
                   local damage = math.floor(damage * 1.35);
                   --print(oriDamage,damage);
                   Char.SetTempData(charIndex, '��������', A_Buff - 1);
                   return damage;
               end
               return damage;
           elseif flg == CONST.DamageFlags.Magic  then
               local damage = damage * mc_val;		--����������
               local damage = self:SpecialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg);
               local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
               if (A_Buff >= 1)  then
                   local damage = math.floor(damage * 1.35);
                   --print(oriDamage,damage);
                   Char.SetTempData(charIndex, '��������', A_Buff - 1);
                   return damage;
               end
               return damage;
           end
           return damage;
         end
  return damage;
end

---------------------------------------------------------------------------
------���ܺ���
--����������
function Module:OnbattleStarCommand(battleIndex)
    for i=0, 19 do
        local charIndex = Battle.GetPlayIndex(battleIndex, i)
        if (charIndex>=0 and Char.IsPlayer(charIndex)==true) then
            local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
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
         if Char.GetData(leader2, CONST.����_����) == CONST.��������_�� then
               leader = leader2
         end
         --����״̬
         Linked_Tbl = {}
         --������������
         for i = 0, 9 do
               local playerPet = Battle.GetPlayIndex(battleIndex, i);
               if (playerPet >= 0 and Char.GetData(leader,CONST.����_ս��Side)==0 and Battle.GetType(battleIndex)==1) then
                   if (Char.GetData(playerPet, CONST.����_����) == CONST.��������_��)  then
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

--������ע����ʼ��
function Module:battleOverEventCallback(battleIndex)
  for i = 0, 19 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
              local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
              local D_Buff = Char.GetTempData(charIndex, '��������') or 0;
              if (A_Buff >= 1) then
                 Char.SetTempData(charIndex, '��������', 0);
              end
              if (D_Buff >= 1) then
                 Char.SetTempData(charIndex, '��������', 0);
              end
        end
  end
end
function Module:onLogbattleOverEvent(charIndex)
	local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
	local D_Buff = Char.GetTempData(charIndex, '��������') or 0;
	if (A_Buff >= 1) then
		Char.SetTempData(charIndex, '��������', 0);
	end
	if (D_Buff >= 1) then
		Char.SetTempData(charIndex, '��������', 0);
	end
end


--������ϵ������
function Module:ImageRate(charIndex, defCharIndex, damage, battleIndex)
        local ac_val_Rate = 1;
        local mc_val_Rate = 1;
        local adef_val_Rate = 1;
        local mdef_val_Rate = 1;
        if Char.IsPlayer(charIndex) == true and Char.IsPlayer(defCharIndex) == false then
            local imageId = Char.GetData(charIndex, CONST.����_����)
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
            local imageId = Char.GetData(defCharIndex, CONST.����_����)
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
          local imageId = Char.GetData(charIndex, CONST.����_����)
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
          local imageId = Char.GetData(defCharIndex, CONST.����_����)
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

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;