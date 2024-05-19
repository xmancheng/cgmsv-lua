local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local STime = os.time()
local YS = 30 --脚本延时多少秒创建NPC
local SXTime = 15 --NPC刷新时间·秒
--队列解释
--     五	三	一	二	四
--     十	八	六	七	九
------------曜日副本NPC设置------------
EnemySet[1] = {406165, 0, 0, 406166, 406166, 0, 406166, 406166, 0, 0}--0代表没有怪
EnemySet[2] = {406167, 0, 0, 406168, 406168, 0, 406168, 406168, 0, 0}
EnemySet[3] = {406169, 0, 0, 406170, 406170, 0, 406170, 406170, 0, 0}
EnemySet[4] = {406171, 0, 0, 406172, 406172, 0, 406172, 406172, 0, 0}
EnemySet[5] = {406173, 0, 0, 406174, 406174, 0, 406174, 406174, 0, 0}
EnemySet[6] = {406175, 0, 0, 406176, 406176, 0, 406176, 406176, 0, 0}
EnemySet[7] = {406177, 0, 0, 406178, 406178, 0, 406178, 406178, 0, 0}
BaseLevelSet[1] = {59, 0, 0, 49, 49, 0, 49, 49, 0, 0}
BaseLevelSet[2] = {59, 0, 0, 49, 49, 0, 49, 49, 0, 0}
BaseLevelSet[3] = {59, 0, 0, 49, 49, 0, 49, 49, 0, 0}
BaseLevelSet[4] = {59, 0, 0, 49, 49, 0, 49, 49, 0, 0}
BaseLevelSet[5] = {59, 0, 0, 49, 49, 0, 49, 49, 0, 0}
BaseLevelSet[6] = {59, 0, 0, 49, 49, 0, 49, 49, 0, 0}
BaseLevelSet[7] = {59, 0, 0, 49, 49, 0, 49, 49, 0, 0}
Pos[1] = {{"日曜日",100576,19202,60,35,6,EnemySet[1],1,BaseLevelSet[1]}}
Pos[2] = {{"月曜一",100602,19202,60,30,6,EnemySet[2],2,BaseLevelSet[2]}}
Pos[3] = {{"火曜二",100725,19202,49,31,4,EnemySet[3],3,BaseLevelSet[3]}}
Pos[4] = {{"水曜三",100555,19202,54,31,4,EnemySet[4],4,BaseLevelSet[4]}}
Pos[5] = {{"木曜四",100678,19202,49,39,0,EnemySet[5],5,BaseLevelSet[5]}}
Pos[6] = {{"金曜五",100754,19202,54,39,0,EnemySet[6],6,BaseLevelSet[6]}}
Pos[7] = {{"土曜六",100528,19202,60,40,6,EnemySet[7],7,BaseLevelSet[7]}}


tbl_RandomDailyNpcIndex = tbl_RandomDailyNpcIndex or {}
------------------------------------------------
local script_map_name = {};
local script_map_point = {};
local script_map_lvlimit = {};
local script_map_payfor = {};
local script_map_drop = {};
local script_map_gift = {};
local script_map_daily_user = {};
local script_map_daily_user_count = {};
script_map_daily_user_count[1] = {};
script_map_daily_user_count[2] = {};
script_map_daily_user_count[3] = {};
script_map_daily_user_count[4] = {};
script_map_daily_user_count[5] = {};
script_map_daily_user_count[6] = {};
local script_map_amount = {};
script_map_amount[2] = {};

script_map_name[2] = "《鬼之島曜日副本》";
script_map_point[2] = {19202,38,11};
script_map_lvlimit[2] = 50;
script_map_payfor[2] = 1000;
script_map_drop[2] = {70250,70251,70252,70253,70254,70255,70256};
script_map_gift[2] = {70247,70248,70249};

Delegate.RegInit("initDailyScriptNpc");

function initDailyScriptNpc_Init(index)
	return 1;
end

function mykgold(_PlayerIndex,gold)
	local tjb = Char.GetData(_PlayerIndex,%对象_金币%);
	tjb = tjb - gold; 
	if(tjb >= 0)then
		Char.SetData(_PlayerIndex,%对象_金币%,tjb);
		NLG.UpChar(_PlayerIndex);
		NLG.SystemMessage(_PlayerIndex,"交出了"..gold.." G魔幣。");
		return true;
	end
	return false;
end

