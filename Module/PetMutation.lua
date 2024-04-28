------------------------------------------------------------------------------
local StrPetMutationEnable = {}
------------------------------------------------------------------------------
--  一种异变一列                                          --
StrPetMutationEnable[1] = {"大地翼龍","變異龍祖",403001,72001,72002}      --原名,異變原名,異變编号,所需異變道具编号
StrPetMutationEnable[2] = {"大炸彈","粉紅炸彈",403002,72003,72004}

StrPetMutationEnable[3] = {"地獄妖犬","雷獸",403003,72005,72006}
StrPetMutationEnable[4] = {"黃金螃蟹","劇毒螃蟹",403004,72007,72008}

StrPetMutationEnable[5] = {"黃蜂","赤炎黃蜂",403005,72009,72010}
StrPetMutationEnable[6] = {"樹精","懷舊樹精",403006,72011,72012}

StrPetMutationEnable[7] = {"液態史萊姆","純白液態史萊姆",403007,72013,72014}
StrPetMutationEnable[8] = {"螳螂","櫻花螳螂",403008,72015,72016}

StrPetMutationEnable[9] = {"鼠王","黃金鼠王",403009,72017,72018}
StrPetMutationEnable[10] = {"水龍蜥","暗黑水龍蜥",403010,72019,72020}

StrPetMutationEnable[11] = {"迷你龍","小白龍",403011,72021,72022}
StrPetMutationEnable[12] = {"煙羅","祥雲寶寶",403012,72023,72024}

StrPetMutationEnable[13] = {"海底龜","萬年龜",403013,72025,72026}
StrPetMutationEnable[14] = {"堀地蟲","金甲蟲",403014,72027,72028}
StrPetMutationEnable[15] = {"石像怪","石像魔王",403015,72029,72030}
------------------------------------------------------------------------------

Delegate.RegInit("PetMutation_Init");

function initPetMutationNpc_Init(index)
	print("宠物不变异变NPC_index = " .. index);
	return 1;
end

function PetMutation_create()
	if (PetMutationNPC == nil) then
		PetMutationNPC = NL.CreateNpc("lua/Module/PetMutation.lua", "initPetMutationNpc_Init");
		Char.SetData(PetMutationNPC,%对象_形象%,14087);
		Char.SetData(PetMutationNPC,%对象_原形%,14087);
		Char.SetData(PetMutationNPC,%对象_地图%,25007);
		Char.SetData(PetMutationNPC,%对象_X%,10);
		Char.SetData(PetMutationNPC,%对象_Y%,10);
		Char.SetData(PetMutationNPC,%对象_方向%,6);
		Char.SetData(PetMutationNPC,%对象_名字%,"洛伊克博士");
		NLG.UpChar(PetMutationNPC);
		Char.SetTalkedEvent("lua/Module/PetMutation.lua", "PetMutationWindow", PetMutationNPC);
		Char.SetWindowTalkedEvent("lua/Module/PetMutation.lua", "PetMutationFunction", PetMutationNPC);
	end
end

