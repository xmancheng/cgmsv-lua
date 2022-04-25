------------------------------------------------------------------------------
local itemid_66666 = 66666;
------------------------------------------------------------------------------

Delegate.RegInit("ShadowWeapon_Init");

function initShadowWeaponNpc_Init(index)
	print("Ӱ������npc_index = " .. index);
	return 1;
end

function ShadowWeapon_create() 
	if (warriorNPC == nil) then
		warriorNPC = NL.CreateNpc("lua/Module/ShadowWeapon.lua", "initShadowWeaponNpc_Init");
		Char.SetData(warriorNPC,%����_����%,105145);
		Char.SetData(warriorNPC,%����_ԭ��%,105145);
		Char.SetData(warriorNPC,%����_X%,26);
		Char.SetData(warriorNPC,%����_Y%,7);
		Char.SetData(warriorNPC,%����_��ͼ%,25000);
		Char.SetData(warriorNPC,%����_����%,4);
		Char.SetData(warriorNPC,%����_����%,"Ӱ������ѧ��");
		NLG.UpChar(warriorNPC);
		Char.SetTalkedEvent("lua/Module/ShadowWeapon.lua", "WarriorWindow", warriorNPC);
		Char.SetWindowTalkedEvent("lua/Module/ShadowWeapon.lua", "WarriorFunction", warriorNPC);
	end
end

function WarriorWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		��ӭʹ��Ӱ������ϵͳ��\\n	 		ѡ��Ŀ������ͬ�������г�����\\n\\n";
		for i=2,3 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			��\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_ѡ���%,%��ť_�ر�%,1,WindowMsg);
	end
	return;
end

function WarriorFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) + 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 3 or selectitem < 2))) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n����ѡ���λ�ò�������");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		local itemID_A = Item.GetData(item_indexA,0);
		local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
		local itemID_B = Item.GetData(item_indexB,0);
		local Gold = Char.GetData(_PlayerIndex, %����_���%);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ������Ӧ��װ������������");
			return;
		end
		if (VaildChar(item_indexB) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ͬ������");
			return;
		end
		if (VaildChar(item_indexB) == true and itemID_A ~= itemID_B) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ͬ������");
			return;
		end
		local itemMIN_A = Item.GetData(item_indexA,%����_��С��������%);
		local itemMAX_A = Item.GetData(item_indexA,%����_��󹥻�����%);
		local itemMIN_B = Item.GetData(item_indexB,%����_��С��������%);
		local itemMAX_B = Item.GetData(item_indexB,%����_��󹥻�����%);
		local Special = Item.GetData(item_indexA,%����_��������%);
		local Para1 = Item.GetData(item_indexA,%����_�Ӳ�һ%);
		local Para2 = Item.GetData(item_indexA,%����_�Ӳζ�%);
		local sr_1 = math.random(1,2);
		local sr_2 = math.random(1,4);
		local sr_3 = math.random(1,8);
		local sr_4 = math.random(1,16);
		local sr_5 = math.random(1,32);
		if (itemMIN_A <= 1 and itemMAX_A <= 1) then
			if (Gold < 10000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ�Ͻ�Ǯ�㹻һ�����Ԩ����50����");
			end
			if (itemMIN_B <= 1 and itemMAX_B <= 1 and Gold >= 10000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%����_��С��������%,1);
				Item.SetData(item_indexA,%����_��󹥻�����%,1);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_1 ==1) then
					Item.SetData(item_indexA,58,5000056);
					Item.SetData(item_indexA,%����_��С��������%,1);
					Item.SetData(item_indexA,%����_��󹥻�����%,2);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexA,%����_����%).."Ӱ�������������ɹ���");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%����_����%).."Ӱ�ӳ�����ʧ�ܣ�");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-10000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ͬ�Ǽ�Ӱ��������");
		end
		if (itemMIN_A == 1 and itemMAX_A == 2) then
			if (Gold < 15000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ�Ͻ�Ǯ�㹻һ�������Ԩ����50����");
			end
			if (itemMIN_B == 1 and itemMAX_B == 2 and Gold >= 15000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%����_��С��������%,1);
				Item.SetData(item_indexA,%����_��󹥻�����%,2);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_2 ==1) then
					Item.SetData(item_indexA,58,5000057);
					Item.SetData(item_indexA,%����_��С��������%,2);
					Item.SetData(item_indexA,%����_��󹥻�����%,2);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexA,%����_����%).."Ӱ�������������ɹ���");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%����_����%).."Ӱ�ӳ�����ʧ�ܣ�");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-15000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ͬ�Ǽ�Ӱ��������");
		end
		if (itemMIN_A == 2 and itemMAX_A == 2) then
			if (Gold < 20000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ�Ͻ�Ǯ�㹻�������Ԩ����50����");
			end
			if (itemMIN_B == 2 and itemMAX_B == 2 and Gold >= 20000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%����_��С��������%,2);
				Item.SetData(item_indexA,%����_��󹥻�����%,2);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_3 ==1) then
					Item.SetData(item_indexA,58,5000058);
					Item.SetData(item_indexA,%����_��С��������%,2);
					Item.SetData(item_indexA,%����_��󹥻�����%,3);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexA,%����_����%).."Ӱ�������������ɹ���");
				end
				if (sr_5 ==1) then
					Item.SetData(item_indexA,58,5000056);
					Item.SetData(item_indexA,%����_��С��������%,1);
					Item.SetData(item_indexA,%����_��󹥻�����%,2);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%����_����%).."Ӱ�ӳ�������Ϊ�ش�ʧ�ܵ����ˣ�");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%����_����%).."Ӱ�ӳ�����ʧ�ܣ�");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-20000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ͬ�Ǽ�Ӱ��������");
		end
		if (itemMIN_A == 2 and itemMAX_A == 3) then
			if (Gold < 25000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ�Ͻ�Ǯ�㹻���������Ԩ����50����");
			end
			if (itemMIN_B == 2 and itemMAX_B == 3 and Gold >= 25000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%����_��С��������%,2);
				Item.SetData(item_indexA,%����_��󹥻�����%,3);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_4 ==1) then
					Item.SetData(item_indexA,58,5000059);
					Item.SetData(item_indexA,%����_��С��������%,3);
					Item.SetData(item_indexA,%����_��󹥻�����%,3);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexA,%����_����%).."Ӱ�������������ɹ���");
				end
				if (sr_5 ==1) then
					Item.SetData(item_indexA,58,5000057);
					Item.SetData(item_indexA,%����_��С��������%,2);
					Item.SetData(item_indexA,%����_��󹥻�����%,2);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%����_����%).."Ӱ�ӳ�������Ϊ�ش�ʧ�ܵ����ˣ�");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%����_����%).."Ӱ�ӳ�����ʧ�ܣ�");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-25000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ͬ�Ǽ�Ӱ��������");
		end
		if (itemMIN_A == 3 and itemMAX_A == 3) then
			if (Gold < 30000 or Char.ItemNum(_PlayerIndex,itemid_66666) < 50) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ�Ͻ�Ǯ�㹻�������Ԩ����50����");
			end
			if (itemMIN_B == 3 and itemMAX_B == 3 and Gold >= 30000 and Char.ItemNum(_PlayerIndex,itemid_66666) >= 50) then
				Item.Kill(_PlayerIndex, item_indexB, 8);
				local info_A = Item.GetData(item_indexA,58);
				Item.SetData(item_indexA,%����_��С��������%,3);
				Item.SetData(item_indexA,%����_��󹥻�����%,3);
				Item.UpItem(_PlayerIndex,selectitem);
				if (sr_4 ==1) then
					Item.SetData(item_indexA,58,5000060);
					Item.SetData(item_indexA,%����_��С��������%,3);
					Item.SetData(item_indexA,%����_��󹥻�����%,4);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexA,%����_����%).."Ӱ�������������ɹ���");
				end
				if (sr_5 ==1) then
					Item.SetData(item_indexA,58,5000058);
					Item.SetData(item_indexA,%����_��С��������%,2);
					Item.SetData(item_indexA,%����_��󹥻�����%,3);
					Item.UpItem(_PlayerIndex,selectitem);
					NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%����_����%).."Ӱ�ӳ�������Ϊ�ش�ʧ�ܵ����ˣ�");
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n"..Item.GetData(item_indexA,%����_����%).."Ӱ�ӳ�����ʧ�ܣ�");
				Char.DelItem(_PlayerIndex,itemid_66666,50);
				Char.AddGold(_PlayerIndex,-30000);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ͬ�Ǽ�Ӱ��������");
		end
		if (itemMIN_A == 3 and itemMAX_A == 4) then
			Msg = "������:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
					.."Ӱ  ��:  ���Ǽ�Ӱ������\\n";
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
		end
	end
end

function ShadowWeapon_Init()
	ShadowWeapon_create();
	return 0;
end
