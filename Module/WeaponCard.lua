------------------------------------------------------------------------------
local itemid_71001 = 71001;
local itemid_71002 = 71002;
local itemid_71003 = 71003;
local itemid_71004 = 71004;
------------------------------------------------------------------------------

Delegate.RegInit("WeaponCard_Init");

function initWeaponCardNpc_Init(index)
	print("武器插卡npc_index = " .. index);
	return 1;
end

function WeaponCard_create() 
	if (prophetNPC == nil) then
		prophetNPC = NL.CreateNpc("lua/Module/WeaponCard.lua", "initWeaponCardNpc_Init");
		Char.SetData(prophetNPC,%对象_形象%,105527);
		Char.SetData(prophetNPC,%对象_原形%,105527);
		Char.SetData(prophetNPC,%对象_X%,28);
		Char.SetData(prophetNPC,%对象_Y%,7);
		Char.SetData(prophetNPC,%对象_地图%,25000);
		Char.SetData(prophetNPC,%对象_方向%,4);
		Char.SetData(prophetNPC,%对象_名字%,"武器插卡大師");
		NLG.UpChar(prophetNPC);
		Char.SetTalkedEvent("lua/Module/WeaponCard.lua", "ProphetWindow", prophetNPC);
		Char.SetWindowTalkedEvent("lua/Module/WeaponCard.lua", "ProphetFunction", prophetNPC);
	end
end

NL.RegItemString("lua/Module/WeaponCard.lua","WeaponCard","LUA_useWCard");
function WeaponCard(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(prophetNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		歡迎使用武器插卡系統！\\n	 		查看選擇武器是否插卡或將武器插上卡片\\n\\n";
		for i=2,3 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			空\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%道具_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,prophetNPC,%窗口_选择框%,%按钮_关闭%,1,WindowMsg);
	end
	return;
end

function ProphetWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		歡迎使用武器插卡系統！\\n	 		查看選擇武器是否插卡或將武器插上卡片\\n\\n";
		for i=2,3 do
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

function ProphetFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) + 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 3 or selectitem < 2))) then
				--NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您所选择的位置不正常！");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
		local itemID_B = Item.GetData(item_indexB,0);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確定您對應的裝備欄有武器！");
			return;
		end
		local itemIndex = Item.GetData(item_indexA,1);
		local Special = Item.GetData(item_indexA,%道具_特殊类型%);
		local Para1 = Item.GetData(item_indexA,%道具_子参一%);
		local Para2 = Item.GetData(item_indexA,%道具_子参二%);
		if (Special == 0 and Item.GetData(item_indexA,%道具_类型%) <= 6) then
			local nameA = Item.GetData(item_indexA,%道具_名字%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local nameB = Item.GetData(item_indexB,%道具_名字%);
			local type = Item.GetData(item_indexB,%道具_特殊类型%);
			if (type == 14 and itemID_B == itemid_71001) then
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%道具_特殊类型%,type);
				Item.SetData(item_indexA,%道具_子参一%,meter1);
				Item.SetData(item_indexA,%道具_子参二%,meter2);
				Item.SetData(item_indexA,%道具_名字%,Newname);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexB,%道具_名字%).."卡片插上武器！\\n\\n請卸下後重新裝備！");
				Char.DelItem(_PlayerIndex,itemid_71001,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type == 14 and itemID_B == itemid_71002) then
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%道具_特殊类型%,type);
				Item.SetData(item_indexA,%道具_子参一%,meter1);
				Item.SetData(item_indexA,%道具_子参二%,meter2);
				Item.SetData(item_indexA,%道具_名字%,Newname);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexB,%道具_名字%).."卡片插上武器！\\n\\n請卸下後重新裝備！");
				Char.DelItem(_PlayerIndex,itemid_71002,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type == 14 and itemID_B == itemid_71003) then
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%道具_特殊类型%,type);
				Item.SetData(item_indexA,%道具_子参一%,meter1);
				Item.SetData(item_indexA,%道具_子参二%,meter2);
				Item.SetData(item_indexA,%道具_名字%,Newname);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexB,%道具_名字%).."卡片插上武器！\\n\\n請卸下後重新裝備！");
				Char.DelItem(_PlayerIndex,itemid_71003,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type == 14 and itemID_B == itemid_71004) then
				local meter1 = Item.GetData(item_indexB,%道具_子参一%);
				local meter2 = Item.GetData(item_indexB,%道具_子参二%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%道具_特殊类型%,type);
				Item.SetData(item_indexA,%道具_子参一%,meter1);
				Item.SetData(item_indexA,%道具_子参二%,meter2);
				Item.SetData(item_indexA,%道具_名字%,Newname);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexB,%道具_名字%).."卡片插上武器！\\n\\n請卸下後重新裝備！");
				Char.DelItem(_PlayerIndex,itemid_71004,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type ~= 14 or VaildChar(item_indexB) == false) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為插槽卡片！");
				return;
			end
		end
		if (Special ~= 0 and Para1 == 9) then
			if(Para2 == 1) then
				Msg = "武器名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色力量BP每7點\\n"
						.."         額外增加強度BP1點\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 2) then
				Msg = "武器名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色力量BP每7點\\n"
						.."         額外增加體力BP1點\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 3) then
				Msg = "武器名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色力量BP每7點\\n"
						.."         額外增加魔法BP1點\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
			if(Para2 == 4) then
				Msg = "武器名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
						.."卡  片:  角色力量BP每7點\\n"
						.."         額外增加速度BP1點\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
				return;
			end
		end
		Msg = "武器名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
				.."卡  片:  空\\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
	end
end

function WeaponCard_Init()
	WeaponCard_create();
	return 0;
end
