---模块类
local Module = ModuleBase:createModule('petEmpower')

local clearType = {
    { type=CONST.CHAR_BattleDamageAbsrob, name="攻擊吸收" },
    { type=CONST.CHAR_BattleDamageReflec, name="攻擊反彈" },
    { type=CONST.CHAR_BattleDamageVanish, name="攻擊無效" },
    { type=CONST.CHAR_BattleDamageMagicAbsrob, name="魔法吸收" },
    { type=CONST.CHAR_BattleDamageMagicReflec, name="魔法反彈" },
    { type=CONST.CHAR_BattleDamageMagicVanish, name="魔法無效" },
    { type=CONST.CHAR_BattleLpRecovery, name="恢復魔法" },
  }

local EmpowerKind_check= {600018,600019,600020,600021,600022,600023,600028,600029,600030,600067,600068,600070,600071,600072,600073,600074,600075,600076,600077,600078,600079,600080,600081};	--enemy编号
local EmpowerKind_list = {};
EmpowerKind_list[600018] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};			--itemID
EmpowerKind_list[600019] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600020] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600021] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600022] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600023] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600028] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600029] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600030] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600067] = {69081, 69084, 69086};
EmpowerKind_list[600068] = {69081, 69084, 69086};
EmpowerKind_list[600070] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600071] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600072] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[600073] = {69081, 69087, 69090};
EmpowerKind_list[600074] = {69083};
EmpowerKind_list[600075] = {69088, 69089};
EmpowerKind_list[600076] = {69081};
EmpowerKind_list[600077] = {69087};
EmpowerKind_list[600078] = {69084, 69086};
EmpowerKind_list[600079] = {69082};
EmpowerKind_list[600080] = {69090};
EmpowerKind_list[600081] = {69085};

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleCalcDexEvent', Func.bind(self.OnBattleCalcDexEvent, self));
  --self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self));
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self));
end

