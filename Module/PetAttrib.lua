------------------------------------------------------------------------------
local itemid_70052 = 70052;
------------------------------------------------------------------------------

Delegate.RegInit("PetAttrib_Init");

function initPetAttribNpc_Init(index)
	print("宠物属性洗档NPC_index = " .. index);
	return 1;
end

function PetAttrib_create()
	if (PetAttribNPC == nil) then
		PetAttribNPC = NL.CreateNpc("lua/Module/PetAttrib.lua", "initPetAttribNpc_Init");
		Char.SetData(PetAttribNPC,%对象_形象%,101025);
		Char.SetData(PetAttribNPC,%对象_原形%,101025);
		Char.SetData(PetAttribNPC,%对象_地图%,1180);
		Char.SetData(PetAttribNPC,%对象_X%,10);
		Char.SetData(PetAttribNPC,%对象_Y%,5);
		Char.SetData(PetAttribNPC,%对象_方向%,4);
		Char.SetData(PetAttribNPC,%对象_名字%,"寵物洗檔大師");
		NLG.UpChar(PetAttribNPC);
		Char.SetTalkedEvent("lua/Module/PetAttrib.lua", "PetAttribWindow", PetAttribNPC);
		Char.SetWindowTalkedEvent("lua/Module/PetAttrib.lua", "PetAttribFunction", PetAttribNPC);
	end
end

NL.RegItemString("lua/Module/PetAttrib.lua","PetAttrib","LUA_usePetAtt");
function PetAttrib(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(PetAttribNPC,_PlayerIndex) == false) then
		WindowMsg = "3|\\n\\n           請選擇您要洗檔的寵物名稱  \\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_PlayerIndex,i);
	
			if(VaildChar(pet)==false)then
				WindowMsg = WindowMsg .. "空\\n";
			else
				WindowMsg = WindowMsg .. ""..Char.GetData(pet,%对象_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,PetAttribNPC,%窗口_选择框%,%按钮_关闭%,1,WindowMsg);
	end
	return;
end


function PetAttribWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "3|\\n\\n           請選擇您要洗檔的寵物名稱  \\n\\n";
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

--宠物属性
function PetAttribFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if (_SqeNo==1) then
		local selectitem = tonumber(_data) - 1;
		print(tonumber(_data));
		if(selectitem == nil or selectitem > 4 or selectitem < 0) then
			--NLG.SystemMessage(_PlayerIndex,"[系统]您所选择的位置不正常!");
			return;
		end
		_PetIndex = Char.GetPet(_PlayerIndex,selectitem);
		if (VaildChar(_PetIndex) == false) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確定您對應的寵物欄有寵物!");
			return;
		end
--		if(Char.GetData(_PetIndex,%对象_等级%) ~= 1) then
--			NLG.SystemMessage(_PlayerIndex,"[系统]无法对非1级宠物进行洗档!");
--			return;
--		end
		if(Char.GetData(_PetIndex,%对象_名色%) ~= 0) then
			NLG.SystemMessage(_PlayerIndex,"[系統]無法對轉生寵物進行洗檔!");
			return;
		end
