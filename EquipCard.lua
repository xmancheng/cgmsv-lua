------------------------------------------------------------------------------
local CardW_ID = {71001,71002,71003,71004}
local CardD_ID = {71005,71006,71007,71008}
local itemid_69163 = 69163;
local itemid_69164 = 69164;
local itemid_69165 = 69165;
local itemid_69166 = 69166;
------------------------------------------------------------------------------

Delegate.RegInit("EquipCard_Init");

function initEquipCardNpc_Init(index)
	print("装备插卡npc_index = " .. index);
	return 1;
end

function EquipCard_create() 
	if (divinerNPC == nil) then
		divinerNPC = NL.CreateNpc("lua/Module/EquipCard.lua", "initEquipCardNpc_Init");
		Char.SetData(divinerNPC,%对象_形象%,105527);
		Char.SetData(divinerNPC,%对象_原形%,105527);
		Char.SetData(divinerNPC,%对象_X%,28);
		Char.SetData(divinerNPC,%对象_Y%,7);
		Char.SetData(divinerNPC,%对象_地图%,25000);
		Char.SetData(divinerNPC,%对象_方向%,4);
		Char.SetData(divinerNPC,%对象_名字%,"装备插卡学徒");
		NLG.UpChar(divinerNPC);
		Char.SetTalkedEvent("lua/Module/EquipCard.lua", "DivinerWindow", divinerNPC);
		Char.SetWindowTalkedEvent("lua/Module/EquipCard.lua", "DivinerFunction", divinerNPC);
	end
end

