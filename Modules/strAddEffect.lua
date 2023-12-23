---模块类
local StrAddEffect = ModuleBase:createModule('strAddEffect')

local TechTbl = {
      { techID_b = 9500, techID_h = 9509, StrAdd_b = 4, StrAdd_h = 9, option = 'AM:', val = 5},
      { techID_b = 25800, techID_h = 25809, StrAdd_b = 7, StrAdd_h = 9, option = 'DD:', val = 20},
      { techID_b = 400, techID_h = 409, StrAdd_b = 4, StrAdd_h = 9, option = 'AM:', val = 3},
      { techID_b = 25700, techID_h = 25709, StrAdd_b = 7, StrAdd_h = 9, option = 'DD:', val = 20},
      { techID_b = 200500, techID_h = 200509, StrAdd_b = 4, StrAdd_h = 9, option = 'AM:', val = 3},
      { techID_b = 26200, techID_h = 26209, StrAdd_b = 7, StrAdd_h = 9, option = 'TR:', val = 20},
      { techID_b = 6300, techID_h = 6309, StrAdd_b = 4, StrAdd_h = 9, option = 'AR:', val = 60},
      { techID_b = 6600, techID_h = 6609, StrAdd_b = 7, StrAdd_h = 9, option = 'RR:', val = 40},
      { techID_b = 26600, techID_h = 26600, StrAdd_b = 0, StrAdd_h = 9, option = 'AR:', val = -15},
      { techID_b = 26601, techID_h = 26601, StrAdd_b = 1, StrAdd_h = 9, option = 'AR:', val = -16},
      { techID_b = 26602, techID_h = 26602, StrAdd_b = 2, StrAdd_h = 9, option = 'AR:', val = -17},
      { techID_b = 26603, techID_h = 26603, StrAdd_b = 3, StrAdd_h = 9, option = 'AR:', val = -18},
      { techID_b = 26604, techID_h = 26604, StrAdd_b = 4, StrAdd_h = 9, option = 'AR:', val = -19},
      { techID_b = 26605, techID_h = 26605, StrAdd_b = 5, StrAdd_h = 9, option = 'AR:', val = -20},
      { techID_b = 26606, techID_h = 26606, StrAdd_b = 6, StrAdd_h = 9, option = 'AR:', val = -23},
      { techID_b = 26607, techID_h = 26607, StrAdd_b = 7, StrAdd_h = 9, option = 'AR:', val = -25},
      { techID_b = 26608, techID_h = 26608, StrAdd_b = 8, StrAdd_h = 9, option = 'AR:', val = -30},
      { techID_b = 26609, techID_h = 26609, StrAdd_b = 9, StrAdd_h = 9, option = 'AR:', val = -30},
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
               local ShieldIndex = Char.GetShield(charIndex);                         --详情底部Fn
               local Shield_Name = Item.GetData(ShieldIndex, CONST.道具_名字);
               local ViceWeaponIndex = Char.GetViceWeapon(charIndex);                --左右手
               local ViceWeapon_Effect = Item.GetData(ViceWeaponIndex, CONST.道具_幸运);
               local GTime = NLG.GetGameTime();
               local StrAdd_W = 0;
               local StrAdd_S = 0;
               if Weapon_Name~=nil then
                 local StrPlus = string.find(Weapon_Name, "+");
                 if StrPlus~=nil then
                   StrAdd_W = tonumber(string.sub(Weapon_Name, StrPlus+1, -1));
                 end
               else
                 if Shield_Name~=nil then
                   local StrPlus = string.find(Shield_Name, "+");
                   if StrPlus~=nil then
                     StrAdd_S = tonumber(string.sub(Shield_Name, StrPlus+1, -1));
                   end
                 end
               end
               if ( StrAdd_W >= 0 ) then
                 local StrEffect_W = 1 + (StrAdd_W*0.03);
                 local StrEffect_S = 1 + (StrAdd_S*0.01);
                 --print(StrEffect)
                 if NLG.Rand(1,10)>=1  then
                        damage = damage * StrEffect_W;
                        --NLG.Say(charIndex,-1,"武器附加強化特殊效果每+1傷害提升3%，目前傷害"..(StrAdd_W*3).."%",4,3);
                        if ( ViceWeapon_Effect == GTime ) then
                               damage = damage+(1000 * StrEffect_S);
                               --NLG.Say(charIndex,-1,"附念造成額外真實傷害1000，每+1真實傷害再提升1%",4,3);
                        end
                        if ( Item.GetData(WeaponIndex, CONST.道具_类型) == 5 or Item.GetData(WeaponIndex, CONST.道具_类型) == 6) then
                               local Shadow = Char.GetTempData(defCharIndex, '影子标记') or 0
                               if (Battle.GetTurn(battleIndex)==1) then               --标记层数初始化
                                      Char.SetTempData(defCharIndex, '影子标记', 0);
                               end
                               if (Shadow>=1) then
                                      local agi = Char.GetData(charIndex, CONST.CHAR_敏捷);
                                      local SR = {0.2, 0.4, 0.8, 1.6}                                 --标记层数对应暴击系数
                                      local SAD = (SR[Shadow]) * agi;                         --影子偷袭附加伤害
                                      damage = damage+SAD;
                                      Char.SetTempData(defCharIndex, '影子标记', 0);      --标记层数初始化
                                      NLG.Say(charIndex,-1,"影子偷襲暴擊".. SAD .."！",4,3);
                               else
                                      local min = Item.GetData(WeaponIndex, CONST.道具_最小攻击数量);
                                      local max = Item.GetData(WeaponIndex, CONST.道具_最大攻击数量);
                                      local SL = math.random(min,max) or 0;
                                      Char.SetTempData(defCharIndex, '影子标记', SL);
                                      --NLG.Say(charIndex,-1,"影子標記".. SL .."層",4,3);
                               end
                        end
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
               local StrAdd_0 = 0;
               local StrAdd_1 = 0;
               local StrAdd_4 = 0;
               if Armour0_Name~=nil then
                 local StrPlus = string.find(Armour0_Name, "+");
                 if StrPlus~=nil then
                   StrAdd_0 = tonumber(string.sub(Armour0_Name, StrPlus+1, -1));
                 end
               elseif Armour1_Name~=nil then
                 local StrPlus = string.find(Armour1_Name, "+");
                 if StrPlus~=nil then
                   StrAdd_1 = tonumber(string.sub(Armour1_Name, StrPlus+1, -1));
                 end
               elseif Armour4_Name~=nil then
                 local StrPlus = string.find(Armour4_Name, "+");
                 if StrPlus~=nil then
                   StrAdd_4 = tonumber(string.sub(Armour4_Name, StrPlus+1, -1));
                 end
               end
               local StrAdd = StrAdd_0 + StrAdd_1 + StrAdd_4;
               if ( StrAdd >= 0 ) then
                 local StrEffect = 1 - (StrAdd*0.01);
                 --print(StrEffect)
                 if NLG.Rand(1,10)>=1  then
                        damage = damage * StrEffect;
                        --NLG.Say(defCharIndex,-1,"防具附加強化特殊效果每+1傷害減少1%，目前減傷"..(StrAdd*1).."%",4,3);
                 end
                 print(damage)
                 return damage;
               end
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
               local ViceWeaponIndex = Char.GetViceWeapon(charIndex);                --左右手
               local ViceWeapon_Name = Item.GetData(ViceWeaponIndex, CONST.道具_名字);
               local ViceStrAdd = 0;
               if ViceWeapon_Name~=nil then
                 local ViceStrPlus = string.find(ViceWeapon_Name, "+");
                 if ViceStrPlus~=nil then
                   ViceStrAdd = tonumber(string.sub(ViceWeapon_Name, ViceStrPlus+1, -1));
                 end
               end
               if NLG.Rand(1,4) >= 1 then
                 for k,v in pairs(TechTbl) do
                  if techID >= v.techID_b and techID <= v.techID_h  then
                        if ViceStrAdd >= v.StrAdd_b and ViceStrAdd <= v.StrAdd_h and option == v.option  then
                              NLG.SystemMessage(charIndex,"【技能威力加成】發動！");
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

Char.GetViceWeapon = function(charIndex)
  local itemType = {
    { type=60},{ type=61},{ type=62},{ type=63},{ type=64},{ type=65},
  }
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.道具_类型)==v.type then
        return ItemIndex;
      end
    end
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手)
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.道具_类型)==v.type then
        return ItemIndex;
      end
    end
  end
  return -1;
end

--- 卸载模块钩子
function StrAddEffect:onUnload()
  self:logInfo('unload')
end

return StrAddEffect;
