local ItemMenus = {
  { "[　　寵物附身媒介　　]x1　　　　　30", 69993, 30, 1},
  { "[　　　滿怪香水　　　]x1　　　　　20", 900500, 20, 1},
  { "[　　　黃金噴霧　　　]x1　　　　　15", 900501, 15, 1},
  { "[　　　復活塊　　　　]x1　　　　　10", 900502, 10, 1},
  { "[　　　離洞繩　　　　]x1　　　　　10", 900503, 10, 1},
  { "[　　　天梯積分券　　]x10　　　　10", 69000, 10, 10},
}

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local STime = os.time()
local YS = 30 --脚本延时多少秒创建NPC
local SXTime = 15 --NPC刷新时间·秒
local FTime = os.time()
local Setting = 0;
--队列解释
--     五	三	一	二	四
--     十	八	六	七	九
------------天梯对战NPC设置------------
EnemySet[1] = {9116, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0代表没有怪
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
Pos[1] = {{"吉拉",100320,25290,18,29,5,EnemySet[1],1,BaseLevelSet[1]}}
Pos[2] = {{"巴雷莉",100092,25290,20,31,5,EnemySet[2],2,BaseLevelSet[2]}}
Pos[3] = {{"伊魯瑪",100394,25290,16,29,5,EnemySet[3],3,BaseLevelSet[3]}}
Pos[4] = {{"伊佐塔",100006,25290,20,33,5,EnemySet[4],4,BaseLevelSet[4]}}
Pos[5] = {{"伍那",100416,25290,18,31,5,EnemySet[5],5,BaseLevelSet[5]}}
Pos[6] = {{"伊諾克",100164,25290,19,13,4,EnemySet[6],6,BaseLevelSet[6]}}
Pos[7] = {{"萊歐尼爾",100071,25290,23,13,4,EnemySet[7],7,BaseLevelSet[7]}}
Pos[8] = {{"歐茲尼克",100802,25290,27,13,4,EnemySet[8],8,BaseLevelSet[8]}}
Pos[9] = {{"阿魯巴斯",100602,25290,35,20,5,EnemySet[9],9,BaseLevelSet[9]}}
Pos[10] = {{"艾謝巴特",100577,25290,36,30,6,EnemySet[10],10,BaseLevelSet[10]}}

tbl_AutoRankingNpcIndex = tbl_AutoRankingNpcIndex or {}
------------------------------------------------
--背景设置
tbl_duel_user = {};			--当前场次玩家的列表
tbl_win_user = {};
------------------------------------------------
Delegate.RegInit("initRankingScriptNpc");

function initRankingScriptNpc_Init(index)
	return 1;
end

function initRankingScriptNpc()
	if (RankingScriptNpcA == nil) then
		RankingScriptNpcA = NL.CreateNpc("lua/Module/RankingScript.lua", "initRankingScriptNpc_Init");
		Char.SetData(RankingScriptNpcA,%对象_形象%,11394);
		Char.SetData(RankingScriptNpcA,%对象_原形%,11394);
		Char.SetData(RankingScriptNpcA,%对象_X%,229);
		Char.SetData(RankingScriptNpcA,%对象_Y%,64);
		Char.SetData(RankingScriptNpcA,%对象_地图%,1000);
		Char.SetData(RankingScriptNpcA,%对象_方向%,4);
		Char.SetData(RankingScriptNpcA,%对象_原名%,"自動天梯對戰模式");
		NLG.UpChar(RankingScriptNpcA);
		Char.SetLoopEvent(nil, "AutoRanking_LoopEvent", RankingScriptNpcA, 1000)
		Char.SetWindowTalkedEvent("lua/Module/RankingScript.lua","RankingScriptA",RankingScriptNpcA);
		Char.SetTalkedEvent("lua/Module/RankingScript.lua","RankingScriptMsgA", RankingScriptNpcA);
	end
	if (RankingScriptNpcB == nil) then
		RankingScriptNpcB = NL.CreateNpc("lua/Module/RankingScript.lua", "initRankingScriptNpc_Init");
		Char.SetData(RankingScriptNpcB,%对象_形象%,17092);
		Char.SetData(RankingScriptNpcB,%对象_原形%,17092);
		Char.SetData(RankingScriptNpcB,%对象_X%,36);
		Char.SetData(RankingScriptNpcB,%对象_Y%,13);
		Char.SetData(RankingScriptNpcB,%对象_地图%,25291);
		Char.SetData(RankingScriptNpcB,%对象_方向%,6);
		Char.SetData(RankingScriptNpcB,%对象_原名%,"淘汰領獎處");
		NLG.UpChar(RankingScriptNpcB);
		Char.SetWindowTalkedEvent("lua/Module/RankingScript.lua","RankingScriptB",RankingScriptNpcB);
		Char.SetTalkedEvent("lua/Module/RankingScript.lua","RankingScriptMsgB", RankingScriptNpcB);
	end
	if (RankingScriptNpcC == nil) then
		RankingScriptNpcC = NL.CreateNpc("lua/Module/RankingScript.lua", "initRankingScriptNpc_Init");
		Char.SetData(RankingScriptNpcC,%对象_形象%,231116);
		Char.SetData(RankingScriptNpcC,%对象_原形%,231116);
		Char.SetData(RankingScriptNpcC,%对象_X%,18);
		Char.SetData(RankingScriptNpcC,%对象_Y%,18);
		Char.SetData(RankingScriptNpcC,%对象_地图%,777);
		Char.SetData(RankingScriptNpcC,%对象_方向%,6);
		Char.SetData(RankingScriptNpcC,%对象_原名%,"明怪设置");
		NLG.UpChar(RankingScriptNpcC);
		Char.SetLoopEvent(nil, "RankingScript_LoopEvent",RankingScriptNpcC, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/RankingScript.lua","RankingScriptC",RankingScriptNpcC);
		Char.SetTalkedEvent("lua/Module/RankingScript.lua","RankingScriptMsgC", RankingScriptNpcC);
	end
end

function RankingScriptMsgA(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		local msg = "1\\n@c歡迎進行天梯對戰功能\\n\\n"
			.."[　報名天梯對戰　]\\n" 
			.."[　觀看天梯說明　]\\n" 
			.."[　進行場外觀戰　]\\n" 
			.."[　登陸長期積分　]\\n" 
			.."[　查詢天梯點數　]\\n" 
			.."[　兌換天梯獎勵　]\\n" ;
		NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, msg);
	end
	return;
end


function RankingScriptA(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)			
	if seqno == 1 then
		if data == 2 then  ----报名天梯对战
			if(Char.ItemNum(player,70213)>0 or Char.ItemNum(player,70212)>0 or Char.ItemNum(player,70211)>0) then
				NLG.SystemMessage(player,"[系統]進入道場前不能有任何資格項鍊。");
				return;
			else
				local msg = "3\\n@c選擇天梯對戰模式\\n"
					.."\\n　　════════════════════"
					.. "\\n1　VS　1　單人對戰\\n"
					.. "\\n3　VS　3　三人對戰\\n"
					.. "\\n5　VS　5　團體對戰\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 21, msg);
			end
		end
		if data == 3 then  ----观看天梯说明
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "\\n@c請詳細閱讀天梯說明\\n"
				.. "\\n選擇1人、3人、5人的對戰模式\\n"
				.. "\\n進入場地後開始自動配對戰鬥\\n"
				.. "\\n冠軍可獲得5張積分\\n"
				.. "\\n挑戰失敗者1張積分\\n";
			NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 31, msg);
			end
		end
		if data == 4 then  ----进行场外观战
			if (tbl_duel_user~=nil) then
			local msg = "3\\n@c天梯觀戰功能\\n"
				.."\\n　　════════════════════\\n";
				for i = 1, #tbl_duel_user do
				local duelplayer = tbl_duel_user[i];
				local duelplayerName = Char.GetData(duelplayer,CONST.CHAR_名字);
				msg = msg .. duelplayerName .. "　VS　".. "\\n"
			end
			NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 41, msg);
			else
				return;
			end
		end
		if data == 5 then  ----登陆长期积分
			if (NLG.CanTalk(npc, player) == true) then
			local key = Char.FindItemId(player,69000);
			local item = Char.GetItemIndex(player,key);
			local PointCount = Char.ItemNum(player,69000);
			local msg = "\\n@c登陸長期天梯積分\\n"
				.. "\\n　　════════════════════\\n"
				.. "\\n　天梯積分券　【".. PointCount .. "】全部上傳嗎?\\n";
			NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 51, msg);
			end
		end
		if data == 6 then  ----查询天梯点数&执行
			if (NLG.CanTalk(npc, player) == true) then
			local PointCount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local msg = "\\n@c查詢天梯點數功能\\n"
				.. "\\n　　════════════════════\\n"
				.. "\\n　天梯積分　　　".. PointCount .. "券\\n";
			NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 61, msg);
			end
		end
		if data == 7 then  ----兑换天梯奖励
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "3\\n@c兌換天梯獎勵功能\\n"
				.."\\n　　════════════════════\\n";
				for i = 1, 6 do
					msg = msg .. ItemMenus[i][1] .. "\\n"
				end
			NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 71, msg);
			end
		end
	end
	------------------------------------------------------------
	if seqno == 21 then  ----报名天梯对战执行
		key = data
		if select == 2 then
			return;
		end
		if key == data then
			local playerName = Char.GetData(player,CONST.CHAR_名字);
			local partyname = playerName .. "－隊";
			Char.SetData(player,%对象_血%, Char.GetData(player,%对象_最大血%));
			Char.SetData(player,%对象_魔%, Char.GetData(player,%对象_最大魔%));
			NLG.UpChar(player);
			--print(key)
			if ( key==1 ) then
				Char.GiveItem(player,70213,1);
				local slot = Char.FindItemId(player,70213);
				local item_indexA = Char.GetItemIndex(player,slot);
				Item.SetData(item_indexA,%道具_魅力%,1);
				Item.UpItem(player,slot);
				table.insert(tbl_duel_user,player);
				Char.Warp(player,0,25290,15,34);
			elseif ( key==3 ) then
				Char.GiveItem(player,70212,1);
				local slot = Char.FindItemId(player,70212);
				local item_indexA = Char.GetItemIndex(player,slot);
				Item.SetData(item_indexA,%道具_魅力%,6);
				Item.UpItem(player,slot);
				table.insert(tbl_duel_user,player);
				Char.Warp(player,0,25290,15,34);
			elseif ( key==5 ) then
				Char.GiveItem(player,70211,1);
				local slot = Char.FindItemId(player,70211);
				local item_indexA = Char.GetItemIndex(player,slot);
				Item.SetData(item_indexA,%道具_魅力%,9);
				Item.UpItem(player,slot);
				table.insert(tbl_duel_user,player);
				Char.Warp(player,0,25290,15,34);
			end
			def_round_start(player, 'wincallbackfunc');
		else
			return 0;
		end
	end
	if seqno == 41 then  ----进行场外观战&执行
		key = data
		local duelplayer= tbl_duel_user[key];
		if ( duelplayer ~= nil ) then
			NLG.WatchEntry(player, tonumber(duelplayer));
		else
			return 0;
		end
	end
	if seqno == 51 then  ----登陆长期积分执行
		if select == 4 then
			local key = Char.FindItemId(player,69000);
			local item = Char.GetItemIndex(player,key);
			local PointCount = Char.ItemNum(player,69000);
			local Restcount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local Restcount = Restcount + PointCount;
			SQL.Run("update lua_hook_character set RankedPoints= '"..Restcount.."' where CdKey='"..cdk.."'")
			NLG.UpChar(player);
			Char.DelItem(player,69000,PointCount);
			NLG.SystemMessage(player,"[系統]已成功上傳所有天梯積分券！");
		else
			return 0;
		end
	end
	if seqno == 71 then  ----兑换天梯奖励执行
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
				NLG.SystemMessage(player,"[系統]天梯積分數量不足！");
				return 0;
			end
		end
	end