function initDailyScriptNpc()
	if (DailyScriptNps == nil) then
		DailyScriptNps = NL.CreateNpc("lua/Module/DailyScript.lua", "initDailyScriptNpc_Init");
		Char.SetData(DailyScriptNps,%对象_形象%,231146);
		Char.SetData(DailyScriptNps,%对象_原形%,231146);
		Char.SetData(DailyScriptNps,%对象_X%,228);
		Char.SetData(DailyScriptNps,%对象_Y%,83);
		Char.SetData(DailyScriptNps,%对象_地图%,1000);
		Char.SetData(DailyScriptNps,%对象_方向%,6);
		Char.SetData(DailyScriptNps,%对象_原名%,"鬼之島曜日副本");
		NLG.UpChar(DailyScriptNps);
		Char.SetWindowTalkedEvent("lua/Module/DailyScript.lua","DailyScriptA",DailyScriptNps);
		Char.SetTalkedEvent("lua/Module/DailyScript.lua","DailyScriptMsg", DailyScriptNps);
	end
	if (DailyScriptNpsB == nil) then
		DailyScriptNpsB = NL.CreateNpc("lua/Module/DailyScript.lua", "initDailyScriptNpc_Init");
		Char.SetData(DailyScriptNpsB,%对象_形象%,231147);
		Char.SetData(DailyScriptNpsB,%对象_原形%,231147);
		Char.SetData(DailyScriptNpsB,%对象_X%,57);
		Char.SetData(DailyScriptNpsB,%对象_Y%,45);
		Char.SetData(DailyScriptNpsB,%对象_地图%,19202);
		Char.SetData(DailyScriptNpsB,%对象_方向%,1);
		Char.SetData(DailyScriptNpsB,%对象_原名%,"被囚禁的公主");
		NLG.UpChar(DailyScriptNpsB);
		Char.SetWindowTalkedEvent("lua/Module/DailyScript.lua","DailyScriptB",DailyScriptNpsB);
		Char.SetTalkedEvent("lua/Module/DailyScript.lua","DailyScriptMsgB", DailyScriptNpsB);
	end
	if (DailyScriptNpsC == nil) then
		DailyScriptNpsC = NL.CreateNpc("lua/Module/DailyScript.lua", "initDailyScriptNpc_Init");
		Char.SetData(DailyScriptNpsC,%对象_形象%,231116);
		Char.SetData(DailyScriptNpsC,%对象_原形%,231116);
		Char.SetData(DailyScriptNpsC,%对象_X%,18);
		Char.SetData(DailyScriptNpsC,%对象_Y%,18);
		Char.SetData(DailyScriptNpsC,%对象_地图%,777);
		Char.SetData(DailyScriptNpsC,%对象_方向%,6);
		Char.SetData(DailyScriptNpsC,%对象_原名%,"明怪設置");
		NLG.UpChar(DailyScriptNpsC);
		Char.SetLoopEvent(nil, "DailyScript_LoopEvent",DailyScriptNpsC, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/DailyScript.lua","DailyScriptC",DailyScriptNpsC);
		Char.SetTalkedEvent("lua/Module/DailyScript.lua","DailyScriptMsgC", DailyScriptNpsC);
	end
end

function DailyScriptMsgA(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local PlayerLevel = tonumber(Char.GetData(_tome,%对象_等级%));
		
		if (PlayerLevel < 50) then
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n先到達50級再來吧！"));
			return;
		end

		if(Time_Out(_tome))then
			script_map_daily_user[Playerkey(_tome)] = os.time();
			for i=1,6 do
				script_map_daily_user_count[i][Playerkey(_tome)] = nil;
			end
		end

		if (script_map_daily_user_count[1][Playerkey(_tome)] == 1) then
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n明天再來吧！"));
			return;
		end
		script_map_daily_user_count[1][Playerkey(_tome)] = 1;
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n你願意參加曜日副本得到曜日珍珠嗎？"));
	end
	return;
end



function DailyScriptMsg(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local _obj = script_map_daily_user[Playerkey(_tome)];
		--如果首次登录
		if (_obj == nil) then 
			script_map_daily_user[Playerkey(_tome)] = os.time();
		end
		if(os.date("%d",_obj) ~= os.date("%d",os.time())) then --判定一天重置
			script_map_daily_user[Playerkey(_tome)] = os.time();
			for i=1,6 do
				script_map_daily_user_count[i][Playerkey(_tome)] = nil;
			end
		end

		str_ChangeWindow = "4|\\n\\n 			你好!我是副本管理員.\\n	 			你要去鬼之島嗎?...\\n\\n";
		local tcount = script_map_daily_user_count[2][Playerkey(_tome)];
		if(tcount == nil)then
			tcount = 3;
			
		else
			tcount = 3 - tcount;
		end
		str_ChangeWindow = str_ChangeWindow .. "<"..script_map_payfor[2].."G>".." "..script_map_name[2].." 剩餘".."<"..tcount..">次".."\\n";

		NLG.ShowWindowTalked(_tome,_me,%窗口_选择框%,%按钮_关闭%,1,str_ChangeWindow);
	end
	return;
end


function DailyScriptA(_MeIndex,_PlayerIndex,_seqno,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data)+1;
		
		if (selectitem==nil or (selectitem~=nil and (selectitem > 2 or selectitem <= 0))) then
				--NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您所选择的位置不正常!");
				return;
		end
		local getlvlit = script_map_lvlimit[selectitem];
		if(getlvlit > Char.GetData(_PlayerIndex,%对象_等级%))then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您的等級不夠，需要"..getlvlit.."才可進入。");
			return;
		end
		local getcountless = script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)];
		if(getcountless ==nil)then
			getcountless = 0;
			script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)] = 0;
		end
		if (getcountless >= 3)then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您的次數已經用完了。");
			return;
		end
		if(Char.PartyNum(_PlayerIndex) > 1)then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請解散隊伍。");
			return;
		end
		if(mykgold(_PlayerIndex,script_map_payfor[selectitem]))then
			script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)] = getcountless + 1;
			if(os.date("%w",os.time()) =="0")then Char.GiveItem(_PlayerIndex,70240,1) end
			if(os.date("%w",os.time()) =="1")then Char.GiveItem(_PlayerIndex,70241,1) end
			if(os.date("%w",os.time()) =="2")then Char.GiveItem(_PlayerIndex,70242,1) end
			if(os.date("%w",os.time()) =="3")then Char.GiveItem(_PlayerIndex,70243,1) end
			if(os.date("%w",os.time()) =="4")then Char.GiveItem(_PlayerIndex,70244,1) end
			if(os.date("%w",os.time()) =="5")then Char.GiveItem(_PlayerIndex,70245,1) end
			if(os.date("%w",os.time()) =="6")then Char.GiveItem(_PlayerIndex,70246,1) end
			Char.DischargeParty(_PlayerIndex)
			Char.Warp(_PlayerIndex,0,script_map_point[selectitem][1],script_map_point[selectitem][2],script_map_point[selectitem][3]);
		else
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您的魔幣不夠。");
			return;
		end
	end
