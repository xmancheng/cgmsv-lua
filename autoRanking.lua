local AutoRanking = ModuleBase:createModule('autoRanking')
local AutoMenus = {
  { "[　报名天梯对战　]" },
  { "[　观看报名人数　]" },
  { "[　进行场外观战　]" },
  { "[　登陆长期积分　]" },
  { "[　查询天梯点数　]" },
  { "[　兑换天梯奖励　]" },
}

local ItemMenus = {
  { "[　【佣兵】露比娃娃　]x1　　　　300", 900200, 300, 1},
  { "[　　　狗狗图鉴　　　]x1　　　　100", 70024, 100, 1},
  { "[　　　龙之心砂　　　]x5　　　　50", 70161, 50, 5},
  { "[　　宠物附身媒介　　]x1　　　　20", 69993, 20, 1},
  { "[　　　水晶强化石　　]x10　　　　5", 69128, 5, 10},
  { "[　　　天梯积分券　　]x10　　　　10", 69000, 10, 10},
}

local Number = 0
local tbl_playerautoranking = {}

---基本设置勿修改
--PartyList = {}
--for sss = 1,40 do
--PartyList[sss] = {}
--PartyList[sss][1] = {
--{ name = '隊伍名稱', member1 = '隊長', member2 = '隊員', member3 = '隊員', member4 = '隊員', member5 = '隊員', win = 0, lose = 0 },
--}
--end

--背景设置
tbl_swjjc_goinfo = {};
tbl_win_user = {};			--当前场次胜利玩家的列表
tbl_swjjc_begin = {};
tbl_swjjc_time ={};
tbl_swjjc_setting =
{
	start = 0;
	round_count =1;
	first_round_user_max = 40; 	--第一场次入选名额限制
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

--- 加载模块钩子
function AutoRanking:onLoad()
  self:logInfo('load')
  local rankingnpc = self:NPC_createNormal('自动天梯对战模式', 11394, { map = 1000, x = 229, y = 64, direction = 4, mapType = 0 })
  self:NPC_regWindowTalkedEvent(rankingnpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(seqno)
    --print(select)
    --print(data)
    print(cdk)
    if seqno == 1 then
     if data == 1 then  ----报名天梯对战
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
         local msg = "\\n@c请详细阅读天梯说明\\n"
                             .. "\\n至少四组方可自动开始对战\\n"
                             .. "\\n不限时段凑齐人数即开赛\\n"
                             .. "\\n冠军可获得5张积分\\n"
                             .. "\\n其余参加者1张积分\\n";
         NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 11, msg);
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
           local msg = "3\\n@c天梯观战功能\\n"
                                .."\\n　　════════════════════\\n";
           for i = 1, #tbl_duel_user do
               local duelplayer = tbl_duel_user[i];
               local duelplayerName = Char.GetData(duelplayer,CONST.CHAR_名字);
                   msg = msg .. duelplayerName .. "　VS　".. "\\n"
           end
           NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 31, msg);
       else
         return;
       end
     end

     if data == 4 then  ----登陆长期积分
       if (NLG.CanTalk(npc, player) == true) then
           local key = Char.FindItemId(player,69000);
           local item = Char.GetItemIndex(player,key);
           local PointCount = Char.ItemNum(player,69000);
           local msg = "\\n@c登陆长期天梯积分\\n"
                             .. "\\n　　════════════════════\\n"
                             .. "\\n　天梯积分券　【".. PointCount .. "】全部上传吗?\\n";
           NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 41, msg);
       end
     end

     if data == 5 then  ----查询天梯点数&执行
       if (NLG.CanTalk(npc, player) == true) then
         local PointCount = tonumber(SQL.Run("select ThankFlower from tbl_character where CdKey='"..cdk.."'")["0_0"])
         local msg = "\\n@c查询天梯点数功能\\n"
                             .. "\\n　　════════════════════\\n"
                             .. "\\n　天梯积分　　　".. PointCount .. "券\\n";
         NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 51, msg);
       end
     end

     if data == 6 then  ----兑换天梯奖励
       if (NLG.CanTalk(npc, player) == true) then
           local msg = "3\\n@c兑换天梯奖励功能\\n"
                                .."\\n　　════════════════════\\n";
           for i = 1, 6 do
               msg = msg .. ItemMenus[i][1] .. "\\n"
           end
           NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 61, msg);
       end
     end

    end
    ------------------------------------------------------------
    if seqno == 11 then  ----报名天梯对战执行
     if select == 4 then
       local playerName = Char.GetData(player,CONST.CHAR_名字);
       local partyname = playerName .. "－隊";
       --print(partyname)
       tbl_playerautoranking[cdk] = {}
       table.insert(tbl_playerautoranking[cdk],cdk);
       --table.insert(tbl_playerautoranking[cdk],player);
       --table.insert(tbl_playerautoranking[cdk],partyname);
       Number = Number + 1;
       Char.Warp(player,0,25290,15,34);
       if (Number >= 4) then
         swjjcStart(player);
         local awardnpc = self:NPC_createNormal( '淘汰领奖处', 17092, { map = 25291, x = 36, y = 13, direction = 6, mapType = 0 })
         self:NPC_regTalkedEvent(awardnpc, Func.bind(self.onSellerTalked, self))
         self:NPC_regWindowTalkedEvent(awardnpc, Func.bind(self.onSellerSelected, self));
         Char.SetLoopEvent('lua/Modules/autoRanking.lua','swjjcStartNpcLoopEvent', awardnpc,1000); 
         tbl_swjjc_time[time][1] = os.time();
         tbl_swjjc_setting.start = 1
       end
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

    if seqno == 41 then  ----登陆长期积分执行
     if select == 4 then
       local key = Char.FindItemId(player,69000);
       local item = Char.GetItemIndex(player,key);
       local PointCount = Char.ItemNum(player,69000);
       local Restcount = tonumber(SQL.Run("select ThankFlower from tbl_character where CdKey='"..cdk.."'")["0_0"])
       local Restcount =Restcount + PointCount;
       SQL.Run("update tbl_character set ThankFlower= '"..Restcount.."' where CdKey='"..cdk.."'")
       Char.DelItem(player,69000,PointCount);
       NLG.UpChar(player);
       NLG.SystemMessage(player,"[系統]已成功上傳所有天梯積分券！");
     else
       return 0;
     end
    end

    if seqno == 61 then  ----兑换天梯奖励执行
     key = data
     if select == 2 then
         return;
     end
     if key == data then
         local PointCount = tonumber(SQL.Run("select ThankFlower from tbl_character where CdKey='"..cdk.."'")["0_0"])
         local itemcost= ItemMenus[data][3];
         if ( PointCount >= itemcost ) then
             local Restcount = PointCount - itemcost;
             SQL.Run("update tbl_character set ThankFlower= '"..Restcount.."' where CdKey='"..cdk.."'")
             Char.GiveItem(player,ItemMenus[data][2],ItemMenus[data][4]);
             NLG.UpChar(player);
         else
             NLG.SystemMessage(player,"[系統]天梯積分數量不足！");
             return 0;
         end
     end
    end


  end)


  self:NPC_regTalkedEvent(rankingnpc, function(npc, player)  ----天梯对战功能AutoMenus{}
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "1\\n@c欢迎进行天梯对战功能\\n";
      for i = 1, 6 do
        msg = msg .. AutoMenus[i][1] .. "\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, msg);
    end
    return
  end)

