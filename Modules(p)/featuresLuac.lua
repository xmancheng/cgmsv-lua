local featuresLuac = ModuleBase:createModule('featuresLuac')

local PartyMember={}
local PetLoyalty={}

--- ����ģ�鹳��
function featuresLuac:onLoad()
  self:logInfo('load')
  self:regCallback('LogoutEvent', Func.bind(featuresLuac.LogoutEvent, self))
  self:regCallback('CharaSavedEvent', function(charIndex)
	local cdk = Char.GetData(charIndex, CONST.����_CDK);
	if (PetLoyalty[cdk] ~= nill) then
		local uuid = PetLoyalty[cdk][2];
		local M_Loyalty = PetLoyalty[cdk][3];
		local V_Loyalty = PetLoyalty[cdk][4];
		SQL.querySQL("update tbl_pet set ModLoyalty= '"..M_Loyalty.."' where CdKey='"..cdk.."' and UUID='"..uuid.."'")
		SQL.querySQL("update tbl_pet set VariableLoyalty= '"..V_Loyalty.."' where CdKey='"..cdk.."' and UUID='"..uuid.."'")
		PetLoyalty[cdk] = {};
	end
  end)

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
				if v > -1 and v~=player  then
					Char.JoinParty(player, v);
					Battle.JoinBattle(v, player);
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
	if text == '�����ǹ�' then
		local cdk = Char.GetData(player,CONST.����_CDK);
		local itemIndex = Char.HaveItem(player,900504);
		local Slot = Char.GetItemSlot(player, itemIndex);
		local petIndex = Char.GetPet(player, 0);
		if petIndex > 0 then
			local uuid = Pet.GetUUID(petIndex);
			local M_Loyalty = tonumber(SQL.Run("select ModLoyalty from tbl_pet where CdKey='"..cdk.."' and UUID='"..uuid.."'")["0_0"])
			local V_Loyalty = tonumber(SQL.Run("select VariableLoyalty from tbl_pet where CdKey='"..cdk.."' and UUID='"..uuid.."'")["0_0"])
			local M_Loyalty = M_Loyalty + 5;
			local V_Loyalty = V_Loyalty + 5;
			SQL.Run("update tbl_pet set ModLoyalty= '"..M_Loyalty.."' where CdKey='"..cdk.."' and UUID='"..uuid.."'")
			SQL.Run("update tbl_pet set VariableLoyalty= '"..V_Loyalty.."' where CdKey='"..cdk.."' and UUID='"..uuid.."'")
			if PetLoyalty[cdk] == nill then
				PetLoyalty[cdk] = {}
			end
			Char.DelItem(player, 900504, 1);
		end
	end
	if text == '������ҩ' then
		local nameColor = Char.GetData(player,CONST.CHAR_��ɫ);
		local playerLevel = Char.GetData(player,CONST.CHAR_�ȼ�);
		if (nameColor == 0)  then
			local point = (playerLevel-1)*4 + 30;
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_ǿ��, 0);
			Char.SetData(player,CONST.CHAR_�ٶ�, 0);
			Char.SetData(player,CONST.CHAR_ħ��, 0);
			Char.SetData(player,CONST.CHAR_��ɱ, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_������, point);
			NLG.UpChar(player);
			Char.DelItem(player, 900505, 1);
		elseif (nameColor == 1)  then
			local point = (playerLevel-1)*4 + 60;
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_ǿ��, 0);
			Char.SetData(player,CONST.CHAR_�ٶ�, 0);
			Char.SetData(player,CONST.CHAR_ħ��, 0);
			Char.SetData(player,CONST.CHAR_��ɱ, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_������, point);
			NLG.UpChar(player);
			Char.DelItem(player, 900505, 1);
		elseif (nameColor == 5)  then
			local point = (playerLevel-1)*4 + 90;
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_ǿ��, 0);
			Char.SetData(player,CONST.CHAR_�ٶ�, 0);
			Char.SetData(player,CONST.CHAR_ħ��, 0);
			Char.SetData(player,CONST.CHAR_��ɱ, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_������, point);
			NLG.UpChar(player);
			Char.DelItem(player, 900505, 1);
		elseif (nameColor == 4)  then
			local point = (playerLevel-1)*4 + 180;
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_ǿ��, 0);
			Char.SetData(player,CONST.CHAR_�ٶ�, 0);
			Char.SetData(player,CONST.CHAR_ħ��, 0);
			Char.SetData(player,CONST.CHAR_��ɱ, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_����, 0);
			Char.SetData(player,CONST.CHAR_������, point);
			NLG.UpChar(player);
			Char.DelItem(player, 900505, 1);
		else
			return;
		end
	end
	if text == '��ڻ���' then
		local itemIndex = Char.HaveItem(player,68017);
		local Slot = Char.GetItemSlot(player, itemIndex);
		local petIndex = Char.GetPet(player, 0);
		if petIndex > 0 and Char.GetPetRank(player,0)<=5 then
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
			local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,0);
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
			NLG.SystemMessage(player, '�����S�C�����ɞ�-'..a6..'�n�Σ��w-'..a1..'��-'..a2..'��-'..a3..'��-'..a4..'ħ-'..a5..'');
		elseif petIndex > 0 and Char.GetPetRank(player,0)>5 then
			NLG.SystemMessage(player, '��ɫ����ֻ������-5�n���µČ��');
		end
	end
	if text == '���ڻ���' then
		local itemIndex = Char.HaveItem(player,68018);
		local Slot = Char.GetItemSlot(player, itemIndex);
		local petIndex = Char.GetPet(player, 0);
		if petIndex > 0 and Char.GetPetRank(player,0)>5 and Char.GetPetRank(player,0)<=10 then
			local Level = Char.GetData(petIndex,CONST.CHAR_�ȼ�);
			if (Char.GetData(petIndex,CONST.CHAR_��ɫ) ~= 0) then
				NLG.SystemMessage(player,"[ϵͳ]�޷���ת������������!");
				return;
			end
			Pet.SetArtRank(petIndex, CONST.PET_���,  Pet.FullArtRank(petIndex, CONST.PET_���) - NLG.Rand(0, 2) );
			Pet.SetArtRank(petIndex, CONST.PET_����,  Pet.FullArtRank(petIndex, CONST.PET_����) - NLG.Rand(0, 2) );
			Pet.SetArtRank(petIndex, CONST.PET_ǿ��,  Pet.FullArtRank(petIndex, CONST.PET_ǿ��) - NLG.Rand(0, 2) );
			Pet.SetArtRank(petIndex, CONST.PET_����,  Pet.FullArtRank(petIndex, CONST.PET_����) - NLG.Rand(0, 2) );
			Pet.SetArtRank(petIndex, CONST.PET_ħ��,  Pet.FullArtRank(petIndex, CONST.PET_ħ��) - NLG.Rand(0, 2) );
			Pet.ReBirth(player, petIndex);
			Pet.UpPet(player, petIndex);
			Char.DelItem(player,68018,1);
			local arr_rank1_new = Pet.GetArtRank(petIndex,CONST.PET_���);
			local arr_rank2_new = Pet.GetArtRank(petIndex,CONST.PET_����);
			local arr_rank3_new = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
			local arr_rank4_new = Pet.GetArtRank(petIndex,CONST.PET_����);
			local arr_rank5_new = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
			local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,0);
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
			NLG.SystemMessage(player, '�����S�C�����ɞ�-'..a6..'�n�Σ��w-'..a1..'��-'..a2..'��-'..a3..'��-'..a4..'ħ-'..a5..'');
		elseif petIndex > 0 then
			NLG.SystemMessage(player, '�yɫ����ֻ������-6��-10�n�Č��');
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

	if PetLoyalty[cdk] ~= nill then
		local petIndex = Char.GetPet(player, 0);
		local uuid = Pet.GetUUID(petIndex);
		local M_Loyalty = tonumber(SQL.Run("select ModLoyalty from tbl_pet where CdKey='"..cdk.."' and UUID='"..uuid.."'")["0_0"])
		local V_Loyalty = tonumber(SQL.Run("select VariableLoyalty from tbl_pet where CdKey='"..cdk.."' and UUID='"..uuid.."'")["0_0"])
		table.insert(PetLoyalty[cdk],cdk);
		table.insert(PetLoyalty[cdk],uuid);
		table.insert(PetLoyalty[cdk],M_Loyalty);
		table.insert(PetLoyalty[cdk],V_Loyalty);
	end
	return 0;
end

Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_���);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_���);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_ǿ��);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_ħ��);
    local a1 = math.abs(arr_rank11 - arr_rank1);
    local a2 = math.abs(arr_rank21 - arr_rank2);
    local a3 = math.abs(arr_rank31 - arr_rank3);
    local a4 = math.abs(arr_rank41 - arr_rank4);
    local a5 = math.abs(arr_rank51 - arr_rank5);
    local a6 = a1 + a2+ a3+ a4+ a5;
    return a6, a1, a2, a3, a4, a5;
  end
  return -1;
end

--- ж��ģ�鹳��
function featuresLuac:onUnload()
  self:logInfo('unload')
end

return featuresLuac;