NL.RegItemString("lua/Module/PetMutation.lua","PetMutation","LUA_usePetMuta");
function PetMutation(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(PetMutationNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n哦．．．你手上拿的是異變核心嘛．．．帶變異寵物來，我就幫你強化他。  \\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_PlayerIndex,i);
	
			if(VaildChar(pet)==false)then
				WindowMsg = WindowMsg .. "空\\n";
			else
				WindowMsg = WindowMsg .. ""..Char.GetData(pet,%对象_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,PetMutationNPC,%窗口_选择框%,%按钮_关闭%,5,WindowMsg);
	end
	return;
end


function PetMutationWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		if (Char.PetNum(_PlayerIndex) >= 5) then
			NLG.SystemMessage(_PlayerIndex, "[系統]寵物欄位置不夠。")
			return;
		end
		for slot=0,4 do
			local R_PetIndex = Char.GetPet(_PlayerIndex,slot);
			local PetID = Char.GetData(R_PetIndex,%对象_原名%);
			for i=1,15 do
			if (PetID == StrPetMutationEnable[i][2]) then
				NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄不能有變異寵物。")
				return;
			end
			end
		end
		WindowMsg = "4|\\n\\n你帶來的材料．．．看來可以讓這只魔物發生異變，要試試看嗎？  \\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_PlayerIndex,i);
	
			if(VaildChar(pet)==false)then
				WindowMsg = WindowMsg .. "空\\n";
			else
				WindowMsg = WindowMsg .. ""..Char.GetData(pet,%对象_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_选择框%,%按钮_关闭%,1,WindowMsg);
	end
	return;
end

--宠物異變
function PetMutationFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if (_SqeNo==1) then
		selectitem = tonumber(_data) - 1;
		print(tonumber(_data));
		if(selectitem == nil or selectitem > 4 or selectitem < 0) then
			--NLG.SystemMessage(_PlayerIndex,"[系统]您所选择的位置不正常!");
			return;
		end
		_PetIndex = Char.GetPet(_PlayerIndex,selectitem);
		EnemyID = Char.GetData(_PetIndex,%对象_原名%);

		if (VaildChar(_PetIndex) == false) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確定您對應的寵物欄有寵物!");
			return;
		end
--		if(Char.GetData(_PetIndex,%对象_等级%) ~= 1) then
--			NLG.SystemMessage(_PlayerIndex,"[系统]无法对非1级宠物进行异变!");
--			return;
--		end
		if(Char.GetData(_PetIndex,%对象_名色%) ~= 0) then
			NLG.SystemMessage(_PlayerIndex,"[系統]無法對轉生寵物進行異變!");
			return;
		end
--		if Char.GetData(_PetIndex,%宠物_获取时等级%) ~= 1 then
--			NLG.SystemMessage(_PlayerIndex,"[系统] 野生宠物无法异变。")
--			return;
--		end
		Level = Char.GetData(_PetIndex,%对象_等级%);
		arr_rank1 = Pet.GetArtRank(_PetIndex,%宠档_体成%);
		arr_rank11 = Pet.FullArtRank(_PetIndex,%宠档_体成%);
		arr_rank2 = Pet.GetArtRank(_PetIndex,%宠档_力成%);
		arr_rank21 = Pet.FullArtRank(_PetIndex,%宠档_力成%);
		arr_rank3 = Pet.GetArtRank(_PetIndex,%宠档_强成%);
		arr_rank31 = Pet.FullArtRank(_PetIndex,%宠档_强成%);
		arr_rank4 = Pet.GetArtRank(_PetIndex,%宠档_敏成%);
		arr_rank41 = Pet.FullArtRank(_PetIndex,%宠档_敏成%);
		arr_rank5 = Pet.GetArtRank(_PetIndex,%宠档_魔成%);
		arr_rank51 = Pet.FullArtRank(_PetIndex,%宠档_魔成%);
		a1 = math.abs(arr_rank1 - arr_rank11);
		a2 = math.abs(arr_rank2 - arr_rank21);
		a3 = math.abs(arr_rank3 - arr_rank31);
		a4 = math.abs(arr_rank4 - arr_rank41);
		a5 = math.abs(arr_rank5 - arr_rank51);
		a6 = a1 + a2+ a3+ a4+ a5;
		if a6 > 20 then
			NLG.SystemMessage(_PlayerIndex,"[系統]無法對白化寵物進行異變!");
			return;
		end
		local	PetInfoMsg = "寵 物 名:  "..Char.GetData(_PetIndex,%对象_名字%).."\\n"
					.."         【檔  次  分  布】\\n"
					.."體力檔數:  -"..a1.." 檔      敏捷檔數:  -"..a4.." 檔 \\n"
					.."力量檔數:  -"..a2.." 檔      魔法檔數:  -"..a5.." 檔 \\n"
					.."防禦檔數:  -"..a3.." 檔      掉 檔 數:  -"..a6.." \\n"
					.."   \\n"
					.."每次需5000研究費用，機率異變成功\\n"
					.."寵物等級越高，異變成功率越高\\n"
					.."失敗得到契約1個，收齊20個相同契約下次必成功\\n"
					.."選【是】進行異變，檔次不會改變 \\n";
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[1][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[1][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[1][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 1;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[2][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[2][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[2][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 2;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[3][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[3][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[3][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 3;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[4][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[4][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[4][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 4;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[5][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[5][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[5][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 5;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[6][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[6][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[6][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 6;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[7][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[7][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[7][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 7;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[8][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[8][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[8][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 8;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[9][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[9][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[9][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 9;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[10][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[10][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[10][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 10;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[11][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[11][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[11][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 11;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[12][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[12][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[12][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 12;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[13][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[13][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[13][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 13;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[14][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[14][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[14][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 14;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[15][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[15][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有異變核心");
			end
		else
			if (EnemyID == StrPetMutationEnable[15][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 15;
			end
		end
	end
	if (_SqeNo==12 and _select==4) then
		if (Char.GetData(_PlayerIndex, %对象_金币%) < 5000) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確認金錢尚有每次的研究費用五千G!");
			return;
		end
		local M_Point = 21 - math.ceil(Level/10);
		local M_Rate = math.random( 1, M_Point );
		if ( M_Rate ~=1 and Char.ItemNum(_PlayerIndex,StrPetMutationEnable[EnemyNum][5]) < 20) then
			Char.DelItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][4],20);
			Char.GiveItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][5],1);
			Char.AddGold(_PlayerIndex,-5000);
			NLG.SystemMessage(_PlayerIndex,"[系統]此次的變異研究失敗!");
			return;
		end
		if ( M_Rate ~=1 and Char.ItemNum(_PlayerIndex,StrPetMutationEnable[EnemyNum][5]) >= 20) then
			Char.AddPet(_PlayerIndex,StrPetMutationEnable[EnemyNum][3]);
			for Slot=0,4 do
				local R_PetIndex = Char.GetPet(_PlayerIndex,Slot);
				local PetID = Char.GetData(R_PetIndex,%对象_原名%);
				if (PetID == StrPetMutationEnable[EnemyNum][2] ) then
					Pet.SetArtRank(R_PetIndex,%宠档_体成%,Pet.FullArtRank(R_PetIndex,%宠档_体成%) - a1);
					Pet.SetArtRank(R_PetIndex,%宠档_力成%,Pet.FullArtRank(R_PetIndex,%宠档_力成%) - a2);
					Pet.SetArtRank(R_PetIndex,%宠档_强成%,Pet.FullArtRank(R_PetIndex,%宠档_强成%) - a3);
					Pet.SetArtRank(R_PetIndex,%宠档_敏成%,Pet.FullArtRank(R_PetIndex,%宠档_敏成%) - a4);
					Pet.SetArtRank(R_PetIndex,%宠档_魔成%,Pet.FullArtRank(R_PetIndex,%宠档_魔成%) - a5);
					Pet.ReBirth(_PlayerIndex, R_PetIndex);
					Pet.UpPet(_PlayerIndex,R_PetIndex);
					Char.DelItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][4],20);
					Char.DelItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][5],20);
					Char.DelSlotPet(_PlayerIndex,selectitem);
					Char.AddGold(_PlayerIndex,-5000);
					local arr_rank1_new = Pet.GetArtRank(R_PetIndex,%宠档_体成%);
					local arr_rank2_new = Pet.GetArtRank(R_PetIndex,%宠档_力成%);
					local arr_rank3_new = Pet.GetArtRank(R_PetIndex,%宠档_强成%);
					local arr_rank4_new = Pet.GetArtRank(R_PetIndex,%宠档_敏成%);
					local arr_rank5_new = Pet.GetArtRank(R_PetIndex,%宠档_魔成%);
					if(Level~=1 ) then
						Char.SetData(R_PetIndex,%对象_升级点%,Level-1);
						Char.SetData(R_PetIndex,%对象_等级%,Level);
						Char.SetData(R_PetIndex,%对象_体力%, (Char.GetData(R_PetIndex,%对象_体力%) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%对象_力量%, (Char.GetData(R_PetIndex,%对象_力量%) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%对象_强度%, (Char.GetData(R_PetIndex,%对象_强度%) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%对象_速度%, (Char.GetData(R_PetIndex,%对象_速度%) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%对象_魔法%, (Char.GetData(R_PetIndex,%对象_魔法%) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
						Pet.UpPet(_PlayerIndex,R_PetIndex);
					end
				end
			end
		end
		if ( M_Rate ==1 ) then
			Char.AddPet(_PlayerIndex,StrPetMutationEnable[EnemyNum][3]);
			for Slot=0,4 do
				local R_PetIndex = Char.GetPet(_PlayerIndex,Slot);
				local PetID = Char.GetData(R_PetIndex,%对象_原名%);
				if (PetID == StrPetMutationEnable[EnemyNum][2] ) then
					Pet.SetArtRank(R_PetIndex,%宠档_体成%,Pet.FullArtRank(R_PetIndex,%宠档_体成%) - a1);
					Pet.SetArtRank(R_PetIndex,%宠档_力成%,Pet.FullArtRank(R_PetIndex,%宠档_力成%) - a2);
					Pet.SetArtRank(R_PetIndex,%宠档_强成%,Pet.FullArtRank(R_PetIndex,%宠档_强成%) - a3);
					Pet.SetArtRank(R_PetIndex,%宠档_敏成%,Pet.FullArtRank(R_PetIndex,%宠档_敏成%) - a4);
					Pet.SetArtRank(R_PetIndex,%宠档_魔成%,Pet.FullArtRank(R_PetIndex,%宠档_魔成%) - a5);
					Pet.ReBirth(_PlayerIndex, R_PetIndex);
					Pet.UpPet(_PlayerIndex,R_PetIndex);
					Char.DelItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][4],20);
					Char.DelSlotPet(_PlayerIndex,selectitem);
					Char.AddGold(_PlayerIndex,-5000);
					local arr_rank1_new = Pet.GetArtRank(R_PetIndex,%宠档_体成%);
					local arr_rank2_new = Pet.GetArtRank(R_PetIndex,%宠档_力成%);
					local arr_rank3_new = Pet.GetArtRank(R_PetIndex,%宠档_强成%);
					local arr_rank4_new = Pet.GetArtRank(R_PetIndex,%宠档_敏成%);
					local arr_rank5_new = Pet.GetArtRank(R_PetIndex,%宠档_魔成%);
					if(Level~=1 ) then
						Char.SetData(R_PetIndex,%对象_升级点%,Level-1);
						Char.SetData(R_PetIndex,%对象_等级%,Level);
						Char.SetData(R_PetIndex,%对象_体力%, (Char.GetData(R_PetIndex,%对象_体力%) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%对象_力量%, (Char.GetData(R_PetIndex,%对象_力量%) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%对象_强度%, (Char.GetData(R_PetIndex,%对象_强度%) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%对象_速度%, (Char.GetData(R_PetIndex,%对象_速度%) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%对象_魔法%, (Char.GetData(R_PetIndex,%对象_魔法%) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
						Pet.UpPet(_PlayerIndex,R_PetIndex);
					end
				end
			end	
		end
	end
	if (_SqeNo==12 and _select==8) then
		return;
	end
	if (_SqeNo==5) then
		selectitem = tonumber(_data) - 1;
		_PetIndex = Char.GetPet(_PlayerIndex,selectitem);
		EnemyID = Char.GetData(_PetIndex,%对象_原名%);
		local ground = Char.GetData(_PetIndex,%对象_地属性%)
		local water = Char.GetData(_PetIndex,%对象_水属性%)
		local fire = Char.GetData(_PetIndex,%对象_火属性%)
		local wind = Char.GetData(_PetIndex,%对象_风属性%)
		if(selectitem == nil or selectitem > 4 or selectitem < 0) then
			NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄需有變異寵物。");
			return;
		end
		if(Char.ItemNum(_PlayerIndex,72000) < 100) then
			NLG.SystemMessage(_PlayerIndex, "[系統]強化須要異變核心至少100個。");
			return;
		end
		if(string.find(EnemyID,"+") ~= nill ) then
			NLG.SystemMessage(_PlayerIndex, "[系統]變異寵物已經強化過。");
			return;
		end
		if(EnemyID == StrPetMutationEnable[1][2] or EnemyID == StrPetMutationEnable[2][2] or EnemyID == StrPetMutationEnable[3][2] or 
			EnemyID == StrPetMutationEnable[4][2] or EnemyID == StrPetMutationEnable[5][2] or EnemyID == StrPetMutationEnable[6][2] or 
			EnemyID == StrPetMutationEnable[7][2] or EnemyID == StrPetMutationEnable[8][2] or EnemyID == StrPetMutationEnable[9][2] or 
			EnemyID == StrPetMutationEnable[10][2] or EnemyID == StrPetMutationEnable[11][2] or EnemyID == StrPetMutationEnable[12][2] or 
			EnemyID == StrPetMutationEnable[13][2] or EnemyID == StrPetMutationEnable[14][2] or EnemyID == StrPetMutationEnable[15][2]) then
			if (ground >0 ) then
				Char.SetData(_PetIndex,%对象_地属性%, Char.GetData(_PetIndex,%对象_地属性%) +10);
				Pet.UpPet(_PlayerIndex,_PetIndex);
			end
			if (water >0 ) then
				Char.SetData(_PetIndex,%对象_水属性%, Char.GetData(_PetIndex,%对象_水属性%) +10);
				Pet.UpPet(_PlayerIndex,_PetIndex);
			end
			if (fire >0 ) then
				Char.SetData(_PetIndex,%对象_火属性%, Char.GetData(_PetIndex,%对象_火属性%) +10);
				Pet.UpPet(_PlayerIndex,_PetIndex);
			end
			if (wind >0 ) then
				Char.SetData(_PetIndex,%对象_风属性%, Char.GetData(_PetIndex,%对象_风属性%) +10);
				Pet.UpPet(_PlayerIndex,_PetIndex);
			end
			Char.DelItem(_PlayerIndex,72000,100);
			Char.SetData(_PetIndex,%对象_原名%, EnemyID.."+" );
			Pet.UpPet(_PlayerIndex,_PetIndex);
			NLG.SystemMessage(_PlayerIndex, "[系統]變異寵物強化成功!");
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]只有變異寵物可以強化。");
			return;
		end
	end
end

function PetMutation_Init()
	PetMutation_create();

end
