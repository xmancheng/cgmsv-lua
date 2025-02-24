local Module = ModuleBase:createModule('autoRanking')

local AutoMenus = {
  { "報名訓練家對戰" },
  { "觀看報名總人數" },
  { "進行對戰場觀戰" },
}

---基本设置勿修改
local Number = 0
local tbl_playerautoranking = {}
local PartyMember = {}

--背景设置
tbl_swjjc_goinfo = {};
tbl_win_user = {};			--当前场次胜利玩家的列表
tbl_swjjc_begin = {};
tbl_swjjc_time ={};
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
  self:regCallback('LoopEvent', Func.bind(self.TrainerBattle_LoopEvent,self))
  local rankingNPC = self:NPC_createNormal('寶可夢訓練家對戰', 11394, { map = 7351, x = 26, y = 37, direction = 4, mapType = 0 })
  Char.SetLoopEvent('./lua/Modules/autoRanking.lua','TrainerBattle_LoopEvent',rankingNPC, 1000);
  self:NPC_regWindowTalkedEvent(rankingNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if seqno == 1 then
     if data == 1 then  ----报名对战
       if (tbl_swjjc_setting.start==1 or tbl_swjjc_setting.start==2) then
         NLG.SystemMessage(player,"[系統]天梯對戰已經開始請等待下一場！");
         return;
       end
       if (tbl_playerautoranking[cdk]~=nil) then
         Char.Warp(player,0,25290,15,34);
         --NLG.SystemMessage(player,"[系統]你已經報名過本輪天梯對戰！");
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
       if (tbl_swjjc_setting.start==0) then
         NLG.SystemMessage(player,"[系統]現在已經有 ".. Number .." 隊報名成功！");
         return;
       else
         NLG.SystemMessage(player,"[系統]天梯對戰已開始請稍後！");
         return;
       end
     end

     if data == 3 then  ----进行场外观战
       if (tbl_swjjc_setting.start==1 or tbl_swjjc_setting.start==2) then
           local msg = "3\\n@c對戰場賽事觀戰\\n"
                                .."\\n　　════════════════════\\n";
           for i = 1, #tbl_duel_user do
               local duelplayer = tbl_duel_user[i];
               local duelplayerName = Char.GetData(duelplayer,CONST.对象_名字);
                   msg = msg .. duelplayerName .. "　VS　".. "\\n"
           end
           NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 31, msg);
       else
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
       end
       table.insert(PartyMember[cdk],cdk);

       Number = Number + 1;
       Char.Warp(player,0,25290,15,34);
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
     Char.GiveItem(player,69000,50);
     Char.Warp(player,0,7351,25,29);
  end
end
function Module:onSellerSelected(npc, player, seqNo, select, data)
  if select == 2 then
     return
  end
end

function TrainerBattle_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	if (os.date("%X",os.time())=="20:00:00") then
		tbl_swjjc_setting.start = 0
		NLG.SystemMessage(-1,"[大會公告]訓練家對戰即將開始，請盡速報名入場。");
	elseif (os.date("%X",os.time())=="20:20:00") then
		NLG.SystemMessage(-1,"[大會公告]訓練家對戰報名剩下10分鐘，請盡速報名入場。");
	elseif (os.date("%X",os.time())=="20:30:00") then
		if (tbl_swjjc_setting.start == 0) then
			swjjcStart(npc);
			local awardnpc = self:NPC_createNormal( '淘汰安慰獎', 17092, { map = 25291, x = 36, y = 13, direction = 6, mapType = 0 })
			self:NPC_regTalkedEvent(awardnpc, Func.bind(self.onSellerTalked, self))
			self:NPC_regWindowTalkedEvent(awardnpc, Func.bind(self.onSellerSelected, self));
			Char.SetLoopEvent('./lua/Modules/autoRanking.lua','swjjcStartNpcLoopEvent', awardnpc,1000); 
			tbl_swjjc_time[time][1] = os.time();
			tbl_swjjc_setting.start = 1
		end
		NLG.SystemMessage(-1,"[大會公告]訓練家對戰開始，報名截止可前往觀戰。");
	elseif (os.date("%X",os.time())=="23:59:59") then
		tbl_swjjc_setting.start = 0
	end
end


