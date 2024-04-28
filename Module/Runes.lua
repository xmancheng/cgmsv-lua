------------------------------------------------------------------------------
local itemid_69163 = 69163;
local itemid_69164 = 69164;
local itemid_69165 = 69165;
local itemid_69166 = 69166;
------------------------------------------------------------------------------

Delegate.RegInit("Runes_Init");

function initRunesNpc_Init(index)
	print("附加属性npc_index = " .. index);
	return 1;
end

function Runes_create() 
	if (appendNPC == nil) then
		appendNPC = NL.CreateNpc("lua/Module/Runes.lua", "initRunesNpc_Init");
		Char.SetData(appendNPC,%对象_形象%,105514);
		Char.SetData(appendNPC,%对象_原形%,105514);
		Char.SetData(appendNPC,%对象_X%,26);
		Char.SetData(appendNPC,%对象_Y%,7);
		Char.SetData(appendNPC,%对象_地图%,25000);
		Char.SetData(appendNPC,%对象_方向%,4);
		Char.SetData(appendNPC,%对象_名字%,"附加屬性大師");
		NLG.UpChar(appendNPC);
		Char.SetTalkedEvent("lua/Module/Runes.lua", "AppendWindow", appendNPC);
		Char.SetWindowTalkedEvent("lua/Module/Runes.lua", "AppendFunction", appendNPC);
	end
end

NL.RegItemString("lua/Module/Runes.lua","Runes","LUA_useRunes");
function Runes(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(appendNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		歡迎使用附加屬性系統！\\n	 		查看選擇是否附加屬性或將部位附加屬性\\n\\n";
		for i=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			空\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%道具_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,appendNPC,%窗口_选择框%,%按钮_关闭%,1,WindowMsg);
	end
	return;
end

function AppendWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		歡迎使用附加屬性系統！\\n	 		查看選擇是否附加屬性或將部位附加屬性\\n\\n";
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

function AppendFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) - 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 4 or selectitem < 0))) then
				--NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您所选择的位置不正常！");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確定您對應的裝備欄有裝備！");
			return;
		end
		local itemIndex = Item.GetData(item_indexA,1);
		local Category = Item.GetData(item_indexA,%道具_属性一%);
		local Value1 = Item.GetData(item_indexA,%道具_属性一值%);
		local resist_a = Item.GetData(item_indexA,%道具_乱抗%);
		local resist_b = Item.GetData(item_indexA,%道具_醉抗%);
		local resist_c = Item.GetData(item_indexA,%道具_毒抗%);
		local resist_d = Item.GetData(item_indexA,%道具_睡抗%);
		if (Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69163) > 0) then
			local colorA = Char.GetData(item_indexA,%对象_名色%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%道具_属性一%);
			if (type == 1) then
				local meter1 = Item.GetData(item_indexB,%道具_属性一值%);
				local resist_aa = resist_a+10;
				Item.SetData(item_indexA,%道具_属性一%,type);
				Item.SetData(item_indexA,%道具_属性一值%,meter1);
				Item.SetData(item_indexA,%道具_乱抗%,resist_aa);
				Item.SetData(item_indexA,%道具_醉抗%,resist_b);
				Item.SetData(item_indexA,%道具_毒抗%,resist_c);
				Item.SetData(item_indexA,%道具_睡抗%,resist_d);
				Item.SetData(item_indexA,%对象_名色%,5);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexB,%道具_名字%).."屬性附加於裝備！");
				Char.DelItem(_PlayerIndex,itemid_69163,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為屬性結晶！");
		end
		if (Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69164) > 0) then
			local colorA = Item.GetData(item_indexA,%对象_名色%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%道具_属性一%);
			if (type == 2) then
				local meter1 = Item.GetData(item_indexB,%道具_属性一值%);
				local resist_bb = resist_b+10;
				Item.SetData(item_indexA,%道具_属性一%,type);
				Item.SetData(item_indexA,%道具_属性一值%,meter1);
				Item.SetData(item_indexA,%道具_醉抗%,resist_bb);
				Item.SetData(item_indexA,%道具_乱抗%,resist_a);
				Item.SetData(item_indexA,%道具_毒抗%,resist_c);
				Item.SetData(item_indexA,%道具_睡抗%,resist_d);
				Item.SetData(item_indexA,%对象_名色%,3);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexB,%道具_名字%).."屬性附加於裝備！");
				Char.DelItem(_PlayerIndex,itemid_69164,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為屬性結晶！");
		end
		if (Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69165) > 0) then
			local colorA = Item.GetData(item_indexA,%对象_名色%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%道具_属性一%);
			if (type == 3) then
				local meter1 = Item.GetData(item_indexB,%道具_属性一值%);
				local resist_cc = resist_c+10;
				Item.SetData(item_indexA,%道具_属性一%,type);
				Item.SetData(item_indexA,%道具_属性一值%,meter1);
				Item.SetData(item_indexA,%道具_毒抗%,resist_cc);
				Item.SetData(item_indexA,%道具_醉抗%,resist_b);
				Item.SetData(item_indexA,%道具_乱抗%,resist_a);
				Item.SetData(item_indexA,%道具_睡抗%,resist_d);
				Item.SetData(item_indexA,%对象_名色%,6);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexB,%道具_名字%).."屬性附加於裝備！");
				Char.DelItem(_PlayerIndex,itemid_69165,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為屬性結晶！");
		end
		if (Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69166) > 0) then
			local colorA = Item.GetData(item_indexA,%对象_名色%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%道具_属性一%);
			if (type == 4) then
				local meter1 = Item.GetData(item_indexB,%道具_属性一值%);
				local resist_dd = resist_d+10;
				Item.SetData(item_indexA,%道具_属性一%,type);
				Item.SetData(item_indexA,%道具_属性一值%,meter1);
				Item.SetData(item_indexA,%道具_睡抗%,resist_dd);
				Item.SetData(item_indexA,%道具_毒抗%,resist_c);
				Item.SetData(item_indexA,%道具_醉抗%,resist_b);
				Item.SetData(item_indexA,%道具_乱抗%,resist_a);
				Item.SetData(item_indexA,%对象_名色%,4);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexB,%道具_名字%).."屬性附加於裝備！");
				Char.DelItem(_PlayerIndex,itemid_69166,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為屬性結晶！");
		end
		if (Category ~= 0) then
			if(Category == 1) then
				Msg = "裝備名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."附  加:  屬性結晶附加裝備地屬性20\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Category == 2) then
				Msg = "裝備名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."附  加:  屬性結晶附加裝備水屬性20\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Category == 3) then
				Msg = "裝備名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."附  加:  屬性結晶附加裝備火屬性20\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Category == 4) then
				Msg = "裝備名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."附  加:  屬性結晶附加裝備風屬性20\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
		end
		Msg = "裝備名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
				.."附  加:  空\\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
	end
end

function Runes_Init()
	Runes_create();
	return 0;
end
