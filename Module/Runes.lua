------------------------------------------------------------------------------
local itemid_69163 = 69163;
local itemid_69164 = 69164;
local itemid_69165 = 69165;
local itemid_69166 = 69166;
------------------------------------------------------------------------------

Delegate.RegInit("Runes_Init");

function initRunesNpc_Init(index)
	print("��������npc_index = " .. index);
	return 1;
end

function Runes_create() 
	if (appendNPC == nil) then
		appendNPC = NL.CreateNpc("lua/Module/Runes.lua", "initRunesNpc_Init");
		Char.SetData(appendNPC,%����_����%,105514);
		Char.SetData(appendNPC,%����_ԭ��%,105514);
		Char.SetData(appendNPC,%����_X%,26);
		Char.SetData(appendNPC,%����_Y%,7);
		Char.SetData(appendNPC,%����_��ͼ%,25000);
		Char.SetData(appendNPC,%����_����%,4);
		Char.SetData(appendNPC,%����_����%,"�������Դ�ʦ");
		NLG.UpChar(appendNPC);
		Char.SetTalkedEvent("lua/Module/Runes.lua", "AppendWindow", appendNPC);
		Char.SetWindowTalkedEvent("lua/Module/Runes.lua", "AppendFunction", appendNPC);
	end
end

NL.RegItemString("lua/Module/Runes.lua","Runes","LUA_useRunes");
function Runes(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	if (NLG.CanTalk(appendNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		��ӭʹ�ø�������ϵͳ��\\n	 		�鿴ѡ���Ƿ񸽼����Ի򽫲�λ��������\\n\\n";
		for i=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			��\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,appendNPC,%����_ѡ���%,%��ť_�ر�%,1,WindowMsg);
	end
	return;
end

function AppendWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		��ӭʹ�ø�������ϵͳ��\\n	 		�鿴ѡ���Ƿ񸽼����Ի򽫲�λ��������\\n\\n";
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

function AppendFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) - 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 4 or selectitem < 0))) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n����ѡ���λ�ò�������");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ������Ӧ��װ������װ����");
			return;
		end
		local itemIndex = Item.GetData(item_indexA,1);
		local Category = Item.GetData(item_indexA,%����_����һ%);
		local Value1 = Item.GetData(item_indexA,%����_����һֵ%);
		local resist_a = Item.GetData(item_indexA,%����_�ҿ�%);
		local resist_b = Item.GetData(item_indexA,%����_��%);
		local resist_c = Item.GetData(item_indexA,%����_����%);
		local resist_d = Item.GetData(item_indexA,%����_˯��%);
		if (Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69163) > 0) then
			local colorA = Char.GetData(item_indexA,%����_��ɫ%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%����_����һ%);
			if (type == 1) then
				local meter1 = Item.GetData(item_indexB,%����_����һֵ%);
				local resist_aa = resist_a+10;
				Item.SetData(item_indexA,%����_����һ%,type);
				Item.SetData(item_indexA,%����_����һֵ%,meter1);
				Item.SetData(item_indexA,%����_�ҿ�%,resist_aa);
				Item.SetData(item_indexA,%����_��%,resist_b);
				Item.SetData(item_indexA,%����_����%,resist_c);
				Item.SetData(item_indexA,%����_˯��%,resist_d);
				Item.SetData(item_indexA,%����_��ɫ%,5);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."���Ը�����װ����");
				Char.DelItem(_PlayerIndex,itemid_69163,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ���Խᾧ��");
		end
		if (Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69164) > 0) then
			local colorA = Item.GetData(item_indexA,%����_��ɫ%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%����_����һ%);
			if (type == 2) then
				local meter1 = Item.GetData(item_indexB,%����_����һֵ%);
				local resist_bb = resist_b+10;
				Item.SetData(item_indexA,%����_����һ%,type);
				Item.SetData(item_indexA,%����_����һֵ%,meter1);
				Item.SetData(item_indexA,%����_��%,resist_bb);
				Item.SetData(item_indexA,%����_�ҿ�%,resist_a);
				Item.SetData(item_indexA,%����_����%,resist_c);
				Item.SetData(item_indexA,%����_˯��%,resist_d);
				Item.SetData(item_indexA,%����_��ɫ%,3);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."���Ը�����װ����");
				Char.DelItem(_PlayerIndex,itemid_69164,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ���Խᾧ��");
		end
		if (Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69165) > 0) then
			local colorA = Item.GetData(item_indexA,%����_��ɫ%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%����_����һ%);
			if (type == 3) then
				local meter1 = Item.GetData(item_indexB,%����_����һֵ%);
				local resist_cc = resist_c+10;
				Item.SetData(item_indexA,%����_����һ%,type);
				Item.SetData(item_indexA,%����_����һֵ%,meter1);
				Item.SetData(item_indexA,%����_����%,resist_cc);
				Item.SetData(item_indexA,%����_��%,resist_b);
				Item.SetData(item_indexA,%����_�ҿ�%,resist_a);
				Item.SetData(item_indexA,%����_˯��%,resist_d);
				Item.SetData(item_indexA,%����_��ɫ%,6);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."���Ը�����װ����");
				Char.DelItem(_PlayerIndex,itemid_69165,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ���Խᾧ��");
		end
		if (Category == 0 and Char.ItemNum(_PlayerIndex,itemid_69166) > 0) then
			local colorA = Item.GetData(item_indexA,%����_��ɫ%);
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%����_����һ%);
			if (type == 4) then
				local meter1 = Item.GetData(item_indexB,%����_����һֵ%);
				local resist_dd = resist_d+10;
				Item.SetData(item_indexA,%����_����һ%,type);
				Item.SetData(item_indexA,%����_����һֵ%,meter1);
				Item.SetData(item_indexA,%����_˯��%,resist_dd);
				Item.SetData(item_indexA,%����_����%,resist_c);
				Item.SetData(item_indexA,%����_��%,resist_b);
				Item.SetData(item_indexA,%����_�ҿ�%,resist_a);
				Item.SetData(item_indexA,%����_��ɫ%,4);
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexB,%����_����%).."���Ը�����װ����");
				Char.DelItem(_PlayerIndex,itemid_69166,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊ���Խᾧ��");
		end
		if (Category ~= 0) then
			if(Category == 1) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  ��:  ���Խᾧ����װ��������20\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Category == 2) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  ��:  ���Խᾧ����װ��ˮ����20\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Category == 3) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  ��:  ���Խᾧ����װ��������20\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Category == 4) then
				Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."��  ��:  ���Խᾧ����װ��������20\\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
		end
		Msg = "װ����:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
				.."��  ��:  ��\\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
	end
end

function Runes_Init()
	Runes_create();
	return 0;
end
