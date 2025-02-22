---ģ����
local Module = ModuleBase:createModule('petEmpower')

local clearType = {
    { type=CONST.CHAR_BattleDamageAbsrob, name="��������" },
    { type=CONST.CHAR_BattleDamageReflec, name="��������" },
    { type=CONST.CHAR_BattleDamageVanish, name="�����oЧ" },
    { type=CONST.CHAR_BattleDamageMagicAbsrob, name="ħ������" },
    { type=CONST.CHAR_BattleDamageMagicReflec, name="ħ������" },
    { type=CONST.CHAR_BattleDamageMagicVanish, name="ħ���oЧ" },
    { type=CONST.CHAR_BattleLpRecovery, name="�֏�ħ��" },
  }

local EmpowerKind_check= {700101,700102,700103,700104,700105,700106,700107,700108,700109,700110,
                          700111,700112,700113,700114,700115,700116,700117,700118,700119,700120,
                          700121,700122,700123,700124,700125,700126,700127,700128,700129,700130,
                          700131,700132,700133,
                          700201,700202,700203,700204,700205,700206,700207,700208,
                          700211,700212,700213,700214,700215,700216,700217,700218,700219,700220,
};	--enemy���
local EmpowerKind_list = {};
EmpowerKind_list[700101] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};			--itemID
EmpowerKind_list[700102] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700103] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700104] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700105] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700106] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700107] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700108] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700109] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700110] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700111] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700112] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700113] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700114] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700115] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700116] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700117] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700118] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700119] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700120] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700121] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700122] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700123] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700124] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700125] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700126] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700127] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700128] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700129] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700130] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700131] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700132] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700133] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};

EmpowerKind_list[700201] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700202] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700203] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700204] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700205] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700206] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700207] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700208] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};

EmpowerKind_list[700211] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700212] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700213] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700214] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700215] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700216] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700217] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700218] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700219] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};
EmpowerKind_list[700220] = {69081, 69082, 69083, 69084, 69085, 69086, 69087, 69088, 69089, 69090};


--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleCalcDexEvent', Func.bind(self.OnBattleCalcDexEvent, self));
  --self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self));
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self));
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
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --����֮צ
                   if (ItemID==69088) then
                     local dex = 3000;
                     return dex;
                   end
                   --��֮β
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