end

function RankingScriptMsgB(npc, player)  ----设立淘汰领奖处
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
	--创建假人
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
--NPC对话事件(NPC索引)
function RankingScriptMsgC(_NpcIndex, _PlayerIndex)
tbl_AutoRankingNpcIndex = {}
end

--NPC窗口事件(NPC索引)
function RankingScriptC ( _NpcIndex, _PlayerIndex, _seqno, _select, _data)
	
end
function CreateRankingNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local AutoRankingNpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( AutoRankingNpcIndex, %对象_形象%, Image);
	Char.SetData( AutoRankingNpcIndex, %对象_原形%, Image);
	Char.SetData( AutoRankingNpcIndex, %对象_地图类型%, MapType);
	Char.SetData( AutoRankingNpcIndex, %对象_地图%, MapID);
	Char.SetData( AutoRankingNpcIndex, %对象_X%, PosX);
	Char.SetData( AutoRankingNpcIndex, %对象_Y%, PosY);
	Char.SetData( AutoRankingNpcIndex, %对象_方向%, Dir);
	Char.SetData( AutoRankingNpcIndex, %对象_原名%, Name);
	Char.SetData( AutoRankingNpcIndex, %对象_名色%, NameColor);
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
	--面向玩家
	local i;
	i = Char.GetData(_PlayerIndex, %对象_方向%);
	if i >= 4 then 
		i = i - 4;
	else
		i = i + 4;		
	end
	Char.SetData(_NpcIndex, %对象_方向%,i);
	NLG.UpChar( _NpcIndex);
	local	token ="\n\n\n\n@c失敗者丟掉項鍊，離開天空競技場！"

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

	--开始战斗
	tbl_UpIndex = {}
	battleindex = {}
	--battleindex[player] = Battle.PVP(tbl_UpIndex[1], player);
	--Battle.SetPVPWinEvent('lua/Modules/autoRanking.lua', 'def_round_wincallback', battleindex);

	if (Char.ItemNum(player,70213)>0) then
		local slot = Char.FindItemId(player,70213);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%道具_魅力%);
		if (Num>=1 and Num<6)then
			NLG.SystemMessage(-1,"競技組合:"..Pos[Num][1][1].." VS "..Char.GetData(player,%对象_名字%));
			local battleindex = Battle.PVE( player, player, nil, Pos[Num][1][7], Pos[Num][1][9], nil)
			Battle.SetWinEvent( nil, "def_round_wincallback", battleindex);
		end
	elseif(Char.ItemNum(player,70212)>0) then
		local slot = Char.FindItemId(player,70212);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%道具_魅力%);
		if (Num>=6 and Num<9)then
			NLG.SystemMessage(-1,"競技組合:"..Pos[Num][1][1].." VS "..Char.GetData(player,%对象_名字%));
			local battleindex = Battle.PVE( player, player, nil, Pos[Num][1][7], Pos[Num][1][9], nil)
			Battle.SetWinEvent( nil, "def_round_wincallback", battleindex);
		end
                    elseif(Char.ItemNum(player,70211)>0) then
		local slot = Char.FindItemId(player,70211);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%道具_魅力%);
		if (Num>=9 and Num<11)then
			NLG.SystemMessage(-1,"競技組合:"..Pos[Num][1][1].." VS "..Char.GetData(player,%对象_名字%));
			local battleindex = Battle.PVE( player, player, nil, Pos[Num][1][7], Pos[Num][1][9], nil)
			Battle.SetWinEvent( nil, "def_round_wincallback", battleindex);
		end
	end

