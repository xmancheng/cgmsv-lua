---模块类
local Module = ModuleBase:createModule('mazeBoss')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
--local STime = os.time()
--local YS = 30 --脚本延时多少秒创建NPC
--local SXTime = 15 --NPC刷新时间·秒
local FTime = os.time()
local Setting = 0;
--队列解释
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------对战NPC设置------------
EnemySet[1] = {401074, 401074, 401074, 401074, 401074, 401073, 401073, 401073, 401073, 401073}    --0代表没有怪
EnemySet[2] = {401154, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[3] = {401154, 0, 0, 0, 0, 0, 0, 0, 0, 0}
BaseLevelSet[1] = {30, 30, 30, 30, 30, 30, 30, 30, 30, 30}
BaseLevelSet[2] = {30, 0, 0, 0, 0, 00, 0, 0, 0, 0}
BaseLevelSet[3] = {30, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[1] = {"森林領主",EnemySet[1],BaseLevelSet[1]}
Pos[2] = {"森林領主",EnemySet[2],BaseLevelSet[2]}
Pos[3] = {"森林領主",EnemySet[3],BaseLevelSet[3]}
------------------------------------------------
--背景设置
local Switch = 1;                          --组队人数限制开关1开0关
local Rank = 0;                             --初始化难度分类
local BossMap= {60003,36,14} -- 战斗场景Floor,X,Y(弱、普、超同场景)
local OutMap= {60001,21,30}  -- 失败传送Floor,X,Y(弱、普、超同场景)
local LeaveMap= {60001,21,30}  -- 离开传送Floor,X,Y(弱、普、超同场景)
local BossKey= {70195,70195,70195} -- 虚弱、普通、超级
local Pts= 70206;                                    --真女神苹果
local BossRoom = {
      { key=1, keyItem=70195, keyItem_count=1, bossRank=1, limit=-1, posNum_L=1, posNum_R=2,
          win={warpWMap=60001, warpWX=21, warpWY=30, getItem = 70206, getItem_count = 10},
          lose={warpLMap=60001, warpLX=21, warpLY=30, getItem = 70206, getItem_count = 1},
       },    -- 虚弱(1~5)
      { key=3, keyItem=70195, keyItem_count=1, bossRank=2, limit=3, posNum_L=2, posNum_R=3,
          win={warpWMap=60001, warpWX=21, warpWY=30, getItem = 70206, getItem_count = 15},
          lose={warpLMap=60001, warpLX=21, warpLY=30, getItem = 70206, getItem_count = 2},
       },    -- 普通(6~10)
      { key=5, keyItem=70195, keyItem_count=1, bossRank=3, limit=5, posNum_L=3, posNum_R=4,
          win={warpWMap=60001, warpWX=21, warpWY=30, getItem = 70206, getItem_count = 25},
          lose={warpLMap=60001, warpLX=21, warpLY=30, getItem = 70206, getItem_count = 4},
       },    -- 超级(11~15)
}
tbl_duel_user = {};			--当前场次玩家的列表
tbl_win_user = {};
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleInjuryEvent', Func.bind(self.OnBattleInjuryCallBack, self))
  local LordNpc = self:NPC_createNormal('區域領主討伐', 11394, { map = 60002, x = 145, y = 28, direction = 4, mapType = 0 })
  self:regCallback('LoopEvent', Func.bind(self.AutoLord_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(LordNpc, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)			
	if seqno == 1 then
		if data == 1 then  ----参加领主讨伐
			local ret1 = SQL.Run("select EndEvent301 from tbl_character order by EndEvent301 desc ");
			if (type(ret1)=="table" and ret1["1_0"]~=nil) then
				worldLayer1 = ret1["1_0"];
			end
			if(Char.ItemNum(player,BossKey[1])>0 or Char.ItemNum(player,BossKey[2])>0 or Char.ItemNum(player,BossKey[3])>0) then
				NLG.SystemMessage(player,"[系統]想進行討伐不能持有過期憑證。");
				return;
			else
				if worldLayer1 == nil then
					local msg = "7\\n@c選擇區域領主討伐的模式\\n"
						.."\\n　　════════════════════"
						.. "\\n虛弱模式：未開啟\\n"
						.. "\\n普通模式：未開啟\\n"
						.. "\\n超級模式：共鬥合作\\n";
					NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 11, msg);
				elseif worldLayer1 == 1 then
					local msg = "3\\n@c選擇區域領主討伐的模式\\n"
						.."\\n　　════════════════════"
						.. "\\n虛弱模式：一般戰鬥\\n"
						.. "\\n普通模式：一般戰鬥\\n";
					NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 12, msg);
				end
			end
		end
		if data == 2 then  ----查看攻略细节
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "\\n@c請選擇要攻略的強度模式\\n"
				.. "\\nBOSS未被討伐過時，僅有超級模式\\n"
				.. "\\n進入領地後立即會遭遇戰鬥\\n"
				.. "\\n超級模式的領主為共鬥模式\\n"
				.. "\\n最後擊殺者獲得獨特裝備\\n";
			NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 21, msg);
			end
		end
		if data == 3 then  ----观看讨伐实况
			if (tbl_duel_user~=nil) then
			local msg = "3\\n@c觀戰目前討伐的實況\\n"
				.."\\n　　════════════════════\\n";
				for i = 1, #tbl_duel_user do
				local duelplayer = tbl_duel_user[i];
				local duelplayerName = Char.GetData(duelplayer,CONST.CHAR_名字);
				local rankLevel = {"虛弱","普通","絕級"};
				if (duelplayerName~=nil and Rank>=1) then
					msg = msg .. "領主挑戰者:  " ..duelplayerName.. "隊  ★".. rankLevel[Rank] .."模式\\n"
				end
			end
			NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 31, msg);
			else
				return;
			end
		end
	end
	------------------------------------------------------------
	if seqno == 11 then  ----超級模式执行
		key = data+4
		if select == 2 then
			return;
		end
		if key == data+4 then
			local playerName = Char.GetData(player,CONST.CHAR_名字);
			local partyname = playerName .. "－隊";
			--print(key)
			local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
			if (MapUser ~= -3 ) then
				local msg = "\\n@c請等待前一組挑戰者\\n"
				.. "\\n每次只准許一隊進行房間攻略\\n"
				.. "\\n進入領地後立即會遭遇戰鬥\\n"
				.. "\\n勝利獎勵全部會分配給隊長\\n"
				.. "\\n請將戰利品與戰友們共享\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 22, msg);
				return;
			end
			for k,v in pairs(BossRoom) do
				if ( key==v.key ) then
					Rank = v.bossRank;
					Char.HealAll(player);
					Char.GiveItem(player, v.keyItem, v.keyItem_count);
					local slot = Char.FindItemId(player, v.keyItem);
					local item_indexA = Char.GetItemIndex(player,slot);
					Item.SetData(item_indexA,CONST.道具_魅力, v.posNum_L);
					Item.SetData(item_indexA,CONST.道具_幸运, v.bossRank);
					Item.UpItem(player,slot);
					table.insert(tbl_duel_user,player);
					Char.Warp(player,0, BossMap[1], BossMap[2], BossMap[3]);
					Char.SetLoopEvent('./lua/Modules/mazeBoss.lua','AutoLord_LoopEvent',player,1000);
				end
			end
			def_round_start(player, 'wincallbackfunc');
		else
			return 0;
		end
	end
	if seqno == 12 then  ----参加领主讨伐执行
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
				local msg = "\\n@c請等待前一組挑戰者\\n"
				.. "\\n每次只准許一隊進行房間攻略\\n"
				.. "\\n進入領地後立即會遭遇戰鬥\\n"
				.. "\\n勝利獎勵全部會分配給隊長\\n"
				.. "\\n請將戰利品與戰友們共享\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 22, msg);
				return;
			end
			for k,v in pairs(BossRoom) do
				if ( key==v.key ) then
					Rank = v.bossRank;
					Char.HealAll(player);
					Char.GiveItem(player, v.keyItem, v.keyItem_count);
					local slot = Char.FindItemId(player, v.keyItem);
					local item_indexA = Char.GetItemIndex(player,slot);
					Item.SetData(item_indexA,CONST.道具_魅力, v.posNum_L);
					Item.SetData(item_indexA,CONST.道具_幸运, v.bossRank);
					Item.UpItem(player,slot);
					table.insert(tbl_duel_user,player);
					Char.Warp(player,0, BossMap[1], BossMap[2], BossMap[3]);
					Char.SetLoopEvent('./lua/Modules/mazeBoss.lua','AutoLord_LoopEvent',player,1000);
				end
			end
			def_round_start(player, 'wincallbackfunc');
		else
			return 0;
		end
	end
	if seqno == 31 then  ----观看讨伐实况&执行
		key = data
		local duelplayer= tbl_duel_user[key];
		if ( duelplayer ~= nil ) then
			NLG.WatchEntry(player, tonumber(duelplayer));
		else
			return 0;
		end
	end
  end)
  self:NPC_regTalkedEvent(LordNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
               local msg = "4\\n\\n@c★超級魔物的領地位在最深處★\\n"
                                             .."\\n　　════════════════════\\n"
                                             .."[　參加領主討伐　]\\n" 
                                             .."[　查看攻略細節　]\\n" 
                                             .."[　觀看討伐實況　]\\n";
               NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, msg);
    end
    return
  end)


  local LeaveNpc = self:NPC_createNormal('逃離沙漏', 235179, { map = 60003, x = 41, y = 9, direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(LeaveNpc, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(LeaveNpc, function(npc, player)
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
        return
  end)


end


function Char.HealAll(player)
	Char.SetData(player,%对象_血%, Char.GetData(player,%对象_最大血%));
	Char.SetData(player,%对象_魔%, Char.GetData(player,%对象_最大魔%));
	Char.SetData(player, %对象_受伤%, 0);
	Char.SetData(player, %对象_掉魂%, 0);
	NLG.UpdateParty(player);
	NLG.UpChar(player);
	for petSlot  = 0,4 do
		local petIndex = Char.GetPet(player,petSlot);
		if petIndex >= 0 then
			local maxLp = Char.GetData(petIndex, CONST.CHAR_最大血);
			local maxFp = Char.GetData(petIndex, CONST.CHAR_最大魔);
			Char.SetData(petIndex, CONST.CHAR_血, maxLp);
			Char.SetData(petIndex, CONST.CHAR_魔, maxFp);
			Char.SetData(petIndex, %对象_受伤%, 0);
			Pet.UpPet(player, petIndex);
		end
	end
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
			for petSlot  = 0,4 do
				local petIndex = Char.GetPet(TeamPlayer,petSlot);
				if petIndex >= 0 then
					local maxLp = Char.GetData(petIndex, CONST.CHAR_最大血);
					local maxFp = Char.GetData(petIndex, CONST.CHAR_最大魔);
					Char.SetData(petIndex, CONST.CHAR_血, maxLp);
					Char.SetData(petIndex, CONST.CHAR_魔, maxFp);
					Char.SetData(petIndex, %对象_受伤%, 0);
					Pet.UpPet(TeamPlayer, petIndex);
				end
			end
		end
		end
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

	for k,v in pairs(BossRoom) do
		if (Char.ItemNum(player, v.keyItem)>0)  then
			local slot = Char.FindItemId(player, v.keyItem);
			local item_indexA = Char.GetItemIndex(player,slot);
			local Num = Item.GetData(item_indexA,CONST.道具_魅力);
			local Rank = Item.GetData(item_indexA,CONST.道具_幸运);
			if (Num>=v.posNum_L and Num<v.posNum_R and Rank==v.bossRank)then
				Char.HealAll(player);
				NLG.SystemMessage(-1,"領主挑戰者:  " ..Char.GetData(player,CONST.CHAR_名字).. "隊");
				local battleindex = Battle.PVE( player, player, nil, Pos[Num][2], Pos[Num][3], nil)
				Battle.SetWinEvent("./lua/Modules/mazeBoss.lua", "def_round_wincallback", battleindex);
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
	local player = tbl_win_user[1];

	for k,v in pairs(BossRoom) do
		if (Char.ItemNum(player, v.keyItem)>0) then
			local slot = Char.FindItemId(player, v.keyItem);
			local item_indexA = Char.GetItemIndex(player,slot);
			local Num = Item.GetData(item_indexA,CONST.道具_魅力);
			local Rank = Item.GetData(item_indexA,CONST.道具_幸运);
			if (Num>=v.posNum_L and Num<v.posNum_R and Rank==v.bossRank)then
				Item.SetData(item_indexA,CONST.道具_魅力,Num+1);
				Item.UpItem(player,slot);
			end
		end
	end
	FTime = os.time()
	wincallbackfunc(tbl_win_user);
end

function AutoLord_LoopEvent(_MeIndex)
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
			if Char.GetData(player,CONST.CHAR_队聊开关) == 1  then
				NLG.SystemMessageToMap(0, BossMap[1],"下一回合即將開始，剩餘"..tostring(31 - timec).."秒。");
			end
			return;
		else
			local player = tbl_win_user[1];
			if Char.GetBattleIndex(player) >= 0 then
				--print("双重战斗")
			else
				for _,v in pairs(tbl_win_user) do
					def_round_start(v, 'wincallbackfunc');
				end
				tbl_win_user = {};
				Setting = 0;
			end
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
				local Num = Item.GetData(item_indexA,CONST.道具_魅力);
				local Rank = Item.GetData(item_indexA,CONST.道具_幸运);
				if (Num==v.posNum_R and Rank==v.bossRank) then
					Char.DelItem(w, v.keyItem, v.keyItem_count);
					Char.GiveItem(w, v.win.getItem, v.win.getItem_count);
					NLG.SystemMessage(-1,"恭喜玩家: "..Char.GetData(w,%对象_名字%).." 討伐成功領主。");
					Char.Warp(w,0, v.win.warpWMap, v.win.warpWX, v.win.warpWY);
					tbl_win_user = {};
					Setting = 0;
					Rank = 0;
				elseif (Num>=v.posNum_L and Num<v.posNum_R and Rank==v.bossRank) then
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
		NLG.SystemMessage(tuser,"可惜敗下陣，明天再來挑戰區域領主！");
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

------------------------------------------------
--受伤设置
function Module:OnBattleInjuryCallBack(fIndex, aIndex, battleIndex, inject)
      --self:logDebug('OnBattleInjuryCallBack', fIndex, aIndex, battleIndex, inject)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local Target_FloorId = Char.GetData(fIndex, CONST.CHAR_地图)
      local defHpE = Char.GetData(fIndex,CONST.CHAR_血);
      if defHpE >=100 and Target_FloorId==BossMap[1]  then
                 inject = inject*0;
      elseif  Target_FloorId==BossMap[1]  then
                 inject = inject;
      end
  return inject;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
