local NPCName = "测试"
local NPCPoint = {106277,777,10,10,6}
local EnemySet = {}
local BaseLevelSet = {}
local STime = os.time()
local YS = 30 --脚本延时多少秒创建NPC
local SXTime = 15 --NPC刷新时间·秒
--队列解释
--     五	三	一	二	四
--     十	八	六	七	九
EnemySet[1] = {360093, 0, 0, 0, 0, 360071, 360017, 360018, 0, 0}--0代表没有怪
EnemySet[2] = {360094, 0, 0, 0, 0, 360082, 360017, 360018, 0, 0}
EnemySet[3] = {360106, 360071, 360082, 360031, 360032, 0, 360033, 360034, 0, 0}
BaseLevelSet[1] = {89, 0, 0, 0, 0, 69, 40, 40, 0, 0}
BaseLevelSet[2] = {89, 0, 0, 0, 0, 77, 40, 40, 0, 0}
BaseLevelSet[3] = {89, 69, 77, 57, 57, 0, 57, 57, 0, 0}
------------随机NPC设置
local Pos = {{"狂魔阿卡斯",108166,1000,279,86,6},{"邪神巴洛斯",108167,1000,279,90,6},{"軍王李貝留斯",108168,1000,277,88,6}}--名字不能一样
tbl_RandomNpcIndex = tbl_RandomNpcIndex or {}
------------------------------------------------
Delegate.RegInit("Wild_main");

function WildNpc_Init(index)
	print(NPCName.."npc_index = " .. index);
	return 1;
end

function Wild_Create()
	if WildNpc == nil then
		WildNpc=NL.CreateNpc("lua/Module/WildBoss.lua","WildNpc_Init")
		Char.SetData(WildNpc,%对象_形象%,NPCPoint[1]);
		Char.SetData(WildNpc,%对象_原形%,NPCPoint[1]);
		Char.SetData(WildNpc,%对象_地图%,NPCPoint[2]);
		Char.SetData(WildNpc,%对象_X%,NPCPoint[3]);
		Char.SetData(WildNpc,%对象_Y%,NPCPoint[4]);
		Char.SetData(WildNpc,%对象_方向%,NPCPoint[5]);
		Char.SetData(WildNpc,%对象_原名%,NPCName);
		NLG.UpChar(WildNpc);
		Char.SetLoopEvent(nil, "Wild_LoopEvent", WildNpc, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/WildBoss.lua","Wild_WindowTalked",WildNpc)
		Char.SetTalkedEvent("lua/Module/WildBoss.lua","Wild_Talked", WildNpc);
	end
end
function Wild_LoopEvent(_MeIndex)
	--创建假人
	local DTime = os.time()
	if DTime - STime >= YS then
		local Posn = NLG.Rand(1,#Pos)
		local Image = Pos[Posn][2]
		local Name = Pos[Posn][1]
		if tbl_RandomNpcIndex[Name] == nil then	
			local NpcIndex = CreateWildNpc(Image, Name, 0, Pos[Posn][3], Pos[Posn][4], Pos[Posn][5], Pos[Posn][6])
			tbl_RandomNpcIndex[Name] = NpcIndex
			--NLG.SystemMessage(-1, "[系統]"..Name.."出現了，快去挑戰吧！")
		end
	end
end
--NPC对话事件(NPC索引)
function Wild_Talked(_NpcIndex, _PlayerIndex)
tbl_RandomNpcIndex = {}
end

--NPC窗口事件(NPC索引)
function Wild_WindowTalked ( _NpcIndex, _PlayerIndex, _seqno, _select, _data)
	
end
function CreateWildNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local NpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( NpcIndex, %对象_形象%, Image);
	Char.SetData( NpcIndex, %对象_原形%, Image);
	Char.SetData( NpcIndex, %对象_地图类型%, MapType);
	Char.SetData( NpcIndex, %对象_地图%, MapID);
	Char.SetData( NpcIndex, %对象_X%, PosX);
	Char.SetData( NpcIndex, %对象_Y%, PosY);
	Char.SetData( NpcIndex, %对象_方向%, Dir);
	Char.SetData( NpcIndex, %对象_原名%, Name);
	Char.SetData( NpcIndex, %对象_名色%, NameColor);
	tbl_LuaNpcIndex = tbl_LuaNpcIndex or {}
	tbl_LuaNpcIndex["WildNpc"] = NpcIndex
	Char.SetTalkedEvent(nil, "WildNpc__Talked", NpcIndex)
	Char.SetWindowTalkedEvent(nil, "WildNpc__WindowTalked", NpcIndex)
	Char.SetLoopEvent(nil, "WildNpc_LoopEvent", NpcIndex, math.random(15000,30000))
	NLG.UpChar(NpcIndex)
	return NpcIndex
end
function WildNpc_LoopEvent(_MeIndex)

end
function WildNpc__Talked(_NpcIndex, _PlayerIndex)
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
	local	token ="\n\n\n\n魔族最強大，人類一個都不留！？"

       NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, token)

end
function WildNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
	local tName = Char.GetData(_NpcIndex, %对象_原名%)
	--创建Boss战斗
	for i=1,#EnemySet do
		if (tName==Pos[i][1]) then
			Posn = i;
		end
	end
	local tBossLv = 1
--	local tWildBattleIndex = Battle.PVE( _PlayerIndex, tbl_LuaNpcIndex["WildNpc"], nil, tBossList, tLvList, nil)
	local tWildBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, EnemySet[Posn], BaseLevelSet[Posn], nil)
	Battle.SetWinEvent("./lua/Module/WildBoss.lua", "WildNpc_BattleWin", tWildBattleIndex);
	NLG.SystemMessage(-1, "傳說勇者 "..Char.GetData(_PlayerIndex,%对象_名字%).." 挑起了與 " .. tName.." 的戰鬥")
 end
end
function WildNpc_BattleWin(_BattleIndex, _NpcIndex)
		local tPlayerIndex = Battle.GetPlayIndex( _BattleIndex, 0)
		local EnemyIndex = Battle.GetPlayIndex( _BattleIndex, 10)
		if tPlayerIndex>=0 and Char.GetData(tPlayerIndex,%对象_类型%)==1 then
			NLG.SystemMessage(-1, "傳說勇者 "..Char.GetData(tPlayerIndex,%对象_名字%).." 率領隊友擊敗了入侵的魔族大軍");
			NL.DelNpc(_NpcIndex)
			local kk = table_n(_NpcIndex,0,'v',tbl_RandomNpcIndex)
			tbl_RandomNpcIndex[kk] = nil
		end
		Battle.UnsetWinEvent( _BattleIndex);
	--return 1
end
function Wild_main()

	Wild_Create()
end

function table_n(c1,c2,n,t)
	for key, value in pairs(t) do
		if c1 == value and n == 'v' then
			return key
		end
	end
end
