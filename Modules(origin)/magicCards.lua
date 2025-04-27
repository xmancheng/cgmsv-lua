local Module = ModuleBase:createModule('magicCards')

local petMettleTable = {
          {9610,9619,9620,9629},       --��BOSS��,��BOSS��,��������,��аħ��
          {9611,9615,9623,9624},       --�Ե���,�Եؼ�,�Է�����,��������
          {9612,9616,9627,9628},       --��ˮ��,��ˮ��,��������,�Խ�����
          {9613,9617,9621,9626},       --�Ի���,�Ի��,��������,��Ұ����
          {9614,9618,9622,9625},       --�Է���,�Է��,�Բ�����,��ֲ����
}

function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleActionEvent', Func.bind(self.onBattleActionEvent, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
  self:regCallback('BattleCalcDexEvent', Func.bind(self.OnBattleCalcDexEvent, self));
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self));
  --self:regCallback('BattleOverEvent', Func.bind(self.onBattleOver, self));
  self:regCallback('BattleExitEvent', Func.bind(self.onBattleExit, self));
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
      if (Item.GetData(ItemIndex, CONST.����_����)==63 and Item.GetData(ItemIndex, CONST.����_�Ѽ���)==1) then
        if (battleIndex==-1) then
          if (Char.GetData(charIndex,CONST.����_���Ŀ���) == 1) then
            NLG.SystemMessage(charIndex,"[������ʾ]���Y�в���ʹ�õĵ���");
          end
        else
          local com1 = Item.GetData(ItemIndex,CONST.����_��������)-1000;
          local com2 = Item.GetData(ItemIndex,CONST.����_�Ӳ�һ);
          local com3 = Item.GetData(ItemIndex,CONST.����_�Ӳζ�);

          local TechIndex = Tech.GetTechIndex(com3);
          local originFP = Tech.GetData(TechIndex, CONST.TECH_FORCEPOINT);
          if (Char.GetData(charIndex, CONST.����_ħ) < originFP) then
            NLG.SystemMessage(charIndex,"[ϵͳ]ʹ�ÿ��Ƶ�ħ�������㡣");
            return
          end

          if (com3==200209) then
            local enemyId = Item.GetData(ItemIndex,CONST.����_����);
            local ThrowItemOn = Char.GetTempData(charIndex, 'ThrowItem') or 0;
            if (ThrowItemOn==0) then
              local com2 = Com2
              Char.SetTempData(charIndex, 'ThrowItem', enemyId);
              Battle.ActionSelect(charIndex, com1, com2, com3);
            end
            Char.SetTempData(charIndex, 'Cards', 1);
            Char.DelItem(charIndex,74042,1);
            NLG.Say(charIndex,charIndex,"���G�����ơ�ʹ�����F��ӡ����",4,3);
          else
            Battle.ActionSelect(charIndex, com1, com2, com3);
            Char.SetTempData(charIndex, 'Cards', 1);
            Char.DelItemBySlot(charIndex, ItemSlot);
            local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
            NLG.Say(charIndex,charIndex,"���G�����ơ�ʹ��"..TechName.."����",4,3);
          end
        end
      elseif (Item.GetData(ItemIndex, CONST.����_����)==63 and Item.GetData(ItemIndex, CONST.����_�Ѽ���)==0) then
        NLG.SystemMessage(charIndex,"�o��ʹ��δ���a��֮���ơ�");
      end
    end
  elseif (Com1==9 and Char.IsPlayer(charIndex)==true) then
    Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, Com2, -1);
    NLG.SystemMessage(charIndex,"[ϵͳ]ʹ�ÿ�����Ҫ�͌���һ�����");
  end