end

function DailyScriptB(_MeIndex,_PlayerIndex,_seqno,_select,_data)

end
function DailyScriptMsgB(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		if (Char.ItemNum(_tome,69215) > 0 and Char.ItemNum(_tome,69216) > 0 and Char.ItemNum(_tome,69217) > 0 and Char.ItemNum(_tome,69218) > 0 and Char.ItemNum(_tome,69219) > 0 and Char.ItemNum(_tome,69220) > 0 and Char.ItemNum(_tome,69221) > 0) then
			if(Char.ItemSlot(_tome)>17)then
				NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請至少留出3個背包位置！"));
				return;
			end
			local gift = math.random(1,3);
			Char.GiveItem(_tome,70238,1);
			Char.GiveItem(_tome,script_map_gift[2][gift],1);
			local PlayerFame = Char.GetData(_tome,%对象_声望%);
			PlayerFame = PlayerFame + 600;
			Char.SetData(_tome,%对象_声望%,PlayerFame);
			local money = Char.GetData(_tome,%对象_金币%);
			Char.SetData(_tome,%对象_金币%,money+7000);
			NLG.UpChar(_tome);
			Char.DelItem(_tome,69215,1);
			Char.DelItem(_tome,69216,1);
			Char.DelItem(_tome,69217,1);
			Char.DelItem(_tome,69218,1);
			Char.DelItem(_tome,69219,1);
			Char.DelItem(_tome,69220,1);
			Char.DelItem(_tome,69221,1);
			NLG.SystemMessage(_tome, "[系統]請收下我的謝禮！")
		end
		if (Char.ItemNum(_tome,70239) == 0) then
			Char.GiveItem(_tome,70239,1);
		end
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n收集七彩珍珠幫助我吧！"));
	end
	return;
end
function DailyScript_LoopEvent(_MeIndex)
	--创建假人
	local DTime = os.time()
	if DTime - STime >= YS then
		for i=1,7 do
		local Image = Pos[i][1][2]
		local Name = Pos[i][1][1]
		local Num = Pos[i][1][8]
			if tbl_RandomDailyNpcIndex[Num] == nil then
				local DailyScriptNpcIndex = CreateDailyNpc(Image, Name, 0, Pos[i][1][3], Pos[i][1][4], Pos[i][1][5], Pos[i][1][6])
				tbl_RandomDailyNpcIndex[Num] = DailyScriptNpcIndex
			end
		end
	end
end
--NPC对话事件(NPC索引)
function DailyScriptMsgC(_NpcIndex, _PlayerIndex)
tbl_RandomDailyNpcIndex = {}
end

--NPC窗口事件(NPC索引)
function DailyScriptC ( _NpcIndex, _PlayerIndex, _seqno, _select, _data)
	
end
function CreateDailyNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local DailyScriptNpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( DailyScriptNpcIndex, %对象_形象%, Image);
	Char.SetData( DailyScriptNpcIndex, %对象_原形%, Image);
	Char.SetData( DailyScriptNpcIndex, %对象_地图类型%, MapType);
	Char.SetData( DailyScriptNpcIndex, %对象_地图%, MapID);
	Char.SetData( DailyScriptNpcIndex, %对象_X%, PosX);
	Char.SetData( DailyScriptNpcIndex, %对象_Y%, PosY);
	Char.SetData( DailyScriptNpcIndex, %对象_方向%, Dir);
	Char.SetData( DailyScriptNpcIndex, %对象_原名%, Name);
	Char.SetData( DailyScriptNpcIndex, %对象_名色%, NameColor);
	tbl_LuaNpcIndex = tbl_LuaNpcIndex or {}
	tbl_LuaNpcIndex["DailyNpc"] = DailyScriptNpcIndex
	Char.SetTalkedEvent(nil, "DailyNpc__Talked", DailyScriptNpcIndex)
	Char.SetWindowTalkedEvent(nil, "DailyNpc__WindowTalked", DailyScriptNpcIndex)
	Char.SetLoopEvent(nil, "DailyNpc_LoopEvent", DailyScriptNpcIndex, math.random(1000,5000))
	NLG.UpChar(DailyScriptNpcIndex)
	return DailyScriptNpcIndex
end
function DailyNpc_LoopEvent(_MeIndex)
	local sit = 11;
	NLG.SetAction(_MeIndex,sit);
	NLG.UpChar(_MeIndex);
end
function DailyNpc__Talked(_NpcIndex, _PlayerIndex)
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
	local mz = "『"..Char.GetData(_PlayerIndex,%对象_名字%).. "』"
	local	token ="\n\n\n\n挑戰者"..mz.."準備進入戰鬥嗎？"

       NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, token)

