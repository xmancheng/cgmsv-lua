local Module = ModuleBase:createModule('magicCards')


function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleActionEvent', Func.bind(self.onBattleActionEvent, self));
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
      if (Item.GetData(ItemIndex, CONST.����_����)==63) then
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

          Battle.ActionSelect(charIndex, com1, com2, com3);
          Char.SetTempData(charIndex, 'Cards', 1);
          --Char.DelItem(charIndex,ItemID,1);
          Char.DelItemBySlot(charIndex, ItemSlot);
          --local TechIndex = Tech.GetTechIndex(com3);
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
	if (player>-1 and Char.HaveItem(player,cardItemId)>-1) then
		Char.DelItem(player, cardItemId, Char.ItemNum(player, cardItemId), false);
	end
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
