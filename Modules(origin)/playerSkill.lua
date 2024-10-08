---ģ����
local Module = ModuleBase:createModule('playerSkill')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self))
end


function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if (flg==CONST.HealDamageFlags.Heal)  then    --�aѪ�ί�ħ��
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
         elseif (flg==CONST.HealDamageFlags.Recovery)  then    --�֏�ħ��
               return heal;
         elseif (flg==CONST.HealDamageFlags.Consentration)  then    --���Rֹˮ
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

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPlayer(defCharIndex)==true  then
               local D_Buff = Char.GetTempData(defCharIndex, '��������') or 0;
               if (D_Buff >= 1)  then
                   local damage = math.floor(oriDamage * 0.8);
                   --print(oriDamage,damage);
                   Char.SetTempData(defCharIndex, '��������', D_Buff - 1);
                   return damage;
               end
               return damage;
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPlayer(charIndex)==true  then
               local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
               if (A_Buff >= 1)  then
                   local damage = math.floor(oriDamage * 1.35);
                   --print(oriDamage,damage);
                   Char.SetTempData(charIndex, '��������', A_Buff - 1);
                   return damage;
               end
               return damage;
         elseif flg == CONST.DamageFlags.Magic and Char.IsPlayer(charIndex)==true  then
               local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
               if (A_Buff >= 1)  then
                   local damage = math.floor(oriDamage * 1.35);
                   --print(oriDamage,damage);
                   Char.SetTempData(charIndex, '��������', A_Buff - 1);
                   return damage;
               end
               return damage;
         else
         end
  return damage;
end

function Module:OnbattleStarCommand(battleIndex)
    for i=0, 19 do
        local charIndex = Battle.GetPlayIndex(battleIndex, i)
        if (charIndex>=0 and Char.IsPlayer(charIndex)==true) then
            local A_Buff = Char.GetTempData(charIndex, '��������') or 0;
            if (A_Buff >= 1) then
                    NLG.SetHeadIcon(charIndex, 119646);
                    NLG.UpChar(charIndex);
            else
                    NLG.SetHeadIcon(charIndex, 1);
                    NLG.UpChar(charIndex);
            end
        end
    end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;