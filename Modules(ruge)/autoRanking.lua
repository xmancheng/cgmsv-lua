local Module = ModuleBase:createModule('autoRanking')

local AutoMenus = {
  { "報名訓練家對戰" },
  { "觀看報名總人數" },
  { "進行對戰場觀戰" },
}

---基本设置勿修改
local FTime = os.time()
local Setting = 0;
local EnterMap = {25290,25,24};
local ExitMap = {25291,24,25};
local LobbyMap = {7351,25,29};
local Enter = 0;
local Number = 0;
local Finish = 0;

local tbl_playerautoranking = {}
local PartyMember = {}

--背景设置
tbl_swjjc_goinfo = {};
tbl_win_user = {};			--当前场次胜利玩家的列表
tbl_duel_user = {};			--当前场次玩家的列表
tbl_trainer = {};
tbl_swjjc_begin = {};
tbl_swjjc_time = {};
tbl_swjjc_setting =
{
	start = 0;
	round_count =1;
	first_round_user_max = 20; 	--第一场次入选名额限制
	this_user_WinFunc = nil;
	WinFunc = nil;				--当前场次所有玩家战斗结束后的回调函数
};

--运行设置
round_count = "round_count";
create_battle_count = "create_battle_count";
create_battle_count_bak = "create_battle_count_bak";
tbl_swjjc_goinfo[round_count] = 1;
tbl_swjjc_goinfo[create_battle_count] = 0;
tbl_swjjc_goinfo[create_battle_count_bak] = 0;
begin = "begin";
Loopbegin = "Loopbegin";
time = "time";
tbl_swjjc_begin[begin] = true;
tbl_swjjc_begin[Loopbegin] = false;
tbl_swjjc_time[time] = {};

