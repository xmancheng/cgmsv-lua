------------------------------------------------------------------------------
local itemid_71016 = 71016;
local itemid_71017 = 71017;
local itemid_71018 = 71018;
local itemid_71019 = 71019;
------------------------------------------------------------------------------
local a1 = {%����_����%,40,30,20};
local a2 = {%����_����%,40,30,20};
local a3 = {%����_����%,25,20,15};
local a4 = {%����_����%,10,7,4};
local a5 = {%����_�ظ�%,15,10,5};
local a6 = {%����_HP%,150,100,50};
local a7 = {%����_MP%,60,40,20};
local a8 = {%����_ħ��%,40,30,20};
local a9 = {%����_ħ��%,20,15,10};
local r1 = {%����_����%,21,14,7};
local r2 = {%����_˯��%,21,14,7};
local r3 = {%����_ʯ��%,21,14,7};
local r4 = {%����_��%,21,14,7};
local r5 = {%����_�ҿ�%,21,14,7};
local r6 = {%����_����%,21,14,7};
local f1 = {%����_��ɱ%,6,4,2};
local f2 = {%����_����%,6,4,2};
local f3 = {%����_����%,6,4,2};
local f4 = {%����_����%,6,4,2};
local Abilitynotes = {a1,a2,a3,a4,a5,a6,a7,a8,a9};
local Resistnotes = {r1,r2,r3,r4,r5,r6};
local Fixnotes = {f1,f2,f3,f4};
local Qualitynotes = {a1,a2,a3,a4,a5,a6,a7,a8,a9,r1,r2,r3,r4,r5,r6,f1,f2,f3,f4};
------------------------------------------------------------------------------

Delegate.RegInit("AccessoriesCube_Init");

function initAccessoriesCubeNpc_Init(index)
	print("ǳ�ܿ���npc_index = " .. index);
	return 1;
end

function AccessoriesCube_create() 
	if (exploitNPC == nil) then
		exploitNPC = NL.CreateNpc("lua/Module/AccessoriesCube.lua", "initAccessoriesCubeNpc_Init");
		Char.SetData(exploitNPC,%����_����%,105389);
		Char.SetData(exploitNPC,%����_ԭ��%,105389);
		Char.SetData(exploitNPC,%����_X%,27);
		Char.SetData(exploitNPC,%����_Y%,7);
		Char.SetData(exploitNPC,%����_��ͼ%,25000);
		Char.SetData(exploitNPC,%����_����%,4);
		Char.SetData(exploitNPC,%����_����%,"ǳ�ܿ���ר��");
		NLG.UpChar(exploitNPC);
		Char.SetTalkedEvent("lua/Module/AccessoriesCube.lua", "ExploitWindow", exploitNPC);
		Char.SetWindowTalkedEvent("lua/Module/AccessoriesCube.lua", "ExploitFunction", exploitNPC);
	end
end

