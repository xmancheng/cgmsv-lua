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
	print("װ���忨npc_index = " .. index);
	return 1;
end

function EquipCard_create() 
	if (divinerNPC == nil) then
		divinerNPC = NL.CreateNpc("lua/Module/EquipCard.lua", "initEquipCardNpc_Init");
		Char.SetData(divinerNPC,%����_����%,105527);
		Char.SetData(divinerNPC,%����_ԭ��%,105527);
		Char.SetData(divinerNPC,%����_X%,28);
		Char.SetData(divinerNPC,%����_Y%,7);
		Char.SetData(divinerNPC,%����_��ͼ%,25000);
		Char.SetData(divinerNPC,%����_����%,4);
		Char.SetData(divinerNPC,%����_����%,"װ���忨ѧͽ");
		NLG.UpChar(divinerNPC);
		Char.SetTalkedEvent("lua/Module/EquipCard.lua", "DivinerWindow", divinerNPC);
		Char.SetWindowTalkedEvent("lua/Module/EquipCard.lua", "DivinerFunction", divinerNPC);
	end
end

NL.RegItemString("lua/Module/EquipCard.lua","EquipCard","LUA_useCard");
function EquipCard(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	if (NLG.CanTalk(divinerNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		��ӭʹ��װ���忨ϵͳ��\\n	 		�鿴ѡ��װ���Ƿ�忨��װ�����Ͽ�Ƭ\\n\\n";
		for i=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			��\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,divinerNPC,%����_ѡ���%,%��ť_�ر�%,1,WindowMsg);
	end
	return;
end

NL.RegItemString("lua/Module/EquipCard.lua","Runes","LUA_useRunes");
function Runes(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	if (NLG.CanTalk(divinerNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		��ӭʹ�ø�������ϵͳ��\\n	 		�鿴ѡ���Ƿ񸽼����Ի򽫲�λ��������\\n\\n";
		for i=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			��\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,divinerNPC,%����_ѡ���%,%��ť_�ر�%,1,WindowMsg);
	end
	return;
end

function DivinerWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		��ӭʹ��װ���忨ϵͳ��\\n	 		�鿴ѡ��װ���Ƿ�忨��װ�����Ͽ�Ƭ\\n\\n";
		for i=0,4 do
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

function DivinerFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) - 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 4 or selectitem < 0))) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n����ѡ���λ�ò�������");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
		local itemID_B = Item.GetData(item_indexB,0);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ������Ӧ��װ������װ����");
			return;
		end
		local itemIndex = Item.GetData(item_indexA,1);
		local Special = Item.GetData(item_indexA,%����_��������%);
		local Para1 = Item.GetData(item_indexA,%����_�Ӳ�һ%);
		local Para2 = Item.GetData(item_indexA,%����_�Ӳζ�%);
		local Category = Item.GetData(item_indexA,%����_����һ%);
		local Value1 = Item.GetData(item_indexA,%����_����һֵ%);
		local resist_a = Item.GetData(item_indexA,%����_�ҿ�%);
		local resist_b = Item.GetData(item_indexA,%����_��%);
		local resist_c = Item.GetData(item_indexA,%����_����%);
		local resist_d = Item.GetData(item_indexA,%����_˯��%);
		if (Special == 0 and Item.GetData(item_indexA,%����_����%) >= 7 and Item.GetData(item_indexA,%����_����%) <= 14) then
			local nameA = Item.GetData(item_indexA,%����_����%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local nameB = Item.GetData(item_indexB,%����_����%);
			local type = Item.GetData(item_indexB,%����_��������%);
			local info = Item.GetData(item_indexB,57);
			if (type == 14 and CARD_CheckInTable(CardD_ID,itemID_B)==true) then
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%����_��������%,type);
				Item.SetData(item_indexA,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexA,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexA,%����_����%,Newname);
				Item.SetData(item_indexA,57,info);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."��Ƭ����װ����\\n\\n��ж�º�����װ����");
				Char.DelItem(_PlayerIndex,itemID_B,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type ~= 14 or VaildChar(item_indexB) == false) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ۿ�Ƭ��");
				return;
			end
		end
		if (Special == 0 and Item.GetData(item_indexA,%����_����%) <= 6) then
			local nameA = Item.GetData(item_indexA,%����_����%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local nameB = Item.GetData(item_indexB,%����_����%);
			local type = Item.GetData(item_indexB,%����_��������%);
			local info = Item.GetData(item_indexB,57);
			if (type == 14 and CARD_CheckInTable(CardW_ID,itemID_B)==true) then
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = nameB .. nameA;
				Item.SetData(item_indexA,%����_��������%,type);
				Item.SetData(item_indexA,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexA,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexA,%����_����%,Newname);
				Item.SetData(item_indexA,57,info);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."��Ƭ����������\\n\\n��ж�º�����װ����");
				Char.DelItem(_PlayerIndex,itemID_B,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			if (type ~= 14 or VaildChar(item_indexB) == false) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ��ۿ�Ƭ��");
				return;
			end
		end
		if (Special ~= 0 and Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69163) > 0) then
			local colorA = Char.GetData(item_indexA,%����_��ɫ%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local Atype = Item.GetData(item_indexB,%����_����һ%);
			if (Atype == 1 and itemID_B == itemid_69163) then
				local Ameter = Item.GetData(item_indexB,%����_����һֵ%);
				local resist_aa = resist_a+10;
				Item.SetData(item_indexA,%����_����һ%,Atype);
				Item.SetData(item_indexA,%����_����һֵ%,Ameter);
				Item.SetData(item_indexA,%����_�ҿ�%,resist_aa);
				Item.SetData(item_indexA,%����_��%,resist_b);
				Item.SetData(item_indexA,%����_����%,resist_c);
				Item.SetData(item_indexA,%����_˯��%,resist_d);
				Item.SetData(item_indexA,%����_��ɫ%,5);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."���Ը�����װ����");
				Char.DelItem(_PlayerIndex,itemid_69163,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ���Խᾧ��");
		end
		if (Special ~= 0 and Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69164) > 0) then
			local colorA = Item.GetData(item_indexA,%����_��ɫ%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local Atype = Item.GetData(item_indexB,%����_����һ%);
			if (Atype == 2 and itemID_B == itemid_69164) then
				local Ameter = Item.GetData(item_indexB,%����_����һֵ%);
				local resist_bb = resist_b+10;
				Item.SetData(item_indexA,%����_����һ%,Atype);
				Item.SetData(item_indexA,%����_����һֵ%,Ameter);
				Item.SetData(item_indexA,%����_��%,resist_bb);
				Item.SetData(item_indexA,%����_�ҿ�%,resist_a);
				Item.SetData(item_indexA,%����_����%,resist_c);
				Item.SetData(item_indexA,%����_˯��%,resist_d);
				Item.SetData(item_indexA,%����_��ɫ%,3);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."���Ը�����װ����");
				Char.DelItem(_PlayerIndex,itemid_69164,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ���Խᾧ��");
		end
		if (Special ~= 0 and Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69165) > 0) then
			local colorA = Item.GetData(item_indexA,%����_��ɫ%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local Atype = Item.GetData(item_indexB,%����_����һ%);
			if (Atype == 3 and itemID_B == itemid_69165) then
				local Ameter = Item.GetData(item_indexB,%����_����һֵ%);
				local resist_cc = resist_c+10;
				Item.SetData(item_indexA,%����_����һ%,Atype);
				Item.SetData(item_indexA,%����_����һֵ%,Ameter);
				Item.SetData(item_indexA,%����_����%,resist_cc);
				Item.SetData(item_indexA,%����_��%,resist_b);
				Item.SetData(item_indexA,%����_�ҿ�%,resist_a);
				Item.SetData(item_indexA,%����_˯��%,resist_d);
				Item.SetData(item_indexA,%����_��ɫ%,6);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."���Ը�����װ����");
				Char.DelItem(_PlayerIndex,itemid_69165,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ���Խᾧ��");
		end
		if (Special ~= 0 and Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69166) > 0) then
			local colorA = Item.GetData(item_indexA,%����_��ɫ%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local Atype = Item.GetData(item_indexB,%����_����һ%);
			if (Atype == 4 and itemID_B == itemid_69166) then
				local Ameter = Item.GetData(item_indexB,%����_����һֵ%);
				local resist_dd = resist_d+10;
				Item.SetData(item_indexA,%����_����һ%,Atype);
				Item.SetData(item_indexA,%����_����һֵ%,Ameter);
				Item.SetData(item_indexA,%����_˯��%,resist_dd);
				Item.SetData(item_indexA,%����_����%,resist_c);
				Item.SetData(item_indexA,%����_��%,resist_b);
				Item.SetData(item_indexA,%����_�ҿ�%,resist_a);
				Item.SetData(item_indexA,%����_��ɫ%,4);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."���Ը�����װ����");
				Char.DelItem(_PlayerIndex,itemid_69166,1);
				Item.UpItem(_PlayerIndex,selectitem);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ���Խᾧ��");
		end
		if (Special ~= 0 and Para1 == 8) then
			if(Para2 == 1) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫǿ��BP����50��ʱ\\n"
						.."         ÿ����10�㣬��������1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 2) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫħ��BP����50��ʱ\\n"
						.."         ÿ����10�㣬��������1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 3) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ����BP����50��ʱ\\n"
						.."         ÿ����10�㣬��������1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 4) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ�ٶ�BP����50��ʱ\\n"
						.."         ÿ����10�㣬��ɱ����1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
		end
		if (Special ~= 0 and Para1 == 9) then
			if(Para2 == 1) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ����BPÿ7��\\n"
						.."         ��������ǿ��BP1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 2) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ����BPÿ7��\\n"
						.."         ������������BP1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 3) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ����BPÿ7��\\n"
						.."         ��������ħ��BP1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 4) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  Ƭ:  ��ɫ����BPÿ7��\\n"
						.."         ���������ٶ�BP1��\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
		end
		Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
				.."��  Ƭ:  ��\\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
	end
end

function EquipCard_Init()
	EquipCard_create();
	return 0;
end
function CARD_CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		print(v .. " = " .. _idVar)
		if v==_idVar then
			return true
		end
	end
	return false
end