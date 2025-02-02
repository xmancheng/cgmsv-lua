---ģ����
local Module = ModuleBase:createModule('petSkill')

local petMettleTable = {
             { MettleType=1, type=CONST.CHAR_EnemyBossFlg, info=CONST.Enemy_�Ƿ�BOSS, skillId=9610 , val = 1.15},              --��BOSS���������˺�
             { MettleType=3, type=CONST.CHAR_������, info=CONST.����_��, skillId=9611 , val = 1.05},              --�Ե����Զ��������˺�
             { MettleType=3, type=CONST.CHAR_ˮ����, info=CONST.����_ˮ, skillId=9612 , val = 1.05},              --��ˮ���Զ��������˺�
             { MettleType=3, type=CONST.CHAR_������, info=CONST.����_��, skillId=9613 , val = 1.05},              --�Ի����Զ��������˺�
             { MettleType=3, type=CONST.CHAR_������, info=CONST.����_��, skillId=9614 , val = 1.05},              --�Է����Զ��������˺�
             { MettleType=4, type=CONST.CHAR_������, info=CONST.����_��, skillId=9615 , val = 0.95},              --�������Ե����Զ����˺�
             { MettleType=4, type=CONST.CHAR_ˮ����, info=CONST.����_ˮ, skillId=9616 , val = 0.95},              --��������ˮ���Զ����˺�
             { MettleType=4, type=CONST.CHAR_������, info=CONST.����_��, skillId=9617 , val = 0.95},              --�������Ի����Զ����˺�
             { MettleType=4, type=CONST.CHAR_������, info=CONST.����_��, skillId=9618 , val = 0.95},              --�������Է����Զ����˺�
             { MettleType=2, type=CONST.CHAR_EnemyBossFlg, info=CONST.Enemy_�Ƿ�BOSS, skillId=9619 , val = 0.85},              --��������BOSS�����˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9620 , val = 1.25},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_��, skillId=9621 , val = 1.25},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9622 , val = 1.25},              --�Բ���ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9623 , val = 1.25},              --�Է���ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9624 , val = 1.25},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_ֲ��, skillId=9625 , val = 1.25},              --��ֲ��ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_Ұ��, skillId=9626 , val = 1.25},              --��Ұ��ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9627 , val = 1.25},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9628 , val = 1.25},              --�Խ���ϵ���������˺�
             { MettleType=5, type=CONST.����_����, info=CONST.����_аħ, skillId=9629 , val = 1.05},              --��аħϵ���������˺�
}

local petStateTable = {
             { StateType=1, type=CONST.CHAR_BattleModPoison, skillId=1840 , val = 2.0},              --���ж�״̬���������˺�
             { StateType=1, type=CONST.CHAR_BattleModPoison, skillId=1841 , val = 2.5},              --���ж�״̬���������˺�
             { StateType=1, type=CONST.CHAR_BattleModStone, skillId=1842 , val = 2.0},              --��ʯ��״̬���������˺�
             { StateType=1, type=CONST.CHAR_BattleModStone, skillId=1843 , val = 2.5},              --��ʯ��״̬���������˺�
             { StateType=1, type=CONST.CHAR_BattleModConfusion, skillId=1844 , val = 2.0},              --�Ի���״̬���������˺�
             { StateType=1, type=CONST.CHAR_BattleModConfusion, skillId=1845 , val = 2.5},              --�Ի���״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310000 , val = 1.2},                                --��������ʴ״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310001 , val = 1.2},                                --��������ʴ״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310002 , val = 1.2},                                --��������ʴ״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310003 , val = 1.2},                                --��������ʴ״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310004 , val = 1.2},                                --��������ʴ״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310005 , val = 1.2},                                --��������ʴ״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310006 , val = 1.2},                                --��������ʴ״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310007 , val = 1.2},                                --��������ʴ״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310008 , val = 1.2},                                --��������ʴ״̬���������˺�
             { StateType=2, type='������ʴ', skillId=310009 , val = 1.5},                                --�Գ�����ʴ״̬���������˺�
}

