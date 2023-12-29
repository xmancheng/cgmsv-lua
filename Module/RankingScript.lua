local ItemMenus = {
  { "[�������︽��ý�顡��]x1����������30", 69993, 30, 1},
  { "[�������M����ˮ������]x1����������20", 900500, 20, 1},
  { "[�������S�����F������]x1����������15", 900501, 15, 1},
  { "[�������ͻ�K��������]x1����������10", 900502, 10, 1},
  { "[�������x���K��������]x1����������10", 900503, 10, 1},
  { "[���������ݷe��ȯ����]x10��������10", 69000, 10, 10},
}

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local STime = os.time()
local YS = 30 --�ű���ʱ�����봴��NPC
local SXTime = 15 --NPCˢ��ʱ�䡤��
local FTime = os.time()
local Setting = 0;
--���н���
--     ��	��	һ	��	��
--     ʮ	��	��	��	��
------------���ݶ�սNPC����------------
EnemySet[1] = {9116, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
EnemySet[2] = {9115, 0, 0, 0, 0, 9134, 0, 0, 0, 0}
EnemySet[3] = {9114, 0, 0, 0, 0, 9133, 0, 0, 0, 0}
EnemySet[4] = {9113, 0, 0, 0, 0, 9132, 0, 0, 0, 0}
EnemySet[5] = {9112, 0, 0, 0, 0, 9131, 0, 0, 0, 0}
EnemySet[6] = {9111, 9116, 9115, 0, 0, 0, 0, 9134, 0, 0}
EnemySet[7] = {9110, 9114, 9113, 0, 0, 0, 9133, 9132, 0, 0}
EnemySet[8] = {9106, 9107, 9112, 0, 0, 9125, 9125, 9131, 0, 0}
EnemySet[9] = {9103, 9100, 9101, 9111, 9110, 9129, 0, 0, 0, 0}
EnemySet[10] = {9099, 9115, 9114, 9113, 9112, 9102, 9134, 9133, 9132, 9131}
BaseLevelSet[1] = {73, 0, 0, 0, 0, 0, 0, 0, 0, 0}
BaseLevelSet[2] = {76, 0, 0, 0, 0, 73, 0, 0, 0, 0}
BaseLevelSet[3] = {79, 0, 0, 0, 0, 75, 0, 0, 0, 0}
BaseLevelSet[4] = {82, 0, 0, 0, 0, 78, 0, 0, 0, 0}
BaseLevelSet[5] = {85, 0, 0, 0, 0, 80, 0, 0, 0, 0}
BaseLevelSet[6] = {88, 73, 76, 0, 0, 0, 0, 73, 0, 0}
BaseLevelSet[7] = {88, 79, 82, 0, 0, 0, 75, 78, 0, 0}
BaseLevelSet[8] = {100, 97, 85, 0, 0, 80, 80, 80, 0, 0}
BaseLevelSet[9] = {109, 118, 115, 88, 88, 99, 0, 0, 0, 0}
BaseLevelSet[10] = {121, 86, 89, 92, 95, 112, 83, 85, 88, 90}
Pos[1] = {{"����",100320,25290,18,29,5,EnemySet[1],1,BaseLevelSet[1]}}
Pos[2] = {{"������",100092,25290,20,31,5,EnemySet[2],2,BaseLevelSet[2]}}
Pos[3] = {{"������",100394,25290,16,29,5,EnemySet[3],3,BaseLevelSet[3]}}
Pos[4] = {{"������",100006,25290,20,33,5,EnemySet[4],4,BaseLevelSet[4]}}
Pos[5] = {{"����",100416,25290,18,31,5,EnemySet[5],5,BaseLevelSet[5]}}
Pos[6] = {{"���Z��",100164,25290,19,13,4,EnemySet[6],6,BaseLevelSet[6]}}
Pos[7] = {{"�R�W�᠖",100071,25290,23,13,4,EnemySet[7],7,BaseLevelSet[7]}}
Pos[8] = {{"�WƝ���",100802,25290,27,13,4,EnemySet[8],8,BaseLevelSet[8]}}
Pos[9] = {{"������˹",100602,25290,35,20,5,EnemySet[9],9,BaseLevelSet[9]}}
Pos[10] = {{"���x����",100577,25290,36,30,6,EnemySet[10],10,BaseLevelSet[10]}}

tbl_AutoRankingNpcIndex = tbl_AutoRankingNpcIndex or {}
------------------------------------------------
--��������
tbl_duel_user = {};			--��ǰ������ҵ��б�
tbl_win_user = {};
------------------------------------------------
Delegate.RegInit("initRankingScriptNpc");

function initRankingScriptNpc_Init(index)
	return 1;
end

function initRankingScriptNpc()
	if (RankingScriptNpcA == nil) then
		RankingScriptNpcA = NL.CreateNpc("lua/Module/RankingScript.lua", "initRankingScriptNpc_Init");
		Char.SetData(RankingScriptNpcA,%����_����%,11394);
		Char.SetData(RankingScriptNpcA,%����_ԭ��%,11394);
		Char.SetData(RankingScriptNpcA,%����_X%,229);
		Char.SetData(RankingScriptNpcA,%����_Y%,64);
		Char.SetData(RankingScriptNpcA,%����_��ͼ%,1000);
		Char.SetData(RankingScriptNpcA,%����_����%,4);
		Char.SetData(RankingScriptNpcA,%����_ԭ��%,"�Ԅ����݌���ģʽ");
		NLG.UpChar(RankingScriptNpcA);
		Char.SetLoopEvent(nil, "AutoRanking_LoopEvent", RankingScriptNpcA, 1000)
		Char.SetWindowTalkedEvent("lua/Module/RankingScript.lua","RankingScriptA",RankingScriptNpcA);
		Char.SetTalkedEvent("lua/Module/RankingScript.lua","RankingScriptMsgA", RankingScriptNpcA);
	end
	if (RankingScriptNpcB == nil) then
		RankingScriptNpcB = NL.CreateNpc("lua/Module/RankingScript.lua", "initRankingScriptNpc_Init");
		Char.SetData(RankingScriptNpcB,%����_����%,17092);
		Char.SetData(RankingScriptNpcB,%����_ԭ��%,17092);
		Char.SetData(RankingScriptNpcB,%����_X%,36);
		Char.SetData(RankingScriptNpcB,%����_Y%,13);
		Char.SetData(RankingScriptNpcB,%����_��ͼ%,25291);
		Char.SetData(RankingScriptNpcB,%����_����%,6);
		Char.SetData(RankingScriptNpcB,%����_ԭ��%,"��̭�I��̎");
		NLG.UpChar(RankingScriptNpcB);
		Char.SetWindowTalkedEvent("lua/Module/RankingScript.lua","RankingScriptB",RankingScriptNpcB);
		Char.SetTalkedEvent("lua/Module/RankingScript.lua","RankingScriptMsgB", RankingScriptNpcB);
	end
	if (RankingScriptNpcC == nil) then
		RankingScriptNpcC = NL.CreateNpc("lua/Module/RankingScript.lua", "initRankingScriptNpc_Init");
		Char.SetData(RankingScriptNpcC,%����_����%,231116);
		Char.SetData(RankingScriptNpcC,%����_ԭ��%,231116);
		Char.SetData(RankingScriptNpcC,%����_X%,18);
		Char.SetData(RankingScriptNpcC,%����_Y%,18);
		Char.SetData(RankingScriptNpcC,%����_��ͼ%,777);
		Char.SetData(RankingScriptNpcC,%����_����%,6);
		Char.SetData(RankingScriptNpcC,%����_ԭ��%,"��������");
		NLG.UpChar(RankingScriptNpcC);
		Char.SetLoopEvent(nil, "RankingScript_LoopEvent",RankingScriptNpcC, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/RankingScript.lua","RankingScriptC",RankingScriptNpcC);
		Char.SetTalkedEvent("lua/Module/RankingScript.lua","RankingScriptMsgC", RankingScriptNpcC);
	end
end

function RankingScriptMsgA(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		local msg = "1\\n@c�gӭ�M�����݌�����\\n\\n"
			.."[���������݌���]\\n" 
			.."[���^�������f����]\\n" 
			.."[���M�Ј����^��]\\n" 
			.."[������L�ڷe�֡�]\\n" 
			.."[����ԃ�����c����]\\n" 
			.."[�����Q���ݪ��]\\n" ;
		NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, msg);
	end
	return;
end


function RankingScriptA(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)			
	if seqno == 1 then
		if data == 2 then  ----�������ݶ�ս
			if(Char.ItemNum(player,70213)>0 or Char.ItemNum(player,70212)>0 or Char.ItemNum(player,70211)>0) then
				NLG.SystemMessage(player,"[ϵ�y]�M�����ǰ�������κ��Y���倡�");
				return;
			else
				local msg = "3\\n@c�x�����݌���ģʽ\\n"
					.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
					.. "\\n1��VS��1�����ˌ���\\n"
					.. "\\n3��VS��3�����ˌ���\\n"
					.. "\\n5��VS��5���F�w����\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 21, msg);
			end
		end
		if data == 3 then  ----�ۿ�����˵��
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "\\n@cՈԔ����x�����f��\\n"
				.. "\\n�x��1�ˡ�3�ˡ�5�˵Č���ģʽ\\n"
				.. "\\n�M��������_ʼ�Ԅ��䌦���Y\\n"
				.. "\\n��܊�ɫ@��5���e��\\n"
				.. "\\n����ʧ����1���e��\\n";
			NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 31, msg);
			end
		end
		if data == 4 then  ----���г����ս
			if (tbl_duel_user~=nil) then
			local msg = "3\\n@c�����^����\\n"
				.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
				for i = 1, #tbl_duel_user do
				local duelplayer = tbl_duel_user[i];
				local duelplayerName = Char.GetData(duelplayer,CONST.CHAR_����);
				msg = msg .. duelplayerName .. "��VS��".. "\\n"
			end
			NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 41, msg);
			else
				return;
			end
		end
		if data == 5 then  ----��½���ڻ���
			if (NLG.CanTalk(npc, player) == true) then
			local key = Char.FindItemId(player,69000);
			local item = Char.GetItemIndex(player,key);
			local PointCount = Char.ItemNum(player,69000);
			local msg = "\\n@c����L�����ݷe��\\n"
				.. "\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
				.. "\\n�����ݷe��ȯ����".. PointCount .. "��ȫ���ς���?\\n";
			NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 51, msg);
			end
		end
		if data == 6 then  ----��ѯ���ݵ���&ִ��
			if (NLG.CanTalk(npc, player) == true) then
			local PointCount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local msg = "\\n@c��ԃ�����c������\\n"
				.. "\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
				.. "\\n�����ݷe�֡�����".. PointCount .. "ȯ\\n";
			NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 61, msg);
			end
		end
		if data == 7 then  ----�һ����ݽ���
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "3\\n@c���Q���ݪ����\\n"
				.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
				for i = 1, 6 do
					msg = msg .. ItemMenus[i][1] .. "\\n"
				end
			NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 71, msg);
			end
		end
	end
	------------------------------------------------------------
	if seqno == 21 then  ----�������ݶ�սִ��
		key = data
		if select == 2 then
			return;
		end
		if key == data then
			local playerName = Char.GetData(player,CONST.CHAR_����);
			local partyname = playerName .. "���";
			Char.SetData(player,%����_Ѫ%, Char.GetData(player,%����_���Ѫ%));
			Char.SetData(player,%����_ħ%, Char.GetData(player,%����_���ħ%));
			NLG.UpChar(player);
			--print(key)
			if ( key==1 ) then
				Char.GiveItem(player,70213,1);
				local slot = Char.FindItemId(player,70213);
				local item_indexA = Char.GetItemIndex(player,slot);
				Item.SetData(item_indexA,%����_����%,1);
				Item.UpItem(player,slot);
				table.insert(tbl_duel_user,player);
				Char.Warp(player,0,25290,15,34);
			elseif ( key==3 ) then
				Char.GiveItem(player,70212,1);
				local slot = Char.FindItemId(player,70212);
				local item_indexA = Char.GetItemIndex(player,slot);
				Item.SetData(item_indexA,%����_����%,6);
				Item.UpItem(player,slot);
				table.insert(tbl_duel_user,player);
				Char.Warp(player,0,25290,15,34);
			elseif ( key==5 ) then
				Char.GiveItem(player,70211,1);
				local slot = Char.FindItemId(player,70211);
				local item_indexA = Char.GetItemIndex(player,slot);
				Item.SetData(item_indexA,%����_����%,9);
				Item.UpItem(player,slot);
				table.insert(tbl_duel_user,player);
				Char.Warp(player,0,25290,15,34);
			end
			def_round_start(player, 'wincallbackfunc');
		else
			return 0;
		end
	end
	if seqno == 41 then  ----���г����ս&ִ��
		key = data
		local duelplayer= tbl_duel_user[key];
		if ( duelplayer ~= nil ) then
			NLG.WatchEntry(player, tonumber(duelplayer));
		else
			return 0;
		end
	end
	if seqno == 51 then  ----��½���ڻ���ִ��
		if select == 4 then
			local key = Char.FindItemId(player,69000);
			local item = Char.GetItemIndex(player,key);
			local PointCount = Char.ItemNum(player,69000);
			local Restcount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local Restcount = Restcount + PointCount;
			SQL.Run("update lua_hook_character set RankedPoints= '"..Restcount.."' where CdKey='"..cdk.."'")
			NLG.UpChar(player);
			Char.DelItem(player,69000,PointCount);
			NLG.SystemMessage(player,"[ϵ�y]�ѳɹ��ς��������ݷe��ȯ��");
		else
			return 0;
		end
	end
	if seqno == 71 then  ----�һ����ݽ���ִ��
		key = data
		if select == 2 then
			return;
		end
		if key == data then
			local PointCount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local itemcost= ItemMenus[data][3];
			if ( PointCount >= itemcost ) then
				local Restcount = PointCount - itemcost;
				SQL.Run("update lua_hook_character set RankedPoints= '"..Restcount.."' where CdKey='"..cdk.."'")
				NLG.UpChar(player);
				Char.GiveItem(player,ItemMenus[data][2],ItemMenus[data][4]);
			else
				NLG.SystemMessage(player,"[ϵ�y]���ݷe�֔������㣡");
				return 0;
			end
		end
	end
