------------------------------------------------------------------------------
local itemid_66666 = 66666;
------------------------------------------------------------------------------

Delegate.RegInit("ShadowWeapon_Init");

function initShadowWeaponNpc_Init(index)
	print("影子武器npc_index = " .. index);
	return 1;
end

function ShadowWeapon_create() 
	if (warriorNPC == nil) then
		warriorNPC = NL.CreateNpc("lua/Module/ShadowWeapon.lua", "initShadowWeaponNpc_Init");
		Char.SetData(warriorNPC,%对象_形象%,105145);
		Char.SetData(warriorNPC,%对象_原形%,105145);
		Char.SetData(warriorNPC,%对象_X%,57);
		Char.SetData(warriorNPC,%对象_Y%,57);
		Char.SetData(warriorNPC,%对象_地图%,60006);
		Char.SetData(warriorNPC,%对象_方向%,4);
		Char.SetData(warriorNPC,%对象_名字%,"影子武器學者");
		NLG.UpChar(warriorNPC);
		Char.SetTalkedEvent("lua/Module/ShadowWeapon.lua", "WarriorWindow", warriorNPC);
		Char.SetWindowTalkedEvent("lua/Module/ShadowWeapon.lua", "WarriorFunction", warriorNPC);
	end
end

function WarriorWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		歡迎使用影子武器系統！\\n	 		選擇目標以相同武器進行超量化\\n\\n";
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

function WarriorFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) + 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 3 or selectitem < 2))) then
				--NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您所选择的位置不正常！");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		local itemID_A = Item.GetData(item_indexA,0);
		local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
		local itemID_B = Item.GetData(item_indexB,0);
		local Gold = Char.GetData(_PlayerIndex, %对象_金币%);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確定您對應的裝備欄有武器！");
			return;
		end
		if (VaildChar(item_indexB) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確認物品欄第一欄是否為相同武器！");
			return;
		end
		if (VaildChar(item_indexB) == true and itemID_A ~= itemID_B) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確認物品欄第一欄是否為相同武器！");
			return;
		end
		local itemMIN_A = Item.GetData(item_indexA,%道具_最小攻击数量%);
		local itemMAX_A = Item.GetData(item_indexA,%道具_最大攻击数量%);
		local itemMIN_B = Item.GetData(item_indexB,%道具_最小攻击数量%);
		local itemMAX_B = Item.GetData(item_indexB,%道具_最大攻击数量%);
		local Special = Item.GetData(item_indexA,%道具_特殊类型%);
		local Para1 = Item.GetData(item_indexA,%道具_子参一%);
		local Para2 = Item.GetData(item_indexA,%道具_子参二%);
		local sr_1 = math.random(1,2);
		local sr_2 = math.random(1,4);
		local sr_3 = math.random(1,8);
		local sr_4 = math.random(1,16);
		local sr_5 = math.random(1,32);
		if (itemMIN_A <= 1 and itemMAX_A <= 1) then
			if (Gold < 10000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確認金錢足夠一萬或深淵魂魄50個！");
			end
			if (itemMIN_B <= 1 and itemMAX_B <= 1 and Gold >= 10000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%道具_最小攻击数量%,1);
				Item.SetData(item_indexA,%道具_最大攻击数量%,1);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_1 ==1) then
					Item.SetData(item_indexA,58,5000056);
					Item.SetData(item_indexA,%道具_最小攻击数量%,1);
					Item.SetData(item_indexA,%道具_最大攻击数量%,2);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexA,%道具_名字%).."影子武器超量化成功！");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%道具_名字%).."影子超量化失敗！");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-10000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為相同星級影子武器！");
		end
		if (itemMIN_A == 1 and itemMAX_A == 2) then
			if (Gold < 15000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確認金錢足夠一萬五或深淵魂魄50個！");
			end
			if (itemMIN_B == 1 and itemMAX_B == 2 and Gold >= 15000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%道具_最小攻击数量%,1);
				Item.SetData(item_indexA,%道具_最大攻击数量%,2);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_2 ==1) then
					Item.SetData(item_indexA,58,5000057);
					Item.SetData(item_indexA,%道具_最小攻击数量%,2);
					Item.SetData(item_indexA,%道具_最大攻击数量%,2);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexA,%道具_名字%).."影子武器超量化成功！");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%道具_名字%).."影子超量化失敗！");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-15000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為相同星級影子武器！");
		end
		if (itemMIN_A == 2 and itemMAX_A == 2) then
			if (Gold < 20000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確認金錢足夠二萬或深淵魂魄50個！");
			end
			if (itemMIN_B == 2 and itemMAX_B == 2 and Gold >= 20000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%道具_最小攻击数量%,2);
				Item.SetData(item_indexA,%道具_最大攻击数量%,2);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_3 ==1) then
					Item.SetData(item_indexA,58,5000058);
					Item.SetData(item_indexA,%道具_最小攻击数量%,2);
					Item.SetData(item_indexA,%道具_最大攻击数量%,3);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexA,%道具_名字%).."影子武器超量化成功！");
				end
				if (sr_5 ==1) then
					Item.SetData(item_indexA,58,5000056);
					Item.SetData(item_indexA,%道具_最小攻击数量%,1);
					Item.SetData(item_indexA,%道具_最大攻击数量%,2);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%道具_名字%).."影子超量化因為重大失敗倒退了！");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%道具_名字%).."影子超量化失敗！");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-20000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為相同星級影子武器！");
		end
		if (itemMIN_A == 2 and itemMAX_A == 3) then
			if (Gold < 25000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確認金錢足夠二萬五或深淵魂魄50個！");
			end
			if (itemMIN_B == 2 and itemMAX_B == 3 and Gold >= 25000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%道具_最小攻击数量%,2);
				Item.SetData(item_indexA,%道具_最大攻击数量%,3);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_4 ==1) then
					Item.SetData(item_indexA,58,5000059);
					Item.SetData(item_indexA,%道具_最小攻击数量%,3);
					Item.SetData(item_indexA,%道具_最大攻击数量%,3);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexA,%道具_名字%).."影子武器超量化成功！");
				end
				if (sr_5 ==1) then
					Item.SetData(item_indexA,58,5000057);
					Item.SetData(item_indexA,%道具_最小攻击数量%,2);
					Item.SetData(item_indexA,%道具_最大攻击数量%,2);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%道具_名字%).."影子超量化因為重大失敗倒退了！");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%道具_名字%).."影子超量化失敗！");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-25000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為相同星級影子武器！");
		end
		if (itemMIN_A == 3 and itemMAX_A == 3) then
			if (Gold < 30000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請確認金錢足夠三萬或深淵魂魄50個！");
			end
			if (itemMIN_B == 3 and itemMAX_B == 3 and Gold >= 30000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%道具_最小攻击数量%,3);
				Item.SetData(item_indexA,%道具_最大攻击数量%,3);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_4 ==1) then
					Item.SetData(item_indexA,58,5000060);
					Item.SetData(item_indexA,%道具_最小攻击数量%,3);
					Item.SetData(item_indexA,%道具_最大攻击数量%,4);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n已將"..Item.GetData(item_indexA,%道具_名字%).."影子武器超量化成功！");
				end
				if (sr_5 ==1) then
					Item.SetData(item_indexA,58,5000058);
					Item.SetData(item_indexA,%道具_最小攻击数量%,2);
					Item.SetData(item_indexA,%道具_最大攻击数量%,3);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%道具_名字%).."影子超量化因為重大失敗倒退了！");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%道具_名字%).."影子超量化失敗！");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-30000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_是%,1,"\\n\\n\\n請確認物品欄第一欄是否為相同星級影子武器！");
		end
		if (itemMIN_A == 3 and itemMAX_A == 4) then
			Msg = "武器名:  "..Item.GetData(item_indexA,%道具_名字%).."  \\n"
					.."影  子:  五星級影子武器\\n";
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,Msg);
		end
	end
end

function ShadowWeapon_Init()
	ShadowWeapon_create();
	return 0;
end
