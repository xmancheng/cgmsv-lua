local record_point_user = {};                  --Player����
local record_point_user_list = {};             --��¼���
------------------------------------------------------------------------------
local MapEnable = {}
MapEnable[1000] = 0          --0 ��ֹ��Ϊ��¼�㣬����Ϊ��ͼID
------------------------------------------------------------------------------
Delegate.RegInit("RecordPoint_Init");

function initRecordPointNpc_Init(index)
	print("��¼��npc_index = " .. index);
	return 1;
end

function RecordPoint_create() 
	if (RecordNPC == nil) then
		RecordNPC = NL.CreateNpc("lua/Module/RecordPoint.lua", "initRecordPointNpc_Init");
		Char.SetData(RecordNPC,%����_����%,106602);
		Char.SetData(RecordNPC,%����_ԭ��%,106602);
		Char.SetData(RecordNPC,%����_X%,34);
		Char.SetData(RecordNPC,%����_Y%,31);
		Char.SetData(RecordNPC,%����_��ͼ%,777);
		Char.SetData(RecordNPC,%����_����%,4);
		Char.SetData(RecordNPC,%����_����%,"��¼���ʹ");
		NLG.UpChar(RecordNPC);
		Char.SetTalkedEvent("lua/Module/RecordPoint.lua", "RecordWindow", RecordNPC);
		Char.SetWindowTalkedEvent("lua/Module/RecordPoint.lua", "RecordFunction", RecordNPC);
	end
end


NL.RegItemString("lua/Module/RecordPoint.lua","RecordPoint","LUA_useCrystal");
function RecordPoint(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	if (NLG.CanTalk(RecordNPC,_PlayerIndex) == false) then
		local _obj = record_point_user[Playerkey(_PlayerIndex)];
		if (_obj == nil) then 
			record_point_user[Playerkey(_PlayerIndex)] = {};
			table.insert(record_point_user[Playerkey(_PlayerIndex)] ,Char.GetData(_PlayerIndex,%����_�˺�%));
			record_point_user_list[Playerkey(_PlayerIndex)] = {};
			for i=1,5 do
				record_point_user_list[Playerkey(_PlayerIndex)][i] = {};
				record_point_user_list[Playerkey(_PlayerIndex)][i].MapType = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].MapId = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].X = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].Y = 0;
			end
		end
		RecordWindowMsg = "4|\\n      ����ﴢ���������д��͡����"..
				"\\n��������������ÿ�δ��ͷ���1000Ԫ"..
				"\\n������������ͼ�����������궫�����������ϡ���"..
				"\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
		for i=1,5 do
			local Mappoint = record_point_user_list[Playerkey(_PlayerIndex)][i].MapId;
			if(Mappoint == 0)then
				RecordWindowMsg = RecordWindowMsg .. "������������\\n";
			else
				RecordWindowMsg = RecordWindowMsg .. "��������<"..record_point_user_list[Playerkey(_PlayerIndex)][i].MapId..">��������<"..record_point_user_list[Playerkey(_PlayerIndex)][i].X..">������ <"..record_point_user_list[Playerkey(_PlayerIndex)][i].Y..">\\n";
			end
		end
		NLG.ShowWindowTalked(_PlayerIndex,RecordNPC,%����_ѡ���%,%��ť_�ر�%,1,RecordWindowMsg);
	end
	return;
end


function RecordWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		local _obj = record_point_user[Playerkey(_PlayerIndex)];
		if (_obj == nil) then 
			record_point_user[Playerkey(_PlayerIndex)] = Char.GetData(_PlayerIndex,%����_�˺�%);
			table.insert(record_point_user[Playerkey(_PlayerIndex)] ,Char.GetData(_PlayerIndex,%����_�˺�%));
			record_point_user_list[Playerkey(_PlayerIndex)] = {};
			for i=1,5 do
				record_point_user_list[Playerkey(_PlayerIndex)][i] = {};
				record_point_user_list[Playerkey(_PlayerIndex)][i].MapType = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].MapId = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].X = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].Y = 0;

			end
		end
		RecordWindowMsg = "4|\\n      ����ﴢ���������д��͡����"..
				"\\n��������������ÿ�δ��ͷ���1000Ԫ"..
				"\\n������������ͼ�����������궫�����������ϡ���"..
				"\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
		for i=1,5 do
			local Mappoint = record_point_user_list[Playerkey(_PlayerIndex)][i].MapId;
			if(Mappoint == 0)then
				RecordWindowMsg = RecordWindowMsg .. "������������\\n";
			else
				RecordWindowMsg = RecordWindowMsg .. "��������<"..record_point_user_list[Playerkey(_PlayerIndex)][i].MapId..">��������<"..record_point_user_list[Playerkey(_PlayerIndex)][i].X..">������ <"..record_point_user_list[Playerkey(_PlayerIndex)][i].Y..">\\n";
				
			end
		end
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_ѡ���%,%��ť_�ر�%,1,RecordWindowMsg);
	end
	return;
end

function RecordFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data);
		local Mappoint = record_point_user_list[Playerkey(_PlayerIndex)][selectitem].MapId;
		local record_MapType = Char.GetData(_PlayerIndex,%����_MAP%);
		local record_MapId = Char.GetData(_PlayerIndex,%����_��ͼ%);
		local record_X = Char.GetData(_PlayerIndex,%����_X%);
		local record_Y = Char.GetData(_PlayerIndex,%����_Y%);
		local Gold = Char.GetData(_PlayerIndex, %����_���%);
		if (Mappoint == 0 and record_MapType == 0 and MapEnable[record_MapId] == 0) then
			NLG.SystemMessage(_PlayerIndex,"�˵�ͼ��ֹ��¼�㡣");
			return;
		end
		if (Mappoint == 0 and record_MapType == 0 and MapEnable[record_MapId] ~= 0) then
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem] = {};
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].MapId = record_MapId;
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].X = record_X;
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].Y = record_Y;
			NLG.SystemMessage(_PlayerIndex,"����λ�ô���ɹ���");
		end
		--if (Mappoint ~= 0 and Char.PartyNum(_PlayerIndex) > 1)then
		--	NLG.SystemMessage(_PlayerIndex,"ֻ�ܵ��˽��д��͡�");
		--	return;
		--end
		if (Gold < 1000) then
			NLG.SystemMessage(_PlayerIndex,"ÿ�δ��ͷ���1000Ԫ��");
			return;
		end
		if (Mappoint ~= 0 and Gold >= 1000) then
			Char.Warp(_PlayerIndex,0,record_point_user_list[Playerkey(_PlayerIndex)][selectitem].MapId,record_point_user_list[Playerkey(_PlayerIndex)][selectitem].X,record_point_user_list[Playerkey(_PlayerIndex)][selectitem].Y);
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem] = {};
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].MapId = 0;
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].X = 0;
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].Y = 0;
			Char.AddGold(_PlayerIndex,-1000);
			NLG.SystemMessage(_PlayerIndex,"�����¼�ظ���ʼ��");
		end
	end
end

function RecordPoint_Init()
	RecordPoint_create();
	return 0;
end