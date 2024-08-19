---模块类
local Module = ModuleBase:createModule('petEmpower')

local EmpowerKind_check= {600018,600019,600020,600021,600022,600023,600028,600029,600030,600070,600071,600072};				--enemy编号
local EmpowerKind_list = {};
EmpowerKind_list[600018] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};		--itemID
EmpowerKind_list[600019] = {69081};
EmpowerKind_list[600020] = {69081};
EmpowerKind_list[600021] = {69081};
EmpowerKind_list[600022] = {69081};
EmpowerKind_list[600023] = {69081};
EmpowerKind_list[600028] = {69081};
EmpowerKind_list[600029] = {69081};
EmpowerKind_list[600030] = {69081};
EmpowerKind_list[600070] = {69081};
EmpowerKind_list[600071] = {69081};
EmpowerKind_list[600072] = {69081};

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleCalcDexEvent', Func.bind(self.OnBattleCalcDexEvent, self));
  --self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self));
  --self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self));
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
             print(PetId,ItemID)
             if (ItemID==EmpowerKind_list[PetId][1] and CheckInTable(EmpowerKind_check,PetId)==true) then
                 local test = EmpowerKind_list[PetId][2];
                 print(test)
             end
         end
      return dex;
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
                   if (ItemID==69081) then
                     local defHp = Char.GetData(defCharIndex,CONST.CHAR_血);
                     local defHpM = Char.GetData(defCharIndex,CONST.CHAR_最大血);
                     local Hp00 = math.floor(defHp/defHpM) * 100;
                     if (damage>=defHp-1) then
                           if (NLG.Rand(1,100)<=Hp00) then
                               Char.SetData(defCharIndex, CONST.CHAR_血, defHp+damage*0.1);
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

                 end
             end
           return damage;
         ---宠物为魔法受攻方事件
         elseif Char.IsPet(defCharIndex) and flg == CONST.DamageFlags.Magic  then

           return damage;
         ---宠物为攻击方事件
         elseif Char.IsPet(charIndex) and flg ~= CONST.DamageFlags.Magic  then
           --宠物特技
           if (com3 == 9509)  then    --疾風迅雷
               local State = Char.GetTempData(defCharIndex, '穿透') or 0;
               print(State)
               if (State>=0 and State<=12) then
                   Char.SetTempData(defCharIndex, '穿透', State+1);
                   damage = damage * ((State+1)/12);
                   return damage;
               elseif (State>=13)  then
                   Char.SetTempData(defCharIndex, '穿透', 0);
                   damage = damage * 1;
                   return damage;
               end
           end
           return damage;
         ---宠物为魔法方事件
         elseif Char.IsPet(charIndex) and flg == CONST.DamageFlags.Magic  then

           --宠物特技
           if (com3 == 2729) then    --千鈞石箭-SE
               if NLG.Rand(1,10)>=8  then
                   Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 2);
                   NLG.UpChar(defCharIndex);
               end
           end
           return damage;

         end
  return damage;
end

function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         if (com3==6339)  then    --君主領域(固定量超補附加恢復魔法補量固定增益)
               local restore = Char.GetData(charIndex,CONST.CHAR_回复);
               local defRestore = Char.GetData(defCharIndex,CONST.CHAR_回复);
             --print(restore,defRestore)
               if (defRestore < restore) then
                 heal = heal+restore;
               else
                 heal = heal;
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