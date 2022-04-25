local NPCName = "����"
local NPCPoint = {106277,777,10,10,6}
local EnemySet = {}
local BaseLevelSet = {}
local STime = os.time()
local YS = 30 --�ű���ʱ�����봴��NPC
local SXTime = 15 --NPCˢ��ʱ�䡤��
--���н���
--     ��	��	һ	��	��
--     ʮ	��	��	��	��
EnemySet[1] = {360092, 0, 0, 0, 0, 360071, 360017, 360018, 0, 0}--0����û�й�
EnemySet[2] = {360093, 0, 0, 0, 0, 360082, 360017, 360018, 0, 0}
EnemySet[3] = {360106, 360071, 360082, 360031, 360032, 0, 360033, 360034, 0, 0}
BaseLevelSet[1] = {89, 0, 0, 0, 0, 69, 40, 40, 0, 0}
BaseLevelSet[2] = {89, 0, 0, 0, 0, 77, 40, 40, 0, 0}
BaseLevelSet[3] = {89, 69, 77, 57, 57, 0, 57, 57, 0, 0}
------------���NPC����
local Pos = {{"ħ��С��",101800,1000,242,86,4},{"ħ�����",101801,1000,242,90,0},{"ħ����",117024,1000,244,88,2}}--���ֲ���һ��
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
		Char.SetData(WildNpc,%����_����%,NPCPoint[1]);
		Char.SetData(WildNpc,%����_ԭ��%,NPCPoint[1]);
		Char.SetData(WildNpc,%����_��ͼ%,NPCPoint[2]);
		Char.SetData(WildNpc,%����_X%,NPCPoint[3]);
		Char.SetData(WildNpc,%����_Y%,NPCPoint[4]);
		Char.SetData(WildNpc,%����_����%,NPCPoint[5]);
		Char.SetData(WildNpc,%����_ԭ��%,NPCName);
		NLG.UpChar(WildNpc);
		Char.SetLoopEvent(nil, "Wild_LoopEvent", WildNpc, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/WildBoss.lua","Wild_WindowTalked",WildNpc)
		Char.SetTalkedEvent("lua/Module/WildBoss.lua","Wild_Talked", WildNpc);
	end
end
function Wild_LoopEvent(_MeIndex)
	--��������
	local DTime = os.time()
	if DTime - STime >= YS then
		local Posn = NLG.Rand(1,#Pos)
		local Image = Pos[Posn][2]
		local Name = Pos[Posn][1]
		if tbl_RandomNpcIndex[Name] == nil then	
			local NpcIndex = CreateWildNpc(Image, Name, 0, Pos[Posn][3], Pos[Posn][4], Pos[Posn][5], Pos[Posn][6])
			tbl_RandomNpcIndex[Name] = NpcIndex
			NLG.SystemMessage(-1, "[ϵͳ]"..Name.."�����ˣ���ȥ��ս�ɣ�")
		end
	end
end
--NPC�Ի��¼�(NPC����)
function Wild_Talked(_NpcIndex, _PlayerIndex)
tbl_RandomNpcIndex = {}
end

--NPC�����¼�(NPC����)
function Wild_WindowTalked ( _NpcIndex, _PlayerIndex, _seqno, _select, _data)
	
end
function CreateWildNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local NpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( NpcIndex, %����_����%, Image);
	Char.SetData( NpcIndex, %����_ԭ��%, Image);
	Char.SetData( NpcIndex, %����_��ͼ����%, MapType);
	Char.SetData( NpcIndex, %����_��ͼ%, MapID);
	Char.SetData( NpcIndex, %����_X%, PosX);
	Char.SetData( NpcIndex, %����_Y%, PosY);
	Char.SetData( NpcIndex, %����_����%, Dir);
	Char.SetData( NpcIndex, %����_ԭ��%, Name);
	Char.SetData( NpcIndex, %����_��ɫ%, NameColor);
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
	local mz = "��"..Char.GetData(_PlayerIndex,%����_����%).. "��"
	local	token ="\n\n\n\nħ����ǿ������һ������������"

       NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, token)

end
function WildNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
	local tName = Char.GetData(_NpcIndex, %����_ԭ��%)
	--����Bossս��
	local RandN = NLG.Rand(1,#EnemySet)
	local tBossLv = 1
--	local tWildBattleIndex = Battle.PVE( _PlayerIndex, tbl_LuaNpcIndex["WildNpc"], nil, tBossList, tLvList, nil)
	local tWildBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, EnemySet[RandN], BaseLevelSet[RandN], nil)
	Battle.SetWinEvent( nil, "WildNpc_BattleWin", tWildBattleIndex);
	NLG.SystemMessage(-1, Char.GetData(_PlayerIndex,%����_����%).."������ս" .. tName)
 end
end
function WildNpc_BattleWin(_BattleIndex, _NpcIndex)
		local tPlayerIndex = Battle.GetPlayIndex( _BattleIndex, 0)
		if tPlayerIndex>=0 and Char.GetData(tPlayerIndex,%����_����%)==1 then
			NLG.SystemMessage(-1, "[ϵͳ]"..Char.GetData(tPlayerIndex,%����_����%).."������ѻ�����"..Char.GetData(_NpcIndex, %����_ԭ��%))
			NL.DelNpc(_NpcIndex)
			local kk = table_n(_NpcIndex,0,'v',tbl_RandomNpcIndex)
			tbl_RandomNpcIndex[kk] = nil
		end
	return 1
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