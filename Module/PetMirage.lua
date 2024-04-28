------------------------------------------------------------------------------
local itemid_card = 70001;
local itemid_ball = 69993;
------------------------------------------------------------------------------
local OverSoulEnable = {}
OverSoulEnable[9305] = 0  --0 禁止超灵体依附的水晶，括号为道具ID
OverSoulEnable[9315] = 0
OverSoulEnable[9325] = 0
OverSoulEnable[9335] = 0
OverSoulEnable[9410] = 0
OverSoulEnable[9420] = 0
OverSoulEnable[9430] = 0
OverSoulEnable[9440] = 0
OverSoulEnable[69129] = 0
OverSoulEnable[69130] = 0
OverSoulEnable[69131] = 0
OverSoulEnable[69132] = 0
OverSoulEnable[69211] = 0
OverSoulEnable[69212] = 0
OverSoulEnable[69213] = 0
OverSoulEnable[69214] = 0
------------------------------------------------------------------------------

Delegate.RegInit("PetMirage_Init");

function initPetMirageNpc_Init(index)
	print("宠物幻化NPC_index = " .. index);
	return 1;
end

function PetMirage_create()
	if (PetMirageNPC == nil) then
		PetMirageNPC = NL.CreateNpc("lua/Module/PetMirage.lua", "initPetMirageNpc_Init");
		Char.SetData(PetMirageNPC,%对象_形象%,104893);
		Char.SetData(PetMirageNPC,%对象_原形%,104893);
		Char.SetData(PetMirageNPC,%对象_地图%,1180);
		Char.SetData(PetMirageNPC,%对象_X%,10);
		Char.SetData(PetMirageNPC,%对象_Y%,15);
		Char.SetData(PetMirageNPC,%对象_方向%,6);
		Char.SetData(PetMirageNPC,%对象_名字%,"通靈人");
		NLG.UpChar(PetMirageNPC);
		Char.SetTalkedEvent("lua/Module/PetMirage.lua", "PetMirageWindow", PetMirageNPC);
		Char.SetWindowTalkedEvent("lua/Module/PetMirage.lua", "PetMirageFunction", PetMirageNPC);
	end
end

function PetMirageWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "3|\\n\\n↓選擇製作成靈體的寵物(回收並提取形象)↓ \\n\\n";
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

