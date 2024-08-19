---ģ����
local Module = ModuleBase:createModule('petEmpower')

local EmpowerKind_check= {600018,600019,600020,600021,600022,600023,600028,600029,600030,600070,600071,600072};				--enemy���
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

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleCalcDexEvent', Func.bind(self.OnBattleCalcDexEvent, self));
  --self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self));
  --self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self));
end

--���и���Ч��
function Module:OnBattleCalcDexEvent(battleIndex, charIndex, action, flg, dex)
      --self:logDebug('OnBattleCalcDexEvent', battleIndex, charIndex, action, flg, dex)
         if Char.IsPet(charIndex)  then
             local PetId = Char.GetData(charIndex,CONST.PET_PetID);
             --������
             local PetAmuletIndex = Pet.GetAmulet(charIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.����_ID);
             print(PetId,ItemID)
             if (ItemID==EmpowerKind_list[PetId][1] and CheckInTable(EmpowerKind_check,PetId)==true) then
                 local test = EmpowerKind_list[PetId][2];
                 print(test)
             end
         end
      return dex;
end

--���и���Ч��
function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         ---����Ϊ�����ܹ����¼�
         if Char.IsPet(defCharIndex) and flg ~= CONST.DamageFlags.Magic  then
             local PetId = Char.GetData(defCharIndex,CONST.PET_PetID);
             --������
             local PetAmuletIndex = Pet.GetAmulet(defCharIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.����_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   if (ItemID==69081) then
                     local defHp = Char.GetData(defCharIndex,CONST.CHAR_Ѫ);
                     local defHpM = Char.GetData(defCharIndex,CONST.CHAR_���Ѫ);
                     local Hp00 = math.floor(defHp/defHpM) * 100;
                     if (damage>=defHp-1) then
                           if (NLG.Rand(1,100)<=Hp00) then
                               Char.SetData(defCharIndex, CONST.CHAR_Ѫ, defHp+damage*0.1);
                               Char.SetData(defCharIndex, CONST.CHAR_����, 0);
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
         ---����Ϊħ���ܹ����¼�
         elseif Char.IsPet(defCharIndex) and flg == CONST.DamageFlags.Magic  then

           return damage;
         ---����Ϊ�������¼�
         elseif Char.IsPet(charIndex) and flg ~= CONST.DamageFlags.Magic  then
           --�����ؼ�
           if (com3 == 9509)  then    --���LѸ��
               local State = Char.GetTempData(defCharIndex, '��͸') or 0;
               print(State)
               if (State>=0 and State<=12) then
                   Char.SetTempData(defCharIndex, '��͸', State+1);
                   damage = damage * ((State+1)/12);
                   return damage;
               elseif (State>=13)  then
                   Char.SetTempData(defCharIndex, '��͸', 0);
                   damage = damage * 1;
                   return damage;
               end
           end
           return damage;
         ---����Ϊħ�����¼�
         elseif Char.IsPet(charIndex) and flg == CONST.DamageFlags.Magic  then

           --�����ؼ�
           if (com3 == 2729) then    --ǧ�xʯ��-SE
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
         if (com3==6339)  then    --�����I��(�̶������a���ӻ֏�ħ���a���̶�����)
               local restore = Char.GetData(charIndex,CONST.CHAR_�ظ�);
               local defRestore = Char.GetData(defCharIndex,CONST.CHAR_�ظ�);
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

--��ȡ����װ��-����
Pet.GetAmulet = function(petIndex)
  local ItemIndex = Char.GetItemIndex(petIndex, CONST.�����_��Ʒ1);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.����_����)==CONST.��������_���ﻤ�� then
    return ItemIndex,CONST.�����_��Ʒ1;
  end
  ItemIndex = Char.GetItemIndex(petIndex, CONST.�����_��Ʒ2);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.����_����)==CONST.��������_���ﻤ�� then
    return ItemIndex,CONST.�����_��Ʒ2;
  end
  return -1,-1;
end

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;