end


function AutoRanking:onSellerTalked(npc, player)  ----设立淘汰领奖处
  if (NLG.CanTalk(npc, player) == true) then
     Char.GiveItem(player,69000,1);
     Char.Warp(player,0,1000,229,65);
  end
end

function AutoRanking:onSellerSelected(npc, player, seqNo, select, data)
  --print(select)
  --print(data)
  if select == 2 then
     return
  end
end

function swjjcStartNpcLoopEvent(index)
	--if(tbl_swjjc_begin[Loopbegin] == true)then
	--	return;
	--end
	--tbl_swjjc_begin[Loopbegin] = true;
	--if(tbl_swjjc_begin[begin]  == false)then
	--	tbl_swjjc_begin[Loopbegin] = false;
	--	return;
	--end


	--if (tbl_swjjc_setting.start ~=0) then
	--	for i,v in ipairs(MapUser) do
	--		if ( Char.GetBattleIndex(v) ~= -1 ) then
	--			tbl_swjjc_begin[Loopbegin] = false;
	--			return;
	--		elseif ( Char.GetBattleIndex(v) == -1 ) then
	--			for i,v in ipairs(tbl_win_user) do
	--			NLG.SystemMessage(tbl_win_user,"天空竞技赛下一回合即将开始。");
	--			wincallbackfunc(tbl_win_user);
	--			end
	--		end
	--	end
	--end

	--tbl_swjjc_begin[begin] = false;
	tbl_swjjc_time[time][2] = os.time();
	if (tbl_swjjc_time[time][1] ~= nil) then
		local timec = tbl_swjjc_time[time][2] - tbl_swjjc_time[time][1];
		if (timec <= 20) then
			NLG.SystemMessage(tbl_win_user,"天空竞技赛下一回合即将开始，剩余 "..tostring(20 - timec).."秒。");
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


function swjjcStart(player)
	tbl_swjjc_setting.start = 1;

	local MapUser = NLG.GetMapPlayer(0,25290);

	for i,v in ipairs(MapUser)do
	--	NLG.SystemMessage(-1,Char.GetData(v,%对象_名字%));
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
			Char.GiveItem(v,69000,5);
			NLG.SystemMessage(-1,"恭喜玩家:"..Char.GetData(v,%对象_名字%).."获得本次天空竞技赛冠军。");
			Char.Warp(v,0,1000,229,65);
		end
		tbl_playerautoranking = {};
		tbl_swjjc_setting.start = 0;
		Number = 0;

	end
