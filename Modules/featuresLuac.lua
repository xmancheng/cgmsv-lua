local featuresLuac = ModuleBase:createModule('featuresLuac')

local PartyMember={}

--- ����ģ�鹳��
function featuresLuac:onLoad()
  self:logInfo('load')
  self:regCallback('LogoutEvent', Func.bind(featuresLuac.LogoutEvent, self))
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)

	player = playerIndex
	npc = npcIndex

	if text == '��������' then
		local cdk = Char.GetData(player,CONST.����_CDK);
		local playeryd = Char.GetData(player,%����_ս����%) == 0
		if playeryd and PartyMember[cdk] ~= nill and cdk == PartyMember[cdk][6] then
			for i,v in ipairs(PartyMember[cdk]) do
				local playerbattle = Char.GetBattleIndex(v);
				if v > -1 then
					Battle.JoinBattle(v, player);
					Char.JoinParty(player, v);
					Char.DelItem(player, 900502, 1);
					NLG.SystemMessage(player, '���»ص����Y�У�');
					PartyMember[cdk] = {}
					return;
				end
			end
		end
	end
	if text == '�붴����' then
		local playerFloorId = Char.GetData(player,CONST.CHAR_��ͼ);
		local dungeonFloorId = Map.GetDungeonId(playerFloorId);
		local mapType,floor,x,y = Map.FindDungeonEntry(dungeonFloorId);
		print(playerFloorId, dungeonFloorId, mapType, floor, x, y)
		if Char.GetData(player,CONST.CHAR_��ͼ����) == CONST.��ͼ����_�Թ�  then
			Char.Warp(player, mapType, floor, x, y);
			Char.DelItem(player, 900503, 1);
		else
			return;
		end
	end
	if text == '��ڻ���' then
		local itemIndex = Char.HaveItem(player,68017);
		local Slot = Char.GetItemSlot(player, itemIndex);
		local petIndex = Char.GetPet(player, 0);
		if petIndex > 0 then
			local Level = Char.GetData(petIndex,CONST.CHAR_�ȼ�);
			if (Char.GetData(petIndex,CONST.CHAR_��ɫ) ~= 0) then
				NLG.SystemMessage(player,"[ϵͳ]�޷���ת������������!");
				return;
			end
			Pet.SetArtRank(petIndex, CONST.PET_���,  Pet.FullArtRank(petIndex, CONST.PET_���) - NLG.Rand(0, 1) );
			Pet.SetArtRank(petIndex, CONST.PET_����,  Pet.FullArtRank(petIndex, CONST.PET_����) - NLG.Rand(0, 1) );
			Pet.SetArtRank(petIndex, CONST.PET_ǿ��,  Pet.FullArtRank(petIndex, CONST.PET_ǿ��) - NLG.Rand(0, 1) );
			Pet.SetArtRank(petIndex, CONST.PET_����,  Pet.FullArtRank(petIndex, CONST.PET_����) - NLG.Rand(0, 1) );
			Pet.SetArtRank(petIndex, CONST.PET_ħ��,  Pet.FullArtRank(petIndex, CONST.PET_ħ��) - NLG.Rand(0, 1) );
			Pet.ReBirth(player, petIndex);
			Pet.UpPet(player, petIndex);
			Char.DelItem(player,68017,1);
			local arr_rank1_new = Pet.GetArtRank(petIndex,CONST.PET_���);
			local arr_rank2_new = Pet.GetArtRank(petIndex,CONST.PET_����);
			local arr_rank3_new = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
			local arr_rank4_new = Pet.GetArtRank(petIndex,CONST.PET_����);
			local arr_rank5_new = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
			local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_���);
			local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_����);
			local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_ǿ��);
			local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_����);
			local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_ħ��);
			local a1 = math.abs(arr_rank1_new - arr_rank11);
			local a2 = math.abs(arr_rank2_new - arr_rank21);
			local a3 = math.abs(arr_rank3_new - arr_rank31);
			local a4 = math.abs(arr_rank4_new - arr_rank41);
			local a5 = math.abs(arr_rank5_new - arr_rank51);
			local a6 = a1 + a2+ a3+ a4+ a5;
			if(Level~=1 ) then
				Char.SetData(petIndex,CONST.CHAR_������,Level-1);
				Char.SetData(petIndex,CONST.CHAR_�ȼ�,Level);
				Char.SetData(petIndex,CONST.CHAR_����, (Char.GetData(petIndex,CONST.CHAR_����) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
				Char.SetData(petIndex,CONST.CHAR_����, (Char.GetData(petIndex,CONST.CHAR_����) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
				Char.SetData(petIndex,CONST.CHAR_ǿ��, (Char.GetData(petIndex,CONST.CHAR_ǿ��) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
				Char.SetData(petIndex,CONST.CHAR_�ٶ�, (Char.GetData(petIndex,CONST.CHAR_�ٶ�) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
				Char.SetData(petIndex,CONST.CHAR_ħ��, (Char.GetData(petIndex,CONST.CHAR_ħ��) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
				Pet.UpPet(player,petIndex);
			end
			NLG.SystemMessage(player, '�����S�C�����ɞ�'..a6..'�n�Σ�');
		end
	end

    return -1;
  end)
end

function featuresLuac:LogoutEvent(player)
	local cdk = Char.GetData(player,CONST.����_CDK);
	if PartyMember[cdk] == nill then
			PartyMember[cdk] = {}
	end
	for partySlot = 0,4 do 
		local targetcharIndex = Char.GetPartyMember(player,partySlot);
		if targetcharIndex >= 0  then
			table.insert(PartyMember[cdk], partySlot+1, targetcharIndex);
		else
			table.insert(PartyMember[cdk], partySlot+1, -1);
		end
	end
	table.insert(PartyMember[cdk],cdk);
	return 0;
end

--- ж��ģ�鹳��
function featuresLuac:onUnload()
  self:logInfo('unload')
end

return featuresLuac;