NL.RegItemString("lua/Module/PetMirage.lua","TransPet","LUA_useTransPet");
function TransPet(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	ItemID = Item.GetData(Char.GetItemIndex(_PlayerIndex,_itemslot),0);
	local TalkMsg =		"\\n                ◆寵物超靈體◆" ..
				"\\n將寵物形象和屬性附身至水晶" ..
				"\\n並使角色外觀改變為寵物形象" ..
				"\\n " ..
				"\\n卸下水晶即解除超靈體狀態" ..
				"\\n裝備水晶即回復超靈體狀態" ..
				"\\n " ..
				"\\n選擇    『依附在水晶』"..
				"\\n "
	NLG.ShowWindowTalked(_PlayerIndex, PetMirageNPC,%窗口_信息框%,%按钮_是否%, 2, TalkMsg);
	return 1;
end

--宠物幻化
function PetMirageFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if (_SqeNo ==1) then
		local selectitem = tonumber(_data) - 1;
		print(tonumber(_data));
		if(selectitem == nil or selectitem > 4 or selectitem < 0) then
			--NLG.SystemMessage(_PlayerIndex,"[系统]您所选择的位置不正常!");
			return;
		end

		local _PetIndex = Char.GetPet(_PlayerIndex,selectitem);
		if (VaildChar(_PetIndex) == false) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確定您對應的寵物欄有寵物!");
			return;
		end
--		if(Char.GetData(_PetIndex,%对象_等级%) ~= 1) then
--			NLG.SystemMessage(_PlayerIndex,"[系统]无法对非1级宠物进行幻化!");
--			return;
--		end
--		if(Char.GetData(_PetIndex,%对象_名色%) ~= 0) then
--			NLG.SystemMessage(_PlayerIndex,"[系统]无法对转生宠物进行幻化!");
--			return;
--		end
--		if Char.GetData(_PetIndex,%宠物_获取时等级%) ~= 1 then
--			NLG.SystemMessage(_PlayerIndex,"[系统] 野生宠物无法幻化。")
--			return;
--		end
		local Gold = Char.GetData(_PlayerIndex, %对象_金币%)
		local nameA = Char.GetData(_PetIndex,%对象_名字%);
		local mirage = Char.GetData(_PetIndex,%对象_形象%);
		local mirage1 = Char.GetData(_PetIndex,%对象_原形%);
		local ground = Char.GetData(_PetIndex,%对象_地属性%);
		local water = Char.GetData(_PetIndex,%对象_水属性%);
		local fire = Char.GetData(_PetIndex,%对象_火属性%);
		local wind = Char.GetData(_PetIndex,%对象_风属性%);

		local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
		local nameB = Item.GetData(item_indexB,%道具_名字%);
		local type = Item.GetData(item_indexB,%道具_特殊类型%);
		local Para1 = Item.GetData(item_indexB,%道具_子参一%);
		local Para2 = Item.GetData(item_indexB,%道具_子参二%);

		if (Char.ItemNum(_PlayerIndex,itemid_card) > 0 and Char.ItemNum(_PlayerIndex,itemid_ball) > 0) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄只能有寵物變身卡或寵物附身媒介");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_card) > 0 and Para2 == 0 and type == 14 and Gold < 10000) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確認金錢尚有一萬G!");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_card) > 0 and Para2 == 0 and type == 14 and Gold >= 10000 and Char.ItemNum(_PlayerIndex,itemid_ball) <=0 ) then
			local Newname = nameA .. nameB;
			Item.SetData(item_indexB,%道具_子参二%,mirage1);
			Item.SetData(item_indexB,%道具_名字%,Newname);
			Item.UpItem(_PlayerIndex,8);
			Char.AddGold(_PlayerIndex,-10000);
			Msg = "\\n\\n\\n     您的寵物 "..Char.GetData(_PetIndex,%对象_名字%).." 靈體附身在卡片了!   \\n"
					.."  \\n"
					.."            尋找帕契族附身合體\\n"
					.."            將任意寵物形象改變\\n";
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_确定%,3,Msg);
			return 0;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_card) > 0 and Para2 ~= 0 and type == 14) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄第一欄是否為未使用寵物變身卡！");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_card) >= 0 and type ~= 14) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄第一欄是否為寵物變身卡或寵物附身媒介！");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_ball) > 0 and Para2 == 0 and type == 14 and Gold < 100000) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確認金錢尚有十萬G!");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_ball) > 0 and Para2 == 0 and type == 14 and Gold >= 100000 and Char.ItemNum(_PlayerIndex,itemid_card) <=0 ) then
			local Newname = nameA .. nameB;
			Item.SetData(item_indexB,%道具_子参二%,mirage1);
			Item.SetData(item_indexB,%道具_名字%,Newname);
			if (ground >0 and fire <= 10)then
				Atype_1 = 1;
				Ameter_1 = ground;
				if (water >0)then
					Atype_2 = 2;
					Ameter_2 = water;
				end
				if (wind >0)then
					Atype_2 = 4;
					Ameter_2 = wind;
				end
			else
				Atype_1 = 3;
				Ameter_1 = fire;
				if (water >0)then
					Atype_2 = 2;
					Ameter_2 = water;
				end
				if (wind >0)then
					Atype_2 = 4;
					Ameter_2 = wind;
				end
			end
			Item.SetData(item_indexB,%道具_属性一%,Atype_1);
			Item.SetData(item_indexB,%道具_属性一值%,Ameter_1);
			Item.SetData(item_indexB,%道具_属性二%,Atype_2);
			Item.SetData(item_indexB,%道具_属性二值%,Ameter_2);
			Item.UpItem(_PlayerIndex,8);
			Char.AddGold(_PlayerIndex,-100000);
			Msg = "\\n\\n\\n     您的寵物 "..Char.GetData(_PetIndex,%对象_名字%).." 灵体附身在媒介了!   \\n"
					.."            請按兩下寵物附身媒介\\n"
					.."            讓水晶可以寵物變身\\n"
					.."  \\n"
					.."            人物裝備時超靈體狀態\\n"
					.."            形象變身成該寵物外觀\\n";
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_确定%,3,Msg);
			return 0;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_ball) > 0 and Para2 ~= 0 and type == 14) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄第一欄是否為未使用寵物附身媒介！");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_ball) >= 0 and type ~= 14) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄第一欄是否為寵物變身卡或寵物附身媒介！");
			return;
		end
	end
	if (_SqeNo ==2) then
		--取消按钮
		local item_indexB = Char.GetItemIndex(_PlayerIndex,Char.FindItemId(_PlayerIndex,ItemID));
		local item_indexC = Char.GetItemIndex(_PlayerIndex,7);
		local TargetItemID = Item.GetData(item_indexC,0);
		local nameC = Item.GetData(item_indexC,%道具_名字%);
		if (_select==8) then
			return
		end
		if (_select==4 and Item.GetData(item_indexB,%道具_子参二%)==0) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確認寵物靈體是否附身在媒介了！");
			return;
		end
		if (nameC == nill) then
			NLG.SystemMessage(_PlayerIndex,"[系統]請確定您的裝備欄有水晶!");
			return;
		end
		if(string.find(nameC,"in") ~= nill ) then
			NLG.SystemMessage(_PlayerIndex, "[系統]水晶無法再依附寵物靈體。");
			return;
		end
		if (_select==4 and Item.GetData(item_indexB,%道具_子参二%)~=0 and OverSoulEnable[TargetItemID] ~= 0) then
			local figure = Char.GetData(_PlayerIndex,%对象_原始图档%);
			local nameB = Item.GetData(item_indexB,%道具_名字%);
			local nameC = Item.GetData(item_indexC,%道具_名字%);
			local nameB_R = string.find(nameB,"寵");
			local nameA_P= string.sub(nameB, 1, nameB_R-1);
			local Newname = "[" .. nameA_P .. "] in 水晶" ;
			local Sitting = Item.GetData(item_indexB,%道具_子参二%);
			local Atype_1 = Item.GetData(item_indexB,%道具_属性一%);
			local Ameter_1 = Item.GetData(item_indexB,%道具_属性一值%);
			local Atype_2 = Item.GetData(item_indexB,%道具_属性二%);
			local Ameter_2 = Item.GetData(item_indexB,%道具_属性二值%);
			Char.SetData(_PlayerIndex,%对象_形象%,Sitting);
			Char.SetData(_PlayerIndex,%对象_原形%,Sitting);
			Char.SetData(_PlayerIndex,%对象_原始图档%,Sitting);
			NLG.UpChar(_PlayerIndex);
			Item.SetData(item_indexC,%道具_鉴前名%,Newname);
			Item.SetData(item_indexC,%道具_名字%,Newname);
			Item.SetData(item_indexC,%道具_子参二%,Sitting);
			Item.SetData(item_indexC,%道具_子参一%,figure);
			Item.SetData(item_indexC,%道具_属性一%,Atype_1);
			Item.SetData(item_indexC,%道具_属性一值%,Ameter_1);
			Item.SetData(item_indexC,%道具_属性二%,Atype_2);
			Item.SetData(item_indexC,%道具_属性二值%,Ameter_2);
			if (Atype_1 ==1 and Atype_1 ~=3) then
				if (Atype_2 == 2) then
					itemimage = 27513;
					itemdirect = 179205;
				end
				if (Atype_2 == 4) then
					itemimage = 27514;
					itemdirect = 179232;
				end
			else
				if (Atype_2 == 2) then
					itemimage = 27516;
					itemdirect = 179214;
				end
				if (Atype_2 == 4) then
					itemimage = 27515;
					itemdirect = 179223;
				end
			end
			Item.SetData(item_indexC,%道具_图%,itemimage);
			Item.SetData(item_indexC,58,itemdirect);
			Item.UpItem(_PlayerIndex,7);
			Char.DelItem(_PlayerIndex,ItemID,1);
			NLG.SystemMessage(_PlayerIndex,"超靈體狀態OVER-SOUL！");
		else
			NLG.SystemMessage(_PlayerIndex,"[系統]無法超靈體依附的水晶！");
		end
	end
end

function PetMirage_Init()
	PetMirage_create();

end
