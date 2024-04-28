------------------------------------------------------------------------------
local StrPetConvertEnable = {}
------------------------------------------------------------------------------
--  一种改造一列                                          --
StrPetConvertEnable[1] = {"大地鼠","改造大地鼠",2013,18602,18603,18604}      --原名,改造原名,改造编号,所需改造图道具编号
StrPetConvertEnable[2] = {"火焰鼠","改造火焰鼠",2014,18605,18606,18607}
StrPetConvertEnable[3] = {"鳥人","改造鳥人",2015,18608,18609,18610,18611}
StrPetConvertEnable[4] = {"寒冰翼龍","改造寒冰翼龍",2016,18612,18613,18614,18615}
StrPetConvertEnable[5] = {"純白嚇人箱","改造旋律影子",2017,18616,18617,18618,18619,18620}

StrPetConvertEnable[6] = {"僵屍","改造僵屍",2019,18641,18642,18643}
StrPetConvertEnable[7] = {"水蜘蛛","改造水蜘蛛",2020,18644,18645,18646,18647}
StrPetConvertEnable[8] = {"綠色口臭鬼","改造綠色口臭鬼",2021,18648,18649,18650,18651,18652}
StrPetConvertEnable[9] = {"兔耳嚇人箱","改造陰影",2022,18653,18654,18655,18656,18657}

StrPetConvertEnable[10] = {"史萊姆","改造史萊姆",2027,18918,18919,18920}
StrPetConvertEnable[11] = {"蜥蜴戰士","改造蜥蜴戰士",2028,18921,18922,18923,18924}
StrPetConvertEnable[12] = {"迷你蝙蝠","改造迷你蝙蝠",2029,18925,18926,18927,18928,18929}
StrPetConvertEnable[13] = {"烈風哥布林","改造烈風哥布林",2030,18934,18935,18936,18937,18938}
StrPetConvertEnable[14] = {"改造水蜘蛛","二次改造水蜘蛛",2031,18939,18940,18941,18942,18943}
StrPetConvertEnable[15] = {"地獄妖犬","改造地獄妖犬",2032,17747,17748,17749,17750}

StrPetConvertEnable[16] = {"鍬型蟲","R鍬型蟲",307390,623520,623521,623522,623523}
StrPetConvertEnable[17] = {"水藍菇","R水藍菇",307391,623524,623525,623526,623527}
StrPetConvertEnable[18] = {"影岩","R影岩",307392,623528,623528,623530}
StrPetConvertEnable[19] = {"煙羅","R煙羅",307393,623531,623532,623533}
StrPetConvertEnable[20] = {"掃把蝙蝠","改造掃把蝙蝠",307394,623534,623535,623536,623537,623538}
StrPetConvertEnable[21] = {"黃蠍","改造黃蠍",307395,623539,623540,623541}
StrPetConvertEnable[22] = {"樹精","改造樹精",307396,623542,623543,623544}

StrPetConvertEnable[23] = {"陸行鯊","陸行鯊後期型",300005,620029}
StrPetConvertEnable[24] = {"布卡","布卡四重奏",311600,631008,631009,631010,631011,631012,631013,631014,631015}
------------------------------------------------------------------------------
local a1 = {101020,101021,101022,101023};
local a2 = {101831,101832,101833,101834};
local a3 = {101101,101102,101103,101104};
local a4 = {101330,101331,101332,101333};
local a5 = {101420,101421,101422,101423};
local a6 = {101700,101701,101702,101703};
local a7 = {101241,101243,101244,101245};
local a8 = {107400,107401,107402,107403};
local a9 = {101401,101402,101403,101404,101405};
local a10 = {110300,110301,110302,110303};
local ConvertImage = {a1,a2,a3,a4,a5,a6,a7,a8,a9,a10};
------------------------------------------------------------------------------

Delegate.RegInit("PetConvert_Init");

function initPetConvertNpc_Init(index)
	print("宠物不变改造NPC_index = " .. index);
	return 1;
end

function PetConvert_create()
	if (PetConvertNPC == nil) then
		PetConvertNPC = NL.CreateNpc("lua/Module/PetConvert.lua", "initPetConvertNpc_Init");
		Char.SetData(PetConvertNPC,%对象_形象%,14146);
		Char.SetData(PetConvertNPC,%对象_原形%,14146);
		Char.SetData(PetConvertNPC,%对象_地图%,1000);
		Char.SetData(PetConvertNPC,%对象_X%,195);
		Char.SetData(PetConvertNPC,%对象_Y%,67);
		Char.SetData(PetConvertNPC,%对象_方向%,6);
		Char.SetData(PetConvertNPC,%对象_名字%,"裘瑟貝");
		NLG.UpChar(PetConvertNPC);
		Char.SetTalkedEvent("lua/Module/PetConvert.lua", "PetConvertWindow", PetConvertNPC);
		Char.SetWindowTalkedEvent("lua/Module/PetConvert.lua", "PetConvertFunction", PetConvertNPC);
	end