end
function DailyNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
	local tName = Char.GetData(_NpcIndex, %对象_原名%)
	local tImage = Char.GetData(_NpcIndex, %对象_形象%)
	--创建Boss战斗
	local tBossLv = 1
--	local tDailyBattleIndex = Battle.PVE( _PlayerIndex, tbl_LuaNpcIndex["DailyNpc"], nil, tBossList, tLvList, nil)
--	if(Char.PartyNum(_PlayerIndex) > 1)then
--		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,2,"\\n\\n\\n請單人進行挑戰。");
--		return;
--	end
	if(tImage == 100576) then
		if(os.date("%w",os.time()) =="0" and Char.ItemNum(_PlayerIndex,70240) >=1)then
			Char.DelItem(_PlayerIndex,70240,1);
			local tDailyBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[1][1][7], Pos[1][1][9], nil)
			Battle.SetWinEvent("./lua/Module/DailyScript.lua", "DailyNpc_BattleWin", tDailyBattleIndex);
		else
			NLG.SystemMessage(_PlayerIndex,"你沒有曜日通行證。");
			return;
		end
	end
	if(tImage == 100602) then
		if(os.date("%w",os.time()) =="1" and Char.ItemNum(_PlayerIndex,70241) >=1)then
			Char.DelItem(_PlayerIndex,70241,1);
			local tDailyBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[2][1][7], Pos[2][1][9], nil)
			Battle.SetWinEvent("./lua/Module/DailyScript.lua", "DailyNpc_BattleWin", tDailyBattleIndex);
		else
			NLG.SystemMessage(_PlayerIndex,"你沒有曜日通行證。");
			return;
		end
	end
	if(tImage == 100725) then
		if(os.date("%w",os.time()) =="2" and Char.ItemNum(_PlayerIndex,70242) >=1)then
			Char.DelItem(_PlayerIndex,70242,1);
			local tDailyBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[3][1][7], Pos[3][1][9], nil)
			Battle.SetWinEvent("./lua/Module/DailyScript.lua", "DailyNpc_BattleWin", tDailyBattleIndex);
		else
			NLG.SystemMessage(_PlayerIndex,"你沒有曜日通行證。");
			return;
		end
	end
	if(tImage == 100555) then
		if(os.date("%w",os.time()) =="3" and Char.ItemNum(_PlayerIndex,70243) >=1)then
			Char.DelItem(_PlayerIndex,70243,1);
			local tDailyBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[4][1][7], Pos[4][1][9], nil)
			Battle.SetWinEvent("./lua/Module/DailyScript.lua", "DailyNpc_BattleWin", tDailyBattleIndex);
		else
			NLG.SystemMessage(_PlayerIndex,"你沒有曜日通行證。");
			return;
		end
	end
	if(tImage == 100678) then
		if(os.date("%w",os.time()) =="4" and Char.ItemNum(_PlayerIndex,70244) >=1)then
			Char.DelItem(_PlayerIndex,70244,1);
			local tDailyBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[5][1][7], Pos[5][1][9], nil)
			Battle.SetWinEvent("./lua/Module/DailyScript.lua", "DailyNpc_BattleWin", tDailyBattleIndex);
		else
			NLG.SystemMessage(_PlayerIndex,"你沒有曜日通行證。");
			return;
		end
	end
	if(tImage == 100754) then
		if(os.date("%w",os.time()) =="5" and Char.ItemNum(_PlayerIndex,70245) >=1)then
			Char.DelItem(_PlayerIndex,70245,1);
			local tDailyBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[6][1][7], Pos[6][1][9], nil)
			Battle.SetWinEvent("./lua/Module/DailyScript.lua", "DailyNpc_BattleWin", tDailyBattleIndex);
		else
			NLG.SystemMessage(_PlayerIndex,"你沒有曜日通行證。");
			return;
		end
	end
	if(tImage == 100528) then
		if(os.date("%w",os.time()) =="6" and Char.ItemNum(_PlayerIndex,70246) >=1)then
			Char.DelItem(_PlayerIndex,70246,1);
			local tDailyBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[7][1][7], Pos[7][1][9], nil)
			Battle.SetWinEvent("./lua/Module/DailyScript.lua", "DailyNpc_BattleWin", tDailyBattleIndex);
		else
			NLG.SystemMessage(_PlayerIndex,"你沒有曜日通行證。");
			return;
		end
	end
 end