end

function def_round_wincallback(battleindex, player)

	local winside = Battle.GetWinSide(battleindex);
	local sideM = 0;

	--获取胜利方
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end
	--获取胜利方的玩家指针，可能站在前方和后方
	local w1 = Battle.GetPlayIndex(battleindex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleindex, 5 + sideM);
	local ww = nil;

	--把胜利玩家加入列表
	tbl_win_user = {}
	if ( Char.GetData(w1, %对象_类型%) >= %对象类型_人% ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, %对象_类型%) >= %对象类型_人% ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	local MapUser = NLG.GetMapPlayer(0,25290);
	for _,w in pairs(MapUser)do
		if (Char.GetData(w, CONST.CHAR_受伤) > 0) then
		Char.SetData(w, %对象_受伤%, 0);
		NLG.UpdateParty(w);
		NLG.UpChar(w);
		end
	end
	local player = tbl_win_user[1];
	if (Char.ItemNum(player,70213)>0) then
		local slot = Char.FindItemId(player,70213);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%道具_魅力%);
		if (Num>=1 and Num<6)then
			Item.SetData(item_indexA,%道具_魅力%,Num+1);
			Item.UpItem(player,slot);
		end
	elseif(Char.FindItemId(player,70212)>0) then
		local slot = Char.FindItemId(player,70212);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%道具_魅力%);
		if (Num>=6 and Num<9)then
			Item.SetData(item_indexA,%道具_魅力%,Num+1);
			Item.UpItem(player,slot);
		end
	elseif(Char.FindItemId(player,70211)>0) then
		local slot = Char.FindItemId(player,70211);
		local item_indexA = Char.GetItemIndex(player,slot);
		local Num = Item.GetData(item_indexA,%道具_魅力%);
		if (Num>=9 and Num<11)then
			Item.SetData(item_indexA,%道具_魅力%,Num+1);
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
			if (Char.GetData(w,%对象_血%)<=1) then
				Setting = 2;
			end
		end
	end
	if (Setting == 1) then
		if (timec <= 20) then
			NLG.SystemMessageToMap(0, 25290,"天空競技賽下一回合即將開始，剩餘"..tostring(21 - timec).."秒。");
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
			local Num = Item.GetData(item_indexA,%道具_魅力%);
			if (Num==6) then
				Char.DelItem(v,70213,1);
				Char.GiveItem(v,69000,5);
				NLG.SystemMessage(-1,"恭喜玩家:"..Char.GetData(v,%对象_名字%).."獲得本次天空競技賽冠軍。");
				Char.Warp(v,0,1000,229,65);
				tbl_win_user ={}
				Setting = 0;
			elseif (Num>=1 and Num<6) then
				Setting = 1;
			end
		elseif(Char.FindItemId(v,70212)>0) then
			local slot = Char.FindItemId(v,70212);
			local item_indexA = Char.GetItemIndex(v,slot);
			local Num = Item.GetData(item_indexA,%道具_魅力%);
			if (Num==9) then
				Char.DelItem(v,70212,1);
				Char.GiveItem(v,69000,5);
				NLG.SystemMessage(-1,"恭喜玩家:"..Char.GetData(v,%对象_名字%).."獲得本次天空競技賽冠軍。");
				Char.Warp(v,0,1000,229,65);
				tbl_win_user ={}
				Setting = 0;
			elseif (Num>=6 and Num<9) then
				Setting = 1;
			end
		elseif(Char.FindItemId(v,70211)>0) then
			local slot = Char.FindItemId(v,70211);
			local item_indexA = Char.GetItemIndex(v,slot);
			local Num = Item.GetData(item_indexA,%道具_魅力%);
			if (Num==11) then
				Char.DelItem(v,70211,1);
				Char.GiveItem(v,69000,5);
				NLG.SystemMessage(-1,"恭喜玩家:"..Char.GetData(v,%对象_名字%).."獲得本次天空競技賽冠軍。");
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


--	函数功能：飞走失败的玩家
function warpfailuser(MapUser,tbl_win_user,floor,mapid,x,y)
	local failuser = delfailuser(MapUser,tbl_win_user);
	for _,tuser in pairs(failuser) do
		Battle.ExitBattle(tuser);
		if (Char.GetData(tuser, CONST.CHAR_受伤) > 0) then
			Char.SetData(tuser, %对象_受伤%, 0);
			NLG.UpdateParty(tuser);
			NLG.UpChar(tuser);
		end
		Char.Warp(tuser,0,25291,35,14);
		NLG.SystemMessage(tuser,"您輸了，感謝參與！");
	end
end

--	函数功能：获取战斗失败的玩家
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