-------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self:regCallback('LoopEvent', Func.bind(self.TrainerBattle_LoopEvent,self));
  self:regCallback('LoopEvent', Func.bind(self.swjjcStartNpcLoopEvent,self));
  local rankingNPC = self:NPC_createNormal('寶可夢訓練家對戰', 11394, { map = 7351, x = 26, y = 37, direction = 4, mapType = 0 })
  Char.SetData(rankingNPC,CONST.对象_ENEMY_PetFlg+2,0);
  Char.SetLoopEvent('lua/Modules/autoRanking.lua','TrainerBattle_LoopEvent',rankingNPC, 1000);
  self:NPC_regWindowTalkedEvent(rankingNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if seqno == 1 then
     if data == 1 then  ----报名对战
       if (Enter==0) then
         NLG.SystemMessage(player,"[大會公告]報名入場時間為每日20:00-20:29！");
         return;
       end
       if (Setting==1 or Setting==2) then
         NLG.SystemMessage(player,"[大會公告]訓練家對戰已經開始，請等待明日報名！");
         return;
       end
       if (tbl_playerautoranking[cdk]~=nil) then
         Char.Warp(player,0,EnterMap[1],EnterMap[2],EnterMap[3]);
         --NLG.SystemMessage(player,"[大會公告]你已經報名過本次訓練家對戰！");
         return;
       end
       if (tbl_playerautoranking[cdk]==nil) then
         local msg = "\\n@c訓練家對戰說明\\n"
                  .. "\\n每日晚上八點進行報名\\n"
                  .. "\\n半小時後場內自動配對\\n"
                  .. "\\n冠軍獲得鑽石獎勵箱\\n"
                  .. "\\n其他參加者獲得金幣\\n";
         NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 11, msg);
       end
     end

     if data == 2 then  ----观看报名人数&执行
       if (Setting==0) then
         NLG.SystemMessage(player,"[大會公告]現在已經有 ".. Number .." 隊報名成功！");
         return;
       else
         NLG.SystemMessage(player,"[大會公告]訓練家對戰已開始請稍後！");
         return;
       end
     end

     if data == 3 then  ----进行场外观战
       if (Setting==1 or Setting==2) then
           local msg = "3\\n@c對戰場賽事觀戰\\n"
                     .."\\n　　════════════════════\\n";
           if (tbl_duel_user~=nil) then
             for i = 1, #tbl_duel_user do
               local duelplayer = tbl_duel_user[i];
               local duelplayerName = Char.GetData(duelplayer,CONST.对象_名字);
               msg = msg .. duelplayerName .. "　VS　".. "\\n"
             end
           end
           NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 31, msg);
       else
         NLG.SystemMessage(player,"[大會公告]訓練家對戰尚未開始。");
         return;
       end
     end

    end
    ------------------------------------------------------------
    if seqno == 11 then  ----报名对战执行
     if select == 4 then
       local playerName = Char.GetData(player,CONST.对象_名字);
       local partyname = playerName .. "－隊";
       --print(partyname)
       tbl_playerautoranking[cdk] = {}
       table.insert(tbl_playerautoranking[cdk],cdk);
       --table.insert(tbl_playerautoranking[cdk],player);
       --table.insert(tbl_playerautoranking[cdk],partyname);

       PartyMember[cdk] = {}
       for partySlot = 0,4 do 
           local targetcharIndex = Char.GetPartyMember(player,partySlot);
           if targetcharIndex >= 0  then
               table.insert(PartyMember[cdk], partySlot+1, targetcharIndex);
           else
               table.insert(PartyMember[cdk], partySlot+1, -1);
           end
           if (partySlot>=1 and not Char.IsDummy(targetcharIndex)) then
             NLG.SystemMessage(player,"[大會公告]訓練家對戰只能和伙伴一起參加。");
             return;
           end
       end
       table.insert(PartyMember[cdk],cdk);

       Number = Number + 1;
       Char.Warp(player,0,EnterMap[1],EnterMap[2],EnterMap[3]);
     else
       return 0;
     end
    end

    if seqno == 31 then  ----进行场外观战&执行
     key = data
     local duelplayer= tbl_duel_user[key];
         if ( duelplayer ~= nil ) then
             NLG.WatchEntry(player, tonumber(duelplayer));
         else
             return 0;
         end
    end

  end)

  self:NPC_regTalkedEvent(rankingNPC, function(npc, player)  ----对战功能AutoMenus{}
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "3\\n@c歡迎每日參加訓練家對戰\\n\\n\\n";
      for i = 1, 3 do
        msg = msg .. AutoMenus[i][1] .. "\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)

end

function Module:onSellerTalked(npc, player)  ----设立淘汰领奖处
  if (NLG.CanTalk(npc, player) == true) then
     Char.GiveItem(player,631096,5);
     Char.Warp(player,0,LobbyMap[1],LobbyMap[2],LobbyMap[3]);
  end
end
function Module:onSellerSelected(npc, player, seqNo, select, data)
  if select == 2 then
     return
  end
end
------------------------------------------------
-------功能设置
--指令启动
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr trainerbattle on]") then
		if (Setting == 0) then
			Enter = 1;
			Finish = 0;
			--swjjcStart(npc);
			self.awardnpc = self:NPC_createNormal( '淘汰參加獎', 17092, { map = 25291, x = 25, y = 24, direction = 6, mapType = 0 })
			self:NPC_regTalkedEvent(self.awardnpc, Func.bind(self.onSellerTalked, self))
			self:NPC_regWindowTalkedEvent(self.awardnpc, Func.bind(self.onSellerSelected, self));
			Char.SetLoopEvent('./lua/Modules/autoRanking.lua','pkStartNpcLoopEvent', self.awardnpc,1000); 
			tbl_swjjc_goinfo[round_count] = 1
			NLG.SystemMessage(-1,"[大會公告]訓練家對戰開始，報名已截止可前往觀戰。");
			return 0;
		else
			NLG.SystemMessage(-1,"[大會公告]訓練家對戰已開始，可前往觀戰。");
			return 0;
		end
	elseif (msg=="[nr trainerbattle off]") then
		NL.DelNpc(self.awardnpc);
		self.awardnpc = nil;
		Enter = 0;
		Number = 0;
		NLG.SystemMessage(-1,"[大會公告]訓練家對戰已圓滿結束。");
		return 0;
	end
	return 1;