end
function DailyNpc_BattleWin(_BattleIndex, _NpcIndex)
		local tImage = Char.GetData(_NpcIndex, %对象_形象%)
		local tPlayerIndex = Battle.GetPlayIndex( _BattleIndex, 0)
		local drop = math.random(3,7);
		if tPlayerIndex>=0 and Char.GetData(tPlayerIndex,%对象_类型%)==1 then
			if(tImage == 100576) then
				Char.GiveItem(tPlayerIndex,script_map_drop[2][1],drop);
			end
			if(tImage == 100602) then
				Char.GiveItem(tPlayerIndex,script_map_drop[2][2],drop);
			end
			if(tImage == 100725) then
				Char.GiveItem(tPlayerIndex,script_map_drop[2][3],drop);
			end
			if(tImage == 100555) then
				Char.GiveItem(tPlayerIndex,script_map_drop[2][4],drop);
			end
			if(tImage == 100678) then
				Char.GiveItem(tPlayerIndex,script_map_drop[2][5],drop);
			end
			if(tImage == 100754) then
				Char.GiveItem(tPlayerIndex,script_map_drop[2][6],drop);
			end
			if(tImage == 100528) then
				Char.GiveItem(tPlayerIndex,script_map_drop[2][7],drop);
			end
			--NL.DelNpc(_NpcIndex)
			local kk = table_n(_NpcIndex,0,'v',tbl_RandomDailyNpcIndex)
			tbl_RandomDailyNpcIndex[kk] = nil
		end
		Battle.UnsetWinEvent( _BattleIndex);
	--return 1
end

function table_n(c1,c2,n,t)
	for key, value in pairs(t) do
		if c1 == value and n == 'v' then
			return key
		end
	end
end
