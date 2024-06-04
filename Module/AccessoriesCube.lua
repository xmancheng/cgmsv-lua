------------------------------------------------------------------------------
local itemid_71016 = 71016;
local itemid_71017 = 71017;
local itemid_71018 = 71018;
local itemid_71019 = 71019;
------------------------------------------------------------------------------
local a1 = {%道具_攻击%,140,130,120};
local a2 = {%道具_防御%,140,130,120};
local a3 = {%道具_敏捷%,125,120,115};
local a4 = {%道具_精神%,110,107,104};
local a5 = {%道具_回复%,115,110,105};
local a6 = {%道具_HP%,1150,1100,1050};
local a7 = {%道具_MP%,1060,1040,1020};
local a8 = {%道具_魔攻%,140,130,120};
local a9 = {%道具_魔抗%,120,115,110};
local r1 = {%道具_毒抗%,21,14,7};
local r2 = {%道具_睡抗%,21,14,7};
local r3 = {%道具_石抗%,21,14,7};
local r4 = {%道具_醉抗%,21,14,7};
local r5 = {%道具_乱抗%,21,14,7};
local r6 = {%道具_忘抗%,21,14,7};
local f1 = {%道具_必杀%,16,14,12};
local f2 = {%道具_反击%,16,14,12};
local f3 = {%道具_命中%,16,14,12};
local f4 = {%道具_闪躲%,16,14,12};
local Abilitynotes = {a1,a2,a3,a4,a5,a6,a7,a8,a9};
local Resistnotes = {r1,r2,r3,r4,r5,r6};
local Fixnotes = {f1,f2,f3,f4};
local Qualitynotes = {a1,a2,a3,a4,a5,a6,a7,a8,a9,r1,r2,r3,r4,r5,r6,f1,f2,f3,f4};
------------------------------------------------------------------------------

Delegate.RegInit("AccessoriesCube_Init");

function initAccessoriesCubeNpc_Init(index)
	print("浅能开发npc_index = " .. index);
	return 1;
end

function AccessoriesCube_create() 
	if (exploitNPC == nil) then
		exploitNPC = NL.CreateNpc("lua/Module/AccessoriesCube.lua", "initAccessoriesCubeNpc_Init");
		Char.SetData(exploitNPC,%对象_形象%,105389);
		Char.SetData(exploitNPC,%对象_原形%,105389);
		Char.SetData(exploitNPC,%对象_X%,33);
		Char.SetData(exploitNPC,%对象_Y%,35);
		Char.SetData(exploitNPC,%对象_地图%,777);
		Char.SetData(exploitNPC,%对象_方向%,4);
		Char.SetData(exploitNPC,%对象_名字%,"浅能開發專家");
		NLG.UpChar(exploitNPC);
		Char.SetTalkedEvent("lua/Module/AccessoriesCube.lua", "ExploitWindow", exploitNPC);
		Char.SetWindowTalkedEvent("lua/Module/AccessoriesCube.lua", "ExploitFunction", exploitNPC);
	end
end

NL.RegItemString("lua/Module/AccessoriesCube.lua","AccessoriesCube","LUA_useACube");
function AccessoriesCube(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(exploitNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		歡迎使用浅能開通系統！\\n	 		浅能開通須從低階往上使用方塊\\n\\n";
		for i=5,6 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			空\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%道具_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,exploitNPC,%窗口_选择框%,%按钮_关闭%,1,WindowMsg);
	end
	return;
end

function ExploitWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		歡迎使用浅能開通系統！\\n	 		浅能開通須從低階往上使用方塊\\n\\n";
		for i=5,6 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			空\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%道具_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_选择框%,%按钮_关闭%,1,WindowMsg);
	end
	return;
end

function ExploitFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) + 4;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 6 or selectitem < 5))) then
				--NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您所選擇的位置不正常！");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確定您對應的裝備欄有裝飾品！");
			return;
		end
		local itemDur = Item.GetData(item_indexA,%道具_耐久%);
		local itemID = Item.GetData(item_indexA,0);
		local Special = Item.GetData(item_indexA,%道具_特殊类型%);
		local Para1 = Item.GetData(item_indexA,%道具_子参一%);
		local Para2 = Item.GetData(item_indexA,%道具_子参二%);
		local ar = math.random(1,9);
		local rr = math.random(1,6);
		local fr = math.random(1,4);
		local qr = math.random(1,19);
		local pr_1 = math.random(2,4);
		local pr_2 = math.random(2,4);
		local pr_3 = math.random(2,4);
		local pr_4 = math.random(2,4);
		if (Para2 <= 1 and Char.ItemNum(_PlayerIndex,itemid_71016) > 0 and Item.GetData(item_indexA,%道具_类型%) >= 15 and Item.GetData(item_indexA,%道具_类型%) <= 21) then
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%道具_特殊类型%);
			if (type == 14 and Item.GetData(item_indexB,%道具_类型%) == 39) then
				Item.Kill(_PlayerIndex, item_indexA, selectitem);
				Char.GiveItem(_PlayerIndex,itemID,1);
				local cs = Char.FindItemId(_PlayerIndex,itemID);
				local item_indexC = Char.GetItemIndex(_PlayerIndex,cs);
				local nameC = Item.GetData(item_indexC,%道具_名字%);
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = "特殊◎" .. nameC;
				Item.SetData(item_indexC,%道具_特殊类型%,type);
				Item.SetData(item_indexC,%道具_子参一%,meter1);
				Item.SetData(item_indexC,%道具_子参二%,meter2);
				Item.SetData(item_indexC,%道具_名字%,Newname);
				Item.SetData(item_indexC,%道具_耐久%,itemDur);
				local C1 = Item.GetData(item_indexC,Abilitynotes[ar][1]);
				local C1_P = C1 + Abilitynotes[ar][pr_1];
				Item.SetData(item_indexC,Abilitynotes[ar][1],C1_P);
				Item.UpItem(_PlayerIndex,cs);
				if (fr ==1) then
					local C2 = Item.GetData(item_indexC,Resistnotes[rr][1]);
					local C2_P = C2 + Resistnotes[rr][pr_2];
					Item.SetData(item_indexC,Resistnotes[rr][1],C2_P);
					Newname = "稀有◎" .. nameC;
					Item.SetData(item_indexC,%道具_名字%,Newname);
					Item.SetData(item_indexC,%道具_子参二%,2);
					Item.UpItem(_PlayerIndex,cs);
				end
				if (qr ==1) then
					local C2 = Item.GetData(item_indexC,Resistnotes[rr][1]);
					local C2_P = C2 + Resistnotes[rr][pr_2];
					Item.SetData(item_indexC,Resistnotes[rr][1],C2_P);
					local C3 = Item.GetData(item_indexC,Fixnotes[fr][1]);
					local C3_P = C3 + Fixnotes[fr][pr_3];
					Item.SetData(item_indexC,Fixnotes[fr][1],C3_P);
					Newname = "罕見◎" .. nameC;
					Item.SetData(item_indexC,%道具_名字%,Newname);
					Item.SetData(item_indexC,%道具_子参二%,3);
					Item.UpItem(_PlayerIndex,cs);
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexC,%道具_名字%).."浅能開通成功！");
				Char.DelItem(_PlayerIndex,itemid_71016,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為浅能方塊(特殊)！");
		end
		if (Special == 14 and Para2 == 2 and Char.ItemNum(_PlayerIndex,itemid_71017) > 0 and Item.GetData(item_indexA,%道具_类型%) >= 15 and Item.GetData(item_indexA,%道具_类型%) <= 21) then
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%道具_特殊类型%);
			if (type == 14 and Item.GetData(item_indexB,%道具_类型%) == 39) then
				Item.Kill(_PlayerIndex, item_indexA, selectitem);
				Char.GiveItem(_PlayerIndex,itemID,1);
				local cs = Char.FindItemId(_PlayerIndex,itemID);
				local item_indexC = Char.GetItemIndex(_PlayerIndex,cs);
				local nameC = Item.GetData(item_indexC,%道具_名字%);
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = "稀有◎" .. nameC;
				Item.SetData(item_indexC,%道具_特殊类型%,type);
				Item.SetData(item_indexC,%道具_子参一%,meter1);
				Item.SetData(item_indexC,%道具_子参二%,meter2);
				Item.SetData(item_indexC,%道具_名字%,Newname);
				Item.SetData(item_indexC,%道具_耐久%,itemDur);
				local C1 = Item.GetData(item_indexC,Abilitynotes[ar][1]);
				local C1_P = C1 + Abilitynotes[ar][pr_1];
				Item.SetData(item_indexC,Abilitynotes[ar][1],C1_P);
				local C2 = Item.GetData(item_indexC,Resistnotes[rr][1]);
				local C2_P = C2 + Resistnotes[rr][pr_2];
				Item.SetData(item_indexC,Resistnotes[rr][1],C2_P);
				Item.UpItem(_PlayerIndex,cs);
				if (rr ==1) then
					local C3 = Item.GetData(item_indexC,Fixnotes[fr][1]);
					local C3_P = C3 + Fixnotes[fr][pr_3];
					Item.SetData(item_indexC,Fixnotes[fr][1],C3_P);
					Newname = "罕見◎" .. nameC;
					Item.SetData(item_indexC,%道具_名字%,Newname);
					Item.SetData(item_indexC,%道具_子参二%,3);
					Item.UpItem(_PlayerIndex,cs);
				end
				if (qr ==1) then
					local C3 = Item.GetData(item_indexC,Fixnotes[fr][1]);
					local C3_P = C3 + Fixnotes[fr][pr_3];
					Item.SetData(item_indexC,Fixnotes[fr][1],C3_P);
					local C4 = Item.GetData(item_indexC,Qualitynotes[qr][1]);
					local C4_P = C4 + Qualitynotes[qr][pr_4];
					Item.SetData(item_indexC,Qualitynotes[qr][1],C4_P);
					Newname = "傳說◎" .. nameC;
					Item.SetData(item_indexC,%道具_名字%,Newname);
					Item.SetData(item_indexC,%道具_子参二%,4);
					Item.UpItem(_PlayerIndex,cs);
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexC,%道具_名字%).."浅能開通成功！");
				Char.DelItem(_PlayerIndex,itemid_71017,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為浅能方塊(稀有)！");
		end
		if (Special == 14 and Para2 == 3 and Char.ItemNum(_PlayerIndex,itemid_71018) > 0 and Item.GetData(item_indexA,%道具_类型%) >= 15 and Item.GetData(item_indexA,%道具_类型%) <= 21) then
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%道具_特殊类型%);
			if (type == 14 and Item.GetData(item_indexB,%道具_类型%) == 39) then
				Item.Kill(_PlayerIndex, item_indexA, selectitem);
				Char.GiveItem(_PlayerIndex,itemID,1);
				local cs = Char.FindItemId(_PlayerIndex,itemID);
				local item_indexC = Char.GetItemIndex(_PlayerIndex,cs);
				local nameC = Item.GetData(item_indexC,%道具_名字%);
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = "罕見◎" .. nameC;
				Item.SetData(item_indexC,%道具_特殊类型%,type);
				Item.SetData(item_indexC,%道具_子参一%,meter1);
				Item.SetData(item_indexC,%道具_子参二%,meter2);
				Item.SetData(item_indexC,%道具_名字%,Newname);
				Item.SetData(item_indexC,%道具_耐久%,itemDur);
				local C1 = Item.GetData(item_indexC,Abilitynotes[ar][1]);
				local C1_P = C1 + Abilitynotes[ar][pr_1];
				Item.SetData(item_indexC,Abilitynotes[ar][1],C1_P);
				local C2 = Item.GetData(item_indexC,Resistnotes[rr][1]);
				local C2_P = C2 + Resistnotes[rr][pr_2];
				Item.SetData(item_indexC,Resistnotes[rr][1],C2_P);
				local C3 = Item.GetData(item_indexC,Fixnotes[fr][1]);
				local C3_P = C3 + Fixnotes[fr][pr_3];
				Item.SetData(item_indexC,Fixnotes[fr][1],C3_P);
				Item.UpItem(_PlayerIndex,cs);
				if (ar ==1) then
					local C4 = Item.GetData(item_indexC,Qualitynotes[qr][1]);
					local C4_P = C4 + Qualitynotes[qr][pr_4];
					Item.SetData(item_indexC,Qualitynotes[qr][1],C4_P);
					Newname = "傳說◎" .. nameC;
					Item.SetData(item_indexC,%道具_名字%,Newname);
					Item.SetData(item_indexC,%道具_子参二%,4);
					Item.UpItem(_PlayerIndex,cs);
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexC,%道具_名字%).."浅能開通成功！");
				Char.DelItem(_PlayerIndex,itemid_71018,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為浅能方塊(罕見)！");
		end
		if (Special == 14 and Para2 == 4 and Char.ItemNum(_PlayerIndex,itemid_71019) > 0 and Item.GetData(item_indexA,%道具_类型%) >= 15 and Item.GetData(item_indexA,%道具_类型%) <= 21) then
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%道具_特殊类型%);
			if (type == 14 and Item.GetData(item_indexB,%道具_类型%) == 39) then
				Item.Kill(_PlayerIndex, item_indexA, selectitem);
				Char.GiveItem(_PlayerIndex,itemID,1);
				local cs = Char.FindItemId(_PlayerIndex,itemID);
				local item_indexC = Char.GetItemIndex(_PlayerIndex,cs);
				local nameC = Item.GetData(item_indexC,%道具_名字%);
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = "傳說◎" .. nameC;
				Item.SetData(item_indexC,%道具_特殊类型%,type);
				Item.SetData(item_indexC,%道具_子参一%,meter1);
				Item.SetData(item_indexC,%道具_子参二%,meter2);
				Item.SetData(item_indexC,%道具_名字%,Newname);
				Item.SetData(item_indexC,%道具_耐久%,itemDur);
				local C1 = Item.GetData(item_indexC,Abilitynotes[ar][1]);
				local C1_P = C1 + Abilitynotes[ar][pr_1];
				Item.SetData(item_indexC,Abilitynotes[ar][1],C1_P);
				local C2 = Item.GetData(item_indexC,Resistnotes[rr][1]);
				local C2_P = C2 + Resistnotes[rr][pr_2];
				Item.SetData(item_indexC,Resistnotes[rr][1],C2_P);
				local C3 = Item.GetData(item_indexC,Fixnotes[fr][1]);
				local C3_P = C3 + Fixnotes[fr][pr_3];
				Item.SetData(item_indexC,Fixnotes[fr][1],C3_P);
				local C4 = Item.GetData(item_indexC,Qualitynotes[qr][1]);
				local C4_P = C4 + Qualitynotes[qr][pr_4];
				Item.SetData(item_indexC,Qualitynotes[qr][1],C4_P);
				Item.UpItem(_PlayerIndex,cs);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexC,%道具_名字%).."浅能開通成功！");
				Char.DelItem(_PlayerIndex,itemid_71019,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為浅能方塊(傳說)！");
		end
		if (Special ~= 0 and Para1 == 7 and item_indexA ~= nill) then
			if(Para2 == 1) then
				Msg = "裝飾品:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."浅  能:  一項  \\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 2) then
				Msg = "裝飾品:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."浅  能:  二項  \\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 3) then
				Msg = "裝飾品:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."浅  能:  三項  \\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 4) then
				Msg = "裝飾品:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."浅  能:  四項  \\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
		else
		Msg = "裝飾品:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
				.."浅  能:  空  \\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
		end
	end
end

function AccessoriesCube_Init()
	AccessoriesCube_create();
	return 0;
end
