---模块类
local Module = ModuleBase:createModule('worldBoss')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
--队列解释
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------对战NPC设置------------
EnemySet[1] = {0, 400073, 400073, 0, 0, 406190, 0, 0, 400072, 400072}--0代表没有怪
BaseLevelSet[1] = {0, 300, 300, 0, 0, 300, 0, 0, 300, 300}
Pos[1] = {"回來復仇的巨櫻樹王",EnemySet[1],BaseLevelSet[1]}
EnemySet[2] = {0, 400075, 400075, 0, 0, 406191, 0, 0, 400074, 400074}
BaseLevelSet[2] = {0, 300, 300, 0, 0, 300, 0, 0, 300, 300}
Pos[2] = {"回來復仇的液態史伊",EnemySet[2],BaseLevelSet[2]}
EnemySet[3] = {0, 0, 0, 0, 0, 0, 406192, 406192, 0, 0}
BaseLevelSet[3] = {0, 0, 0, 0, 0, 0, 300, 300, 0, 0}
Pos[3] = {"回來復仇的夜地獄星",EnemySet[3],BaseLevelSet[3]}
EnemySet[4] = {406193, 0, 0, 0, 0, 0, 406193, 406193, 0, 0}
BaseLevelSet[4] = {300, 0, 0, 0, 0, 0, 300, 300, 0, 0}
Pos[4] = {"回來復仇的冥府之主",EnemySet[4],BaseLevelSet[4]}
EnemySet[5] = {406220, 0, 0, 0, 0, 0, 0, 0, 0, 0}
BaseLevelSet[5] = {300, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[5] = {"回來復仇的水母霸王",EnemySet[5],BaseLevelSet[5]}
EnemySet[6] = {0, 0, 0, 0, 0, 0, 406226, 406206, 0, 0}
BaseLevelSet[6] = {0, 0, 0, 0, 0, 0, 300, 300, 0, 0}
Pos[6] = {"回來復仇的暴走霸王",EnemySet[6],BaseLevelSet[6]}
EnemySet[7] = {0, 0, 0, 0, 0, 406233, 0, 0, 0, 0}
BaseLevelSet[7] = {0, 0, 0, 0, 0, 300, 0, 0, 0, 0}
Pos[7] = {"回來復仇的魷魚霸王",EnemySet[7],BaseLevelSet[7]}
------------------------------------------------------
--背景设置
local Pts= 70206;                                    --真女神苹果
local WorldBoss = {
      { weekday=1, weekdayItem=70241, lordName="復仇巨櫻樹王", lordImage=104889 , waitingArea={map=777,X=36,Y=41}, onfieldArea={map=25013,X=35,Y=15},
        rewardsItem={73940,73941,73893}, rewardsItem_count=1, prizeItem={73876,73878,73880,73890,73891}, prizeItem_count=1},
      { weekday=2, weekdayItem=70242, lordName="復仇液態史伊", lordImage=108206 , waitingArea={map=777,X=36,Y=43}, onfieldArea={map=25013,X=35,Y=15},
        rewardsItem={73923,73924}, rewardsItem_count=1, prizeItem={73921,73922,73930,73932}, prizeItem_count=1},
      { weekday=3, weekdayItem=70243, lordName="復仇夜地獄星", lordImage=108228 , waitingArea={map=777,X=36,Y=45}, onfieldArea={map=25013,X=35,Y=15},
        rewardsItem={73808,73809,73820,73821}, rewardsItem_count=1, prizeItem={73818,73819,73806,73938,73939}, prizeItem_count=1},
      { weekday=4, weekdayItem=70244, lordName="復仇冥府之主", lordImage=108205 , waitingArea={map=777,X=36,Y=47}, onfieldArea={map=25013,X=35,Y=15},
        rewardsItem={73833,73834,73912,73913}, rewardsItem_count=1, prizeItem={73835,73826,73828,73830,73831}, prizeItem_count=1},
      { weekday=5, weekdayItem=70245, lordName="復仇水母霸王", lordImage=108127 , waitingArea={map=777,X=36,Y=49}, onfieldArea={map=25013,X=35,Y=15},
        rewardsItem={73934,73935,73887,73888}, rewardsItem_count=1, prizeItem={73853,73854,73856,73885,73886}, prizeItem_count=1},
      { weekday=6, weekdayItem=70246, lordName="復仇暴走霸王", lordImage=108179 , waitingArea={map=777,X=36,Y=51}, onfieldArea={map=25013,X=35,Y=15},
        rewardsItem={73857,73859,73946,73948}, rewardsItem_count=1, prizeItem={73858,73860,73951,73952,73953}, prizeItem_count=1},
      { weekday=7, weekdayItem=70240, lordName="復仇魷魚霸王", lordImage=108121 , waitingArea={map=777,X=36,Y=53}, onfieldArea={map=25013,X=35,Y=15},
        rewardsItem={73866,73870,73843,73845}, rewardsItem_count=1, prizeItem={73861,73863,73865,73955,73957,73958}, prizeItem_count=1},
}
local tbl_duel_user = {};			--当前场次玩家的列表
local tbl_win_user = {};
local worldBossBattle = {}
tbl_WorldBossNPCIndex = tbl_WorldBossNPCIndex or {}
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  --self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('BeforeBattleTurnStartEvent', Func.bind(self.OnBeforeBattleTurnStartCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  --self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('LoopEvent', Func.bind(self.WorldBoss_LoopEvent,self))
    WorldBossNPC = self:NPC_createNormal('世界強敵討伐', 110308, { map = 777, x = 36, y = 39, direction = 5, mapType = 0 })
    self:NPC_regWindowTalkedEvent(WorldBossNPC, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
    end)
    self:NPC_regTalkedEvent(WorldBossNPC, function(npc, player)
      if(NLG.CheckInFront(player, npc, 1)==false) then
          return ;
      end
      if (NLG.CanTalk(npc, player) == true) then
               local bossDay = tonumber(os.date("%w",os.time()))
               if (bossDay==0) then bossDay=7; end
               print(bossDay)
               --面向玩家
               local i;
               i = Char.GetData(player, CONST.对象_方向);
               if i >= 4 then 
                              i = i - 4;
               else
                              i = i + 4;		
               end
               Char.SetData(npc, CONST.对象_方向,i);
               NLG.UpChar(npc);
               --世界BOSS
	local json = Field.Get(player, 'WorldDate');
	local ret, WorldDate = nil, nil;
	if json then
		ret, WorldDate = pcall(JSON.decode, json)
	else
		return
	end
	if ret and #WorldDate > 0 then
		if WorldDate[bossDay][1]==os.date("%d",os.time()) then
			NLG.SystemMessage(player,"[系統]每日僅能進行1次討伐。");
			return;
		end

	else
		WorldDate = {};
		for i=1,7 do
			WorldDate[i]={"32",};
		end
	end
	local playerName = Char.GetData(player,CONST.CHAR_名字);
	local partyname = playerName .. "－隊";
	local playerLv = Char.GetData(player,CONST.CHAR_等级);
	if playerLv<=100 then
		NLG.SystemMessage(player,"[系統]討伐建議隊長等級要100以上");
		return;
	end
	for k,v in pairs(WorldBoss) do
		if ( bossDay==v.weekday ) then
			table.insert(tbl_duel_user,player);
			boss_round_start(player, boss_round_callback);
			--WorldDate = {}
			WorldDate[bossDay] = {
			os.date("%d",os.time()),
			}
			Field.Set(player, 'WorldDate', JSON.encode(WorldDate));
			if (Char.EndEvent(player, 308) == 1) then
				local rand = NLG.Rand(1,#v.prizeItem);
				Char.GiveItem(player, v.prizeItem[rand], v.prizeItem_count);
			end
			local PartyNum = Char.PartyNum(player);
			if (PartyNum>1) then
				for Slot=1,4 do
					local TeamPlayer = Char.GetPartyMember(player,Slot);
					if Char.IsDummy(TeamPlayer)==false then
						Field.Set(TeamPlayer, 'WorldDate', JSON.encode(WorldDate));
						if (Char.EndEvent(TeamPlayer, 308) == 1) then
							local rand = NLG.Rand(1,#v.prizeItem);
							Char.GiveItem(TeamPlayer, v.prizeItem[rand], v.prizeItem_count);
						end
					end
				end
			end
		end
	end
      end
      return
    end)

    WarpBossNPC = self:NPC_createNormal('強敵討伐傳送', 110308, { map = 777, x = 37, y = 39, direction = 4, mapType = 0 })
    self:NPC_regWindowTalkedEvent(WarpBossNPC, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
    end)
    self:NPC_regTalkedEvent(WarpBossNPC, function(npc, player)
      if(NLG.CheckInFront(player, npc, 1)==false) then
          return ;
      end
      if (NLG.CanTalk(npc, player) == true) then
               local bossDay = tonumber(os.date("%w",os.time()))
               if (bossDay==0) then bossDay=7; end
               --面向玩家
               local i;
               i = Char.GetData(player, CONST.对象_方向);
               if i >= 4 then 
                              i = i - 4;
               else
                              i = i + 4;		
               end
               Char.SetData(npc, CONST.对象_方向,i);
               NLG.UpChar(npc);
               Char.Warp(player, 0, 25012, 25, 27);
               for k,v in pairs(WorldBoss) do
                   if ( bossDay==v.weekday ) then
                       Char.GiveItem(player, v.weekdayItem, 1);
                   end
               end
      end
      return
    end)

end
------------------------------------------------
-------功能设置
--战斗前全恢复
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

--指令启动循环
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr worldboss start]") then
		local cdk = Char.GetData(charIndex,CONST.对象_CDK);
		if (cdk == "123456") then
			Char.SetLoopEvent('./lua/Modules/worldBoss.lua','WorldBoss1_LoopEvent',WorldBossNPC,1000);
			Char.SetLoopEvent('./lua/Modules/worldBoss.lua','WorldBoss2_LoopEvent',WarpBossNPC,1000);
			NLG.SystemMessage(charIndex, "[系統]世界強敵共鬥開始。");
			NLG.UpChar(charIndex);
			return 0;
		end
	end
	return 1;
end
--转移每日世界强敌
function WorldBoss1_LoopEvent(WorldBossNPC)
	if (os.date("%X",os.time())=="00:45:01") or (os.date("%X",os.time())=="00:00:01") or (os.date("%X",os.time())=="12:15:01") or (os.date("%X",os.time())=="13:15:01") or (os.date("%X",os.time())=="17:15:01") or (os.date("%X",os.time())=="18:15:01") or (os.date("%X",os.time())=="20:15:01") or (os.date("%X",os.time())=="21:15:01") or (os.date("%X",os.time())=="22:15:01") then
		local bossDay = tonumber(os.date("%w",os.time()))
		if (bossDay==0) then bossDay=7; end
		NLG.SystemMessage(-1,"[系統]新一輪的世界強敵討伐活動開始了，快去法蘭城(218,88)！");
		for k,v in pairs(WorldBoss) do
			if ( bossDay==v.weekday ) then
				Char.SetData(WorldBossNPC,CONST.对象_名字, v.lordName);
				Char.SetData(WorldBossNPC,CONST.对象_形象, v.lordImage);
				Char.SetData(WorldBossNPC,CONST.对象_X, v.onfieldArea.X);
				Char.SetData(WorldBossNPC,CONST.对象_Y, v.onfieldArea.Y);
				Char.SetData(WorldBossNPC,CONST.对象_地图, v.onfieldArea.map);
				NLG.UpChar(WorldBossNPC);
			end
		end
		--每轮重置
		WorldDate = {};
		for i=1,7 do
			WorldDate[i]={"32",};
		end
		local newdata = JSON.encode(WorldDate);
		SQL.querySQL("update tbl_globalregvalue set value= '"..newdata.."' where str ='WorldDate' ")
	elseif (os.date("%X",os.time())=="23:59:00") or (os.date("%X",os.time())=="07:45:01") or (os.date("%X",os.time())=="13:45:01") or (os.date("%X",os.time())=="18:45:01") or (os.date("%X",os.time())=="21:45:01")  then
		Char.SetData(WorldBossNPC,CONST.对象_X, 36);
		Char.SetData(WorldBossNPC,CONST.对象_Y, 41);
		Char.SetData(WorldBossNPC,CONST.对象_地图, 777);
		NLG.UpChar(WorldBossNPC);
	end
end
--转移
function WorldBoss2_LoopEvent(WarpBossNPC)
	if (os.date("%X",os.time())=="00:45:01") or (os.date("%X",os.time())=="00:00:01") or (os.date("%X",os.time())=="12:15:01") or (os.date("%X",os.time())=="13:15:01") or (os.date("%X",os.time())=="17:15:01") or (os.date("%X",os.time())=="18:15:01") or (os.date("%X",os.time())=="20:15:01") or (os.date("%X",os.time())=="21:15:01") or (os.date("%X",os.time())=="22:15:01") then
		local bossDay = tonumber(os.date("%w",os.time()))
		if (bossDay==0) then bossDay=7; end
		--传送NPC
		for k,v in pairs(WorldBoss) do
			if ( bossDay==v.weekday ) then
				Char.SetData(WarpBossNPC,CONST.对象_名字, v.lordName);
				Char.SetData(WarpBossNPC,CONST.对象_形象, v.lordImage);
				Char.SetData(WarpBossNPC,CONST.对象_X, 218);
				Char.SetData(WarpBossNPC,CONST.对象_Y, 88);
				Char.SetData(WarpBossNPC,CONST.对象_地图, 1000);
				NLG.UpChar(WarpBossNPC);
			end
		end
	elseif (os.date("%X",os.time())=="23:59:00") or (os.date("%X",os.time())=="07:45:01") or (os.date("%X",os.time())=="13:45:01") or (os.date("%X",os.time())=="18:45:01") or (os.date("%X",os.time())=="21:45:01")  then
		Char.SetData(WarpBossNPC,CONST.对象_X, 37);
		Char.SetData(WarpBossNPC,CONST.对象_Y, 41);
		Char.SetData(WarpBossNPC,CONST.对象_地图, 777);
		NLG.UpChar(WarpBossNPC);
	end
end

function boss_round_start(player, callback)

	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--开始战斗
	tbl_UpIndex = {}
	battleindex = {}

	local bossDay = tonumber(os.date("%w",os.time()))
	if (bossDay==0) then bossDay=7; end
	for k,v in pairs(WorldBoss) do
		if ( bossDay==v.weekday ) then
			Char.HealAll(player);
			local battleindex = Battle.PVE( player, player, nil, Pos[bossDay][2], Pos[bossDay][3], nil)
			Battle.SetWinEvent("./lua/Modules/worldBoss.lua", "boss_round_callback", battleindex);
			worldBossBattle={}
			table.insert(worldBossBattle, battleindex);
		end
	end
end

function boss_round_callback(battleindex, player)

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

	local player = tbl_win_user[1];
	local bossDay = tonumber(os.date("%w",os.time()))
	if (bossDay==0) then bossDay=7; end
	if (Char.EndEvent(player, 308) == 1) then
		for k,v in pairs(WorldBoss) do
			if ( bossDay==v.weekday ) then
				local rand = NLG.Rand(1,#v.rewardsItem);
				Char.GiveItem(player, v.rewardsItem[rand], v.rewardsItem_count);
				Char.GiveItem(player, 70016, 20);
				NLG.SystemMessage(-1,"恭喜玩家: "..Char.GetData(player,CONST.对象_名字).." 討伐成功"..v.lordName.."。");
			end
		end
	end
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
			local TeamPlayer = Char.GetPartyMember(player,Slot);
			if Char.IsDummy(TeamPlayer)==false then
				Field.Set(TeamPlayer, 'WorldDate', JSON.encode(WorldDate));
				if (Char.EndEvent(TeamPlayer, 308) == 1) then
					for k,v in pairs(WorldBoss) do
						if ( bossDay==v.weekday ) then
							local rand = NLG.Rand(1,#v.rewardsItem);
							Char.GiveItem(TeamPlayer, v.rewardsItem[rand], v.rewardsItem_count);
							Char.GiveItem(TeamPlayer, 70016, 20);
						end
					end
				end
			end
		end
	end
	Battle.UnsetWinEvent(battleindex);
	worldBossBattle ={};
	Battle.UnsetWinEvent(battleindex);
end

--超级领主设置
function Module:OnbattleStartEventCallback(battleIndex)
	local ret = SQL.Run("select Name,WorldLord8 from lua_hook_worldboss order by WorldLord8 desc limit 1");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP8=tonumber(ret["0_1"]);
	end
	local playerCount = #NLG.GetPlayer();
	table.forEach(worldBossBattle, function(e)
		if  e==battleIndex  then
			--local playerCount = tonumber(SQL.Run("select count(WorldLord8) from lua_hook_worldboss")["0_0"])
			NLG.SystemMessage(-1,"[系統]世界強敵血量超激增.總共有"..playerCount.."名玩家x10萬的血量！");
		end
	end)
	if LordHP8<=10000 then
		LordHP8 = 100000;
		local HP = LordHP8;
		SQL.querySQL("update lua_hook_worldboss set WorldLord8= '"..HP.."' where LordEnd8='0' ")
	elseif LordHP8>100000 then
		local HP = 100000;
		SQL.querySQL("update lua_hook_worldboss set WorldLord8= '"..HP.."' where LordEnd8='0' ")
	end
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP8;
		table.forEach(worldBossBattle, function(e)
			if enemy>=0 and e==battleIndex  then
				if Char.GetData(enemy, CONST.对象_ENEMY_ID)==406190 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406191 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406192 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406193 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406220 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406206 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406233 then
					Char.SetData(enemy, CONST.CHAR_最大血, 1000000);
					Char.SetData(enemy, CONST.CHAR_血, HP);
					--NLG.SystemMessage(-1,"[系統]世界強敵血量超激增！");
				end
			end
		end)
	end
end
function Module:OnBeforeBattleTurnStartCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local ret = SQL.Run("select Name,WorldLord8 from lua_hook_worldboss order by WorldLord8 desc limit 1");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP8=tonumber(ret["0_1"]);
	end
	--print(LordHP8)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP8;
		table.forEach(worldBossBattle, function(e)
		if Round==0 and enemy>=0 and e==battleIndex  then
			if Char.GetData(enemy, CONST.对象_ENEMY_ID)==406190 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406191 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406192 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406193 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406220 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406206 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406233 then
				Char.SetData(enemy, CONST.CHAR_最大血, 1000000);     --血量上限100万
				Char.SetData(enemy, CONST.CHAR_血, HP);
			end
		elseif Round>0 and enemy>=0 and e==battleIndex  then
			if Char.GetData(enemy, CONST.对象_ENEMY_ID)==406190 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406191 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406192 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406193 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406220 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406206 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406233 then
				Char.SetData(enemy, CONST.CHAR_最大血, 1000000);     --血量上限100万
				Char.SetData(enemy, CONST.CHAR_血, HP);
				if Round>=1 then
					Char.SetData(enemy, CONST.CHAR_攻击力, 10000);
					Char.SetData(enemy, CONST.CHAR_防御力, 666);
					Char.SetData(enemy, CONST.CHAR_敏捷, 10000);
					Char.SetData(enemy, CONST.CHAR_精神, 10000);
					Char.SetData(enemy, CONST.CHAR_回复, 66);
					Char.SetData(enemy, CONST.CHAR_必杀, 100);
					Char.SetData(enemy, CONST.CHAR_闪躲, 100);
					Char.SetData(enemy, CONST.CHAR_命中, 100);
					Char.SetData(enemy, CONST.CHAR_反击, 70);
					Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,108511);
				end
			end
		end
		--NLG.SystemMessage(-1,"[系統]世界強敵血量超激增！");
		end)
	end
end
function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人 then
		player = leader0
	else
		player = leaderpet
	end
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		table.forEach(worldBossBattle, function(e)
		if Round>=0 and enemy>=0 and e==battleIndex  then
			if Char.GetData(enemy, CONST.对象_ENEMY_ID)==406190 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406191 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406192 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406193 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406220 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406206 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406233 then
				local HP = Char.GetData(enemy,CONST.CHAR_血);
				Char.SetData(enemy, CONST.CHAR_最大血, 1000000);
				Char.SetData(enemy, CONST.CHAR_血, HP);
				if Char.GetData(player,CONST.对象_对战开关) == 1  then
					NLG.SystemMessage(player,"[系統]世界強敵此條剩餘血量"..HP.."，尚還有其他玩家的10萬血量！");
				end
				NLG.UpChar(enemy);
				--Lord血量写入库
				local cdk = Char.GetData(player,CONST.对象_CDK) or nil;
				if (cdk~=nil) then
					SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE CdKey='"..cdk.."')");
					--SQL.Run("update lua_hook_worldboss set WorldLord8= '"..HP.."' where CdKey='"..cdk.."'")
					--NLG.UpChar(player);
					local Blood_cdk = SQL.Run("select CdKey from lua_hook_worldboss order by WorldLord8 desc limit 1")["0_0"];
					SQL.Run("update lua_hook_worldboss set WorldLord8= '"..HP.."' where CdKey='"..Blood_cdk.."'")
					NLG.UpChar(NLG.FindUser(Blood_cdk));
				end
			end
		end
		end)
	end
end
--暴走模式技能施放
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
            local enemy = Battle.GetPlayer(battleIndex, i);
            if enemy>= 0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==406190 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406191 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406192 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406193 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406220 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406206 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==406233 then
                table.forEach(worldBossBattle, function(e)
                if Round==5 and e==battleIndex  then
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8607);
                elseif Round==10 and e==battleIndex  then
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8609);
                elseif Round>=15 and e==battleIndex  then
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8659);
                end
                end)
            end
      end
end
function SetCom(charIndex, action, com1, com2, com3)
  if action == 0 then
    Char.SetData(charIndex, CONST.CHAR_BattleCom1, com1)
    Char.SetData(charIndex, CONST.CHAR_BattleCom2, com2)
    Char.SetData(charIndex, CONST.CHAR_BattleCom3, com3)
  else
    Char.SetData(charIndex, CONST.CHAR_BattleCom1, com1)
    Char.SetData(charIndex, CONST.CHAR_BattleCom2, com2)
    Char.SetData(charIndex, CONST.CHAR_BattleCom3, com3)
  end
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local playerCount = #NLG.GetPlayer()+1;
      local ret = SQL.Run("select WorldLord8 from lua_hook_worldboss order by WorldLord8 asc limit "..playerCount.." ");
      local Invincible = 0;
      local deadCount = 0;
      if(type(ret)=="table" and ret["0_0"]~=nil)then
            for i=0,playerCount-1 do
                local LordHP8=tonumber(ret[i.."_0"]);
                if LordHP8<=10000 then
                    deadCount=deadCount+1;
                end
            end
            if deadCount==playerCount-1 then
                    Invincible = 1;
            elseif deadCount>playerCount-1 then
                    Invincible = 2;
            end
      end
      --print(deadCount,Invincible)
      local Round = Battle.GetTurn(battleIndex);
      if Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==406190 or Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==406191 or Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==406192 or Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==406193 or Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==406220 or Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==406206 or Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==406233 then
          if Invincible==1 then
              table.forEach(worldBossBattle, function(e)
              if Round>=0 and e==battleIndex  then
                  local defHpE = Char.GetData(defCharIndex,CONST.CHAR_血);
                  if damage>=defHpE-1 then
                      Char.SetData(defCharIndex, CONST.CHAR_血, defHpE+damage*0.1);
                      NLG.UpChar(defCharIndex);
                      damage = damage*0;
                  else
                      damage = damage*0;
                  end
              end
              end)
              if Char.GetData(charIndex,CONST.对象_对战开关) == 1  then
                  NLG.SystemMessage(charIndex,"[系統]世界強敵無敵狀態，須等待剩餘的血條下回合更新！");
              end
              return damage;
          else
              table.forEach(worldBossBattle, function(e)
              if Round>=0 and e==battleIndex  then
                  if Char.GetData(charIndex,CONST.对象_对战开关) == 1  then
                      local playerCount = #NLG.GetPlayer();
                      NLG.SystemMessage(charIndex,"[系統]世界強敵剩餘的血條"..deadCount.."/"..playerCount.."！");
                  end
                  local defHpE = Char.GetData(defCharIndex,CONST.CHAR_血);
                  if damage<defHpE-1 then
                      defHpE = defHpE - damage;
                      damage = damage;
                  else
                      damage = defHpE-1;
                      defHpE = 1;
                  end
                  if defHpE==1 and Invincible~=2 then
                      damage = damage*0;
                  elseif defHpE==1 and Invincible==2 then
                      damage = damage;
                  end
                  local Blood_cdk = SQL.Run("select CdKey from lua_hook_worldboss order by WorldLord8 desc limit 1")["0_0"];
                  SQL.Run("update lua_hook_worldboss set WorldLord8= '"..defHpE.."' where CdKey='"..Blood_cdk.."'")
                  NLG.UpChar(NLG.FindUser(Blood_cdk));
                  return damage;
              end
              end)
          end
      end
      if Char.IsEnemy(charIndex) and Char.GetData(charIndex, CONST.CHAR_ENEMY_ID) == 700031 and Char.IsPlayer(defCharIndex) then
          if math.random(1, 100) >= 85 then
              local slot = Char.GetEmptyItemSlot(defCharIndex);
              local itemIndex, wslot = Char.GetWeapon(defCharIndex);
              if itemIndex >= 0 then
                  NLG.SystemMessage(defCharIndex,"[系統]"..Char.GetData(defCharIndex, CONST.CHAR_名字).."武器被卸下了！");
                  if slot < 0 then
                            damage = math.floor(damage * 1.5);
                  else
                            Char.MoveItem(defCharIndex, wslot, slot, -1);
                            Char.SetData(defCharIndex, CONST.CHAR_BattleCom1, CONST.BATTLE_COM.BATTLE_COM_ATTACK);
                            Char.SetData(defCharIndex, CONST.CHAR_BattleCom2, 10);
                            Char.SetData(defCharIndex, CONST.CHAR_BattleCom3, -1);
                            NLG.UpChar(defCharIndex);
                  end
              end
          end
          return damage;
      end
  return damage;
end

--[[
    for k,v in pairs(WorldBoss) do
        if tbl_WorldBossNPCIndex[k] == nil then
            local WorldBossNPC = self:NPC_createNormal(v.lordName, v.lordImage, { map = v.waitingArea.map, x = v.waitingArea.X, y = v.waitingArea.Y, direction = 6, mapType = 0 })
            tbl_WorldBossNPCIndex[k] = WorldBossNPC
	self:NPC_regWindowTalkedEvent(tbl_WorldBossNPCIndex[k], function(npc, player, _seqno, _select, _data)
		local cdk = Char.GetData(player,CONST.对象_CDK);
		local seqno = tonumber(_seqno)
		local select = tonumber(_select)
		local data = tonumber(_data)
	end)
	self:NPC_regTalkedEvent(tbl_WorldBossNPCIndex[k], function(npc, player)
		if(NLG.CheckInFront(player, npc, 1)==false) then
			return ;
		end
		if (NLG.CanTalk(npc, player) == true) then
			local bossDay = tonumber(os.date("%w",os.time()))
			if (bossDay==0) then bossDay=7; end
			print(bossDay)
			--面向玩家
			local i;
			i = Char.GetData(player, CONST.对象_方向);
			if i >= 4 then 
				i = i - 4;
			else
				i = i + 4;		
			end
			Char.SetData(player, CONST.对象_方向,i);
			NLG.UpChar(player);
			--世界BOSS
			local json = Field.Get(player, 'WorldDate');
			local ret, WorldDate = nil, nil;
			if json then
				ret, WorldDate = pcall(JSON.decode, json)
			else
				return
			end
			if ret and #WorldDate > 0 then
				if WorldDate[bossDay][1]==os.date("%d",os.time()) then
					NLG.SystemMessage(player,"[系統]每日僅能進行1次討伐。");
					return;
				end

			else
				WorldDate = {};
				for i=1,7 do
					WorldDate[i]={"32",};
				end
			end
			local playerName = Char.GetData(player,CONST.CHAR_名字);
			local partyname = playerName .. "－隊";
			for k,v in pairs(WorldBoss) do
				if ( bossDay==v.weekday ) then
					table.insert(tbl_duel_user,player);
					boss_round_start(player, boss_round_callback);
					--WorldDate = {}
					WorldDate[bossDay] = {
					os.date("%d",os.time()),
					}
					Field.Set(player, 'WorldDate', JSON.encode(WorldDate));
					local PartyNum = Char.PartyNum(player);
					if (PartyNum>1) then
						for Slot=1,4 do
							local TeamPlayer = Char.GetPartyMember(player,Slot);
							if Char.IsDummy(TeamPlayer)==false then
								Field.Set(TeamPlayer, 'WorldDate', JSON.encode(WorldDate));
							end
						end
					end
				end
			end
		end
		return
	end)
        end
    end
]]
--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
