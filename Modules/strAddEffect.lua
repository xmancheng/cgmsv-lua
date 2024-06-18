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

local signShadow = {
    { type=Shadow, min=1, max=2, layer=1, round=1, ratio=0.2},        --影子标记、最小攻击次数、最大攻击次数、层数、回合、暴击系数
    { type=Shadow, min=2, max=2, layer=1, round=2, ratio=0.2},
    { type=Shadow, min=2, max=3, layer=2, round=2, ratio=0.41},
    { type=Shadow, min=3, max=3, layer=2, round=3, ratio=0.4},
    { type=Shadow, min=3, max=4, layer=3, round=3, ratio=0.8},
}

local signAbsorb = {
    { type=Absorb, min=1, max=2, bruise=10000},    --集伤标记、最小攻击次数、最大攻击次数、转换数值上限
    { type=Absorb, min=2, max=2, bruise=15000},
    { type=Absorb, min=2, max=3, bruise=20000},
    { type=Absorb, min=3, max=3, bruise=25000},
    { type=Absorb, min=3, max=4, bruise=30000},
}

--- 加载模块钩子
function StrAddEffect:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
end


function StrAddEffect:battleOverEventCallback(battleIndex)
         for i = 0,19 do
               local markCharIndex = Battle.GetPlayer(battleIndex, i);
               if (markCharIndex > 0) then    --标记层数初始化
                      if (Char.GetTempData(markCharIndex, '影子标记层数')==nil or Char.GetTempData(markCharIndex, '影子标记层数') > 0 )  then
                             Char.SetTempData(markCharIndex, '影子标记层数', 0);
                             NLG.UpChar(markCharIndex)
                      end
                      if (Char.GetTempData(markCharIndex, '集伤标记转换')==nil or Char.GetTempData(markCharIndex, '集伤标记转换') > 0 )  then
                             Char.SetTempData(markCharIndex, '集伤标记转换', 0);
                             NLG.UpChar(markCharIndex)
                      end
               end
         end
         for DementorWhile = 0,9 do
              local player = Battle.GetPlayer(battleIndex,DementorWhile);
              if (player>0) then
                 local ViceWeaponIndex = Char.GetViceWeapon(player);                --左右手
                 if (ViceWeaponIndex>0) then ViceWeapon_Effect = Item.GetData(ViceWeaponIndex, CONST.道具_幸运); end
                 if (ViceWeaponIndex>0) then ViceWeapon_Name = Item.GetData(ViceWeaponIndex, CONST.道具_名字); end
                 local GTime = NLG.GetGameTime();
                 local StrAdd_V = 0;
                 if ViceWeapon_Name~=nil then
                    local StrPlus = string.find(ViceWeapon_Name, "+");
                    if StrPlus~=nil then
                       StrAdd_V = tonumber(string.sub(ViceWeapon_Name, StrPlus+1, -1));
                    end
                 end
                 if Char.GetData(player,%对象_类型%) == 1 and StrAdd_V >= 1 and ViceWeapon_Effect ~= GTime then
                    for i = 0 , 7 do
                          local itemIndex = Char.GetItemIndex(player,i)
                          if itemIndex > 0 then
                              local itemdu = Item.GetData(itemIndex,CONST.道具_耐久);
                              local itemmaxdu = Item.GetData(itemIndex,CONST.道具_最大耐久);
                              if (itemdu <= itemmaxdu-StrAdd_V) then
                                  Item.SetData(itemIndex,CONST.道具_耐久,itemdu+StrAdd_V);
                              else
                                  Item.SetData(itemIndex,CONST.道具_耐久,itemmaxdu);
                              end
                              Item.UpItem(player,i);
                          end
                    end
                    NLG.Say(player,-1,"附念吸取怪物的魂魄，並回復全身裝備耐久，每+1效果提升1點",4,3);
                 end
              end
         end
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
               if (WeaponIndex>0) then Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字); end
               local ShieldIndex = Char.GetShield(charIndex);                         --详情底部Fn
               if (ShieldIndex>0) then Shield_Name = Item.GetData(ShieldIndex, CONST.道具_名字); end
               local ViceWeaponIndex = Char.GetViceWeapon(charIndex);                --左右手
               if (ViceWeaponIndex>0) then ViceWeapon_Effect = Item.GetData(ViceWeaponIndex, CONST.道具_幸运); end
               local GTime = NLG.GetGameTime();
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
               if ( StrAdd >= 0 ) then
                 local StrEffect = 1 + (StrAdd*0.03);
                 --print(StrEffect)
                 if NLG.Rand(1,10)>=1  then
                        damage = damage * StrEffect;
                        --NLG.Say(charIndex,-1,"武器附加強化特殊效果每+1傷害提升3%，目前傷害"..(StrAdd*3).."%",4,3);
                        if ( ViceWeapon_Effect == GTime ) then
                               damage = (damage+1000) * StrEffect;
                               --NLG.Say(charIndex,-1,"附念造成額外真實傷害1000，每+1真實傷害再提升3%",4,3);
                        end
                        if ( WeaponIndex>0 and Item.GetData(WeaponIndex, CONST.道具_类型) == 5 or Item.GetData(WeaponIndex, CONST.道具_类型) == 6) then
                               for k, v in ipairs(signShadow) do
                                      local Round = Battle.GetTurn(battleIndex);
                                      local yzbj_round= Char.GetTempData(defCharIndex, '影子标记回合') or 0
                                      local min_w = Item.GetData(WeaponIndex, CONST.道具_最小攻击数量);
                                      local max_w = Item.GetData(WeaponIndex, CONST.道具_最大攻击数量);
                                      if (v.type == Shadow and min_w==v.min and max_w==v.max ) then
                                             if ( (Round - yzbj_round)<0 or (Round - yzbj_round)>=v.round+1 ) then
                                                    Char.SetTempData(defCharIndex, '影子标记层数', 0);      --标记层数初始化
                                                    Char.SetData(defCharIndex, CONST.对象_ENEMY_HeadGraNo,0);
                                                    Char.SetData(defCharIndex, CONST.对象_NPC_HeadGraNo,0);
                                                    Char.SetData(defCharIndex, CONST.对象_PET_HeadGraNo,0);
                                                    NLG.UpChar(defCharIndex)
                                             end
                                             local yzbj_layer = Char.GetTempData(defCharIndex, '影子标记层数') or 0
                                             if (yzbj_layer>=1) then
                                                    local agi = Char.GetData(charIndex, CONST.CHAR_敏捷);
                                                    local SAD = v.layer * v.ratio * agi;                         --影子偷袭附加伤害
                                                    damage = damage+SAD;
                                                    NLG.Say(charIndex,-1,"影子偷襲暴擊".. SAD .."！",4,3);
                                             else
                                                    Char.SetTempData(defCharIndex, '影子标记层数', v.layer);
                                                    Char.SetTempData(defCharIndex, '影子标记回合', Round);
                                                    Char.SetData(defCharIndex, CONST.对象_ENEMY_HeadGraNo,111121);
                                                    Char.SetData(defCharIndex, CONST.对象_NPC_HeadGraNo,111121);
                                                    Char.SetData(defCharIndex, CONST.对象_PET_HeadGraNo,111121);
                                                    NLG.Say(charIndex,-1,"影子標記".. v.layer .."層".. v.round .."回合，下回合起算第1回合",4,3);
                                             end
                                      end
                               end
                        end
                        if ( ShieldIndex>0 and Item.GetData(ShieldIndex, CONST.道具_类型) == 7) then
                               for k, v in ipairs(signAbsorb) do
                                      local min_w = Item.GetData(ShieldIndex, CONST.道具_最小攻击数量);
                                      local max_w = Item.GetData(ShieldIndex, CONST.道具_最大攻击数量);
                                      if (v.type == Absorb and min_w==v.min and max_w==v.max ) then
                                             local ysbj_value = Char.GetTempData(charIndex, '集伤标记转换') or 0
                                             if (ysbj_value>=1 and com1==4) then
                                                    damage = damage+ysbj_value;
                                                    Char.SetTempData(charIndex, '集伤标记转换', 0);
                                                    NLG.UpChar(charIndex)
                                                    NLG.Say(charIndex,-1,"集氣傷害".. ysbj_value .."進行全反擊",4,3);
                                             end
                                      end
                               end
                        end
                 end
                 --print(damage)
                 return damage;
               end
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               local Armour0 = Char.GetItemIndex(defCharIndex, 0);                  --头
               if (Armour0>0) then Armour0_Name = Item.GetData(Armour0, CONST.道具_名字); end
               local Armour1 = Char.GetItemIndex(defCharIndex, 1);                  --身
               if (Armour1>0) then Armour1_Name = Item.GetData(Armour1, CONST.道具_名字); end
               local Armour4 = Char.GetItemIndex(defCharIndex, 4);                  --腿
               if (Armour4>0) then Armour4_Name = Item.GetData(Armour4, CONST.道具_名字); end
               local StrAdd_0 = 0;
               local StrAdd_1 = 0;
               local StrAdd_4 = 0;
               local ShieldIndex = Char.GetShield(defCharIndex);                         --详情底部Fn
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
                 if NLG.Rand(1,10)>=1 and ShieldIndex>0  then
                        if ( Item.GetData(ShieldIndex, CONST.道具_类型) == 7) then
                               for k, v in ipairs(signAbsorb) do
                                      local Round = Battle.GetTurn(battleIndex);
                                      local min_w = Item.GetData(ShieldIndex, CONST.道具_最小攻击数量);
                                      local max_w = Item.GetData(ShieldIndex, CONST.道具_最大攻击数量);
                                      if (v.type == Absorb and min_w==v.min and max_w==v.max ) then
                                             local ysbj_value = Char.GetTempData(defCharIndex, '集伤标记转换') or 0
                                             local Absorb = ysbj_value + damage;
                                             if (v.bruise>=Absorb) then
                                                    Char.SetTempData(defCharIndex, '集伤标记转换', Absorb);
                                                    NLG.SetHeadIcon(defCharIndex, 111247);
                                                    NLG.Say(defCharIndex,-1,"集傷標記目前累積".. Absorb .."/".. v.bruise .."全反擊傷害",4,3);
                                             else
                                                    Char.SetTempData(defCharIndex, '集伤标记转换', v.bruise);
                                                    NLG.SetHeadIcon(defCharIndex, 111247);
                                                    NLG.Say(defCharIndex,-1,"集傷標記目前累積".. Absorb .."/".. v.bruise .."全反擊傷害",4,3);
                                             end
                                      end
                               end
                        end
                        damage = damage * StrEffect;
                        --NLG.Say(defCharIndex,-1,"防具附加強化特殊效果每+1傷害減少1%，目前減傷"..(StrAdd*1).."%",4,3);
                 end
                 --print(damage)
                 return damage;
               end
         else
         end
  return damage;
end


function StrAddEffect:OnTechOptionEventCallBack(charIndex, option, techID, val)         
         --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
      if Char.IsPlayer(charIndex) then
         local battleIndex = Char.GetBattleIndex(charIndex)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
               local ViceWeaponIndex = Char.GetViceWeapon(charIndex);                --左右手
               if (ViceWeaponIndex>0) then ViceWeapon_Name = Item.GetData(ViceWeaponIndex, CONST.道具_名字); end
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
    { type=65},{ type=66},{ type=67},{ type=68},{ type=69},{ type=70},
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