end

function RankingScriptMsgB(npc, player)  ----������̭�콱��
	if (NLG.CanTalk(npc, player) == true) then
		if (Char.ItemNum(player,70213) > 0) then
			local slot = Char.FindItemId(player,70213);
			local item_indexA = Char.GetItemIndex(player,slot);
			Char.DelItem(player,70213,1);
			Char.GiveItem(player,69000,1);
			Char.Warp(player,0,1000,229,65);
		end
		if (Char.ItemNum(player,70212) > 0) then
			local slot = Char.FindItemId(player,70212);
			local item_indexA = Char.GetItemIndex(player,slot);
			Char.DelItem(player,70212,1);
			Char.GiveItem(player,69000,1);
			Char.Warp(player,0,1000,229,65);
		end
		if (Char.ItemNum(player,70211) > 0) then
			local slot = Char.FindItemId(player,70211);
			local item_indexA = Char.GetItemIndex(player,slot);
			Char.DelItem(player,70211,1);
			Char.GiveItem(player,69000,1);
			Char.Warp(player,0,1000,229,65);
		end
	end
	return;
end
function RankingScriptB(_MeIndex,_PlayerIndex,_seqno,_select,_data)

end

function RankingScript_LoopEvent(_MeIndex)
	--��������
	local DTime = os.time()
	if DTime - STime >= YS then
		for i=1, #Pos do
		local Num = Pos[i][1][8]
			if tbl_AutoRankingNpcIndex[Num] == nil then
				local AutoRankingNpcIndex = CreateRankingNpc( Pos[i][1][2], Pos[i][1][1], 0, Pos[i][1][3], Pos[i][1][4], Pos[i][1][5], Pos[i][1][6])
				tbl_AutoRankingNpcIndex[Num] = AutoRankingNpcIndex
			end
		end
	end
