------------------------------------------------------------------------------
local itemid_71001 = 71001;
local itemid_71002 = 71002;
local itemid_71003 = 71003;
local itemid_71004 = 71004;
------------------------------------------------------------------------------

Delegate.RegInit("WeaponCard_Init");

function initWeaponCardNpc_Init(index)
	print("�����忨npc_index = " .. index);
	return 1;
end

function WeaponCard_create() 
	if (prophetNPC == nil) then
		prophetNPC = NL.CreateNpc("lua/Module/WeaponCard.lua", "initWeaponCardNpc_Init");
		Char.SetData(prophetNPC,%����_����%,105527);
		Char.SetData(prophetNPC,%����_ԭ��%,105527);
		Char.SetData(prophetNPC,%����_X%,28);
		Char.SetData(prophetNPC,%����_Y%,7);
		Char.SetData(prophetNPC,%����_��ͼ%,25000);
		Char.SetData(prophetNPC,%����_����%,4);
		Char.SetData(prophetNPC,%����_����%,"�����忨��ʦ");
		NLG.UpChar(prophetNPC);
		Char.SetTalkedEvent("lua/Module/WeaponCard.lua", "ProphetWindow", prophetNPC);
		Char.SetWindowTalkedEvent("lua/Module/WeaponCard.lua", "ProphetFunction", prophetNPC);
	end
end

NL.RegItemString("lua/Module/WeaponCard.lua","WeaponCard","LUA_useWCard");
function WeaponCard(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	if (NLG.CanTalk(prophetNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		��ӭʹ�������忨ϵͳ��\\n	 		�鿴ѡ�������Ƿ�忨���������Ͽ�Ƭ\\n\\n";
		for i=2,3 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			��\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,prophetNPC,%����_ѡ���%,%��ť_�ر�%,1,WindowMsg);
	end
	return;
end

function ProphetWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		��ӭʹ�������忨ϵͳ��\\n	 		�鿴ѡ�������Ƿ�忨���������Ͽ�Ƭ\\n\\n";
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

function ProphetFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) + 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 3 or selectitem < 2))) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n����ѡ���λ�ò�������");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
		local itemID_B = Item.GetData(item_indexB,0);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ������Ӧ��װ������������");
			return;
		end
		local itemIndex = Item.GetData(item_indexA,1);
		local Special = Item.GetData(item_indexA,%����_��������%);
		local Para1 = Item.GetData(item_indexA,%����_�Ӳ�һ%);
		local Para2 = Item.GetData(item_indexA,%����_�Ӳζ�%);
		if (Special == 0 and Item.GetData(item_indexA,%����_����%) <= 6) then
			local nameA = Item.GetData(item_indexA,%����_����%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local nameB = Item.GetData(item_indexB,%����_����%);
			local type = Item.GetData(item_indexB,%����_��������%);
			if (type == 14 and itemID_B == itemid_71001) then
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%����_��������%,type);
				Item.SetData(item_indexA,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexA,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexA,%����_����%,Newname);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."��Ƭ����������\\n\\n��ж�º�����װ����");
				Char.DelItem(_PlayerIndex,itemid_71001,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type == 14 and itemID_B == itemid_71002) then
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%����_��������%,type);
				Item.SetData(item_indexA,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexA,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexA,%����_����%,Newname);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."��Ƭ����������\\n\\n��ж�º�����װ����");
				Char.DelItem(_PlayerIndex,itemid_71002,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type == 14 and itemID_B == itemid_71003) then
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%����_��������%,type);
				Item.SetData(item_indexA,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexA,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexA,%����_����%,Newname);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."��Ƭ����������\\n\\n��ж�º�����װ����");
				Char.DelItem(_PlayerIndex,itemid_71003,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type == 14 and itemID_B == itemid_71004) then
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%����_��������%,type);
				Item.SetData(item_indexA,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexA,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexA,%����_����%,Newname);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."��Ƭ����������\\n\\n��ж�º�����װ����");
				Char.DelItem(_PlayerIndex,itemid_71004,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type ~= 14 or VaildChar(item_indexB) == false) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ۿ�Ƭ��");
				return;
			end
		end
		if (Special ~= 0 and Para1 == 9) then
			if(Para2 == 1) then
				Msg = "������:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ����BPÿ7��\\n"
						.."         ��������ǿ��BP1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 2) then
				Msg = "������:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ����BPÿ7��\\n"
						.."         ������������BP1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 3) then
				Msg = "������:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ����BPÿ7��\\n"
						.."         ��������ħ��BP1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 4) then
				Msg = "������:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ����BPÿ7��\\n"
						.."         ���������ٶ�BP1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
		end
		Msg = "������:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
				.."��  Ƭ:  ��\\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
	end
end

function WeaponCard_Init()
	WeaponCard_create();
	return 0;
end