end
--对战开始循环
function TrainerBattle_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	if (os.date("%X",os.time())=="20:00:00") then
		local MapUser = NLG.GetMapPlayer(0,EnterMap[1]);
		if (MapUser~=-3) then
			for _,v in pairs(MapUser) do
				Char.Warp(v,0,EnterMap[1],EnterMap[2],EnterMap[3]);
			end
		end
		Enter = 1;
		Finish = 0;
		NLG.SystemMessage(-1,"[大會公告]訓練家對戰即將開始，請盡速報名入場。");
	elseif (os.date("%X",os.time())=="20:20:00") then
		NLG.SystemMessage(-1,"[大會公告]訓練家對戰報名剩下10分鐘，請盡速報名入場。");
	elseif (os.date("%X",os.time())=="20:30:00") then
		if (Setting == 0) then
			--swjjcStart(npc);
			self.awardnpc = self:NPC_createNormal( '淘汰參加獎', 17092, { map = 25291, x = 25, y = 24, direction = 6, mapType = 0 })
			self:NPC_regTalkedEvent(self.awardnpc, Func.bind(self.onSellerTalked, self))
			self:NPC_regWindowTalkedEvent(self.awardnpc, Func.bind(self.onSellerSelected, self));
			Char.SetLoopEvent('./lua/Modules/autoRanking.lua','pkStartNpcLoopEvent', self.awardnpc,1000); 
			tbl_swjjc_goinfo[round_count] = 1
			NLG.SystemMessage(-1,"[大會公告]訓練家對戰開始，報名已截止可前往觀戰。");
		end
	elseif (os.date("%X",os.time())=="23:59:59") then
		NL.DelNpc(self.awardnpc);
		self.awardnpc = nil;
		Enter = 0;
		Number = 0;
	end
end