end
--NPC�Ի��¼�(NPC����)
function RankingScriptMsgC(_NpcIndex, _PlayerIndex)
tbl_AutoRankingNpcIndex = {}
end

--NPC�����¼�(NPC����)
function RankingScriptC ( _NpcIndex, _PlayerIndex, _seqno, _select, _data)
	
end
function CreateRankingNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local AutoRankingNpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( AutoRankingNpcIndex, %����_����%, Image);
	Char.SetData( AutoRankingNpcIndex, %����_ԭ��%, Image);
	Char.SetData( AutoRankingNpcIndex, %����_��ͼ����%, MapType);
	Char.SetData( AutoRankingNpcIndex, %����_��ͼ%, MapID);
	Char.SetData( AutoRankingNpcIndex, %����_X%, PosX);
	Char.SetData( AutoRankingNpcIndex, %����_Y%, PosY);
	Char.SetData( AutoRankingNpcIndex, %����_����%, Dir);
	Char.SetData( AutoRankingNpcIndex, %����_ԭ��%, Name);
	Char.SetData( AutoRankingNpcIndex, %����_��ɫ%, NameColor);
	tbl_LuaNpcIndex = tbl_LuaNpcIndex or {}
	tbl_LuaNpcIndex["RankingNpc"] = AutoRankingNpcIndex
	Char.SetTalkedEvent(nil, "RankingNpc__Talked", AutoRankingNpcIndex)
	Char.SetWindowTalkedEvent(nil, "RankingNpc__WindowTalked", AutoRankingNpcIndex)
	Char.SetLoopEvent(nil, "RankingNpc_LoopEvent", AutoRankingNpcIndex, math.random(1000,5000))
	NLG.UpChar(AutoRankingNpcIndex)
	return AutoRankingNpcIndex
