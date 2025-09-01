local featuresLuac = ModuleBase:createModule('featuresLuac')

local PartyMember={}
local PetLoyalty={}

--- 加载模块钩子
function featuresLuac:onLoad()
  self:logInfo('load')
  self:regCallback('LogoutEvent', Func.bind(featuresLuac.LogoutEvent, self))
  self:regCallback('CharaSavedEvent', function(charIndex)
	local cdk = Char.GetData(charIndex, CONST.对象_CDK);
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

	if text == '断线重连' then
		local cdk = Char.GetData(player,CONST.对象_CDK);
		local playeryd = Char.GetData(player,%对象_战斗中%) == 0
		if playeryd and PartyMember[cdk] ~= nill and cdk == PartyMember[cdk][6] then
			for i,v in ipairs(PartyMember[cdk]) do
				local playerbattle = Char.GetBattleIndex(v);
				if v > -1 and v~=player  then
					Char.JoinParty(player, v);
					Battle.JoinBattle(v, player);
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
	if text == '神奇糖果' then
		local cdk = Char.GetData(player,CONST.对象_CDK);
		local itemIndex = Char.HaveItem(player,900504);
		local Slot = Char.GetItemSlot(player, itemIndex);
		local petIndex = Char.GetPet(player, 0);
		if petIndex > 0 then
			local uuid = Pet.GetUUID(petIndex);
			local M_Loyalty = tonumber(SQL.Run("select ModLoyalty from tbl_pet where CdKey='"..cdk.."' and UUID='"..uuid.."'")["0_0"])
			local V_Loyalty = tonumber(SQL.Run("select VariableLoyalty from tbl_pet where CdKey='"..cdk.."' and UUID='"..uuid.."'")["0_0"])
			local M_Loyalty = M_Loyalty - 100;
			local V_Loyalty = V_Loyalty + 250;
			SQL.Run("update tbl_pet set ModLoyalty= '"..M_Loyalty.."' where CdKey='"..cdk.."' and UUID='"..uuid.."'")
			SQL.Run("update tbl_pet set VariableLoyalty= '"..V_Loyalty.."' where CdKey='"..cdk.."' and UUID='"..uuid.."'")
			if PetLoyalty[cdk] == nill then
				PetLoyalty[cdk] = {}
			end
			Char.DelItem(player, 900504, 1);
		end
	end
	if text == '再生剧药' then
		local nameColor = Char.GetData(player,CONST.CHAR_名色);
		local playerLevel = Char.GetData(player,CONST.CHAR_等级);
		if (nameColor == 0)  then
			local point = (playerLevel-1)*4 + 30;
			Char.SetData(player,CONST.CHAR_体力, 0);
			Char.SetData(player,CONST.CHAR_力量, 0);
			Char.SetData(player,CONST.CHAR_强度, 0);
			Char.SetData(player,CONST.CHAR_速度, 0);
			Char.SetData(player,CONST.CHAR_魔法, 0);
			Char.SetData(player,CONST.CHAR_必杀, 0);
			Char.SetData(player,CONST.CHAR_反击, 0);
			Char.SetData(player,CONST.CHAR_命中, 0);
			Char.SetData(player,CONST.CHAR_闪躲, 0);
			Char.SetData(player,CONST.CHAR_升级点, point);
			NLG.UpChar(player);
			Char.DelItem(player, 900503, 1);
		elseif (nameColor == 1)  then
			local point = (playerLevel-1)*4 + 60;
			Char.SetData(player,CONST.CHAR_体力, 0);
			Char.SetData(player,CONST.CHAR_力量, 0);
			Char.SetData(player,CONST.CHAR_强度, 0);
			Char.SetData(player,CONST.CHAR_速度, 0);
			Char.SetData(player,CONST.CHAR_魔法, 0);
			Char.SetData(player,CONST.CHAR_必杀, 0);
			Char.SetData(player,CONST.CHAR_反击, 0);
			Char.SetData(player,CONST.CHAR_命中, 0);
			Char.SetData(player,CONST.CHAR_闪躲, 0);
			Char.SetData(player,CONST.CHAR_升级点, point);
			NLG.UpChar(player);
			Char.DelItem(player, 900503, 1);
		elseif (nameColor == 5)  then
			local point = (playerLevel-1)*4 + 90;
			Char.SetData(player,CONST.CHAR_体力, 0);
			Char.SetData(player,CONST.CHAR_力量, 0);
			Char.SetData(player,CONST.CHAR_强度, 0);
			Char.SetData(player,CONST.CHAR_速度, 0);
			Char.SetData(player,CONST.CHAR_魔法, 0);
			Char.SetData(player,CONST.CHAR_必杀, 0);
			Char.SetData(player,CONST.CHAR_反击, 0);
			Char.SetData(player,CONST.CHAR_命中, 0);
			Char.SetData(player,CONST.CHAR_闪躲, 0);
			Char.SetData(player,CONST.CHAR_升级点, point);
			NLG.UpChar(player);
			Char.DelItem(player, 900503, 1);
		elseif (nameColor == 4)  then
			local point = (playerLevel-1)*4 + 180;
			Char.SetData(player,CONST.CHAR_体力, 0);
			Char.SetData(player,CONST.CHAR_力量, 0);
			Char.SetData(player,CONST.CHAR_强度, 0);
			Char.SetData(player,CONST.CHAR_速度, 0);
			Char.SetData(player,CONST.CHAR_魔法, 0);
			Char.SetData(player,CONST.CHAR_必杀, 0);
			Char.SetData(player,CONST.CHAR_反击, 0);
			Char.SetData(player,CONST.CHAR_命中, 0);
			Char.SetData(player,CONST.CHAR_闪躲, 0);
			Char.SetData(player,CONST.CHAR_升级点, point);
			NLG.UpChar(player);
			Char.DelItem(player, 900503, 1);
		else
			return;
		end
	end
	if text == '金冠徽章' then
		local itemIndex = Char.HaveItem(player,68017);
		local Slot = Char.GetItemSlot(player, itemIndex);
		local petIndex = Char.GetPet(player, 0);
		if petIndex > 0 and Char.GetPetRank(player,0)<=5 then
			local PetName_1 = Char.GetData(petIndex,CONST.对象_原名);
			local Level = Char.GetData(petIndex,CONST.对象_等级);
			local last = string.find(PetName_1, "★", 1);
			if (last==nil) then
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
				local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,0);
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
				NLG.SystemMessage(player, '寵物隨機升級成為-'..a6..'檔次！體-'..a1..'力-'..a2..'強-'..a3..'速-'..a4..'魔-'..a5..'');
			elseif (last~=nil) then
				local StarLv = tonumber(string.sub(PetName_1, last+2, -1));
				local PetRawName = string.sub(PetName_1, 1, last-1);
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
				local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,0);
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
				NLG.SystemMessage(player, '寵物隨機升級成為-'..a6..'檔次！體-'..a1..'力-'..a2..'強-'..a3..'速-'..a4..'魔-'..a5..'');
				Char.SetData(petIndex,CONST.对象_原名, PetRawName .. "★".. StarLv);
				local PetId = Char.GetData(petIndex,CONST.PET_PetID);
				local Type_check = {21,22,23,24,25,26,112,113,206,211,212,213,214,411,412,413,414,521,522,523,524,531,532,533,534,603,604,
                                                                                                      611,612,613,614,615,616,834,835,}
				if (StarLv==1) then		--★1
					if (CheckInTable(Type_check, PetId)==true) then
						Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+2000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+2000);
					else
						Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+2000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+2000);
					end
				elseif (StarLv==2) then	--★2
					if (CheckInTable(Type_check, PetId)==true) then
						Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+5000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+5000);
					else
						Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+5000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+5000);
					end
				elseif (StarLv==3) then	--★3
					if (CheckInTable(Type_check, PetId)==true) then
						Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+10000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+10000);
					else
						Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+10000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+10000);
					end
				end
				Pet.UpPet(player,petIndex);
				NLG.UpChar(player);
			end
		elseif petIndex > 0 and Char.GetPetRank(player,0)>5 then
			NLG.SystemMessage(player, '金色王冠只能用在-5檔以下的寵物！');
		end
	end
	if text == '银冠徽章' then
		local itemIndex = Char.HaveItem(player,68018);
		local Slot = Char.GetItemSlot(player, itemIndex);
		local petIndex = Char.GetPet(player, 0);
		if petIndex > 0 and Char.GetPetRank(player,0)>5 and Char.GetPetRank(player,0)<=10 then
			local PetName_1 = Char.GetData(petIndex,CONST.对象_原名);
			local Level = Char.GetData(petIndex,CONST.对象_等级);
			local last = string.find(PetName_1, "★", 1);
			if (last==nil) then
				Pet.SetArtRank(petIndex, CONST.PET_体成,  Pet.FullArtRank(petIndex, CONST.PET_体成) - NLG.Rand(0, 2) );
				Pet.SetArtRank(petIndex, CONST.PET_力成,  Pet.FullArtRank(petIndex, CONST.PET_力成) - NLG.Rand(0, 2) );
				Pet.SetArtRank(petIndex, CONST.PET_强成,  Pet.FullArtRank(petIndex, CONST.PET_强成) - NLG.Rand(0, 2) );
				Pet.SetArtRank(petIndex, CONST.PET_敏成,  Pet.FullArtRank(petIndex, CONST.PET_敏成) - NLG.Rand(0, 2) );
				Pet.SetArtRank(petIndex, CONST.PET_魔成,  Pet.FullArtRank(petIndex, CONST.PET_魔成) - NLG.Rand(0, 2) );
				Pet.ReBirth(player, petIndex);
				Pet.UpPet(player, petIndex);
				Char.DelItem(player,68018,1);
				local arr_rank1_new = Pet.GetArtRank(petIndex,CONST.PET_体成);
				local arr_rank2_new = Pet.GetArtRank(petIndex,CONST.PET_力成);
				local arr_rank3_new = Pet.GetArtRank(petIndex,CONST.PET_强成);
				local arr_rank4_new = Pet.GetArtRank(petIndex,CONST.PET_敏成);
				local arr_rank5_new = Pet.GetArtRank(petIndex,CONST.PET_魔成);
				local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,0);
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
				NLG.SystemMessage(player, '寵物隨機升級成為-'..a6..'檔次！體-'..a1..'力-'..a2..'強-'..a3..'速-'..a4..'魔-'..a5..'');
			elseif (last~=nil) then
				local StarLv = tonumber(string.sub(PetName_1, last+2, -1));
				local PetRawName = string.sub(PetName_1, 1, last-1);
				Pet.SetArtRank(petIndex, CONST.PET_体成,  Pet.FullArtRank(petIndex, CONST.PET_体成) - NLG.Rand(0, 2) );
				Pet.SetArtRank(petIndex, CONST.PET_力成,  Pet.FullArtRank(petIndex, CONST.PET_力成) - NLG.Rand(0, 2) );
				Pet.SetArtRank(petIndex, CONST.PET_强成,  Pet.FullArtRank(petIndex, CONST.PET_强成) - NLG.Rand(0, 2) );
				Pet.SetArtRank(petIndex, CONST.PET_敏成,  Pet.FullArtRank(petIndex, CONST.PET_敏成) - NLG.Rand(0, 2) );
				Pet.SetArtRank(petIndex, CONST.PET_魔成,  Pet.FullArtRank(petIndex, CONST.PET_魔成) - NLG.Rand(0, 2) );
				Pet.ReBirth(player, petIndex);
				Pet.UpPet(player, petIndex);
				Char.DelItem(player,68018,1);
				local arr_rank1_new = Pet.GetArtRank(petIndex,CONST.PET_体成);
				local arr_rank2_new = Pet.GetArtRank(petIndex,CONST.PET_力成);
				local arr_rank3_new = Pet.GetArtRank(petIndex,CONST.PET_强成);
				local arr_rank4_new = Pet.GetArtRank(petIndex,CONST.PET_敏成);
				local arr_rank5_new = Pet.GetArtRank(petIndex,CONST.PET_魔成);
				local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,0);
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
				NLG.SystemMessage(player, '寵物隨機升級成為-'..a6..'檔次！體-'..a1..'力-'..a2..'強-'..a3..'速-'..a4..'魔-'..a5..'');
				Char.SetData(petIndex,CONST.对象_原名, PetRawName .. "★".. StarLv);
				local PetId = Char.GetData(petIndex,CONST.PET_PetID);
				local Type_check = {21,22,23,24,25,26,112,113,206,211,212,213,214,411,412,413,414,521,522,523,524,531,532,533,534,603,604,
                                                                                                      611,612,613,614,615,616,834,835,}
				if (StarLv==1) then		--★1
					if (CheckInTable(Type_check, PetId)==true) then
						Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+2000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+2000);
					else
						Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+2000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+2000);
					end
				elseif (StarLv==2) then	--★2
					if (CheckInTable(Type_check, PetId)==true) then
						Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+5000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+5000);
					else
						Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+5000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+5000);
					end
				elseif (StarLv==3) then	--★3
					if (CheckInTable(Type_check, PetId)==true) then
						Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+10000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+10000);
					else
						Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+10000);
						Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+10000);
					end
				end
				Pet.UpPet(player,petIndex);
				NLG.UpChar(player);
			end
		elseif petIndex > 0 then
			NLG.SystemMessage(player, '銀色王冠只能用在-6至-10檔的寵物！');
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
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_体成);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_力成);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_强成);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_敏成);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_魔成);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_体成);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_力成);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_强成);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_敏成);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_魔成);
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

--- 卸载模块钩子
function featuresLuac:onUnload()
  self:logInfo('unload')
end

return featuresLuac;