local techRateTable = {
             { TechType=1, skillId=1440, c_prob=8, c_val = 1.3, def_prob=8, def_val = 1.0},               --����ڤ��.80%�������������˺�
             { TechType=2, skillId=1441, c_prob=8, c_val = 1.0, def_prob=8, def_val = 0.7},               --�F������.80%�������������˺�
             { TechType=3, skillId=1442, c_prob=9, c_val = 1.5, def_prob=9, def_val = 1.2},               --��¡.��������90%��������
             { TechType=4, skillId=1443, c_prob=9, c_val = 0.8, def_prob=9, def_val = 0.5},               --�㼪ʿ.����[��90%��������
             { TechType=5, skillId=1444, c_prob=10, c_val = 1.2, def_prob=10, def_val = 0.8},             --����.���z�w�|100%��������
             { TechType=6, skillId=1445, c_prob=10, c_val = 1.3, def_prob=10, def_val = 0.9},             --��.ҹ������100%��������
             { TechType=7, skillId=1446, c_prob=9, c_val = 1.4, def_prob=9, def_val = 1.1},               --�Q��.����ģʽ90%��������
             { TechType=8, skillId=1447, c_prob=9, c_val = 0.9, def_prob=9, def_val = 0.6},               --����.����ܺ�90%��������
             { TechType=9, skillId=1448, c_prob=7, c_val = 1.6, def_prob=7, def_val = 1.3},               --��.��݆��70%��������
             { TechType=10, skillId=1449, c_prob=7, c_val = 0.7, def_prob=7, def_val = 0.4},              --�V��.�����g70%��������
             { TechType=11, skillId=1450, c_prob=5, c_val = 1.8, def_prob=5, def_val = 1.5},              --��ِ��.ِ����50%��������
             { TechType=12, skillId=1451, c_prob=5, c_val = 0.5, def_prob=5, def_val = 0.2},              --18̖.������50%��������
             { TechType=13, skillId=1452, c_prob=10, c_val = 1.1, def_prob=10, def_val = 0.7},            --������.м�L100%��������
             { TechType=14, skillId=1453, c_prob=10, c_val = 1.1, def_prob=10, def_val = 0.7},            --��֪����.����100%��������
             { TechType=15, skillId=310000, c_prob=8, c_val = 1.2, def_prob=8, def_val = 0.9},              --����֮Ȩ��80%��������20%��80%��������10%
             { TechType=16, skillId=310001, c_prob=9, c_val = 0.9, def_prob=9, def_val = 0.9},              --����֮Ȩ��90%��������10%��90%��������10%
             { TechType=17, skillId=310002, c_prob=10, c_val = 1.4, def_prob=8, def_val = 1.3},             --����֮Ȩ��100%��������40%��80%��������30%
             { TechType=18, skillId=310003, c_prob=9, c_val = 1.1, def_prob=9, def_val = 0.9},              --��ʳ֮Ȩ��90%��������10%��90%��������10%
             { TechType=19, skillId=310004, c_prob=5, c_val = 0.9, def_prob=7, def_val = 1.1},              --ɫ��֮Ȩ��50%��������10%��70%��������10%
             { TechType=20, skillId=310005, c_prob=9, c_val = 1.7, def_prob=10, def_val = 1.2},             --��ŭ֮Ȩ��90%��������70%��100%��������20%
             { TechType=21, skillId=310006, c_prob=8, c_val = 0.7, def_prob=10, def_val = 0.8},             --ǿ��֮Ȩ��80%��������30%��100%��������20%
             { TechType=22, skillId=310007, c_prob=10, c_val = 0.8, def_prob=7, def_val = 0.5},             --����֮Ȩ��100%��������20%��70%��������50%
             { TechType=23, skillId=310008, c_prob=10, c_val = 0.8, def_prob=7, def_val = 0.5},             --����֮Ȩ��100%��������20%��70%��������50%
             { TechType=24, skillId=310009, c_prob=5, c_val = 2.0, def_prob=5, def_val = 0.3},              --����֮ħŮ50%��������100%��50%��������70%
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
end

function Module:tempDamage(charIndex, defCharIndex, damage, battleIndex)
        for k, v in ipairs(petMettleTable) do
           if (v.MettleType==1 and Char.GetData(charIndex, CONST.����_����) == CONST.��������_��)  then           --����BOSS�����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       --print("�Ը����:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==2 and Char.GetData(defCharIndex, CONST.����_����) == CONST.��������_��)  then     --�ܷ�BOSS�����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       --print("�Ը����:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==3 and Char.GetData(charIndex, CONST.����_����) == CONST.��������_��)  then            --������������س����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       --print("�Ը����:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==4 and Char.GetData(defCharIndex, CONST.����_����) == CONST.��������_��)  then     --�ܷ���������س����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       --print("�Ը����:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==5 and Char.GetData(charIndex, CONST.����_����) == CONST.��������_��)  then           --������������Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == v.info) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       --print("�Ը����:"..damage)
                       return damage;
                   end
               end
           end

         end
    return damage;
end

function Module:specialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg)
         --������㹫ʽ����
         if Char.IsPet(charIndex) == true then
               if (com3 == 3031 or com3 == 2931 or com3 == 2831) then
                   --�����YӍ
                   local Amnd_R = Char.GetData(charIndex, CONST.CHAR_������);
                   local Amnd = math.max( Conver_240(Amnd_R), 1);
                   local Dmnd_R = Char.GetData(defCharIndex, CONST.CHAR_������);
                   local Dmnd = math.max( Conver_240(Dmnd_R), 100)
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
                   local damage = math.floor( ((Amnd / (0.67 + Dmnd / Amnd))* 2)* AttRate * RaceRate * RndRate)
                   local Spirit = Char.GetData(charIndex, CONST.CHAR_����);
                   local damage = math.ceil(  damage * ( math.max( Conver_240(Spirit), 100) / 60 )  );
                   if com3 == 2931 and NLG.Rand(1,3)==3 then
                       Char.SetData(defCharIndex, CONST.CHAR_BattleModPoison, 3);
                       NLG.UpChar(defCharIndex);
                   elseif com3 == 2831 and NLG.Rand(1,3)==3 then
                       Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 1);
                       NLG.UpChar(defCharIndex);
                   elseif com3 == 3031 and NLG.Rand(1,3)==3 then
                       Char.SetData(defCharIndex, CONST.CHAR_BattleModConfusion, 2);
                       NLG.UpChar(defCharIndex);
                   end
                   return damage;
               elseif (com3 == 310000 or com3 == 310001 or com3 == 310002 or com3 == 310003 or com3 == 310004 or com3 == 310005 or com3 == 310006 or com3 == 310007 or com3 == 310008 or com3 == 310009) then
                   if com3 == 310000 or com3 == 310001 or com3 == 310002 or com3 == 310003 or com3 == 310004 or com3 == 310005 or com3 == 310006 or com3 == 310007 or com3 == 310008 then
                       Char.SetTempData(defCharIndex, '������ʴ', 1);
                       NLG.UpChar(defCharIndex);
                   elseif com3 == 310009 then
                       Char.SetTempData(defCharIndex, '������ʴ', 1);
                       NLG.UpChar(defCharIndex);
                   end
                   return damage;
               end
               return damage;
         end
    return damage;