end
function RankingNpc_LoopEvent(_MeIndex)
	local spell = 6;
	NLG.SetAction(_MeIndex,spell);
	NLG.UpChar(_MeIndex);
end
function RankingNpc__Talked(_NpcIndex, _PlayerIndex)
	if(NLG.CheckInFront(_PlayerIndex, _NpcIndex, 1)==false and _Mode~=1) then
		return ;
	end
	--�������
	local i;
	i = Char.GetData(_PlayerIndex, %����_����%);
	if i >= 4 then 
		i = i - 4;
	else
		i = i + 4;		
	end
	Char.SetData(_NpcIndex, %����_����%,i);
	NLG.UpChar( _NpcIndex);
	local	token ="\n\n\n\n@cʧ���߁G���倣��x�_��ո�������"

       NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, token)

end
function RankingNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
		return;
	end
end


function def_round_start(player, callback)

	MapUser = NLG.GetMapPlayer(0,25290);
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--��ʼս��
	tbl_UpIndex = {}
	battleindex = {}
	--battleindex[player] = Battle.PVP(tbl_UpIndex[1], player);
	--Battle.SetPVPWinEvent('lua/Modules/autoRanking.lua', 'def_round_wincallback', battleindex);

	if (Char.ItemNum(player,70213)>0) then
		local slot = Char.FindItemId(player,70213);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%����_����%);
		if (Num>=1 and Num<6)then
			NLG.SystemMessage(-1,"�����M��:"..Pos[Num][1][1].." VS "..Char.GetData(player,%����_����%));
			local battleindex = Battle.PVE( player, player, nil, Pos[Num][1][7], Pos[Num][1][9], nil)
			Battle.SetWinEvent( nil, "def_round_wincallback", battleindex);
		end
	elseif(Char.ItemNum(player,70212)>0) then
		local slot = Char.FindItemId(player,70212);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%����_����%);
		if (Num>=6 and Num<9)then
			NLG.SystemMessage(-1,"�����M��:"..Pos[Num][1][1].." VS "..Char.GetData(player,%����_����%));
			local battleindex = Battle.PVE( player, player, nil, Pos[Num][1][7], Pos[Num][1][9], nil)
			Battle.SetWinEvent( nil, "def_round_wincallback", battleindex);
		end
                    elseif(Char.ItemNum(player,70211)>0) then
		local slot = Char.FindItemId(player,70211);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%����_����%);
		if (Num>=9 and Num<11)then
			NLG.SystemMessage(-1,"�����M��:"..Pos[Num][1][1].." VS "..Char.GetData(player,%����_����%));
			local battleindex = Battle.PVE( player, player, nil, Pos[Num][1][7], Pos[Num][1][9], nil)
			Battle.SetWinEvent( nil, "def_round_wincallback", battleindex);
		end
	end