NL.RegItemString("lua/Module/AccessoriesCube.lua","AccessoriesCube","LUA_useACube");
function AccessoriesCube(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	if (NLG.CanTalk(exploitNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\n 		��ӭʹ��ǳ�ܿ���ϵͳ��\\n	 		ǳ�ܿ�����ӵͽ�����ʹ�÷���\\n\\n";
		for i=5,6 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			��\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,exploitNPC,%����_ѡ���%,%��ť_�ر�%,1,WindowMsg);
	end
	return;
end

function ExploitWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "4|\\n\\n 		��ӭʹ��ǳ�ܿ���ϵͳ��\\n	 		ǳ�ܿ�����ӵͽ�����ʹ�÷���\\n\\n";
		for i=5,6 do
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

function ExploitFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) + 4;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 6 or selectitem < 5))) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n����ѡ���λ�ò�������");
				return;
		end
		local item_indexA = Char.GetItemIndex(_PlayerIndex,selectitem);
		if (VaildChar(item_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ������Ӧ��װ������װ��Ʒ��");
			return;
		end
		local itemDur = Item.GetData(item_indexA,%����_�;�%);
		local itemID = Item.GetData(item_indexA,0);
		local Special = Item.GetData(item_indexA,%����_��������%);
		local Para1 = Item.GetData(item_indexA,%����_�Ӳ�һ%);
		local Para2 = Item.GetData(item_indexA,%����_�Ӳζ�%);
		local ar = math.random(1,9);
		local rr = math.random(1,6);
		local fr = math.random(1,4);
		local qr = math.random(1,19);
		local pr_1 = math.random(2,4);
		local pr_2 = math.random(2,4);
		local pr_3 = math.random(2,4);
		local pr_4 = math.random(2,4);
		if (Para2 <= 1 and Char.ItemNum(_PlayerIndex,itemid_71016) > 0 and Item.GetData(item_indexA,%����_����%) >= 15 and Item.GetData(item_indexA,%����_����%) <= 21) then
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%����_��������%);
			if (type == 14 and Item.GetData(item_indexB,%����_����%) == 39) then
				Item.Kill(_PlayerIndex, item_indexA, selectitem);
				Char.GiveItem(_PlayerIndex,itemID,1);
				local cs = Char.FindItemId(_PlayerIndex,itemID);
				local item_indexC = Char.GetItemIndex(_PlayerIndex,cs);
				local nameC = Item.GetData(item_indexC,%����_����%);
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = "�����" .. nameC;
				Item.SetData(item_indexC,%����_��������%,type);
				Item.SetData(item_indexC,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexC,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexC,%����_����%,Newname);
				Item.SetData(item_indexC,%����_�;�%,itemDur);
				local C1 = Item.GetData(item_indexC,Abilitynotes[ar][1]);
				local C1_P = C1 + Abilitynotes[ar][pr_1];
				Item.SetData(item_indexC,Abilitynotes[ar][1],C1_P);
				Item.UpItem(_PlayerIndex,cs);
				if (fr ==1) then
					local C2 = Item.GetData(item_indexC,Resistnotes[rr][1]);
					local C2_P = C2 + Resistnotes[rr][pr_2];
					Item.SetData(item_indexC,Resistnotes[rr][1],C2_P);
					Newname = "ϡ�С�" .. nameC;
					Item.SetData(item_indexC,%����_����%,Newname);
					Item.SetData(item_indexC,%����_�Ӳζ�%,2);
					Item.UpItem(_PlayerIndex,cs);
				end
				if (qr ==1) then
					local C2 = Item.GetData(item_indexC,Resistnotes[rr][1]);
					local C2_P = C2 + Resistnotes[rr][pr_2];
					Item.SetData(item_indexC,Resistnotes[rr][1],C2_P);
					local C3 = Item.GetData(item_indexC,Fixnotes[fr][1]);
					local C3_P = C3 + Fixnotes[fr][pr_3];
					Item.SetData(item_indexC,Fixnotes[fr][1],C3_P);
					Newname = "��Ҋ��" .. nameC;
					Item.SetData(item_indexC,%����_����%,Newname);
					Item.SetData(item_indexC,%����_�Ӳζ�%,3);
					Item.UpItem(_PlayerIndex,cs);
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexC,%����_����%).."ǳ�ܿ����ɹ���");
				Char.DelItem(_PlayerIndex,itemid_71016,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊǳ�ܷ���(����)��");
		end
		if (Special == 14 and Para2 == 2 and Char.ItemNum(_PlayerIndex,itemid_71017) > 0 and Item.GetData(item_indexA,%����_����%) >= 15 and Item.GetData(item_indexA,%����_����%) <= 21) then
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%����_��������%);
			if (type == 14 and Item.GetData(item_indexB,%����_����%) == 39) then
				Item.Kill(_PlayerIndex, item_indexA, selectitem);
				Char.GiveItem(_PlayerIndex,itemID,1);
				local cs = Char.FindItemId(_PlayerIndex,itemID);
				local item_indexC = Char.GetItemIndex(_PlayerIndex,cs);
				local nameC = Item.GetData(item_indexC,%����_����%);
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = "ϡ�С�" .. nameC;
				Item.SetData(item_indexC,%����_��������%,type);
				Item.SetData(item_indexC,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexC,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexC,%����_����%,Newname);
				Item.SetData(item_indexC,%����_�;�%,itemDur);
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
					Newname = "��Ҋ��" .. nameC;
					Item.SetData(item_indexC,%����_����%,Newname);
					Item.SetData(item_indexC,%����_�Ӳζ�%,3);
					Item.UpItem(_PlayerIndex,cs);
				end
				if (qr ==1) then
					local C3 = Item.GetData(item_indexC,Fixnotes[fr][1]);
					local C3_P = C3 + Fixnotes[fr][pr_3];
					Item.SetData(item_indexC,Fixnotes[fr][1],C3_P);
					local C4 = Item.GetData(item_indexC,Qualitynotes[qr][1]);
					local C4_P = C4 + Qualitynotes[qr][pr_4];
					Item.SetData(item_indexC,Qualitynotes[qr][1],C4_P);
					Newname = "���f��" .. nameC;
					Item.SetData(item_indexC,%����_����%,Newname);
					Item.SetData(item_indexC,%����_�Ӳζ�%,4);
					Item.UpItem(_PlayerIndex,cs);
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexC,%����_����%).."ǳ�ܿ����ɹ���");
				Char.DelItem(_PlayerIndex,itemid_71017,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊǳ�ܷ���(ϡ��)��");
		end
		if (Special == 14 and Para2 == 3 and Char.ItemNum(_PlayerIndex,itemid_71018) > 0 and Item.GetData(item_indexA,%����_����%) >= 15 and Item.GetData(item_indexA,%����_����%) <= 21) then
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%����_��������%);
			if (type == 14 and Item.GetData(item_indexB,%����_����%) == 39) then
				Item.Kill(_PlayerIndex, item_indexA, selectitem);
				Char.GiveItem(_PlayerIndex,itemID,1);
				local cs = Char.FindItemId(_PlayerIndex,itemID);
				local item_indexC = Char.GetItemIndex(_PlayerIndex,cs);
				local nameC = Item.GetData(item_indexC,%����_����%);
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = "��Ҋ��" .. nameC;
				Item.SetData(item_indexC,%����_��������%,type);
				Item.SetData(item_indexC,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexC,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexC,%����_����%,Newname);
				Item.SetData(item_indexC,%����_�;�%,itemDur);
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
					Newname = "���f��" .. nameC;
					Item.SetData(item_indexC,%����_����%,Newname);
					Item.SetData(item_indexC,%����_�Ӳζ�%,4);
					Item.UpItem(_PlayerIndex,cs);
				end
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexC,%����_����%).."ǳ�ܿ����ɹ���");
				Char.DelItem(_PlayerIndex,itemid_71018,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊǳ�ܷ���(����)��");
		end
		if (Special == 14 and Para2 == 4 and Char.ItemNum(_PlayerIndex,itemid_71019) > 0 and Item.GetData(item_indexA,%����_����%) >= 15 and Item.GetData(item_indexA,%����_����%) <= 21) then
			local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
			local type = Item.GetData(item_indexB,%����_��������%);
			if (type == 14 and Item.GetData(item_indexB,%����_����%) == 39) then
				Item.Kill(_PlayerIndex, item_indexA, selectitem);
				Char.GiveItem(_PlayerIndex,itemID,1);
				local cs = Char.FindItemId(_PlayerIndex,itemID);
				local item_indexC = Char.GetItemIndex(_PlayerIndex,cs);
				local nameC = Item.GetData(item_indexC,%����_����%);
				local meter1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
				local meter2 = Item.GetData(item_indexB,%����_�Ӳζ�%);
				Newname = "���f��" .. nameC;
				Item.SetData(item_indexC,%����_��������%,type);
				Item.SetData(item_indexC,%����_�Ӳ�һ%,meter1);
				Item.SetData(item_indexC,%����_�Ӳζ�%,meter2);
				Item.SetData(item_indexC,%����_����%,Newname);
				Item.SetData(item_indexC,%����_�;�%,itemDur);
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
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n�ѽ�"..Item.GetData(item_indexC,%����_����%).."ǳ�ܿ����ɹ���");
				Char.DelItem(_PlayerIndex,itemid_71019,1);
			end
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_��%,1,"\\n\\n\\n��ȷ����Ʒ����һ���Ƿ�Ϊǳ�ܷ���(��˵)��");
		end
		if (Special ~= 0 and Para1 == 7 and item_indexA ~= nill) then
			if(Para2 == 1) then
				Msg = "װ��Ʒ:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."ǳ  ��:  һ��  \\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 2) then
				Msg = "װ��Ʒ:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."ǳ  ��:  ����  \\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 3) then
				Msg = "װ��Ʒ:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."ǳ  ��:  ����  \\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
			if(Para2 == 4) then
				Msg = "װ��Ʒ:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
						.."ǳ  ��:  ����  \\n";
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
				return;
			end
		else
		Msg = "װ��Ʒ:  "..Item.GetData(item_indexA,%����_����%).."  \\n"
				.."ǳ  ��:  ��  \\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
		end
	end
end

function AccessoriesCube_Init()
	AccessoriesCube_create();
	return 0;
end