end

NL.RegItemString("lua/Module/PetConvert.lua","PetConvert","LUA_usePetConv");
function PetConvert(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(PetConvertNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n哦．．．你手上拿的是異色進化石嘛．．．帶一隻改造寵物來，我就幫你手術。 \\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_PlayerIndex,i);
	
			if(VaildChar(pet)==false)then
				WindowMsg = WindowMsg .. "空\\n";
			else
				WindowMsg = WindowMsg .. ""..Char.GetData(pet,%对象_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,PetConvertNPC,%窗口_选择框%,%按钮_关闭%,5,WindowMsg);
	end
	return;
end


function PetConvertWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		if (Char.PetNum(_PlayerIndex) >= 5) then
			NLG.SystemMessage(_PlayerIndex, "[系統]寵物欄位置不夠。")
			return;
		end
		for slot=0,4 do
			local R_PetIndex = Char.GetPet(_PlayerIndex,slot);
			local PetID = Char.GetData(R_PetIndex,%对象_原名%);
			for i=1,24 do
			if (PetID == StrPetConvertEnable[i][2]) then
				NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄不能有改造寵物。")
				return;
			end
			end
		end
		WindowMsg = "4|\\n\\n哦．．．你手上拿的是改造圖嘛．．．收集齊全之後帶一隻來，我就幫你改造。  \\n\\n";
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

--宠物改造
function PetConvertFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
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
--			NLG.SystemMessage(_PlayerIndex,"[系统]无法对非1级宠物进行改造!");
--			return;
--		end
		if(Char.GetData(_PetIndex,%对象_名色%) ~= 0) then
			NLG.SystemMessage(_PlayerIndex,"[系統]無法對轉生寵物進行改造!");
			return;
		end
--		if Char.GetData(_PetIndex,%宠物_获取时等级%) ~= 1 then
--			NLG.SystemMessage(_PlayerIndex,"[系统] 野生宠物无法改造。")
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
			NLG.SystemMessage(_PlayerIndex,"[系統]無法對白化寵物進行改造!");
			return;
		end
		local	PetInfoMsg = "寵 物 名:  "..Char.GetData(_PetIndex,%对象_名字%).."\\n"
					.."         【檔次分佈】\\n"
					.."體力檔數:  -"..a1.." 檔 \\n"
					.."力量檔數:  -"..a2.." 檔 \\n"
					.."防禦檔數:  -"..a3.." 檔 \\n"
					.."敏捷檔數:  -"..a4.." 檔 \\n"
					.."魔法檔數:  -"..a5.." 檔 \\n"
					.."掉 檔 數:  -"..a6.." \\n"
					.."選【是】進行改造 \\n";
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[1][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[1][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[1][6]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[1][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[1][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 1;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[2][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[2][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[2][6]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[2][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[2][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 2;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[3][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[3][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[3][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[3][7]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[3][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[3][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 3;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[4][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[4][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[4][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[4][7]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[4][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[4][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 4;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[5][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[5][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[5][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[5][7]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[5][8]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[5][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[5][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 5;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[6][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[6][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[6][6]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[6][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[6][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 6;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[7][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[7][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[7][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[7][7]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[7][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[7][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 7;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[8][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[8][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[8][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[8][7]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[8][8]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[8][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[8][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 8;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[9][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[9][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[9][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[9][7]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[9][8]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[9][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[9][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 9;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[10][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[10][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[10][6]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[10][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[10][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 10;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[11][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[11][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[11][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[11][7]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[11][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[11][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 11;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[12][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[12][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[12][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[12][7]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[12][8]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[12][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[12][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 12;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[13][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[13][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[13][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[13][7]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[13][8]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[13][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[13][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 13;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[14][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[14][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[14][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[14][7]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[14][8]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[14][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[14][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 14;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[15][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[15][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[15][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[15][7]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[15][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[15][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 15;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[16][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[16][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[16][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[16][7]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[16][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[16][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 16;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[17][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[17][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[17][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[17][7]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[17][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[17][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 17;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[18][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[18][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[18][6]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[18][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[18][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 18;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[19][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[19][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[19][6]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[19][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[19][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 19;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[20][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[20][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[20][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[20][7]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[20][8]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[20][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[20][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 20;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[21][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[21][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[21][6]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[21][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[21][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 21;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[22][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[22][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[22][6]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[22][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[22][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 22;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[23][4]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[23][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[23][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 23;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetConvertEnable[24][4]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[24][5]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[24][6]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[24][7]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[24][8]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[24][9]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[24][10]) == 0 or Char.ItemNum(_PlayerIndex,StrPetConvertEnable[24][11]) == 0 ) then
			if (EnemyID == StrPetConvertEnable[24][1]) then
				NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有改造設計圖");
			end
		else
			if (EnemyID == StrPetConvertEnable[24][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
				EnemyNum = 24;
			end
		end
	end
	if (_SqeNo==12 and _select==4) then
		Char.AddPet(_PlayerIndex,StrPetConvertEnable[EnemyNum][3]);

		for Slot=0,4 do
			R_PetIndex = Char.GetPet(_PlayerIndex,Slot);
			PetID = Char.GetData(R_PetIndex,%对象_原名%);
			if (PetID == StrPetConvertEnable[EnemyNum][2]) then
			Pet.SetArtRank(R_PetIndex,%宠档_体成%,Pet.FullArtRank(R_PetIndex,%宠档_体成%) - a1);
			Pet.SetArtRank(R_PetIndex,%宠档_力成%,Pet.FullArtRank(R_PetIndex,%宠档_力成%) - a2);
			Pet.SetArtRank(R_PetIndex,%宠档_强成%,Pet.FullArtRank(R_PetIndex,%宠档_强成%) - a3);
			Pet.SetArtRank(R_PetIndex,%宠档_敏成%,Pet.FullArtRank(R_PetIndex,%宠档_敏成%) - a4);
			Pet.SetArtRank(R_PetIndex,%宠档_魔成%,Pet.FullArtRank(R_PetIndex,%宠档_魔成%) - a5);
			Pet.ReBirth(_PlayerIndex, R_PetIndex);
			Pet.UpPet(_PlayerIndex,R_PetIndex);
			Char.DelItem(_PlayerIndex,StrPetConvertEnable[EnemyNum][4],1);
			Char.DelItem(_PlayerIndex,StrPetConvertEnable[EnemyNum][5],1);
			Char.DelItem(_PlayerIndex,StrPetConvertEnable[EnemyNum][6],1);
			Char.DelItem(_PlayerIndex,StrPetConvertEnable[EnemyNum][7],1);
			Char.DelItem(_PlayerIndex,StrPetConvertEnable[EnemyNum][8],1);
			Char.DelItem(_PlayerIndex,StrPetConvertEnable[EnemyNum][9],1);
			Char.DelItem(_PlayerIndex,StrPetConvertEnable[EnemyNum][10],1);
			Char.DelItem(_PlayerIndex,StrPetConvertEnable[EnemyNum][11],1);
			Char.DelSlotPet(_PlayerIndex,selectitem);
			local arr_rank1_new = Pet.GetArtRank(R_PetIndex,%宠档_体成%);
			local arr_rank2_new = Pet.GetArtRank(R_PetIndex,%宠档_力成%);
			local arr_rank3_new = Pet.GetArtRank(R_PetIndex,%宠档_强成%);
			local arr_rank4_new = Pet.GetArtRank(R_PetIndex,%宠档_敏成%);
			local arr_rank5_new = Pet.GetArtRank(R_PetIndex,%宠档_魔成%);
			if(Level~=1) then
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
	if (_SqeNo==12 and _select==8) then
		return;
	end
	if (_SqeNo==5) then
		selectitem = tonumber(_data) - 1;
		_PetIndex = Char.GetPet(_PlayerIndex,selectitem);
		EnemyID = Char.GetData(_PetIndex,%对象_原名%);
		if(selectitem == nil or selectitem > 4 or selectitem < 0) then
			NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄需有改造寵物。");
			return;
		end
		if (EnemyID == StrPetConvertEnable[1][2] or EnemyID == StrPetConvertEnable[2][2]) then
			local ar = math.random(1,4);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[1][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[1][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
		if (EnemyID == StrPetConvertEnable[3][2]) then
			local ar = math.random(1,4);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[2][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[2][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
		if (EnemyID == StrPetConvertEnable[6][2]) then
			local ar = math.random(1,4);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[3][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[3][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
		if (EnemyID == StrPetConvertEnable[7][2] or EnemyID == StrPetConvertEnable[14][2]) then
			local ar = math.random(1,4);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[4][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[4][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
		if (EnemyID == StrPetConvertEnable[8][2]) then
			local ar = math.random(1,4);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[5][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[5][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
		if (EnemyID == StrPetConvertEnable[11][2]) then
			local ar = math.random(1,4);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[6][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[6][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
		if (EnemyID == StrPetConvertEnable[12][2] or EnemyID == StrPetConvertEnable[20][2]) then
			local ar = math.random(1,4);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[7][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[7][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
		if (EnemyID == StrPetConvertEnable[17][2]) then
			local ar = math.random(1,4);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[8][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[8][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
		if (EnemyID == StrPetConvertEnable[22][2]) then
			local ar = math.random(1,5);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[9][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[9][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
		if (EnemyID == StrPetConvertEnable[23][2]) then
			local ar = math.random(1,4);
			Char.SetData(_PetIndex,%对象_形象%,ConvertImage[10][ar]);
			Char.SetData(_PetIndex,%对象_原形%,ConvertImage[10][ar]);
			Pet.UpPet(_PlayerIndex,_PetIndex);
			Char.DelItem(_PlayerIndex,68010,1);
		end
	end
end

function PetConvert_Init()
	PetConvert_create();

end
