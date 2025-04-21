local Module = ModuleBase:createModule('detectiveCards')

local cardItemId = 74042;
-----------------------------------------------------------------
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleActionEvent', Func.bind(self.onBattleActionEvent, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self));
  --self:regCallback('BattleOverEvent', Func.bind(self.onBattleOver, self));
  self:regCallback('BattleExitEvent', Func.bind(self.onBattleExit, self));
  self:regCallback('CalcFpConsumeEvent', Func.bind(self.onCalcFpConsumeEvent, self));
  self:regCallback('BattleCalcDexEvent', Func.bind(self.OnBattleCalcDexEvent, self));
  self:regCallback('BattleDodgeRateEvent', Func.bind(self.OnBattleDodgeRateEvent, self));
  Item.CreateNewItemType( 63, "���ܿ���", 26409, -1, 0);

end


function Module:onBattleActionEvent(charIndex, Com1, Com2, Com3, ActionNum)
  --self:logDebug('onBattleActionEventCallBack', charIndex, Com1, Com2, Com3, ActionNum)
  local battleIndex = Char.GetBattleIndex(charIndex);
  local charside = 1;
  local ybside = Char.GetData(charIndex, CONST.����_ս��Side);
  if ybside == 1 then
    charside = 2;
  end
  if (Com1==9 and Char.GetData(charIndex, CONST.����_ս��)>-1 and Char.IsPlayer(charIndex)==true) then
    if (ActionNum==1) then
      local ItemSlot = Com3;
      local ItemIndex = Char.GetItemIndex(charIndex,ItemSlot);
      local ItemID = Item.GetData(ItemIndex, CONST.����_ID);
      if (Item.GetData(ItemIndex, CONST.����_����)==63) then
        if (battleIndex==-1) then
          NLG.SystemMessage(charIndex,"[������ʾ]���Y�в���ʹ�õĵ���");
        else
          local com1 = Item.GetData(ItemIndex,CONST.����_��������)-1000;
          if (Item.GetData(ItemIndex,CONST.����_�Ӳ�һ)>=20 and Item.GetData(ItemIndex,CONST.����_�Ӳ�һ)<=29) then
            com2 = Com2+20;
          elseif (Item.GetData(ItemIndex,CONST.����_�Ӳ�һ)==40) then
            com2 = 41;
          else
            com2 = Com2;
          end
          local com3 = Item.GetData(ItemIndex,CONST.����_�Ӳζ�);
          if (com3>=0 and com3<=60) then
            Char.SetTempData(charIndex, 'ContiAttack', 0);
          elseif (com3>=9500 and com3<=9551) then
            Char.SetTempData(charIndex, 'RandomShot', 0);
          elseif (com3>=6100 and com3<=6609) then
            if (Item.GetData(ItemIndex,CONST.����_�Ӳ�һ)>=10 and Item.GetData(ItemIndex,CONST.����_�Ӳ�һ)<=19) then
              com2 = Com2+10;
            else
              com2 = Item.GetData(ItemIndex,CONST.����_�Ӳ�һ);
            end
            local Round = Battle.GetTurn(battleIndex);
            local HealMagicRoundOn = Char.GetTempData(charIndex, 'HealMagicRound') or -1;
            if (Round>=HealMagicRoundOn) then
              Char.SetTempData(charIndex, 'HealMagicRound', Round);
              NLG.UpChar(charIndex);
            end
          end
          Battle.ActionSelect(charIndex, com1, com2, com3);
          --Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_THROWITEM, Com2, 200209);
          Char.SetTempData(charIndex, 'Cards', 1);
          --Char.DelItem(charIndex,ItemID,1);
          Char.DelItemBySlot(charIndex, ItemSlot);
          local TechIndex = Tech.GetTechIndex(com3);
          local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
          NLG.Say(charIndex,charIndex,"���G�����ơ�ʹ��"..TechName.."����",4,3);
        end
      end
    end
  elseif (Com1==9 and Char.IsPlayer(charIndex)==true) then
    Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, Com2, -1);
    NLG.SystemMessage(charIndex,"[ϵͳ]ʹ�ÿ�����Ҫ�͌���һ�����");
  end