end

function def_round_wincallback(battleindex, player)

	local winside = Battle.GetWinSide(battleindex);
	local sideM = 0;

	--��ȡʤ����
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end
	--��ȡʤ���������ָ�룬����վ��ǰ���ͺ�
	local w1 = Battle.GetPlayIndex(battleindex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleindex, 5 + sideM);
	local ww = nil;

	--��ʤ����Ҽ����б�
	tbl_win_user = {}
	if ( Char.GetData(w1, %����_����%) >= %��������_��% ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, %����_����%) >= %��������_��% ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	local MapUser = NLG.GetMapPlayer(0,25290);
	for _,w in pairs(MapUser)do
		if (Char.GetData(w, CONST.CHAR_����) > 0) then
		Char.SetData(w, %����_����%, 0);
		NLG.UpdateParty(w);
		NLG.UpChar(w);
		end
	end
	local player = tbl_win_user[1];
	if (Char.ItemNum(player,70213)>0) then
		local slot = Char.FindItemId(player,70213);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%����_����%);
		if (Num>=1 and Num<6)then
			Item.SetData(item_indexA,%����_����%,Num+1);
			Item.UpItem(player,slot);
		end
	elseif(Char.FindItemId(player,70212)>0) then
		local slot = Char.FindItemId(player,70212);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%����_����%);
		if (Num>=6 and Num<9)then
			Item.SetData(item_indexA,%����_����%,Num+1);
			Item.UpItem(player,slot);
		end
	elseif(Char.FindItemId(player,70211)>0) then
		local slot = Char.FindItemId(player,70211);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%����_����%);
		if (Num>=9 and Num<11)then
			Item.SetData(item_indexA,%����_����%,Num+1);
			Item.UpItem(player,slot);
		end
	end
	FTime = os.time()
	wincallbackfunc(tbl_win_user);
