local featuresLuac = ModuleBase:createModule('featuresLuac')

local PartyMember={}

--- 加载模块钩子
function featuresLuac:onLoad()
  self:logInfo('load')
  self:regCallback('LogoutEvent', Func.bind(featuresLuac.LogoutEvent, self))
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)

	player = playerIndex
	npc = npcIndex

	if text == '断线重连' then
		local cdk = Char.GetData(player,CONST.对象_CDK);
		local playeryd = Char.GetData(player,%对象_战斗中%) == 0
		if playeryd and PartyMember[cdk] ~= nill and cdk == PartyMember[cdk][6] then
			for i,v in ipairs(PartyMember[cdk]) do
				local playerbattle = Char.GetBattleIndex(v);
				if v > -1 then
					Battle.JoinBattle(v, player);
					Char.JoinParty(player, v);
					Char.DelItem(player, 900502, 1);
					NLG.SystemMessage(player, '重新回到戰鬥中！');
					PartyMember[cdk] = {}
					return;
				end
			end
		end
	end
	if text == '离洞绳子' then
		local playerFloorId = Char.GetData(player,CONST.CHAR_地图);
		local dungeonFloorId = Map.GetDungeonId(playerFloorId);
		local mapType,floor,x,y = Map.FindDungeonEntry(dungeonFloorId);
		print(playerFloorId, dungeonFloorId, mapType, floor, x, y)
		if Char.GetData(player,CONST.CHAR_地图类型) == CONST.地图类型_迷宫  then
			Char.Warp(player, mapType, floor, x, y);
			Char.DelItem(player, 900503, 1);
		else
			return;
		end
	end
	if text == '金冠徽章' then
		local itemIndex = Char.HaveItem(player,68017);
		local Slot = Char.GetItemSlot(player, itemIndex);
		local petIndex = Char.GetPet(player, 0);
		if petIndex > 0 then
			local Level = Char.GetData(petIndex,CONST.CHAR_等级);
			if (Char.GetData(petIndex,CONST.CHAR_名色) ~= 0) then
				NLG.SystemMessage(player,"[系统]无法对转生宠物进行异变!");
				return;
			end
			Pet.SetArtRank(petIndex, CONST.PET_体成,  Pet.FullArtRank(petIndex, CONST.PET_体成) - NLG.Rand(0, 1) );
			Pet.SetArtRank(petIndex, CONST.PET_力成,  Pet.FullArtRank(petIndex, CONST.PET_力成) - NLG.Rand(0, 1) );
			Pet.SetArtRank(petIndex, CONST.PET_强成,  Pet.FullArtRank(petIndex, CONST.PET_强成) - NLG.Rand(0, 1) );
			Pet.SetArtRank(petIndex, CONST.PET_敏成,  Pet.FullArtRank(petIndex, CONST.PET_敏成) - NLG.Rand(0, 1) );
			Pet.SetArtRank(petIndex, CONST.PET_魔成,  Pet.FullArtRank(petIndex, CONST.PET_魔成) - NLG.Rand(0, 1) );
			Pet.ReBirth(player, petIndex);
			Pet.UpPet(player, petIndex);
			Char.DelItem(player,68017,1);
			local arr_rank1_new = Pet.GetArtRank(petIndex,CONST.PET_体成);
			local arr_rank2_new = Pet.GetArtRank(petIndex,CONST.PET_力成);
			local arr_rank3_new = Pet.GetArtRank(petIndex,CONST.PET_强成);
			local arr_rank4_new = Pet.GetArtRank(petIndex,CONST.PET_敏成);
			local arr_rank5_new = Pet.GetArtRank(petIndex,CONST.PET_魔成);
			local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_体成);
			local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_力成);
			local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_强成);
			local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_敏成);
			local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_魔成);
			local a1 = math.abs(arr_rank1_new - arr_rank11);
			local a2 = math.abs(arr_rank2_new - arr_rank21);
			local a3 = math.abs(arr_rank3_new - arr_rank31);
			local a4 = math.abs(arr_rank4_new - arr_rank41);
			local a5 = math.abs(arr_rank5_new - arr_rank51);
			local a6 = a1 + a2+ a3+ a4+ a5;
			if(Level~=1 ) then
				Char.SetData(petIndex,CONST.CHAR_升级点,Level-1);
				Char.SetData(petIndex,CONST.CHAR_等级,Level);
				Char.SetData(petIndex,CONST.CHAR_体力, (Char.GetData(petIndex,CONST.CHAR_体力) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
				Char.SetData(petIndex,CONST.CHAR_力量, (Char.GetData(petIndex,CONST.CHAR_力量) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
				Char.SetData(petIndex,CONST.CHAR_强度, (Char.GetData(petIndex,CONST.CHAR_强度) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
				Char.SetData(petIndex,CONST.CHAR_速度, (Char.GetData(petIndex,CONST.CHAR_速度) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
				Char.SetData(petIndex,CONST.CHAR_魔法, (Char.GetData(petIndex,CONST.CHAR_魔法) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
				Pet.UpPet(player,petIndex);
			end
			NLG.SystemMessage(player, '寵物隨機升級成為'..a6..'檔次！');
		end
	end

    return -1;
  end)
end

function featuresLuac:LogoutEvent(player)
	local cdk = Char.GetData(player,CONST.对象_CDK);
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

--- 卸载模块钩子
function featuresLuac:onUnload()
  self:logInfo('unload')
end

return featuresLuac;