end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	if (Char.IsEnemy(charIndex) and Char.IsDummy(defCharIndex)==false) then
		if (Char.GetData(defCharIndex,CONST.����_ְ��ID)==2020) then	--��̽410
			if (Char.ItemSlot(defCharIndex)>=20) then
				--NLG.SystemMessage(defCharIndex,"[ϵ�y]��Ʒ��λ���ѝM��");
				return damage;
			end
			--print("���﹥��:",com1,com2,com3)
			if (com3==-1 or com3==7300) then
				--print("������ϓ�:",com1,com2,com3)
			elseif (com3>=0 and com3<=60) then		--����������Ϊ��õ���1��
				local ContiAttackOn = Char.GetTempData(defCharIndex, 'ContiAttack') or 0;
				if (ContiAttackOn==0) then
					--��������λ��
					local EmptySlot = Char.GetItemEmptySlot(defCharIndex);
					Char.GiveItem(defCharIndex, cardItemId, 1, false);
					local ItemIndex = Char.GetItemIndex(defCharIndex, EmptySlot);
					local Com1 = com1;
					local Com2 = com2;
					local Com3 = com3;
					local TechIndex = Tech.GetTechIndex(Com3);
					local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
					if (Item.GetData(ItemIndex,CONST.����_�Ӳζ�)==0) then
						Item.SetData(ItemIndex,CONST.����_����, "["..TechName.."]���ܿ���");
						Item.SetData(ItemIndex,CONST.����_��������, Com1+1000);
						Item.SetData(ItemIndex,CONST.����_�Ӳ�һ, Com2);
						Item.SetData(ItemIndex,CONST.����_�Ӳζ�, Com3);
						Item.UpItem(defCharIndex, EmptySlot);
						Char.SetTempData(defCharIndex, 'ContiAttack', 1);
						NLG.UpChar(defCharIndex);
					end
				end
			elseif (com3>=9500 and com3<=9551) then		--����������Ϊ��õ���1��
				local RandomShotOn = Char.GetTempData(defCharIndex, 'RandomShot') or 0;
				if (RandomShotOn==0) then
					--��������λ��
					local EmptySlot = Char.GetItemEmptySlot(defCharIndex);
					Char.GiveItem(defCharIndex, cardItemId, 1, false);
					local ItemIndex = Char.GetItemIndex(defCharIndex, EmptySlot);
					local Com1 = com1;
					local Com2 = com2;
					local Com3 = com3;
					local TechIndex = Tech.GetTechIndex(Com3);
					local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
					if (Item.GetData(ItemIndex,CONST.����_�Ӳζ�)==0) then
						Item.SetData(ItemIndex,CONST.����_����, "["..TechName.."]���ܿ���");
						Item.SetData(ItemIndex,CONST.����_��������, Com1+1000);
						Item.SetData(ItemIndex,CONST.����_�Ӳ�һ, Com2);
						Item.SetData(ItemIndex,CONST.����_�Ӳζ�, Com3);
						Item.UpItem(defCharIndex, EmptySlot);
						Char.SetTempData(defCharIndex, 'RandomShot', 1);
						NLG.UpChar(defCharIndex);
					end
				end
			else
				--��������λ��
				local EmptySlot = Char.GetItemEmptySlot(defCharIndex);
				Char.GiveItem(defCharIndex, cardItemId, 1, false);
				local ItemIndex = Char.GetItemIndex(defCharIndex, EmptySlot);
				local Com1 = com1;
				local Com2 = com2;
				local Com3 = com3;
				--print("����:",Com1,Com2,Com3)
				local TechIndex = Tech.GetTechIndex(Com3);
				local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
				if (Item.GetData(ItemIndex,CONST.����_�Ӳζ�)==0) then
					Item.SetData(ItemIndex,CONST.����_����, "["..TechName.."]���ܿ���");
					Item.SetData(ItemIndex,CONST.����_��������, Com1+1000);
					Item.SetData(ItemIndex,CONST.����_�Ӳ�һ, Com2);
					Item.SetData(ItemIndex,CONST.����_�Ӳζ�, Com3);
					Item.UpItem(defCharIndex, EmptySlot);
					NLG.UpChar(defCharIndex);
				end
			end
			local CardsDamage = Char.GetTempData(charIndex, 'CardsDamage') or 0;
			if (damage>CardsDamage) then
				Char.SetTempData(defCharIndex, 'CardsDamage', damage);
			end
		end
		return damage;
	elseif (Char.IsEnemy(defCharIndex) and Char.IsDummy(charIndex)==false) then
		if (Char.GetData(charIndex,CONST.����_ְ��ID)==2020) then	--��̽410
			local CardsDamage = Char.GetTempData(charIndex, 'CardsDamage') or 0;
			--print(CardsDamage)
			if (CardsDamage>0) then
				if (damage<CardsDamage) then
					Char.SetTempData(charIndex, 'CardsDamage', 0);
					Char.SetTempData(charIndex, 'Cards', 0);
					local damage = CardsDamage * NLG.Rand(90,110) / 100;
					return damage;
				else
					Char.SetTempData(charIndex, 'CardsDamage', 0);
					Char.SetTempData(charIndex, 'Cards', 0);
					return damage;
				end
			else
				local damage = damage;
				return damage;
			end
		end
	end
	return damage;
end