--持有赋能效果
function Module:OnBattleCalcDexEvent(battleIndex, charIndex, action, flg, dex)
      --self:logDebug('OnBattleCalcDexEvent', battleIndex, charIndex, action, flg, dex)
         if Char.IsPet(charIndex)  then
             local PetId = Char.GetData(charIndex,CONST.PET_PetID);
             --持有物
             local PetAmuletIndex = Pet.GetAmulet(charIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.道具_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --先制之爪
                   if (ItemID==69088) then
                     local dex = 3000;
                     return dex;
                   end
                   --后攻之尾
                   if (ItemID==69089) then
                     local dex = 300;
                     return dex;
                   end
                 end
             end
             return dex;
         end
  return dex;
end

--持有赋能效果
function Module:OnAfterBattleTurnCommand(battleIndex)
     for i = 0, 19 do
         local PetIndex = Battle.GetPlayer(battleIndex, i);
         if PetIndex>=0 and Char.IsPet(PetIndex) then
             local PetId = Char.GetData(PetIndex,CONST.PET_PetID);
             --持有物
             local PetAmuletIndex = Pet.GetAmulet(PetIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.道具_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --突击背心
                   if (ItemID==69083) then
                     local defHp = Char.GetData(PetIndex,CONST.CHAR_血);
                     local defHpM = Char.GetData(PetIndex,CONST.CHAR_最大血);
                     local Hp00 =defHp/defHpM;
                     print(defHp,defHpM,Hp00)
                     if (Hp00<=0.5 and defHp<=defHpM) then
                         Char.SetData(PetIndex, CONST.CHAR_血, defHp+(defHpM*0.1) );
                         NLG.UpChar(PetIndex);
                     end
                   end
                 end
             end
         end
     end
end

--持有赋能效果
function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         ---宠物为物理受攻方事件
         if Char.IsPet(defCharIndex) and flg ~= CONST.DamageFlags.Magic  then
             local PetId = Char.GetData(defCharIndex,CONST.PET_PetID);
             --持有物
             local PetAmuletIndex = Pet.GetAmulet(defCharIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.道具_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --气势头带
                   if (ItemID==69081) then
                     local defHp = Char.GetData(defCharIndex,CONST.CHAR_血);
                     local defHpM = Char.GetData(defCharIndex,CONST.CHAR_最大血);
                     local Hp00 = math.floor(defHp/defHpM) * 100;
                     if (damage>=defHp-1) then
                           if (NLG.Rand(1,100)<=Hp00) then
                               Char.SetData(defCharIndex, CONST.CHAR_血, defHp+math.floor(damage*0.1));
                               Char.SetData(defCharIndex, CONST.CHAR_受伤, 0);
                               NLG.UpChar(defCharIndex);
                               damage = damage*0;
                           else
                               damage = damage;
                           end
                     else
                           damage = damage;
                     end
                     return damage;
                   end
                   --凸凸头盔
                   if (ItemID==69082) then
                     local defDefense = Char.GetData(defCharIndex,CONST.CHAR_防御力);
                     local reHit = math.floor(defDefense*0.01);
                     local enemyHp = Char.GetData(charIndex,CONST.CHAR_血);
                     if (enemyHp>=reHit-1) then
                         Char.SetData(charIndex, CONST.CHAR_血,  enemyHp-reHit);
                         NLG.UpChar(charIndex);
                     else
                         Char.SetData(charIndex, CONST.CHAR_血,  1);
                         NLG.UpChar(charIndex);
                     end
                     return damage;
                   end
                   --弱点保险
                   if (ItemID==69087) then
                        local State = Char.GetTempData(defCharIndex, '弱点保险') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '弱点保险', State+1);
                        end
                        return damage;
                   end
                 end
             end
           return damage;
         ---宠物为魔法受攻方事件
         elseif Char.IsPet(defCharIndex) and flg == CONST.DamageFlags.Magic  then
             local PetId = Char.GetData(defCharIndex,CONST.PET_PetID);
             --持有物
             local PetAmuletIndex = Pet.GetAmulet(defCharIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.道具_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --气势头带
                   if (ItemID==69081) then
                     local defHp = Char.GetData(defCharIndex,CONST.CHAR_血);
                     local defHpM = Char.GetData(defCharIndex,CONST.CHAR_最大血);
                     local Hp00 = math.floor(defHp/defHpM) * 100;
                     if (damage>=defHp-1) then
                           if (NLG.Rand(1,100)<=Hp00) then
                               Char.SetData(defCharIndex, CONST.CHAR_血, defHp+math.floor(damage*0.1));
                               Char.SetData(defCharIndex, CONST.CHAR_受伤, 0);
                               NLG.UpChar(defCharIndex);
                               damage = damage*0;
                           else
                               damage = damage;
                           end
                     else
                           damage = damage;
                     end
                     return damage;
                   end
                   --凸凸头盔
                   if (ItemID==69082) then
                     local defDefense = Char.GetData(defCharIndex,CONST.CHAR_防御力);
                     local reHit = math.floor(defDefense*0.01);
                     local enemyHp = Char.GetData(charIndex,CONST.CHAR_血);
                     if (enemyHp>=reHit-1) then
                         Char.SetData(charIndex, CONST.CHAR_血,  enemyHp-reHit);
                         NLG.UpChar(charIndex);
                     else
                         Char.SetData(charIndex, CONST.CHAR_血,  1);
                         NLG.UpChar(charIndex);
                     end
                     return damage;
                   end
                   --弱点保险
                   if (ItemID==69087) then
                        local State = Char.GetTempData(defCharIndex, '弱点保险') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '弱点保险', State+1);
                        end
                        return damage;
                   end

                 end
             end
           return damage;
         ---宠物为攻击方事件
         elseif Char.IsPet(charIndex) and flg ~= CONST.DamageFlags.Magic  then
             local PetId = Char.GetData(charIndex,CONST.PET_PetID);
             --持有物
             local PetAmuletIndex = Pet.GetAmulet(charIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.道具_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --弱点保险
                   if (ItemID==69087) then
                        local State = Char.GetTempData(charIndex, '弱点保险') or 0;
                        if (State>=0) then
                            damage = damage * (1+((5+State)/100));
                            return damage;
                        end
                        return damage;
                   end
                   --力量头带
                   if (ItemID==69084) then
                        local State = Char.GetTempData(defCharIndex, '力量头带') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '力量头带', State+1);
                            damage = damage * (1+((5+State)/100));
                            return damage;
                        end
                        return damage;
                   end
                   --锐利之爪
                   if (ItemID==69085) then
                     for k, v in ipairs(clearType) do
                        local sorcery = Char.GetData(defCharIndex, v.type);
                        if sorcery>=1 then
                               Char.SetData(defCharIndex, v.type, 0);
                               damage = damage*0;
                        else
                               damage = damage;
                        end
                     end
                     return damage;
                   end
                   --贝壳之铃
                   if (ItemID==69090) then
                     local heal = math.floor(damage*0.01);
                     local defHp = Char.GetData(charIndex,CONST.CHAR_血);
                     local defHpM = Char.GetData(charIndex,CONST.CHAR_最大血);
                     if (defHp+heal<=defHpM) then
                         Char.SetData(charIndex, CONST.CHAR_血, defHp+heal);
                         NLG.UpChar(charIndex);
                     else
                         Char.SetData(charIndex, CONST.CHAR_血, defHpM);
                         NLG.UpChar(charIndex);
                     end
                     return damage;
                   end

                 end
             end
           return damage;
         ---宠物为魔法方事件
         elseif Char.IsPet(charIndex) and flg == CONST.DamageFlags.Magic  then
             local PetId = Char.GetData(charIndex,CONST.PET_PetID);
             --持有物
             local PetAmuletIndex = Pet.GetAmulet(charIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.道具_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --弱点保险
                   if (ItemID==69087) then
                        local State = Char.GetTempData(charIndex, '弱点保险') or 0;
                        if (State>=0) then
                            damage = damage * (1+((3+State)/100));
                            return damage;
                        end
                        return damage;
                   end
                   --力量头带
                   if (ItemID==69084) then
                        local State = Char.GetTempData(defCharIndex, '力量头带') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '力量头带', State+1);
                            damage = damage * (1+((5+State)/100));
                            return damage;
                        end
                        return damage;
                   end
                   --锐利之爪
                   if (ItemID==69085) then
                     for k, v in ipairs(clearType) do
                        local sorcery = Char.GetData(defCharIndex, v.type);
                        if sorcery>=1 then
                               Char.SetData(defCharIndex, v.type, 0);
                               damage = damage*0;
                        else
                               damage = damage;
                        end
                     end
                     return damage;
                   end
                   --贝壳之铃
                   if (ItemID==69090) then
                     local heal = math.floor(damage*0.01);
                     local defHp = Char.GetData(charIndex,CONST.CHAR_血);
                     local defHpM = Char.GetData(charIndex,CONST.CHAR_最大血);
                     if (defHp+heal<=defHpM) then
                         Char.SetData(charIndex, CONST.CHAR_血, defHp+heal);
                         NLG.UpChar(charIndex);
                     else
                         Char.SetData(charIndex, CONST.CHAR_血, defHpM);
                         NLG.UpChar(charIndex);
                     end
                     return damage;
                   end

                 end
             end
           return damage;
         end
  return damage;
end

--持有赋能效果
function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         if Char.IsPet(charIndex)  then
             local PetId = Char.GetData(charIndex,CONST.PET_PetID);
             --持有物
             local PetAmuletIndex = Pet.GetAmulet(charIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.道具_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --博识眼镜
                   if (ItemID==69086) then
                        local restore = Char.GetData(charIndex,CONST.CHAR_回复);
                        local defRestore = Char.GetData(defCharIndex,CONST.CHAR_回复);
                        if (defRestore < restore) then
                            heal = heal+(restore*0.01);
                            return damage;
                        else
                            heal = heal;
                        end
                        return damage;
                   end

                 end
             end
           return heal;
         end
  return heal;
end

--获取宠物装备-护符
Pet.GetAmulet = function(petIndex)
  local ItemIndex = Char.GetItemIndex(petIndex, CONST.宠道栏_饰品1);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.道具类型_宠物护符 then
    return ItemIndex,CONST.宠道栏_饰品1;
  end
  ItemIndex = Char.GetItemIndex(petIndex, CONST.宠道栏_饰品2);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.道具类型_宠物护符 then
    return ItemIndex,CONST.宠道栏_饰品2;
  end
  return -1,-1;
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
