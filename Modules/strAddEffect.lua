---模块类
local StrAddEffect = ModuleBase:createModule('strAddEffect')

local TechTbl = {
      { techID_b = 9500, techID_h = 9509, StrAdd_b = 5, StrAdd_h = 8, option = 'AM:', val = 3},
      { techID_b = 9500, techID_h = 9509, StrAdd_b = 9, StrAdd_h = 9, option = 'AM:', val = 8},
      { techID_b = 400, techID_h = 409, StrAdd_b = 5, StrAdd_h = 8, option = 'AM:', val = 2},
      { techID_b = 400, techID_h = 409, StrAdd_b = 9, StrAdd_h = 9, option = 'AM:', val = 3},
      { techID_b = 200500, techID_h = 200509, StrAdd_b = 5, StrAdd_h = 8, option = 'AM:', val = 2},
      { techID_b = 200500, techID_h = 200509, StrAdd_b = 9, StrAdd_h = 9, option = 'AM:', val = 3}
}

--- 加载模块钩子
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
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               local WeaponIndex = Char.GetWeapon(charIndex);                --左右手
               local Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字);
               local StrAdd = 0;
               if Weapon_Name~=nil then
                 local StrPlus = string.find(Weapon_Name, "+");
                 if StrPlus~=nil then
                   StrAdd = tonumber(string.sub(Weapon_Name, StrPlus+1, -1));
                 end
               end
               if ( StrAdd >= 0 ) then
                 local StrEffect = 1 + (StrAdd*0.02);
                 --print(StrEffect)
                 if NLG.Rand(1,10)>=1  then
                        damage = damage * StrEffect;
                        --NLG.Say(charIndex,-1,"武器附加强化特殊效果每+1伤害提升2%，目前伤害"..(StrAdd*2).."%",4,3);
                 end
                 print(damage)
                 return damage;
               end
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               local Armour0 = Char.GetItemIndex(defCharIndex, 0);                  --头
               local Armour0_Name = Item.GetData(Armour0, CONST.道具_名字);
               local Armour1 = Char.GetItemIndex(defCharIndex, 1);                  --身
               local Armour1_Name = Item.GetData(Armour1, CONST.道具_名字);
               local Armour4 = Char.GetItemIndex(defCharIndex, 4);                  --腿
               local Armour4_Name = Item.GetData(Armour4, CONST.道具_名字);

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
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
               local WeaponIndex = Char.GetWeapon(charIndex);                --左右手
               local Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字);
               local ShieldIndex = Char.GetShield(charIndex);                         --详情底部Fn
               local Shield_Name = Item.GetData(ShieldIndex, CONST.道具_名字);
               local StrAdd = 0;
               if Weapon_Name~=nil then
                 local StrPlus = string.find(Weapon_Name, "+");
                 if StrPlus~=nil then
                   StrAdd = tonumber(string.sub(Weapon_Name, StrPlus+1, -1));
                 end
               else
                 if Shield_Name~=nil then
                   local StrPlus = string.find(Shield_Name, "+");
                   if StrPlus~=nil then
                     StrAdd = tonumber(string.sub(Shield_Name, StrPlus+1, -1));
                   end
                 end
               end
               if NLG.Rand(1,4) >= 1 then
                 for k,v in pairs(TechTbl) do
                  if techID >= v.techID_b and techID <= v.techID_h and StrAdd >= v.StrAdd_b and StrAdd <= v.StrAdd_h  then
                        if option == v.option then
                              NLG.SystemMessage(charIndex,"【技能威力加成】发动！");
                              return val+v.val;
                        end
                        return val
                  end
                 end
               end
         end
end


Char.GetShield = function(charIndex)
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.ITEM_TYPE_盾 then
    return ItemIndex;
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手)
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.ITEM_TYPE_盾 then
    return ItemIndex;
  end
  return -1;
end

--- 卸载模块钩子
function StrAddEffect:onUnload()
  self:logInfo('unload')
end

return StrAddEffect;