function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
	if (Char.IsPlayer(charIndex) and Char.IsDummy(defCharIndex)==false) then
		if (Char.GetData(defCharIndex,CONST.����_ְ��ID)==2020) then	--��̽410
			if (Char.ItemSlot(defCharIndex)>=20) then
				--NLG.SystemMessage(defCharIndex,"[ϵ�y]��Ʒ��λ���ѝM��");
				return heal;
			end
			local Round = Battle.GetTurn(battleIndex);
			local HealMagicOn = Char.GetTempData(defCharIndex, 'HealMagic') or 0;
			if (HealMagicOn==0) then	--������õ���Ϊ1��֮����
				--��������λ��
				local EmptySlot = Char.GetItemEmptySlot(defCharIndex);
				Char.GiveItem(defCharIndex, cardItemId, 1, false);
				local ItemIndex = Char.GetItemIndex(defCharIndex, EmptySlot);
				local Com1 = com1;
				local Com2 = com2;
				local Com3 = com3;
				--print("����:",Com1,Com2,Com3)
				local TechIndex = Tech.GetTechIndex(Com3);
				local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
				if (Item.GetData(ItemIndex,CONST.����_�Ӳζ�)==0) then
					Item.SetData(ItemIndex,CONST.����_����, "["..TechName.."]���ܿ���");
					Item.SetData(ItemIndex,CONST.����_��������, Com1+1000);
					Item.SetData(ItemIndex,CONST.����_�Ӳ�һ, Com2);
					Item.SetData(ItemIndex,CONST.����_�Ӳζ�, Com3);
					Item.SetData(ItemIndex,CONST.����_ʹ�÷�Χ, 93);
					Item.UpItem(defCharIndex, EmptySlot);
					Char.SetTempData(defCharIndex, 'HealMagic', 1);
					Char.SetTempData(defCharIndex, 'HealMagicRound', Round);
					NLG.UpChar(defCharIndex);
				end
			end
			local HealMagicRoundOn = Char.GetTempData(defCharIndex, 'HealMagicRound') or -1;
			if (Round>=HealMagicRoundOn+1) then
				Char.SetTempData(defCharIndex, 'HealMagic', 0);
				NLG.UpChar(defCharIndex);
			end
			Char.SetTempData(defCharIndex, 'Cards', 0);
		end
		return heal;
	end
	return heal;
end


--ս������������
function Module:onBattleOver(battleIndex)
	for i=0,9 do
		local player = Battle.GetPlayer(battleIndex,i)
		if (player>-1 and Char.HaveItem(player,cardItemId)>-1) then
			Char.DelItem(player, cardItemId, Char.ItemNum(player, cardItemId), false);
		end
		--Char.SetTempData(player, 'ContiAttack', 0);
		--Char.SetTempData(player, 'RandomShot', 0);
		--Char.SetTempData(player, 'HealMagic', 0);
	end
end
--�뿪ս������������
function Module:onBattleExit(player, battleIndex, type)
	if (player>-1 and Char.HaveItem(player,cardItemId)>-1) then
		Char.DelItem(player, cardItemId, Char.ItemNum(player, cardItemId), false);
	end
end

--���ƺ�ħ����
function Module:onCalcFpConsumeEvent(charIndex, techId, Fp)
	if (Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false) then
		local Cards = Char.GetTempData(charIndex, 'Cards') or 0;
		if (Cards == 1) then
			local TechIndex = Tech.GetTechIndex(techId);
			local originFP = Tech.GetData(TechIndex, CONST.TECH_FORCEPOINT);
			local Fp = math.ceil(originFP * 0.5);
			return Fp;
		end
		return Fp;
	end
	return Fp;
end
--��������
function Module:OnBattleCalcDexEvent(battleIndex, charIndex, action, flg, dex)
	--self:logDebug('OnBattleCalcDexEvent', battleIndex, charIndex, action, flg, dex)
	if (Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false) then
		local Cards = Char.GetTempData(charIndex, 'Cards') or 0;
		if (Cards == 1) then
			local dex = 3000;
			return dex;
		end
		return dex;
	end
	return dex;
end
--���Ʊ���
function Module:OnBattleDodgeRateEvent(battleIndex, aIndex, fIndex, rate)
	--self:logDebug('OnBattleDodgeRateCallBack', battleIndex, aIndex, fIndex, rate)
	local battleIndex = Char.GetBattleIndex(aIndex);
	if Char.IsPlayer(aIndex) and Char.IsEnemy(fIndex) then	--����
		local Cards = Char.GetTempData(aIndex, 'Cards') or 0;
		if (Cards == 1)  then
			--Char.SetTempData(aIndex, 'Cards', 0);
			rate = 0;
			return rate
		end
	else
	end
	return rate
end

--���ܺ���
Char.GetItemEmptySlot = function(charIndex)
  for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