--		if Char.GetData(_PetIndex,%宠物_获取时等级%) ~= 1 then
--			NLG.SystemMessage(_PlayerIndex,"[系统] 野生宠物无法洗档。")
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
	end
	if a6 == 0 then
		NLG.SystemMessage(_PlayerIndex,"[系統]您的寵物 "..Char.GetData(_PetIndex,%对象_名字%).." 已經是滿檔!");
		return;
	end
	if a6 > 20 then
		NLG.SystemMessage(_PlayerIndex,"[系統]無法對白化寵物進行洗檔!");
		return;
	end
	if (_SqeNo==1 and Char.ItemNum(_PlayerIndex,itemid_70052) == 0) then
		NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄有洗檔道具");
		return;
	end
	if (_SqeNo==1 and Char.ItemNum(_PlayerIndex,itemid_70052) > 0) then
		Pet.SetArtRank(_PetIndex,%宠档_体成%,Pet.FullArtRank(_PetIndex,%宠档_体成%) - math.random(0,4));
		Pet.SetArtRank(_PetIndex,%宠档_力成%,Pet.FullArtRank(_PetIndex,%宠档_力成%) - math.random(0,4));
		Pet.SetArtRank(_PetIndex,%宠档_强成%,Pet.FullArtRank(_PetIndex,%宠档_强成%) - math.random(0,4));
		Pet.SetArtRank(_PetIndex,%宠档_敏成%,Pet.FullArtRank(_PetIndex,%宠档_敏成%) - math.random(0,4));
		Pet.SetArtRank(_PetIndex,%宠档_魔成%,Pet.FullArtRank(_PetIndex,%宠档_魔成%) - math.random(0,4));

		Pet.ReBirth(_PlayerIndex, _PetIndex);
		Pet.UpPet(_PlayerIndex,_PetIndex);
		Char.DelItem(_PlayerIndex,itemid_70052,1);
		local arr_rank1_new = Pet.GetArtRank(_PetIndex,%宠档_体成%);
		local arr_rank2_new = Pet.GetArtRank(_PetIndex,%宠档_力成%);
		local arr_rank3_new = Pet.GetArtRank(_PetIndex,%宠档_强成%);
		local arr_rank4_new = Pet.GetArtRank(_PetIndex,%宠档_敏成%);
		local arr_rank5_new = Pet.GetArtRank(_PetIndex,%宠档_魔成%);
		local a1_new = math.abs(arr_rank1_new - arr_rank11);
		local a2_new = math.abs(arr_rank2_new - arr_rank21);
		local a3_new = math.abs(arr_rank3_new - arr_rank31);
		local a4_new = math.abs(arr_rank4_new - arr_rank41);
		local a5_new = math.abs(arr_rank5_new - arr_rank51);
		local a6_new = a1_new + a2_new+ a3_new+ a4_new+ a5_new;
		if(Level~=1) then
			Char.SetData(_PetIndex,%对象_升级点%,Level-1);
			Char.SetData(_PetIndex,%对象_等级%,Level);
			Char.SetData(_PetIndex,%对象_体力%, (Char.GetData(_PetIndex,%对象_体力%) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%对象_力量%, (Char.GetData(_PetIndex,%对象_力量%) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%对象_强度%, (Char.GetData(_PetIndex,%对象_强度%) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%对象_速度%, (Char.GetData(_PetIndex,%对象_速度%) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%对象_魔法%, (Char.GetData(_PetIndex,%对象_魔法%) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
			Pet.UpPet(_PlayerIndex,_PetIndex);
		end
		local	PetInfoMsg = "寵 物 名:  "..Char.GetData(_PetIndex,%对象_名字%).."\\n"
					.."         【新掉檔】    【前掉檔】 \\n"
					.."體力檔數:  -"..a1_new.." 檔       -"..a1.." 檔 \\n"
					.."力量檔數:  -"..a2_new.." 檔       -"..a2.." 檔 \\n"
					.."防禦檔數:  -"..a3_new.." 檔       -"..a3.." 檔 \\n"
					.."敏捷檔數:  -"..a4_new.." 檔       -"..a4.." 檔 \\n"
					.."魔法檔數:  -"..a5_new.." 檔       -"..a5.." 檔 \\n"
					.."掉 檔 數:  -"..a6_new.."         -"..a6.." \\n"
					.."選【是】保留新掉檔     選【否】回復前掉檔 \\n"
					.."※如不選擇而關閉視窗會是新掉檔 \\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是否%,12,PetInfoMsg);
	end
	if (_SqeNo==12 and _select==4) then
		NLG.SystemMessage(_PlayerIndex,"[系統]您的寵物 "..Char.GetData(_PetIndex,%对象_名字%).." 洗檔完畢!");
	end
	if (_SqeNo==12 and _select==8) then
		Pet.SetArtRank(_PetIndex,%宠档_体成%,arr_rank1);
		Pet.SetArtRank(_PetIndex,%宠档_力成%,arr_rank2);
		Pet.SetArtRank(_PetIndex,%宠档_强成%,arr_rank3);
		Pet.SetArtRank(_PetIndex,%宠档_敏成%,arr_rank4);
		Pet.SetArtRank(_PetIndex,%宠档_魔成%,arr_rank5);
		Pet.ReBirth(_PlayerIndex, _PetIndex);
		Pet.UpPet(_PlayerIndex,_PetIndex);
		if(Level~=1) then
			Char.SetData(_PetIndex,%对象_升级点%,Level-1);
			Char.SetData(_PetIndex,%对象_等级%,Level);
			Char.SetData(_PetIndex,%对象_体力%, (Char.GetData(_PetIndex,%对象_体力%) + (arr_rank1 * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%对象_力量%, (Char.GetData(_PetIndex,%对象_力量%) + (arr_rank2 * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%对象_强度%, (Char.GetData(_PetIndex,%对象_强度%) + (arr_rank3 * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%对象_速度%, (Char.GetData(_PetIndex,%对象_速度%) + (arr_rank4 * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%对象_魔法%, (Char.GetData(_PetIndex,%对象_魔法%) + (arr_rank5 * (1/24) * (Level - 1)*100)) );
			Pet.UpPet(_PlayerIndex,_PetIndex);
		end
		NLG.SystemMessage(_PlayerIndex,"[系統]您的寵物 "..Char.GetData(_PetIndex,%对象_名字%).." 回復檔次!");
	end
end

function PetAttrib_Init()
	PetAttrib_create();

end
