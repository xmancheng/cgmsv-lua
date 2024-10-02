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
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_аħ, skillId=9629 , val = 1.05},              --��аħϵ���������˺�
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
end

function Module:tempDamage(charIndex, defCharIndex, damage, battleIndex)
        for k, v in ipairs(petMettleTable) do
           if (v.MettleType==1 and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��)  then           --����BOSS�����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       --print("�Ը����:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==2 and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��)  then     --�ܷ�BOSS�����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       --print("�Ը����:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==3 and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��)  then            --������������س����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       --print("�Ը����:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==4 and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��)  then     --�ܷ���������س����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       --print("�Ը����:"..damage)
                       return damage;
                   end
               end
           elseif (v.MettleType==5 and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��)  then           --������������Ը�
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

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if  flg ~= CONST.DamageFlags.Magic and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
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
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
           --����ӳ�
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
           local damage = damage * 1.05 ;
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

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
