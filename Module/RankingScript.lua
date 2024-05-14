local ItemMenus = {
  { "[　　寵物附身媒介　　]x1　　　　　30", 69993, 30, 1},
  { "[　　　滿怪香水　　　]x1　　　　　20", 900500, 20, 1},
  { "[　　　黃金噴霧　　　]x1　　　　　15", 900501, 15, 1},
  { "[　　　復活塊　　　　]x1　　　　　10", 900502, 10, 1},
  { "[　　　離洞繩　　　　]x1　　　　　10", 900503, 10, 1},
  { "[　　　頭目積分券　　]x10　　　　10", 69000, 10, 10},
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
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------头目对战NPC设置------------
EnemySet[1] = {25029, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0代表没有怪
EnemySet[2] = {25030, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[3] = {0, 0, 0, 0, 0, 25037, 0, 0, 0, 0}
EnemySet[4] = {0, 0, 0, 0, 0, 25033, 0, 0, 0, 0}
EnemySet[5] = {0, 0, 0, 0, 0, 0, 25034, 25035, 0, 0}
EnemySet[6] = {0, 25029, 25030, 0, 0, 25028, 0, 0, 0, 0}
EnemySet[7] = {0, 25036, 25035, 0, 0, 25031, 0, 0, 0, 0}
EnemySet[8] = {0, 25032, 25034, 0, 0, 25041, 0, 0, 0, 0}
EnemySet[9] = {0, 25032, 25036, 25034, 25035, 25031, 25033, 25037, 0, 0}
EnemySet[10] = {0, 25032, 25036, 25034, 25035, 25041, 25033, 25037, 0, 0}
BaseLevelSet[1] = {24, 0, 0, 0, 0, 0, 0, 0, 0, 0}
BaseLevelSet[2] = {24, 0, 0, 0, 0, 0, 0, 0, 0, 0}
BaseLevelSet[3] = {0, 0, 0, 0, 0, 30, 0, 0, 0, 0}
BaseLevelSet[4] = {0, 0, 0, 0, 0, 30, 0, 0, 0, 0}
BaseLevelSet[5] = {0, 0, 0, 0, 0, 0, 30, 30, 0, 0}
BaseLevelSet[6] = {0, 44, 44, 0, 0, 49, 0, 0, 0, 0}
BaseLevelSet[7] = {0, 50, 50, 0, 0, 58, 0, 0, 0, 0}
BaseLevelSet[8] = {0, 50, 50, 0, 0, 58, 0, 0, 0, 0}
BaseLevelSet[9] = {0, 80, 80, 80, 80, 88, 80, 90, 0, 0}
BaseLevelSet[10] = {0, 80, 80, 80, 80, 88, 80, 90, 0, 0}
Pos[1] = {{"艾兒卡絲的手下",100727,25290,18,29,5,EnemySet[1],1,BaseLevelSet[1]}}      -- 初级(1~5)
Pos[2] = {{"艾兒卡絲的手下",106527,25290,20,31,5,EnemySet[2],2,BaseLevelSet[2]}}
Pos[3] = {{"熊美",101012,25290,16,29,5,EnemySet[3],3,BaseLevelSet[3]}}
Pos[4] = {{"小烏",101501,25290,20,33,5,EnemySet[4],4,BaseLevelSet[4]}}
Pos[5] = {{"凱傑爾",106427,25290,18,31,5,EnemySet[5],5,BaseLevelSet[5]}}
Pos[6] = {{"艾兒卡絲",100702,25290,19,13,4,EnemySet[6],6,BaseLevelSet[6]}}                  -- 高级(6~8)
Pos[7] = {{"帕利耶",106654,25290,23,13,4,EnemySet[7],7,BaseLevelSet[7]}}
Pos[8] = {{"烏莉兒",106604,25290,27,13,4,EnemySet[8],8,BaseLevelSet[8]}}
Pos[9] = {{"白銀之騎士",106555,25290,35,20,5,EnemySet[9],9,BaseLevelSet[9]}}              -- 绝级(9~10)
Pos[10] = {{"百合之少女",106726,25290,36,30,6,EnemySet[10],10,BaseLevelSet[10]}}

tbl_AutoRankingNpcIndex = tbl_AutoRankingNpcIndex or {}
------------------------------------------------
--背景设置
local Switch = 1;                          --组队人数限制开关1开0关
local Rank = 0;                             --难度分类
local BossMap= {25290,15,34} -- 战斗场景Floor,X,Y(初、高、绝同场景)
local OutMap= {25291,35,14}  -- 失败传送Floor,X,Y(初、高、绝同场景)
local LeaveMap= {1000,229,65}  -- 离开传送Floor,X,Y(初、高、绝同场景)
local BossKey= {70213,70212,70211} -- 初级、高级、绝级
local Pts= 69000;                        --积分券
local BossRoom = {
      { key=1, keyItem=70213, keyItem_count=1, bossRank=1, limit=-1, posNum_L=1, posNum_R=6,
          win={warpWMap=1000, warpWX=229, warpWY=65, getItem = 69000, getItem_count = 5},
          lose={warpLMap=25291, warpLX=35, warpLY=14, getItem = 69000, getItem_count = 1},
       },    -- 初级(1~5)
      { key=3, keyItem=70212, keyItem_count=1, bossRank=2, limit=3, posNum_L=6, posNum_R=9,
          win={warpWMap=1000, warpWX=229, warpWY=65, getItem = 69000, getItem_count = 10},
          lose={warpLMap=25291, warpLX=35, warpLY=14, getItem = 69000, getItem_count = 1},
       },    -- 高级(6~8)
      { key=5, keyItem=70211, keyItem_count=1, bossRank=3, limit=5, posNum_L=9, posNum_R=11,
          win={warpWMap=1000, warpWX=229, warpWY=65, getItem = 69000, getItem_count = 20},
          lose={warpLMap=25291, warpLX=35, warpLY=14, getItem = 69000, getItem_count = 1},
       },    -- 绝级(9~10)
}
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
		Char.SetData(RankingScriptNpcA,%对象_原名%,"自動頭目房對戰");
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

function Char.HealAll(player)
	Char.SetData(player,%对象_血%, Char.GetData(player,%对象_最大血%));
	Char.SetData(player,%对象_魔%, Char.GetData(player,%对象_最大魔%));
	Char.SetData(player, %对象_受伤%, 0);
	Char.SetData(player, %对象_掉魂%, 0);
	NLG.UpdateParty(player);
	NLG.UpChar(player);
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
		local TeamPlayer = Char.GetPartyMember(player,Slot);
		if (TeamPlayer>0) then
			Char.SetData(TeamPlayer,%对象_血%, Char.GetData(TeamPlayer,%对象_最大血%));
			Char.SetData(TeamPlayer,%对象_魔%, Char.GetData(TeamPlayer,%对象_最大魔%));
			Char.SetData(TeamPlayer, %对象_受伤%, 0);
			Char.SetData(TeamPlayer, %对象_掉魂%, 0);
			NLG.UpdateParty(TeamPlayer);
			NLG.UpChar(TeamPlayer);
		end
		end
	end
end

function RankingScriptMsgA(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		local msg = "1\\n@c歡迎進行頭目房對戰功能\\n\\n"
			.."[　報名頭目對戰　]\\n" 
			.."[　觀看頭目說明　]\\n" 
			.."[　進行場外觀戰　]\\n" 
			.."[　登陸長期積分　]\\n" 
			.."[　查詢頭目點數　]\\n" 
			.."[　兌換頭目獎勵　]\\n" ;
		NLG.ShowWindowTalked(player, npc, %窗口_选择框%, %按钮_关闭%, 1, msg);
	end
	return;
end


function RankingScriptA(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)			
	if seqno == 1 then
		if data == 2 then  ----报名头目房对战
			if(Char.ItemNum(player,BossKey[1])>0 or Char.ItemNum(player,BossKey[2])>0 or Char.ItemNum(player,BossKey[3])>0) then
				NLG.SystemMessage(player,"[系統]進入頭目房不能有任何資格項鍊。");
				return;
			else
				local msg = "3\\n@c選擇頭目房對戰模式\\n"
					.."\\n　　════════════════════"
					.. "\\n1人小隊　VS　初級對戰\\n"
					.. "\\n3人小組　VS　高級對戰\\n"
					.. "\\n5人小眾　VS　絕級對戰\\n";
				NLG.ShowWindowTalked(player, npc, %窗口_选择框%, %按钮_关闭%, 21, msg);
			end
		end
		if data == 3 then  ----观看头目房说明
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "\\n@c請詳細閱讀頭目房說明\\n"
				.. "\\n選擇1人、3人、5人的攻略模式\\n"
				.. "\\n進入場地後開始自動配對戰鬥\\n"
				.. "\\n多人戰勝可獲得越多積分\\n"
				.. "\\n挑戰失敗者1張積分\\n";
			NLG.ShowWindowTalked(player, npc, %窗口_信息框%, %按钮_确定%, 31, msg);
			end
		end
		if data == 4 then  ----进行场外观战
			if (tbl_duel_user~=nil) then
			local msg = "3\\n@c頭目房觀戰功能\\n"
				.."\\n　　════════════════════\\n";
				for i = 1, #tbl_duel_user do
				local duelplayer = tbl_duel_user[i];
				local duelplayerName = Char.GetData(duelplayer,CONST.CHAR_名字);
				local rankLevel = {"初級","高級","絕級"};
				if (duelplayerName~=nil and Rank>=1) then
					msg = msg .. duelplayerName .. "　VS　".. rankLevel[Rank] .."對戰\\n"
				end
			end
			NLG.ShowWindowTalked(player, npc, %窗口_选择框%, %按钮_关闭%, 41, msg);
			else
				return;
			end
		end
		if data == 5 then  ----登陆长期积分
			if (NLG.CanTalk(npc, player) == true) then
			local key = Char.FindItemId(player,Pts);
			local item = Char.GetItemIndex(player,key);
			local PointCount = Char.ItemNum(player,Pts);
			local msg = "\\n@c登陸長期頭目積分\\n"
				.. "\\n　　════════════════════\\n"
				.. "\\n　頭目積分券　【".. PointCount .. "】全部上傳嗎?\\n";
			NLG.ShowWindowTalked(player, npc, %窗口_信息框%, %按钮_是否%, 51, msg);
			end
		end
		if data == 6 then  ----查询头目点数&执行
			if (NLG.CanTalk(npc, player) == true) then
			local PointCount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local msg = "\\n@c查詢頭目點數功能\\n"
				.. "\\n　　════════════════════\\n"
				.. "\\n　頭目積分　　　".. PointCount .. "券\\n";
			NLG.ShowWindowTalked(player, npc, %窗口_信息框%, %按钮_确定%, 61, msg);
			end
		end
		if data == 7 then  ----兑换头目奖励
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "3\\n@c兌換頭目獎勵功能\\n"
				.."\\n　　════════════════════\\n";
				for i = 1, 6 do
					msg = msg .. ItemMenus[i][1] .. "\\n"
				end
			NLG.ShowWindowTalked(player, npc, %窗口_选择框%, %按钮_关闭%, 71, msg);
			end
		end
	end
	------------------------------------------------------------
	if seqno == 21 then  ----报名头目对战执行
		key = data
		if select == 2 then
			return;
		end
		if key == data then
			local playerName = Char.GetData(player,CONST.CHAR_名字);
			local partyname = playerName .. "－隊";
			--print(key)
			local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
			if (MapUser ~= -3 ) then
				local msg = "\\n@c請等待前一組冒險者\\n"
				.. "\\n每次只准許一隊進行房間攻略\\n"
				.. "\\n進入場地即開始自動配對戰鬥\\n"
				.. "\\n勝利獎勵全部會分配給隊長\\n"
				.. "\\n請將戰利品與隊友們共享\\n";
				NLG.ShowWindowTalked(player, npc, %窗口_信息框%, %按钮_确定%, 22, msg);
				return;
			end
			for k,v in pairs(BossRoom) do
				if ( key==v.key ) then
					if( Switch==1 and Char.PartyNum(player) ~= v.limit) then
						local msg = "\\n\\n\\n\\n@c攻略需湊足正確人數！！\\n";
						NLG.ShowWindowTalked(player, npc, %窗口_信息框%, %按钮_确定%, 23, msg);
						return;
					elseif( Switch==1 and Char.PartyNum(player) == v.limit) then
						Rank = v.bossRank;
						Char.HealAll(player);
						Char.GiveItem(player, v.keyItem, v.keyItem_count);
						local slot = Char.FindItemId(player, v.keyItem);
						local item_indexA = Char.GetItemIndex(player,slot);
						Item.SetData(item_indexA,%道具_魅力%, v.posNum_L);
						Item.UpItem(player,slot);
						table.insert(tbl_duel_user,player);
						Char.Warp(player,0, BossMap[1], BossMap[2], BossMap[3]);
					elseif( Switch==0) then
						Rank = v.bossRank;
						Char.HealAll(player);
						Char.GiveItem(player, v.keyItem, v.keyItem_count);
						local slot = Char.FindItemId(player, v.keyItem);
						local item_indexA = Char.GetItemIndex(player,slot);
						Item.SetData(item_indexA,%道具_魅力%, v.posNum_L);
						Item.UpItem(player,slot);
						table.insert(tbl_duel_user,player);
						Char.Warp(player,0, BossMap[1], BossMap[2], BossMap[3]);
					end
				end
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
			local key = Char.FindItemId(player,Pts);
			local item = Char.GetItemIndex(player,key);
			local PointCount = Char.ItemNum(player,Pts);
			local Restcount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local Restcount = Restcount + PointCount;
			SQL.Run("update lua_hook_character set RankedPoints= '"..Restcount.."' where CdKey='"..cdk.."'")
			NLG.UpChar(player);
			Char.DelItem(player,Pts,PointCount);
			NLG.SystemMessage(player,"[系統]已成功上傳所有頭目積分券！");
		else
			return 0;
		end
	end
	if seqno == 71 then  ----兑换头目奖励执行
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
				NLG.SystemMessage(player,"[系統]頭目積分數量不足！");
				return 0;
			end
		end
	end
end

function RankingScriptMsgB(npc, player)  ----设立淘汰领奖处
	if (NLG.CanTalk(npc, player) == true) then
		if (Char.PartyNum(player)==-1) then
			if (Char.ItemNum(player, BossKey[1]) > 0) then
				local slot = Char.FindItemId(player, BossKey[1]);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, BossKey[1], 1);
				Char.GiveItem(player, 69000, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
			else
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
			end
		else
			for k,v in pairs(BossRoom) do
			if (Char.ItemNum(player, v.keyItem) > 0) then
				local slot = Char.FindItemId(player, v.keyItem);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, v.keyItem, v.keyItem_count);
				Char.GiveItem(player, v.lose.getItem, v.lose.getItem_count);
				Char.Warp(player,0,v.win.warpWMap,v.win.warpWX,v.win.warpWY);
			end
			end
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
	local walk = 1;
	NLG.SetAction(_MeIndex,walk);
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
	local	token ="\n\n\n\n@c失敗者丟掉項鍊，離開頭目房！"

       NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, token)

end
function RankingNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
		return;
	end
end


function def_round_start(player, callback)

	MapUser = NLG.GetMapPlayer(0,BossMap[1]);
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--开始战斗
	tbl_UpIndex = {}
	battleindex = {}
	--battleindex[player] = Battle.PVP(tbl_UpIndex[1], player);
	--Battle.SetPVPWinEvent('lua/Modules/autoRanking.lua', 'def_round_wincallback', battleindex);

	for k,v in pairs(BossRoom) do
		if (Char.ItemNum(player, v.keyItem)>0) then
			local slot = Char.FindItemId(player, v.keyItem);
			local item_indexA = Char.GetItemIndex(player,slot);
			local Num = Item.GetData(item_indexA,%道具_魅力%);
			if (Num>=v.posNum_L and Num<v.posNum_R)then
				NLG.SystemMessage(-1,"挑戰組合:"..Pos[Num][1][1].." VS "..Char.GetData(player,%对象_名字%));
				local battleindex = Battle.PVE( player, player, nil, Pos[Num][1][7], Pos[Num][1][9], nil)
				Battle.SetWinEvent("./lua/Module/RankingScript.lua", "def_round_wincallback", battleindex);
			end
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

	local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
	for _,w in pairs(MapUser)do
		if (Char.GetData(w, %对象_受伤%) > 0) then
		Char.SetData(w, %对象_受伤%, 0);
		NLG.UpdateParty(w);
		NLG.UpChar(w);
		end
	end
	local player = tbl_win_user[1];

	for k,v in pairs(BossRoom) do
		if (Char.ItemNum(player, v.keyItem)>0) then
			local slot = Char.FindItemId(player, v.keyItem);
			local item_indexA = Char.GetItemIndex(player,slot);
			local Num = Item.GetData(item_indexA,%道具_魅力%);
			if (Num>=v.posNum_L and Num<v.posNum_R)then
				Item.SetData(item_indexA,%道具_魅力%,Num+1);
				Item.UpItem(player,slot);
			end
		end
	end
	FTime = os.time()
	wincallbackfunc(tbl_win_user);
end

function AutoRanking_LoopEvent(_MeIndex)
	local BTime= os.time()
	local timec = BTime - FTime;

	local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
	if (MapUser == -3 and tonumber(#tbl_win_user) == 0 ) then
		Setting = 0;
	elseif (MapUser ~= -3 and tonumber(#tbl_win_user) >= 1 ) then
		Setting = 1;
	elseif (MapUser ~= -3 and tonumber(#tbl_win_user) == 0 ) then
		if (tbl_duel_user[1] ~= nil) then
			local PartyNum = Char.PartyNum(tbl_duel_user[1]);
			local DeadNum = 0;
			for _,w in pairs(MapUser)do
				if (Char.GetData(w,%对象_血%)<=1) then
					DeadNum = DeadNum+1;
				end
			end
			if (PartyNum==-1) then
	 			if (DeadNum==1) then
					Setting = 2;
				end
			elseif (PartyNum>=1) then
				if (DeadNum==PartyNum) then
					Setting = 2;
				end
			end
		else
			return;
		end
	end

	if (Setting == 1) then
		if (timec <= 30) then
			local player = tbl_win_user[1];
			if Char.GetData(player,%对象_队聊开关%) == 1  then
				NLG.SystemMessageToMap(0, BossMap[1],"頭目房挑戰下一回合即將開始，剩餘"..tostring(31 - timec).."秒。");
			end
			return;
		else
			for _,v in pairs(tbl_win_user) do
				def_round_start(v, 'wincallbackfunc');
			end
			tbl_win_user = {};
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
		for _,w in pairs(tbl_win_user) do
			for k,v in pairs(BossRoom) do
			if (Char.ItemNum(w, v.keyItem)>0) then
				local slot = Char.FindItemId(w, v.keyItem);
				local item_indexA = Char.GetItemIndex(w,slot);
				local Num = Item.GetData(item_indexA,%道具_魅力%);
				if (Num==v.posNum_R) then
					Char.DelItem(w, v.keyItem, v.keyItem_count);
					Char.GiveItem(w, v.win.getItem, v.win.getItem_count);
					NLG.SystemMessage(-1,"恭喜玩家:"..Char.GetData(w,%对象_名字%).."攻略成功本次頭目房。");
					Char.Warp(w,0, v.win.warpWMap, v.win.warpWX, v.win.warpWY);
					tbl_win_user = {};
					Setting = 0;
					Rank = 0;
				elseif (Num>=v.posNum_L and Num<v.posNum_R) then
					Setting = 1;
				end
			end
			end
		end
	else
		-----------------------------------------------------
		local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
		if (MapUser == -3) then
			return;
		else
			warpfailuser(MapUser,tbl_win_user,0,OutMap[1],OutMap[2],OutMap[3]);
			Rank = 0;
			tbl_win_user = {};
			tbl_duel_user = {};

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
		Char.Warp(tuser,0,OutMap[1],OutMap[2],OutMap[3]);
		NLG.SystemMessage(tuser,"您輸了，感謝參與本次頭目房！");
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