end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	if (Char.IsEnemy(defCharIndex) and Char.IsDummy(charIndex)==false) then
		local floor = Char.GetData(charIndex,CONST.����_��ͼ);
		if (com3==200209 and floor==20300) then
			local defHpE = Char.GetData(defCharIndex,CONST.����_Ѫ);
			local ThrowItemOn = Char.GetTempData(charIndex, 'ThrowItem') or 0;	--���enemyId���з�ӡ
			if (ThrowItemOn>0) then
				if (Char.GetData(defCharIndex,CONST.����_�ȼ�) == 1)  then
					local PetSlot = Char.GetPetEmptySlot(charIndex);
					local enemyId = Char.GetData(defCharIndex, CONST.����_ENEMY_ID);
					if (ThrowItemOn==enemyId) then
						Char.GivePet(charIndex,enemyId,0);
						if (PetSlot>=0) then
							local PetIndex = Char.GetPet(charIndex, PetSlot);
							local typeRand = math.random(1,#petMettleTable);
							local pos = math.random(1,#petMettleTable[typeRand]);
							Pet.AddSkill(PetIndex, petMettleTable[typeRand][pos], 9);
							Pet.UpPet(charIndex,PetIndex);
							NLG.UpChar(charIndex);
						end
						Char.SetTempData(charIndex, 'ThrowItem', 0);
						local damage = 7777777;
						return damage;
					else
						Char.SetTempData(charIndex, 'ThrowItem', 0);
						local damage = 4444444;
						return damage;
					end
				else
					Char.SetTempData(charIndex, 'ThrowItem', 0);
					local damage = defHpE*0.5;
					return damage;
				end
			end
		elseif (com3~=200209 and floor==20300) then
			local damage = damage*0.50;
			return damage;
		elseif (com3==200209 and floor~=20300) then
			Char.SetTempData(charIndex, 'ThrowItem', 0);
			return damage;
		elseif (Char.IsPet(charIndex) == true) then
			local cdk = Char.GetData(charIndex,CONST.����_����CDK);
			local OwnerIndex = NLG.FindUser(cdk);
			local Ownerfloor = Char.GetData(OwnerIndex,CONST.����_��ͼ);
			if (Ownerfloor==20300) then
				local damage = damage*0.25;
				return damage;
			else
				return damage;
			end
		end
	end
	return damage;
end

--��������
function Module:OnBattleCalcDexEvent(battleIndex, charIndex, action, flg, dex)
	--self:logDebug('OnBattleCalcDexEvent', battleIndex, charIndex, action, flg, dex)
	if (Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false) then
		local Cards = Char.GetTempData(charIndex, 'Cards') or 0;
		if (Cards == 1) then
			Char.SetTempData(charIndex, 'Cards', 0);
			local dex = 1000;
			return dex;
		end
		return dex;
	end
	return dex;
end

function Module:OnbattleStarCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.����_����) == CONST.��������_�� then
		leader = leader2
	end
	if (Round==0) then
		Char.SetTempData(leader, 'ȫ��ħ��', 0);
	elseif (Round>=1) then
		local Vigor_pre = Char.GetTempData(leader, 'ȫ��ħ��') or 0;
		local Count = 0;
		for i=0,9 do
			local player = Battle.GetPlayIndex(battleIndex, i)
			if (player>=0) then
				if (Char.GetData(player, CONST.����_ս��)==0) then
					Count = Count+1;
				end
			end
		end
		Char.SetTempData(leader, 'ȫ��ħ��', Vigor_pre + Count);
		local Vigor = Char.GetTempData(leader, 'ȫ��ħ��') or 0;
		if (Vigor >= 100) then
			local cardItemId = {75034,75035,75036,75037};
			local rand = NLG.Rand(1,#cardItemId);
			Char.GiveItem(leader, cardItemId[rand], 1, false);
			NLG.SystemMessage(leader,"[ϵ�y] �_��100����ֵ�@��ȫ��ħ����");
			Char.SetTempData(leader, 'ȫ��ħ��', 0);
		else
			if (Char.GetData(leader,CONST.����_���Ŀ���) == 1) then
				NLG.SystemMessage(leader,"[ϵ�y] �۷e"..Vigor.."����ֵ��");
			end
		end
	end

end

--ս������������
function Module:onBattleOver(battleIndex)
	for i=0,9 do
		local player = Battle.GetPlayer(battleIndex,i)
		if (player>-1) then
			for kItemId=75034,75037 do
				Char.DelItem(player, kItemId, Char.ItemNum(player, kItemId), false);
			end
		end
	end
end
--�뿪ս������������
function Module:onBattleExit(player, battleIndex, type)
	for cardItemId=75034,75037 do
		if (player>-1 and Char.HaveItem(player,cardItemId)>-1) then
			Char.DelItem(player, cardItemId, Char.ItemNum(player, cardItemId), false);
		end
	end
end

Char.GetPetEmptySlot = function(charIndex)
  for Slot=0,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      --print(PetIndex);
      if (PetIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