--���и���Ч��
function Module:OnAfterBattleTurnCommand(battleIndex)
     for i = 0, 19 do
         local PetIndex = Battle.GetPlayer(battleIndex, i);
         if PetIndex>=0 and Char.IsPet(PetIndex) then
             local PetId = Char.GetData(PetIndex,CONST.PET_PetID);
             --������
             local PetAmuletIndex = Pet.GetAmulet(PetIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.����_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --ͻ������
                   if (ItemID==69083) then
                     local defHp = Char.GetData(PetIndex,CONST.CHAR_Ѫ);
                     local defHpM = Char.GetData(PetIndex,CONST.CHAR_���Ѫ);
                     local Hp00 =defHp/defHpM;
                     print(defHp,defHpM,Hp00)
                     if (Hp00<=0.5 and defHp<=defHpM) then
                         Char.SetData(PetIndex, CONST.CHAR_Ѫ, defHp+(defHpM*0.1) );
                         NLG.UpChar(PetIndex);
                     end
                   end
                 end
             end
         end
     end
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
                   --����ͷ��
                   if (ItemID==69081) then
                     local defHp = Char.GetData(defCharIndex,CONST.CHAR_Ѫ);
                     local defHpM = Char.GetData(defCharIndex,CONST.CHAR_���Ѫ);
                     local Hp00 = math.floor(defHp/defHpM) * 100;
                     if (damage>=defHp-1) then
                           if (NLG.Rand(1,100)<=Hp00) then
                               Char.SetData(defCharIndex, CONST.CHAR_Ѫ, defHp+math.floor(damage*0.1));
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
                   --͹͹ͷ��
                   if (ItemID==69082) then
                     local defDefense = Char.GetData(defCharIndex,CONST.CHAR_������);
                     local reHit = math.floor(defDefense*0.01);
                     local enemyHp = Char.GetData(charIndex,CONST.CHAR_Ѫ);
                     if (enemyHp>=reHit-1) then
                         Char.SetData(charIndex, CONST.CHAR_Ѫ,  enemyHp-reHit);
                         NLG.UpChar(charIndex);
                     else
                         Char.SetData(charIndex, CONST.CHAR_Ѫ,  1);
                         NLG.UpChar(charIndex);
                     end
                     return damage;
                   end
                   --���㱣��
                   if (ItemID==69087) then
                        local State = Char.GetTempData(defCharIndex, '���㱣��') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '���㱣��', State+1);
                        end
                        return damage;
                   end
                 end
             end
           return damage;
         ---����Ϊħ���ܹ����¼�
         elseif Char.IsPet(defCharIndex) and flg == CONST.DamageFlags.Magic  then
             local PetId = Char.GetData(defCharIndex,CONST.PET_PetID);
             --������
             local PetAmuletIndex = Pet.GetAmulet(defCharIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.����_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --����ͷ��
                   if (ItemID==69081) then
                     local defHp = Char.GetData(defCharIndex,CONST.CHAR_Ѫ);
                     local defHpM = Char.GetData(defCharIndex,CONST.CHAR_���Ѫ);
                     local Hp00 = math.floor(defHp/defHpM) * 100;
                     if (damage>=defHp-1) then
                           if (NLG.Rand(1,100)<=Hp00) then
                               Char.SetData(defCharIndex, CONST.CHAR_Ѫ, defHp+math.floor(damage*0.1));
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
                   --͹͹ͷ��
                   if (ItemID==69082) then
                     local defDefense = Char.GetData(defCharIndex,CONST.CHAR_������);
                     local reHit = math.floor(defDefense*0.01);
                     local enemyHp = Char.GetData(charIndex,CONST.CHAR_Ѫ);
                     if (enemyHp>=reHit-1) then
                         Char.SetData(charIndex, CONST.CHAR_Ѫ,  enemyHp-reHit);
                         NLG.UpChar(charIndex);
                     else
                         Char.SetData(charIndex, CONST.CHAR_Ѫ,  1);
                         NLG.UpChar(charIndex);
                     end
                     return damage;
                   end
                   --���㱣��
                   if (ItemID==69087) then
                        local State = Char.GetTempData(defCharIndex, '���㱣��') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '���㱣��', State+1);
                        end
                        return damage;
                   end

                 end
             end
           return damage;
         ---����Ϊ�������¼�
         elseif Char.IsPet(charIndex) and flg ~= CONST.DamageFlags.Magic  then
             local PetId = Char.GetData(charIndex,CONST.PET_PetID);
             --������
             local PetAmuletIndex = Pet.GetAmulet(charIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.����_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --���㱣��
                   if (ItemID==69087) then
                        local State = Char.GetTempData(charIndex, '���㱣��') or 0;
                        if (State>=0) then
                            damage = damage * (1+((5+State)/100));
                            return damage;
                        end
                        return damage;
                   end
                   --����ͷ��
                   if (ItemID==69084) then
                        local State = Char.GetTempData(defCharIndex, '����ͷ��') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '����ͷ��', State+1);
                            damage = damage * (1+((5+State)/100));
                            return damage;
                        end
                        return damage;
                   end
                   --����֮צ
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
                   --����֮��
                   if (ItemID==69090) then
                     local heal = math.floor(damage*0.01);
                     local defHp = Char.GetData(charIndex,CONST.CHAR_Ѫ);
                     local defHpM = Char.GetData(charIndex,CONST.CHAR_���Ѫ);
                     if (defHp+heal<=defHpM) then
                         Char.SetData(charIndex, CONST.CHAR_Ѫ, defHp+heal);
                         NLG.UpChar(charIndex);
                     else
                         Char.SetData(charIndex, CONST.CHAR_Ѫ, defHpM);
                         NLG.UpChar(charIndex);
                     end
                     return damage;
                   end

                 end
             end
           return damage;
         ---����Ϊħ�����¼�
         elseif Char.IsPet(charIndex) and flg == CONST.DamageFlags.Magic  then
             local PetId = Char.GetData(charIndex,CONST.PET_PetID);
             --������
             local PetAmuletIndex = Pet.GetAmulet(charIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.����_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --���㱣��
                   if (ItemID==69087) then
                        local State = Char.GetTempData(charIndex, '���㱣��') or 0;
                        if (State>=0) then
                            damage = damage * (1+((3+State)/100));
                            return damage;
                        end
                        return damage;
                   end
                   --����ͷ��
                   if (ItemID==69084) then
                        local State = Char.GetTempData(defCharIndex, '����ͷ��') or 0;
                        if (State>=0) then
                            Char.SetTempData(defCharIndex, '����ͷ��', State+1);
                            damage = damage * (1+((5+State)/100));
                            return damage;
                        end
                        return damage;
                   end
                   --����֮צ
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
                   --����֮��
                   if (ItemID==69090) then
                     local heal = math.floor(damage*0.01);
                     local defHp = Char.GetData(charIndex,CONST.CHAR_Ѫ);
                     local defHpM = Char.GetData(charIndex,CONST.CHAR_���Ѫ);
                     if (defHp+heal<=defHpM) then
                         Char.SetData(charIndex, CONST.CHAR_Ѫ, defHp+heal);
                         NLG.UpChar(charIndex);
                     else
                         Char.SetData(charIndex, CONST.CHAR_Ѫ, defHpM);
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

--���и���Ч��
function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         if Char.IsPet(charIndex)  then
             local PetId = Char.GetData(charIndex,CONST.PET_PetID);
             --������
             local PetAmuletIndex = Pet.GetAmulet(charIndex);
             local ItemID = Item.GetData(PetAmuletIndex, CONST.����_ID);
             --print(PetId,ItemID)
             if (CheckInTable(EmpowerKind_check,PetId)==true) then
                 if (CheckInTable(EmpowerKind_list[PetId],ItemID)==true) then
                   --��ʶ�۾�
                   if (ItemID==69086) then
                        local restore = Char.GetData(charIndex,CONST.CHAR_�ظ�);
                        local defRestore = Char.GetData(defCharIndex,CONST.CHAR_�ظ�);
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