function swjjcStartNpcLoopEvent(index)

	tbl_swjjc_time[time][2] = os.time();
	if (tbl_swjjc_time[time][1] ~= nil) then
		local timec = tbl_swjjc_time[time][2] - tbl_swjjc_time[time][1];
		if (timec <= 20) then
			NLG.SystemMessage(tbl_win_user,"訓練家對戰下一回即將開始，倒數 "..tostring(20 - timec).."秒。");
			tbl_swjjc_begin[Loopbegin] = false;
			return;
		end
	end

	local MapUser = NLG.GetMapPlayer(0,25290);
	if (MapUser ==nil) then
		return;
	end
	if(tbl_swjjc_setting.start == 2) then
		def_round_start(tbl_win_user,'wincallbackfunc');
		tbl_swjjc_begin[Loopbegin] = false;
	else
		return;
	end
	return;
end


function swjjcStart(npc)
	tbl_swjjc_setting.start = 1;

	local MapUser = NLG.GetMapPlayer(0,25290);

	for i,v in ipairs(MapUser)do
	--	NLG.SystemMessage(-1,Char.GetData(v,CONST.对象_名字));
	end

	setUser_WinFunc('user_WinFunc');
	def_round_start(MapUser,'wincallbackfunc');

end

function wincallbackfunc(tbl_win_user)
	if(tonumber(#tbl_win_user) > 1)then
		for i,v in ipairs(tbl_win_user)do
			if(v == nil)then
				table.remove(tbl_win_user,i);
			end
		end

		--飞走所有失败的玩家，可怜呀-----------------------------
		local MapUser = NLG.GetMapPlayer(0,25290);
		if (MapUser ==nil) then
			return;
		end
		warpfailuser(MapUser,tbl_win_user,0,25291,35,14);
		-------------------------------------------------------
		--继续轮回咯
		--tbl_win_user = {};
		--tbl_win_user = winuser;
		tbl_swjjc_begin[begin] = true;
		tbl_swjjc_begin[Loopbegin] = false;
		tbl_swjjc_time[time][1] = os.time();
		tbl_swjjc_setting.start = 2;
		--def_round_start(tbl_win_user,'wincallbackfunc');
	end

	-- 直到n次轮回过后，最终胜利一名玩家
	if(tonumber(#tbl_win_user) <= 1)then

		--飞走第二名玩家，可怜呀-----------------------------
		local MapUser = NLG.GetMapPlayer(0,25290);
		if (MapUser ==nil) then
			return;
		end
		warpfailuser(MapUser,tbl_win_user,0,25291,35,14);
		-----------------------------------------------------

		for _,v in pairs(tbl_win_user) do
			Char.GiveItem(v,69000,50);
			NLG.SystemMessage(-1,"恭喜訓練家:"..Char.GetData(v,CONST.对象_名字).."獲得本次聯盟對戰冠軍。");
			Char.Warp(v,0,1000,229,65);
		end
		tbl_playerautoranking = {};
		tbl_swjjc_setting.start = 0;
		Number = 0;

	end
end


function def_round_start(usertable,callback)

	--NLG.SystemMessage(-1,"訓練家對戰 第:"..tbl_swjjc_goinfo[round_count].."場開始。");
	-- 目前战斗场次自加
	tbl_swjjc_goinfo[round_count] = tbl_swjjc_goinfo[round_count] + 1;
	tbl_swjjc_setting.start = 1;

	-- 打乱玩家阵列
	usertable = tablereset(usertable);
	-- 设置x强产生后的回调函数
	tbl_swjjc_setting.WinFunc = callback;
	-- 开始为玩家配对战斗
	
	--NLG.SystemMessage(-1,"=====訓練家=====");
	--for i,v in ipairs(usertable)do
	--	NLG.SystemMessage(-1,Char.GetData(v,CONST.对象_名字));	
	--end
	--NLG.SystemMessage(-1,"================");


	local tbl_UpIndex = {};
	local tbl_DownIndex = {};
	-- 分出上下组
	for i = 1,tonumber(#usertable),2 do
	--	NLG.SystemMessage(-1,"i:"..i);
		table.insert(tbl_UpIndex,usertable[i]);
		if(i + 1 > tonumber(#usertable))then
			table.insert(tbl_DownIndex,-1);
		else
			table.insert(tbl_DownIndex,usertable[i + 1]);
		end
	--	NLG.SystemMessage(-1,"xxxxx=======");
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i],CONST.对象_名字));
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i+1],CONST.对象_名字));
	end
	-- 清空胜利玩家列表	
	tbl_win_user = {};
	tbl_duel_user = {};

	--[[--非佣兵假人可能需要自动组队
	for b,p in ipairs(usertable) then
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
	]]
	--开始战斗
	for j = 1,tonumber(#tbl_UpIndex) + 1,1 do
		--如果双方都掉线，则什么都不做，直接跳过
		if(tbl_UpIndex[j] == nil and tbl_DownIndex[j] == nil)then
		--do nothing		
		--如果上方落单队员产生，则直接给予下方队员晋级
		elseif(tbl_UpIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_DownIndex[j]);
			NLG.SystemMessage(tbl_DownIndex[j],"無人和你配對將直接晉級，請等待別人戰鬥結束。");
		--如果下方落单队员产生，则直接给予上方队员晋级
		elseif(tbl_DownIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_UpIndex[j]);
			NLG.SystemMessage(tbl_UpIndex[j],"無人和你配對將直接晉級，請等待別人戰鬥結束。");
		--开战
		else
			--NLG.SystemMessage(-1,"[大會公告]"..Char.GetData(tbl_UpIndex[j],CONST.对象_名字).." VS "..Char.GetData(tbl_DownIndex[j],CONST.对象_名字));

			battleIndex = {}
			battleIndex[j] = Battle.PVP(tbl_UpIndex[j], tbl_DownIndex[j]);
			table.insert(tbl_duel_user,tbl_DownIndex[j]);

			-- 当前场次创建战斗总计次，用于判断是否已经达到结束标准
			tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] + 1;
			Battle.SetWinEvent('./lua/Modules/autoRanking.lua', 'def_round_wincallback', battleIndex[j]);
		end
	end
	tbl_swjjc_goinfo[create_battle_count_bak] = tbl_swjjc_goinfo[create_battle_count];
end


function def_round_wincallback(battleIndex)

	local winside = Battle.GetWinSide(battleIndex);
	print(winside)
	local sideM = 0;
	tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] - 1;

	--获取胜利方
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end
	--获取胜利方的玩家指针，可能站在前方和后方
	local w1 = Battle.GetPlayIndex(battleIndex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleIndex, 5 + sideM);
	local ww = nil;

	print(w1)
	print(w2)
	--把胜利玩家加入列表
	if ( Char.GetData(w1,CONST.对象_登陆次数) >= 1 ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2,CONST.对象_登陆次数) >= 1 ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	local MapUser = NLG.GetMapPlayer(0,25290);
	local MapUserNum = tonumber(#MapUser);
	local shortlist = math.floor(MapUserNum/2);

	--如果是首战
	if (tbl_swjjc_setting.round_count == 1)then
		--判断人数是否已达进入第二轮的要求
		if (tonumber(#tbl_win_user) >= shortlist)then
			NLG.SystemMessage(-1,"訓練家對戰下一回合即將開始。");
			wincallbackfunc(tbl_win_user);
		end
	else
		--判断人数是否已达进入下一轮的要求
		if (tbl_swjjc_goinfo['create_battle_count'] == 0)then
			wincallbackfunc(tbl_win_user);
		end
	end
	Battle.UnsetWinEvent(battleIndex);
end


function user_WinFunc(player,mc)
	NLG.SystemMessage(player,"恭喜獲得勝利，請等待其他訓練家間對戰結束。");
end

function setUser_WinFunc(winfuncname)
	tbl_swjjc_setting.this_user_WinFunc = winfuncname;
end

--	函数功能：飞走失败的玩家
function warpfailuser(MapUser,tbl_win_user,floor,mapid,x,y)
	local failuser = delfailuser(MapUser,tbl_win_user);
	for _,tuser in pairs(failuser) do
		Battle.ExitBattle(tuser);
		Char.Warp(tuser,0,25291,35,14);
		NLG.SystemMessage(tuser,"感謝參與訓練家間的對戰！");
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

--	函数功能：打乱玩家列表(未完成)
function tablereset(trainer_tbl)
	local xa = NLG.Rand(1,3);
	if ((#trainer_tbl-1-xa) <= 1) then
		num=1;
	else
		num=(#trainer_tbl-1-xa);
	end
	for i=1,num do
		if ((i+1+xa)>=#trainer_tbl) then
			slot=(#trainer_tbl);
		else
			slot=i+1+xa;
		end
		a = NLG.Rand(1,slot);
		temp=trainer_tbl[a];
		trainer_tbl[a]=trainer_tbl[i];
		trainer_tbl[i]=temp;
	end
	return trainer_tbl;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