end

function AutoRanking_LoopEvent(_MeIndex)
	local BTime= os.time()
	local timec = BTime - FTime;
	local MapUser = NLG.GetMapPlayer(0,25290);
	if (MapUser == -3 and tonumber(#tbl_win_user) == 0 ) then
		Setting = 0;
	elseif (MapUser ~= -3 and tonumber(#tbl_win_user) >= 1 ) then
		Setting = 1;
	elseif (MapUser ~= -3 and tonumber(#tbl_win_user) == 0 ) then
		for _,w in pairs(MapUser)do
			if (Char.GetData(w,%����_Ѫ%)<=1) then
				Setting = 2;
			end
		end
	end
	if (Setting == 1) then
		if (timec <= 20) then
			NLG.SystemMessageToMap(0, 25290,"��ո���ِ��һ�غϼ����_ʼ��ʣ�N"..tostring(21 - timec).."�롣");
			return;
		else
			for _,v in pairs(tbl_win_user) do
				def_round_start(v, 'wincallbackfunc');
			end
			tbl_win_user ={}
			Setting = 0;
		end
	elseif (Setting == 2) then
		wincallbackfunc(tbl_win_user);
		return;
	elseif (Setting == 0) then
		return;
	end
end

function wincallbackfunc(tbl_win_user)
	if (tbl_win_user ~= nil and tonumber(#tbl_win_user) >= 1)then
		-----------------------------------------------------
		for _,v in pairs(tbl_win_user) do
		if (Char.ItemNum(v,70213)>0) then
			local slot = Char.FindItemId(v,70213);
			local item_indexA = Char.GetItemIndex(v,slot);
			local Num = Item.GetData(item_indexA,%����_����%);
			if (Num==6) then
				Char.DelItem(v,70213,1);
				Char.GiveItem(v,69000,5);
				NLG.SystemMessage(-1,"��ϲ���:"..Char.GetData(v,%����_����%).."�@�ñ�����ո���ِ��܊��");
				Char.Warp(v,0,1000,229,65);
				tbl_win_user ={}
				Setting = 0;
			elseif (Num>=1 and Num<6) then
				Setting = 1;
			end
		elseif(Char.FindItemId(v,70212)>0) then
			local slot = Char.FindItemId(v,70212);
			local item_indexA = Char.GetItemIndex(v,slot);
			local Num = Item.GetData(item_indexA,%����_����%);
			if (Num==9) then
				Char.DelItem(v,70212,1);
				Char.GiveItem(v,69000,5);
				NLG.SystemMessage(-1,"��ϲ���:"..Char.GetData(v,%����_����%).."�@�ñ�����ո���ِ��܊��");
				Char.Warp(v,0,1000,229,65);
				tbl_win_user ={}
				Setting = 0;
			elseif (Num>=6 and Num<9) then
				Setting = 1;
			end
		elseif(Char.FindItemId(v,70211)>0) then
			local slot = Char.FindItemId(v,70211);
			local item_indexA = Char.GetItemIndex(v,slot);
			local Num = Item.GetData(item_indexA,%����_����%);
			if (Num==11) then
				Char.DelItem(v,70211,1);
				Char.GiveItem(v,69000,5);
				NLG.SystemMessage(-1,"��ϲ���:"..Char.GetData(v,%����_����%).."�@�ñ�����ո���ِ��܊��");
				Char.Warp(v,0,1000,229,65);
				tbl_win_user ={}
				Setting = 0;
			elseif (Num>=9 and Num<11) then
				Setting = 1;
			end
		end
		end
	else
		-----------------------------------------------------
		local MapUser = NLG.GetMapPlayer(0,25290);
		if (MapUser == -3) then
			return;
		else
			tbl_win_user ={};
			tbl_duel_user = {};
			warpfailuser(MapUser,tbl_win_user,0,25291,35,14);
		end
	end
end


--	�������ܣ�����ʧ�ܵ����
function warpfailuser(MapUser,tbl_win_user,floor,mapid,x,y)
	local failuser = delfailuser(MapUser,tbl_win_user);
	for _,tuser in pairs(failuser) do
		Battle.ExitBattle(tuser);
		if (Char.GetData(tuser, CONST.CHAR_����) > 0) then
			Char.SetData(tuser, %����_����%, 0);
			NLG.UpdateParty(tuser);
			NLG.UpChar(tuser);
		end
		Char.Warp(tuser,0,25291,35,14);
		NLG.SystemMessage(tuser,"��ݔ�ˣ����x���c��");
	end
end

--	�������ܣ���ȡս��ʧ�ܵ����
function delfailuser(MapUser,tbl_win_user)
	for _,v in pairs(tbl_win_user)do
		for i,w in pairs(MapUser)do
			if(v == w)then
				MapUser[i] = nil;
			end
		end
	end
	return MapUser;
end

function table_n(c1,c2,n,t)
	for key, value in pairs(t) do
		if c1 == value and n == 'v' then
			return key
		end
	end
end