end




--[[ def_round_start
	函数功能： 每一回合的开始，第一回合不限制报名人数，前first_round_user_max名胜利者晋级，后面回合均所有战斗结束后晋级。
	如果有落单者，则直接晋级
	参数1)usertable:表示参与玩家的列表
	    2)funcallback:当函数结束后执行的回调函数，即产生x强之后触发
	    **funtcion callback(
		 参数一:table 参与的玩家
		)
]]
function def_round_start(usertable,callback)

	--NLG.SystemMessage(-1,"天空竞技赛 第:"..tbl_swjjc_goinfo[round_count].."场开始。");
	-- 目前战斗场次自加
	tbl_swjjc_goinfo[round_count] = tbl_swjjc_goinfo[round_count] + 1;
	tbl_swjjc_setting.start = 1;

	-- 打乱玩家阵列
	usertable = tablereset(usertable);
	-- 设置x强产生后的回调函数
	tbl_swjjc_setting.WinFunc = callback;
	-- 开始为玩家配对战斗
	
	--NLG.SystemMessage(-1,"====参与玩家====");
	--for i,v in ipairs(usertable)do
	--	NLG.SystemMessage(-1,Char.GetData(v,%对象_名字%));	
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
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i],%对象_名字%));
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i+1],%对象_名字%));
	end
	-- 清空胜利玩家列表	
	tbl_win_user = {};
	tbl_duel_user = {};
	
	--开始战斗
	for j = 1,tonumber(#tbl_UpIndex) + 1,1 do
		--如果双方都掉线，则什么都不做，直接跳过
		if(tbl_UpIndex[j] == nil and tbl_DownIndex[j] == nil)then
		   --do nothing		
		--如果上方落单队员产生，则直接给予下方队员晋级
		elseif(tbl_UpIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_DownIndex[j]);
			NLG.SystemMessage(tbl_DownIndex[j],"无人和你配对，你将直接晋级，请等待别人战斗结束。");
		--如果下方落单队员产生，则直接给予上方队员晋级
		elseif(tbl_DownIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_UpIndex[j]);
			NLG.SystemMessage(tbl_UpIndex[j],"无人和你配对，你将直接晋级，请等待别人战斗结束。");
		--开战
		else
			--NLG.SystemMessage(-1,"pk:"..Char.GetData(tbl_UpIndex[j],%对象_名字%).." VS "..Char.GetData(tbl_DownIndex[j],%对象_名字%));

			battleindex = {}
			battleindex[j] = Battle.PVP(tbl_UpIndex[j], tbl_DownIndex[j]);
			table.insert(tbl_duel_user,tbl_DownIndex[j]);

			-- 当前场次创建战斗总计次，用于判断是否已经达到结束标准
			tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] + 1;
			Battle.SetPVPWinEvent('lua/Modules/autoRanking.lua', 'def_round_wincallback', battleindex[j]);
		end
	end
	tbl_swjjc_goinfo[create_battle_count_bak] = tbl_swjjc_goinfo[create_battle_count];
end


--[[ def_round_wincallback
	函数功能： 当前场次战斗结束后每个玩家胜利后的回调函数。
	当达到本场次结束标准时(第一场次为first_round_user_max个人胜利，其余场次为所有玩家战斗结束)，触发x强产生函数
	
	参数：1)number battleindex:表示战斗指针
	    
]]

function def_round_wincallback(battleindex)

	local winside = Battle.GetWinSide(battleindex);
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
	local w1 = Battle.GetPlayIndex(battleindex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleindex, 5 + sideM);
	local ww = nil;

	print(w1)
	print(w2)
	--把胜利玩家加入列表
	if ( Char.GetData(w1,CONST.CHAR_登陆次数) >= 1 ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2,CONST.CHAR_登陆次数) >= 1 ) then
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
			NLG.SystemMessage(-1,"天空竞技赛下一回合即将开始。");
			wincallbackfunc(tbl_win_user);
		end
	else
		--判断人数是否已达进入下一轮的要求
		if (tbl_swjjc_goinfo['create_battle_count'] == 0)then
			wincallbackfunc(tbl_win_user);
		end
	end

end


function user_WinFunc(player,mc)
	NLG.SystemMessage(player,"恭喜您获胜，请耐心等待其他玩家结束战斗。");
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
		NLG.SystemMessage(tuser,"您输了，感谢参与！");
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
function tablereset(_table)
	return  _table;
end

--- 卸载模块钩子
function AutoRanking:onUnload()
  self:logInfo('unload')
end

return AutoRanking;
