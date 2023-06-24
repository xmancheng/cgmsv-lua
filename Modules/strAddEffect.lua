---ģ����
local StrAddEffect = ModuleBase:createModule('strAddEffect')

--- ����ģ�鹳��
function StrAddEffect:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
end


function StrAddEffect:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex)
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
               local WeaponIndex = Char.GetWeapon(charIndex);                --������
               local Weapon_Name = Item.GetData(WeaponIndex, CONST.����_����);
               local StrPlus = string.find(Weapon_Name, "+");
               if StrPlus~=nil then
                 StrAdd = tonumber(string.sub(Weapon_Name, StrPlus+1, -1));
               else
                 StrAdd = 0;
               end
               if ( StrAdd >= 0 ) then
                 local StrEffect = 1 + (StrAdd*0.02);
                 --print(StrEffect)
                 if NLG.Rand(1,10)>=1  then
                        damage = damage * StrEffect;
                        NLG.Say(charIndex,-1,"��������ǿ������Ч��ÿ+1�˺�����2%��Ŀǰ�˺�"..(StrAdd*2).."%",4,3);
                 end
                 print(damage)
                 return damage;
               end
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then
               local Armour0 = Char.GetItemIndex(defCharIndex, 0);                  --ͷ
               local Armour0_Name = Item.GetData(Armour0, CONST.����_����);
               local Armour1 = Char.GetItemIndex(defCharIndex, 1);                  --��
               local Armour0_Name = Item.GetData(Armour1, CONST.����_����);
               local Armour4 = Char.GetItemIndex(defCharIndex, 4);                  --��
               local Armour0_Name = Item.GetData(Armour4, CONST.����_����);

         else
         end
  return damage;
end


function StrAddEffect:OnTechOptionEventCallBack(charIndex, option, techID, val)         
         --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
         local battleIndex = Char.GetBattleIndex(charIndex)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_�� then
               local WeaponIndex = Char.GetWeapon(charIndex);                --������
               local Weapon_Name = Item.GetData(WeaponIndex, CONST.����_����);
               local StrPlus = string.find(Weapon_Name, "+");
               if StrPlus~=nil then
                 StrAdd = tonumber(string.sub(Weapon_Name, StrPlus+1, -1));
               else
                 StrAdd = 0;
               end
               if NLG.Rand(1,4) >= 1 then
                  if techID >= 9500 and techID <= 9509 and StrAdd>= 7 then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"�����������ӳɡ�������");
                              return val+3;
                        end
                        return val
                  end
               end
         end
end

--- ж��ģ�鹳��
function StrAddEffect:onUnload()
  self:logInfo('unload')
end

return StrAddEffect;