end

function Module:StateDamage(charIndex, defCharIndex, damage, battleIndex)
        for k, v in ipairs(petStateTable) do
           if (v.StateType==1)  then
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i);
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) > 1) then
                       damage = damage * v.val;
                       return damage;
                   end
               end
           elseif (v.StateType==2)  then
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i);
                   local state= Char.GetTempData(defCharIndex, v.type) or 0;
                   if (skillId == v.skillId and state>= 1) then
                       damage = damage * v.val;
                       return damage;
                   end
               end
           end
         end
    return damage;
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.����_����) == CONST.��������_�� then
               leader = leader2
         end
         if Char.IsDummy(charIndex) then
           return
         end

         --�����ؼ�
         local damage = self:specialDamage(charIndex, defCharIndex, damage, battleIndex, com3, flg);

         if  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPet(defCharIndex) == true  then
           if  flg == CONST.DamageFlags.Normal or flg == CONST.DamageFlags.Critical  then
             --����ӳ�
             local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage_temp;
             --���������S��
             local c_techRate,def_techRate = self:TechRate(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage * def_techRate;
               local D_Buff = Char.GetTempData(defCharIndex, '��������') or 0;
               if (D_Buff >= 1)  then
                   damage = math.floor(damage * 0.8);
                   Char.SetTempData(defCharIndex, '��������', D_Buff - 1);
                   return damage;
               end
             return damage;
           elseif  flg == CONST.DamageFlags.Magic  then
             --����ӳ�
             local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage_temp;
             --���������S��
             local c_techRate,def_techRate = self:TechRate(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage * def_techRate;
               local D_Buff = Char.GetTempData(defCharIndex, '��������') or 0;
               if (D_Buff >= 1)  then
                   damage = math.floor(damage * 0.8);
                   Char.SetTempData(defCharIndex, '��������', D_Buff - 1);
                   return damage;
               end
             return damage;
           end
           return damage;
         elseif  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPet(charIndex) == true  then
           if  flg == CONST.DamageFlags.Normal or flg == CONST.DamageFlags.Critical  then
             --״̬����ӳ�
             local damage = self:StateDamage(charIndex, defCharIndex, damage, battleIndex);
             --����ӳ�
             local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage_temp;
             --���������S��
             local c_techRate,def_techRate = self:TechRate(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage * c_techRate;
               local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
               if (A_Buff >= 1)  then
                   damage = math.floor(damage * 1.35);
                   Char.SetTempData(charIndex, '��������', A_Buff - 1);
                   return damage;
               end
             return damage;
           elseif  flg == CONST.DamageFlags.Magic  then
             --����ӳ�
             local ASpirit = Char.GetData(charIndex, CONST.CHAR_����);
             local DSpirit = Char.GetData(defCharIndex, CONST.CHAR_����);
             local RegulateRate = Conver_303(ASpirit/DSpirit);
             local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage_temp;
             local damage = math.ceil(  damage * RegulateRate * ( math.max( Conver_240(ASpirit), 303) / 120 )  );
             --���������S��
             local c_techRate,def_techRate = self:TechRate(charIndex, defCharIndex, damage, battleIndex);
             local damage = damage * c_techRate;
               local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
               if (A_Buff >= 1)  then
                   damage = math.floor(damage * 1.35);
                   Char.SetTempData(charIndex, '��������', A_Buff - 1);
                   return damage;
               end
             if (com3 >= 26700 and com3 <= 26720)  then
                local TechLv = math.fmod(com3,26700)+1;
                local Amnd_R = Char.GetData(charIndex, CONST.CHAR_������);
                local Amnd = math.max( Conver_240(Amnd_R), 1);
                local Dmnd_R = Char.GetData(defCharIndex, CONST.CHAR_������);
                local Dmnd = math.max( Conver_240(Dmnd_R), 100)
                local dp = {}
                dp[1] = Char.GetData(defCharIndex, CONST.CHAR_������)
                dp[2] = Char.GetData(defCharIndex, CONST.CHAR_ˮ����)
                dp[3] = Char.GetData(defCharIndex, CONST.CHAR_������)
                dp[4] = Char.GetData(defCharIndex, CONST.CHAR_������)
                local AttRate_2 = Battle.CalcAttributeDmgRate(charIndex, defCharIndex)
                local AttRate = (AttRate_2 - 1) * 0.5 + 1
                local RaceRate = Battle.CalcTribeDmgRate(charIndex, defCharIndex) + 1
                local RndRate = NLG.Rand(90,110) / 100
                local damage = math.floor( ((Amnd / (0.67 + Dmnd / Amnd))* TechLv * 0.5)* AttRate * RaceRate * RndRate)
                return damage;
             end
             return damage;
           end
           return damage;
         end
  return damage;
end


function Conver_240(Num)
	if Num >= 240 then
		local a = math.floor((Num - 240 ) * 0.3 + 240)
		return a
	else
		return Num
	end
end

function Conver_303(Rate)
    local Rate = Rate*100;
	if Rate >= 120 then
		return 1
	elseif Rate >= 114 and Rate < 120 then
		local Num = 10/9;
		return Num
	elseif Rate >= 105 and Rate < 114 then
		local Num = 10/8.2;
		return Num
	elseif Rate >= 102 and Rate < 105 then
		local Num = 10/6.3;
		return Num
	elseif Rate >= 98 and Rate < 102 then
		local Num = 10/5;
		return Num
	elseif Rate >= 90 and Rate < 98 then
		local Num = 10/5.5;
		return Num
	elseif Rate >= 80 and Rate < 90 then
		local Num = 10/3.6;
		return Num
	elseif Rate >= 70 and Rate < 80 then
		local Num = 10/2.7;
		return Num
	elseif Rate < 70 then
		local Num = 10/0.9;
		return Num
	end
end

function Module:TechRate(charIndex, defCharIndex, damage, battleIndex)
        local c_val_Rate = 1;
        local def_val_Rate = 1;
        if Char.IsPet(charIndex) == true and Char.IsPet(defCharIndex) == false then
          for i=0,9 do
            local skillId = Pet.GetSkill(charIndex, i)
            for k, v in ipairs(techRateTable) do
               if (skillId == v.skillId) then
                  if (NLG.Rand(1,10) <= v.c_prob) then
                     c_val_Rate = c_val_Rate * v.c_val;
                     def_val_Rate = def_val_Rate * v.def_val;
                  else
                     c_val_Rate = c_val_Rate;
                     def_val_Rate = def_val_Rate;
                  end
               end
            end
          end
          return c_val_Rate, def_val_Rate;
        elseif Char.IsPet(defCharIndex) == true and Char.IsPet(charIndex) == false then
          for i=0,9 do
            local skillId = Pet.GetSkill(defCharIndex, i)
            for k, v in ipairs(techRateTable) do
               if (skillId == v.skillId) then
                  if (NLG.Rand(1,10) <= v.def_prob) then
                     c_val_Rate = c_val_Rate * v.c_val;
                     def_val_Rate = def_val_Rate * v.def_val;
                  else
                     c_val_Rate = c_val_Rate;
                     def_val_Rate = def_val_Rate;
                  end
               end
            end
          end
          return c_val_Rate, def_val_Rate;
        elseif Char.IsPet(charIndex) == true and Char.IsPet(defCharIndex) == true then
          local temp_c_1 = 1;
          local temp_def_1 = 1;
          for i=0,9 do
            local skillId = Pet.GetSkill(charIndex, i)
            for k, v in ipairs(techRateTable) do
               if (skillId == v.skillId) then
                  if (NLG.Rand(1,10) <= v.c_prob) then
                     temp_c_1 = temp_c_1 * v.c_val;
                     temp_def_1 = temp_def_1 * v.def_val;
                  else
                     temp_c_1 = temp_c_1;
                     temp_def_1 = temp_def_1;
                  end
               end
            end
          end
          local temp_c_2 = 1;
          local temp_def_2 = 1;
          for i=0,9 do
            local skillId = Pet.GetSkill(defCharIndex, i)
            for k, v in ipairs(techRateTable) do
               if (skillId == v.skillId) then
                  if (NLG.Rand(1,10) <= v.def_prob) then
                     temp_c_2 = temp_c_2 * v.c_val;
                     temp_def_2 = temp_def_2 * v.def_val;
                  else
                     temp_c_2 = temp_c_2;
                     temp_def_2 = temp_def_2;
                  end
               end
            end
          end
          c_val_Rate = temp_c_1 * temp_def_2;
          def_val_Rate = temp_def_1 * temp_c_2;
          return c_val_Rate, def_val_Rate;
        end
    return 1,1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
