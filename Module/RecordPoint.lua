local record_point_user = {};                  --Player名单
local record_point_user_list = {};             --纪录点表单
------------------------------------------------------------------------------
local MapEnable = {}
MapEnable[1000] = 0          --0 禁止作为纪录点，括号为地图ID
------------------------------------------------------------------------------
Delegate.RegInit("RecordPoint_Init");

function initRecordPointNpc_Init(index)
	print("纪录点npc_index = " .. index);
	return 1;
end

function RecordPoint_create() 
	if (RecordNPC == nil) then
		RecordNPC = NL.CreateNpc("lua/Module/RecordPoint.lua", "initRecordPointNpc_Init");
		Char.SetData(RecordNPC,%对象_形象%,106602);
		Char.SetData(RecordNPC,%对象_原形%,106602);
		Char.SetData(RecordNPC,%对象_X%,34);
		Char.SetData(RecordNPC,%对象_Y%,31);
		Char.SetData(RecordNPC,%对象_地图%,777);
		Char.SetData(RecordNPC,%对象_方向%,4);
		Char.SetData(RecordNPC,%对象_名字%,"纪录点大使");
		NLG.UpChar(RecordNPC);
		Char.SetTalkedEvent("lua/Module/RecordPoint.lua", "RecordWindow", RecordNPC);
		Char.SetWindowTalkedEvent("lua/Module/RecordPoint.lua", "RecordFunction", RecordNPC);
	end
end


NL.RegItemString("lua/Module/RecordPoint.lua","RecordPoint","LUA_useCrystal");
function RecordPoint(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(RecordNPC,_PlayerIndex) == false) then
		local _obj = record_point_user[Playerkey(_PlayerIndex)];
		if (_obj == nil) then 
			record_point_user[Playerkey(_PlayerIndex)] = {};
			table.insert(record_point_user[Playerkey(_PlayerIndex)] ,Char.GetData(_PlayerIndex,%对象_账号%));
			record_point_user_list[Playerkey(_PlayerIndex)] = {};
			for i=1,5 do
				record_point_user_list[Playerkey(_PlayerIndex)][i] = {};
				record_point_user_list[Playerkey(_PlayerIndex)][i].MapType = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].MapId = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].X = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].Y = 0;
			end
		end
		RecordWindowMsg = "4|\\n      ★★★★儲存座標或進行傳送★★★★"..
				"\\n　　　　　　※每次傳送費用1000元"..
				"\\n　　　　　地圖　　　　座標東　　　座標南　　"..
				"\\n　　════════════════════\\n";
		for i=1,5 do
			local Mappoint = record_point_user_list[Playerkey(_PlayerIndex)][i].MapId;
			if(Mappoint == 0)then
				RecordWindowMsg = RecordWindowMsg .. "　　　　　空\\n";
			else
				RecordWindowMsg = RecordWindowMsg .. "　　　　<"..record_point_user_list[Playerkey(_PlayerIndex)][i].MapId..">　　　　<"..record_point_user_list[Playerkey(_PlayerIndex)][i].X..">　　　 <"..record_point_user_list[Playerkey(_PlayerIndex)][i].Y..">\\n";
			end
		end
		NLG.ShowWindowTalked(_PlayerIndex,RecordNPC,%窗口_选择框%,%按钮_关闭%,1,RecordWindowMsg);
	end
	return;
end


function RecordWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		local _obj = record_point_user[Playerkey(_PlayerIndex)];
		if (_obj == nil) then 
			record_point_user[Playerkey(_PlayerIndex)] = Char.GetData(_PlayerIndex,%对象_账号%);
			table.insert(record_point_user[Playerkey(_PlayerIndex)] ,Char.GetData(_PlayerIndex,%对象_账号%));
			record_point_user_list[Playerkey(_PlayerIndex)] = {};
			for i=1,5 do
				record_point_user_list[Playerkey(_PlayerIndex)][i] = {};
				record_point_user_list[Playerkey(_PlayerIndex)][i].MapType = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].MapId = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].X = 0;
				record_point_user_list[Playerkey(_PlayerIndex)][i].Y = 0;

			end
		end
		RecordWindowMsg = "4|\\n      ★★★★儲存座標或進行傳送★★★★"..
				"\\n　　　　　　※每次傳送費用1000元"..
				"\\n　　　　　地圖　　　　座標東　　　座標南　　"..
				"\\n　　════════════════════\\n";
		for i=1,5 do
			local Mappoint = record_point_user_list[Playerkey(_PlayerIndex)][i].MapId;
			if(Mappoint == 0)then
				RecordWindowMsg = RecordWindowMsg .. "　　　　　空\\n";
			else
				RecordWindowMsg = RecordWindowMsg .. "　　　　<"..record_point_user_list[Playerkey(_PlayerIndex)][i].MapId..">　　　　<"..record_point_user_list[Playerkey(_PlayerIndex)][i].X..">　　　 <"..record_point_user_list[Playerkey(_PlayerIndex)][i].Y..">\\n";
				
			end
		end
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_选择框%,%按钮_关闭%,1,RecordWindowMsg);
	end
	return;
end

function RecordFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data);
		local Mappoint = record_point_user_list[Playerkey(_PlayerIndex)][selectitem].MapId;
		local record_MapType = Char.GetData(_PlayerIndex,%对象_MAP%);
		local record_MapId = Char.GetData(_PlayerIndex,%对象_地图%);
		local record_X = Char.GetData(_PlayerIndex,%对象_X%);
		local record_Y = Char.GetData(_PlayerIndex,%对象_Y%);
		local Gold = Char.GetData(_PlayerIndex, %对象_金币%);
		if (Mappoint == 0 and record_MapType == 0 and MapEnable[record_MapId] == 0) then
			NLG.SystemMessage(_PlayerIndex,"此地圖禁止紀錄點。");
			return;
		end
		if (Mappoint == 0 and record_MapType == 0 and MapEnable[record_MapId] ~= 0) then
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem] = {};
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].MapId = record_MapId;
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].X = record_X;
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].Y = record_Y;
			NLG.SystemMessage(_PlayerIndex,"座標位置儲存成功。");
		end
		--if (Mappoint ~= 0 and Char.PartyNum(_PlayerIndex) > 1)then
		--	NLG.SystemMessage(_PlayerIndex,"只能单人进行传送。");
		--	return;
		--end
		if (Gold < 1000) then
			NLG.SystemMessage(_PlayerIndex,"每次傳送費用1000元。");
			return;
		end
		if (Mappoint ~= 0 and Gold >= 1000) then
			Char.Warp(_PlayerIndex,0,record_point_user_list[Playerkey(_PlayerIndex)][selectitem].MapId,record_point_user_list[Playerkey(_PlayerIndex)][selectitem].X,record_point_user_list[Playerkey(_PlayerIndex)][selectitem].Y);
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem] = {};
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].MapId = 0;
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].X = 0;
			record_point_user_list[Playerkey(_PlayerIndex)][selectitem].Y = 0;
			Char.AddGold(_PlayerIndex,-1000);
			NLG.SystemMessage(_PlayerIndex,"座標紀錄回復初始。");
		end
	end
end

function RecordPoint_Init()
	RecordPoint_create();
	return 0;
end