--启动到结束循环监测
function pkStartNpcLoopEvent(index)

	if (Setting == 0) then	--第一场启动
		STime = os.time()
		local timec = STime - FTime;
		tbl_win_user = {};
		tbl_duel_user = {};

		local MapUser = NLG.GetMapPlayer(0, EnterMap[1]);
		tbl_trainer = {};
		if (MapUser~=-3) then	--战斗中地图判定没人?
			for i,v in ipairs(MapUser)do
				--NLG.SystemMessage(-1,Char.GetData(v,CONST.对象_名字));
				if not Char.IsDummy(v) then
					table.insert(tbl_trainer,v);
				end
			end
		end
		playerNum = #tbl_trainer;

		tbl_duel_user = battle_round_start(tbl_trainer,'wincallbackfunc');
		NLG.SystemMessage(-1,"訓練家對戰 第"..tbl_swjjc_goinfo[round_count].."場開始。");
		tbl_swjjc_goinfo[round_count] = tbl_swjjc_goinfo[round_count] + 1;
		Setting = 1;
	elseif (Setting == 1) then
		TTime = os.time()
		local timec = TTime - STime;
		if (timec <= 600) then	--10分内
			NextRound = 0;
			local battle_count = tbl_swjjc_goinfo[create_battle_count];		--对战场数data传送不来
			if ( battle_count >= math.floor(playerNum/2) ) then
				NextRound = 1;
				goto continue
			end
			for _,v in pairs(tbl_win_user) do
				if (not Char.IsDummy(v) and Char.GetData(v,CONST.对象_队聊开关) == 1) then
					if (math.fmod(timec,60)==0) then	--1分钟公告
						NLG.SystemMessage(v,"[大會公告]恭喜獲得勝利，請等待其他訓練家間對戰結束。");
					end
				end
			end
			if (timec==300) then
				NLG.SystemMessageToMap(0, EnterMap[1],"[大會公告]距離判定時間剩下5分鐘，請盡速決定勝負。");
			end
		end
		::continue::
		if (timec > 600 or NextRound==1) then	--超时10分钟结束，两边皆算输家
			for i,j in ipairs(tbl_duel_user)do
				if (j[3]==0 and Char.GetBattleIndex(j[2])>=0) then
					Battle.ExitBattle(j[1]);
					Battle.ExitBattle(j[2]);
				elseif (j[3]==0 and Char.GetBattleIndex(j[2])<0) then
					table.insert(tbl_win_user,j[1]);
				end
			end
			Setting = 2;
		end
	elseif (Setting == 2) then
		ZTime = os.time()
		local timec = ZTime - TTime;
		if (timec <= 10) then	--缓衝判定驱逐输家
			wincallbackfunc(tbl_win_user);
			return;
		else
			Setting = 3;
		end
	elseif (Setting == 3) then
		WTime = os.time()
		local timec = WTime - ZTime;

		local MapUser = NLG.GetMapPlayer(0, EnterMap[1]);
		tbl_trainer = {};
		if (MapUser~=-3) then	--战斗中地图判定没人?
			for i,v in ipairs(MapUser)do
				--NLG.SystemMessage(-1,Char.GetData(v,CONST.对象_名字));
				if not Char.IsDummy(v) then
					table.insert(tbl_trainer,v);
				end
			end
		end

		if (tonumber(#tbl_trainer)==1) then
			wincallbackfunc(tbl_trainer);
			Setting = -1;
		elseif (tonumber(#tbl_trainer)>=2 and timec <= 30) then
			for _,v in pairs(tbl_trainer) do
				if (not Char.IsDummy(v) and Char.GetData(v,CONST.对象_队聊开关) == 1) then
					NLG.SystemMessage(v,"[大會公告]訓練家對戰下一回即將開始，倒數"..tostring(31 - timec).."秒。");
				end
			end
		elseif (tonumber(#tbl_trainer)>=2 and timec > 30) then
			Setting = 0;
		else
			return;
		end
	end

end

--流程条件判定
function wincallbackfunc(tbl_win_user)
	if (tbl_win_user ~= nil and Setting == 2)then
		local MapUser = NLG.GetMapPlayer(0,EnterMap[1]);
		tbl_trainer = {};
		for i,v in ipairs(MapUser)do
			if not Char.IsDummy(v) then
				table.insert(tbl_trainer,v);
			end
		end
		if (tbl_trainer==-3) then
			return;
		else
			warpfailuser(tbl_trainer,tbl_win_user,0,ExitMap[1],ExitMap[2],ExitMap[3]);
		end
	elseif (tbl_win_user ~= nil and Setting == 3)then
		if (Finish == 0) then
			for _,v in pairs(tbl_win_user) do
				if not Char.IsDummy(v) then
					Char.GiveItem(v,631097,1);
					NLG.SystemMessage(-1,"[大會公告]恭喜訓練家:"..Char.GetData(v,CONST.对象_名字).."獲得本次聯盟對戰冠軍。");
					Char.Warp(v,0,LobbyMap[1],LobbyMap[2],LobbyMap[3]);
					Char.UnsetLoopEvent(self.awardnpc);
				end
			end
			Finish = 1;
			tbl_playerautoranking = {};
		end
	else
	end
end

--对战执行
function battle_round_start(tbl_trainer,callback)

	-- 打乱玩家阵列
	tbl_trainer = tablereset(tbl_trainer);

	--开始为玩家配对战斗
	--NLG.SystemMessage(-1,"=====訓練家=====");
	--NLG.SystemMessage(-1,"================");

	local tbl_UpIndex = {};
	local tbl_DownIndex = {};
	-- 分出上下组
	for i = 1,tonumber(#tbl_trainer),2 do
	--NLG.SystemMessage(-1,"i:"..i);
		table.insert(tbl_UpIndex,tbl_trainer[i]);
		if(i + 1 > tonumber(#tbl_trainer))then
			table.insert(tbl_DownIndex,-1);
		else
			table.insert(tbl_DownIndex,tbl_trainer[i + 1]);
		end
	--NLG.SystemMessage(-1,"================");
	--NLG.SystemMessage(-1,Char.GetData(tbl_trainer[i],CONST.对象_名字));
	--NLG.SystemMessage(-1,Char.GetData(tbl_trainer[i+1],CONST.对象_名字));
	end

	--自动组队
	for b,p in ipairs(tbl_trainer) do
		local cdk = Char.GetData(p,CONST.对象_CDK);
		if PartyMember[cdk] ~= nill and cdk == PartyMember[cdk][6] then
			local playerMapType = Char.GetData(p, CONST.对象_地图类型);
			local playerMap = Char.GetData(p, CONST.对象_地图);
			local playerX = Char.GetData(p, CONST.对象_X);
			local playerY = Char.GetData(p, CONST.对象_Y);
			for k,v in ipairs(PartyMember[cdk]) do
				local memberMap = Char.GetData(v, CONST.对象_地图);
				local memberX = Char.GetData(v, CONST.对象_X);
				local memberY = Char.GetData(v, CONST.对象_Y);
				if v~=p then
					Char.Warp(v, playerMapType, playerMap, playerX, playerY);
					Char.JoinParty(v, p);
				end
			end
		end
	end
	--开始战斗
	for j = 1,tonumber(#tbl_UpIndex) + 1,1 do
		--如果双方都掉线，则什么都不做，直接跳过
		if(tbl_UpIndex[j] == nil and tbl_DownIndex[j] == nil)then
		--do nothing		
		--如果上方落单队员产生，则直接给予下方队员晋级
		elseif(tbl_UpIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_DownIndex[j]);
			NLG.SystemMessage(tbl_DownIndex[j],"[大會公告]無人和你配對將直接晉級，請等待別人戰鬥結束。");
		--如果下方落单队员产生，则直接给予上方队员晋级
		elseif(tbl_DownIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_UpIndex[j]);
			NLG.SystemMessage(tbl_UpIndex[j],"[大會公告]無人和你配對將直接晉級，請等待別人戰鬥結束。");
		--开战
		else
			--NLG.SystemMessage(-1,"[大會公告]"..Char.GetData(tbl_UpIndex[j],CONST.对象_名字).." VS "..Char.GetData(tbl_DownIndex[j],CONST.对象_名字));

			battleIndex = {}
			battleIndex[j] = Battle.PVP(tbl_UpIndex[j], tbl_DownIndex[j]);
			table.insert(tbl_duel_user,{tbl_UpIndex[j],tbl_DownIndex[j],0});

			Battle.SetPVPWinEvent('./lua/Modules/autoRanking.lua', 'battle_wincallback', battleIndex[j]);
		end
	end

	return tbl_duel_user;
end

--下方胜利事件
function battle_wincallback(battleIndex)

	local winside = Battle.GetWinSide(battleIndex);
	--print(winside)
	local sideM = 0;
	tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] - 1;

	--[[获取胜利方
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end]]
	--获取胜利方的玩家指针，可能站在前方和后方
	local leader1 = Battle.GetPlayIndex(battleIndex, 0 + 0);
	local leader2 = Battle.GetPlayIndex(battleIndex, 5 + 0);
	if Char.IsPlayer(leader2) then
		leader1 = leader2;
	end

	--把胜利玩家加入列表
    for k,v in pairs(tbl_win_user) do
		if (CheckInTable(tbl_win_user,v)==false) then
			table.insert(tbl_win_user, leader1);
		end
	end
	local safe=0;
	for i,j in ipairs(tbl_duel_user)do
		for k,v in ipairs(tbl_win_user)do
			if (j[2]==v) then
				safe=i;
				j[3]=1;
			end
		end
		if (safe==0) then
			table.insert(tbl_win_user,j[1]);
		end
	end

	-- 当前场次创建战斗总计次，用于判断是否已经达到结束标准
	tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] + 1;
	Battle.UnsetWinEvent(battleIndex);

end

--上方胜利手动判定
function checkWinner(tbl_duel_user,tbl_win_user)
	local safe=0;
	for i,j in ipairs(tbl_duel_user)do
		for k,v in ipairs(tbl_win_user)do
			if (j[2]==v) then
				safe=i;
			end
		end
		if (safe==0) then
			table.insert(tbl_win_user,j[1]);
		end
	end
	if (tbl_win_user~= nil) then
		wincallbackfunc(tbl_win_user);
	end
	return tbl_win_user;
end

--飞走失败的玩家
function warpfailuser(tbl_trainer,tbl_win_user,floor,mapid,x,y)
	local failuser = delfailuser(tbl_trainer,tbl_win_user);
	for _,tuser in pairs(failuser) do
		Battle.ExitBattle(tuser);
		Char.Warp(tuser,0,ExitMap[1],ExitMap[2],ExitMap[3]);
		NLG.SystemMessage(tuser,"[大會公告]感謝參與訓練家間的對戰！");
	end
end

--获取战斗失败的玩家
function delfailuser(tbl_trainer,tbl_win_user)
	for _,v in pairs(tbl_win_user)do
		for i,w in pairs(tbl_trainer)do
			if(v == w)then
				tbl_trainer[i] = nil;
			end
		end
	end
	return tbl_trainer;
end

--打乱玩家列表(未测试)
function tablereset(tbl_trainer)
	local len = #tbl_trainer;
	local xa = NLG.Rand(1,3);
	if ((len-1-xa) <= 1) then
		num = 1;
	else
		num = len-1-xa;
	end
	for i=1,num do
		if ((i+1+xa)>=len) then
			slot = len;
		else
			slot = i+1+xa;
		end
		a = NLG.Rand(1,slot);
		temp=tbl_trainer[a];
		tbl_trainer[a]=tbl_trainer[i];
		tbl_trainer[i]=temp;
	end
	return tbl_trainer;
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end
--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