NL.RegItemString("lua/Module/EquipCard.lua","EquipCard","LUA_useCard");
function EquipCard(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(divinerNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		欢迎使用装备插卡系统！\\n	 		查看选择装备是否插卡或将装备插上卡片\\n\\n";
		for i=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			空\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%道具_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,divinerNPC,%窗口_选择框%,%按钮_关闭%,1,WindowMsg);
	end
	return;
end

NL.RegItemString("lua/Module/EquipCard.lua","Runes","LUA_useRunes");
function Runes(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(divinerNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		欢迎使用附加属性系统！\\n	 		查看选择是否附加属性或将部位附加属性\\n\\n";
		for i=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			空\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%道具_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,divinerNPC,%窗口_选择框%,%按钮_关闭%,1,WindowMsg);
	end
	return;
end

function DivinerWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		欢迎使用装备插卡系统！\\n	 		查看选择装备是否插卡或将装备插上卡片\\n\\n";
		for i=0,4 do
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

function DivinerFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) - 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 4 or selectitem < 0))) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您所选择的位置不正常！");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
		local itemID_B = Item.GetData(item_indexB,0);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n请确定您对应的装备栏有装备！");
			return;
		end
		local itemIndex = Item.GetData(item_indexA,1);
		local Special = Item.GetData(item_indexA,%道具_特殊类型%);
		local Para1 = Item.GetData(item_indexA,%道具_子参一%);
		local Para2 = Item.GetData(item_indexA,%道具_子参二%);
		local Category = Item.GetData(item_indexA,%道具_属性一%);
		local Value1 = Item.GetData(item_indexA,%道具_属性一值%);
		local resist_a = Item.GetData(item_indexA,%道具_乱抗%);
		local resist_b = Item.GetData(item_indexA,%道具_醉抗%);
		local resist_c = Item.GetData(item_indexA,%道具_毒抗%);
		local resist_d = Item.GetData(item_indexA,%道具_睡抗%);
		if (Special == 0 and Item.GetData(item_indexA,%道具_类型%) >= 7 and Item.GetData(item_indexA,%道具_类型%) <= 14) then
			local nameA = Item.GetData(item_indexA,%道具_名字%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local nameB = Item.GetData(item_indexB,%道具_名字%);
			local type = Item.GetData(item_indexB,%道具_特殊类型%);
			local info = Item.GetData(item_indexB,57);
			if (type == 14 and CARD_CheckInTable(CardD_ID,itemID_B)==true) then
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%道具_特殊类型%,type);
				Item.SetData(item_indexA,%道具_子参一%,meter1);
				Item.SetData(item_indexA,%道具_子参二%,meter2);
				Item.SetData(item_indexA,%道具_名字%,Newname);
				Item.SetData(item_indexA,57,info);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已将"..Item.GetData(item_indexB,%道具_名字%).."卡片插上装备！\\n\\n请卸下后重新装备！");
				Char.DelItem(_PlayerIndex,itemID_B,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type ~= 14 or VaildChar(item_indexB) == false) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n请确认物品栏第一栏是否为插槽卡片！");
				return;
			end
		end
		if (Special == 0 and Item.GetData(item_indexA,%道具_类型%) <= 6) then
			local nameA = Item.GetData(item_indexA,%道具_名字%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local nameB = Item.GetData(item_indexB,%道具_名字%);
			local type = Item.GetData(item_indexB,%道具_特殊类型%);
			local info = Item.GetData(item_indexB,57);
			if (type == 14 and CARD_CheckInTable(CardW_ID,itemID_B)==true) then
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%道具_特殊类型%,type);
				Item.SetData(item_indexA,%道具_子参一%,meter1);
				Item.SetData(item_indexA,%道具_子参二%,meter2);
				Item.SetData(item_indexA,%道具_名字%,Newname);
				Item.SetData(item_indexA,57,info);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已将"..Item.GetData(item_indexB,%道具_名字%).."卡片插上武器！\\n\\n请卸下后重新装备！");
				Char.DelItem(_PlayerIndex,itemID_B,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type ~= 14 or VaildChar(item_indexB) == false) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n请确认物品栏第一栏是否为插槽卡片！");
				return;
			end
		end
		if (Special ~= 0 and Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69163) > 0) then
			local colorA = Char.GetData(item_indexA,%对象_名色%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local Atype = Item.GetData(item_indexB,%道具_属性一%);
			if (Atype == 1 and itemID_B == itemid_69163) then
				local Ameter = Item.GetData(item_indexB,%道具_属性一值%);
				local resist_aa = resist_a+10;
				Item.SetData(item_indexA,%道具_属性一%,Atype);
				Item.SetData(item_indexA,%道具_属性一值%,Ameter);
				Item.SetData(item_indexA,%道具_乱抗%,resist_aa);
				Item.SetData(item_indexA,%道具_醉抗%,resist_b);
				Item.SetData(item_indexA,%道具_毒抗%,resist_c);
				Item.SetData(item_indexA,%道具_睡抗%,resist_d);
				Item.SetData(item_indexA,%对象_名色%,5);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已将"..Item.GetData(item_indexB,%道具_名字%).."属性附加于装备！");
				Char.DelItem(_PlayerIndex,itemid_69163,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n请确认物品栏第一栏是否为属性结晶！");
		end
		if (Special ~= 0 and Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69164) > 0) then
			local colorA = Item.GetData(item_indexA,%对象_名色%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local Atype = Item.GetData(item_indexB,%道具_属性一%);
			if (Atype == 2 and itemID_B == itemid_69164) then
				local Ameter = Item.GetData(item_indexB,%道具_属性一值%);
				local resist_bb = resist_b+10;
				Item.SetData(item_indexA,%道具_属性一%,Atype);
				Item.SetData(item_indexA,%道具_属性一值%,Ameter);
				Item.SetData(item_indexA,%道具_醉抗%,resist_bb);
				Item.SetData(item_indexA,%道具_乱抗%,resist_a);
				Item.SetData(item_indexA,%道具_毒抗%,resist_c);
				Item.SetData(item_indexA,%道具_睡抗%,resist_d);
				Item.SetData(item_indexA,%对象_名色%,3);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已将"..Item.GetData(item_indexB,%道具_名字%).."属性附加于装备！");
				Char.DelItem(_PlayerIndex,itemid_69164,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n请确认物品栏第一栏是否为属性结晶！");
		end
		if (Special ~= 0 and Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69165) > 0) then
			local colorA = Item.GetData(item_indexA,%对象_名色%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local Atype = Item.GetData(item_indexB,%道具_属性一%);
			if (Atype == 3 and itemID_B == itemid_69165) then
				local Ameter = Item.GetData(item_indexB,%道具_属性一值%);
				local resist_cc = resist_c+10;
				Item.SetData(item_indexA,%道具_属性一%,Atype);
				Item.SetData(item_indexA,%道具_属性一值%,Ameter);
				Item.SetData(item_indexA,%道具_毒抗%,resist_cc);
				Item.SetData(item_indexA,%道具_醉抗%,resist_b);
				Item.SetData(item_indexA,%道具_乱抗%,resist_a);
				Item.SetData(item_indexA,%道具_睡抗%,resist_d);
				Item.SetData(item_indexA,%对象_名色%,6);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已将"..Item.GetData(item_indexB,%道具_名字%).."属性附加于装备！");
				Char.DelItem(_PlayerIndex,itemid_69165,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n请确认物品栏第一栏是否为属性结晶！");
		end
		if (Special ~= 0 and Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69166) > 0) then
			local colorA = Item.GetData(item_indexA,%对象_名色%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local Atype = Item.GetData(item_indexB,%道具_属性一%);
			if (Atype == 4 and itemID_B == itemid_69166) then
				local Ameter = Item.GetData(item_indexB,%道具_属性一值%);
				local resist_dd = resist_d+10;
				Item.SetData(item_indexA,%道具_属性一%,Atype);
				Item.SetData(item_indexA,%道具_属性一值%,Ameter);
				Item.SetData(item_indexA,%道具_睡抗%,resist_dd);
				Item.SetData(item_indexA,%道具_毒抗%,resist_c);
				Item.SetData(item_indexA,%道具_醉抗%,resist_b);
				Item.SetData(item_indexA,%道具_乱抗%,resist_a);
				Item.SetData(item_indexA,%对象_名色%,4);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已将"..Item.GetData(item_indexB,%道具_名字%).."属性附加于装备！");
				Char.DelItem(_PlayerIndex,itemid_69166,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n请确认物品栏第一栏是否为属性结晶！");
		end
		if (Special ~= 0 and Para1 == 8) then
			if(Para2 == 1) then
				Msg = "装备名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色强度BP大于50点时\\n"
						.."         每增加10点，反击提升1点\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 2) then
				Msg = "装备名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色魔法BP大于50点时\\n"
						.."         每增加10点，闪躲提升1点\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 3) then
				Msg = "装备名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色体力BP大于50点时\\n"
						.."         每增加10点，命中提升1点\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 4) then
				Msg = "装备名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色速度BP大于50点时\\n"
						.."         每增加10点，必杀提升1点\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
		end
		if (Special ~= 0 and Para1 == 9) then
			if(Para2 == 1) then
				Msg = "装备名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色力量BP每7点\\n"
						.."         额外增加强度BP1点\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 2) then
				Msg = "装备名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色力量BP每7点\\n"
						.."         额外增加体力BP1点\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 3) then
				Msg = "装备名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色力量BP每7点\\n"
						.."         额外增加魔法BP1点\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 4) then
				Msg = "装备名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色力量BP每7点\\n"
						.."         额外增加速度BP1点\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
		end
		Msg = "装备名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
				.."卡  片:  空\\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
	end
end

function EquipCard_Init()
	EquipCard_create();
	return 0;
end
function CARD_CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		print(v .. " = " .. _idVar)
		if v==_idVar then
			return true
		end
	end
	return false
end