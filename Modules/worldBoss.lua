---ģ����
local Module = ModuleBase:createModule('worldBoss')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
EnemySet[1] = {0, 400073, 400073, 0, 0, 406190, 0, 0, 400072, 400072}--0����û�й�
BaseLevelSet[1] = {0, 300, 300, 0, 0, 300, 0, 0, 300, 300}
Pos[1] = {"�؁�ͳ�ľޙј���",EnemySet[1],BaseLevelSet[1]}
EnemySet[2] = {0, 400075, 400075, 0, 0, 406191, 0, 0, 400074, 400074}
BaseLevelSet[2] = {0, 300, 300, 0, 0, 300, 0, 0, 300, 300}
Pos[2] = {"�؁�ͳ��Һ�Bʷ��",EnemySet[2],BaseLevelSet[2]}
EnemySet[3] = {0, 0, 0, 0, 0, 0, 406192, 406192, 0, 0}
BaseLevelSet[3] = {0, 0, 0, 0, 0, 0, 300, 300, 0, 0}
Pos[3] = {"�؁�ͳ��ҹ�تz��",EnemySet[3],BaseLevelSet[3]}
EnemySet[4] = {406193, 0, 0, 0, 0, 0, 406193, 406193, 0, 0}
BaseLevelSet[4] = {300, 0, 0, 0, 0, 0, 300, 300, 0, 0}
Pos[4] = {"�؁�ͳ��ڤ��֮��",EnemySet[4],BaseLevelSet[4]}
EnemySet[5] = {406220, 0, 0, 0, 0, 0, 0, 0, 0, 0}
BaseLevelSet[5] = {300, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[5] = {"�؁�ͳ��ˮĸ����",EnemySet[5],BaseLevelSet[5]}
EnemySet[6] = {0, 0, 0, 0, 0, 0, 406226, 406206, 0, 0}
BaseLevelSet[6] = {0, 0, 0, 0, 0, 0, 300, 300, 0, 0}
Pos[6] = {"�؁�ͳ�ı��߰���",EnemySet[6],BaseLevelSet[6]}
EnemySet[7] = {0, 0, 0, 0, 0, 406233, 0, 0, 0, 0}
BaseLevelSet[7] = {0, 0, 0, 0, 0, 300, 0, 0, 0, 0}
Pos[7] = {"�؁�ͳ�����~����",EnemySet[7],BaseLevelSet[7]}
------------------------------------------------------
--��������
local Pts= 70206;                                    --��Ů��ƻ��
local WorldBoss = {
      { weekday=1, lordName="�ͳ�ޙј���", lordImage=104889 , waitingArea={map=777,X=36,Y=41}, onfieldArea={map=1000,X=218,Y=88},
        win={getItem=70257, getItem_count=1}, lose={getItem=70257, getItem_count=1}},
      { weekday=2, lordName="�ͳ�Һ�Bʷ��", lordImage=108206 , waitingArea={map=777,X=36,Y=43}, onfieldArea={map=1000,X=218,Y=88},
        win={getItem=70257, getItem_count=1}, lose={getItem=70257, getItem_count=1}},
      { weekday=3, lordName="�ͳ�ҹ�تz��", lordImage=108228 , waitingArea={map=777,X=36,Y=45}, onfieldArea={map=1000,X=218,Y=88},
        win={getItem=70257, getItem_count=1}, lose={getItem=70257, getItem_count=1}},
      { weekday=4, lordName="�ͳ�ڤ��֮��", lordImage=108205 , waitingArea={map=777,X=36,Y=47}, onfieldArea={map=1000,X=218,Y=88},
        win={getItem=70257, getItem_count=1}, lose={getItem=70257, getItem_count=1}},
      { weekday=5, lordName="�ͳ�ˮĸ����", lordImage=108127 , waitingArea={map=777,X=36,Y=49}, onfieldArea={map=1000,X=218,Y=88},
        win={getItem=70257, getItem_count=1}, lose={getItem=70257, getItem_count=1}},
      { weekday=6, lordName="�ͳ��߰���", lordImage=108179 , waitingArea={map=777,X=36,Y=51}, onfieldArea={map=1000,X=218,Y=88},
        win={getItem=70257, getItem_count=1}, lose={getItem=70257, getItem_count=1}},
      { weekday=7, lordName="�ͳ����~����", lordImage=108121 , waitingArea={map=777,X=36,Y=53}, onfieldArea={map=1000,X=218,Y=88},
        win={getItem=70257, getItem_count=1}, lose={getItem=70257, getItem_count=1}},
}
tbl_duel_user = {};			--��ǰ������ҵ��б�
tbl_win_user = {};
tbl_WorldBossNPCIndex = tbl_WorldBossNPCIndex or {}
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('LoopEvent', Func.bind(self.WorldBoss_LoopEvent,self))
    WorldBossNPC = self:NPC_createNormal('���珊��ӑ��', 110308, { map = 777, x = 36, y = 39, direction = 6, mapType = 0 })
    self:NPC_regWindowTalkedEvent(WorldBossNPC, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
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
               --�������
               local i;
               i = Char.GetData(player, CONST.����_����);
               if i >= 4 then 
                              i = i - 4;
               else
                              i = i + 4;		
                              end
               Char.SetData(player, CONST.����_����,i);
               NLG.UpChar(player);
               --����BOSS
	local json = Field.Get(player, 'WorldDate');
	local ret, WorldDate = nil, nil;
	if json then
		ret, WorldDate = pcall(JSON.decode, json)
	else
		return
	end
	if ret and #WorldDate > 0 then
		if WorldDate[bossDay][1]==os.date("%d",os.time()) then
			NLG.SystemMessage(player,"[ϵ�y]ÿ�ՃH���M��1��ӑ����");
			return;
		end

	else
		WorldDate = {};
		for i=1,7 do
			WorldDate[i]={"32",};
		end
	end
	local playerName = Char.GetData(player,CONST.CHAR_����);
	local partyname = playerName .. "���";
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
------------------------------------------------
-------��������
--ս��ǰȫ�ָ�
function Char.HealAll(player)
	Char.SetData(player,%����_Ѫ%, Char.GetData(player,%����_���Ѫ%));
	Char.SetData(player,%����_ħ%, Char.GetData(player,%����_���ħ%));
	Char.SetData(player, %����_����%, 0);
	Char.SetData(player, %����_����%, 0);
	NLG.UpdateParty(player);
	NLG.UpChar(player);
	for petSlot  = 0,4 do
		local petIndex = Char.GetPet(player,petSlot);
		if petIndex >= 0 then
			local maxLp = Char.GetData(petIndex, CONST.CHAR_���Ѫ);
			local maxFp = Char.GetData(petIndex, CONST.CHAR_���ħ);
			Char.SetData(petIndex, CONST.CHAR_Ѫ, maxLp);
			Char.SetData(petIndex, CONST.CHAR_ħ, maxFp);
			Char.SetData(petIndex, %����_����%, 0);
			Pet.UpPet(player, petIndex);
		end
	end
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
		local TeamPlayer = Char.GetPartyMember(player,Slot);
		if (TeamPlayer>0) then
			Char.SetData(TeamPlayer,%����_Ѫ%, Char.GetData(TeamPlayer,%����_���Ѫ%));
			Char.SetData(TeamPlayer,%����_ħ%, Char.GetData(TeamPlayer,%����_���ħ%));
			Char.SetData(TeamPlayer, %����_����%, 0);
			Char.SetData(TeamPlayer, %����_����%, 0);
			NLG.UpdateParty(TeamPlayer);
			NLG.UpChar(TeamPlayer);
			for petSlot  = 0,4 do
				local petIndex = Char.GetPet(TeamPlayer,petSlot);
				if petIndex >= 0 then
					local maxLp = Char.GetData(petIndex, CONST.CHAR_���Ѫ);
					local maxFp = Char.GetData(petIndex, CONST.CHAR_���ħ);
					Char.SetData(petIndex, CONST.CHAR_Ѫ, maxLp);
					Char.SetData(petIndex, CONST.CHAR_ħ, maxFp);
					Char.SetData(petIndex, %����_����%, 0);
					Pet.UpPet(TeamPlayer, petIndex);
				end
			end
		end
		end
	end
end

--ָ������ѭ��
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr worldboss start]") then
		local cdk = Char.GetData(charIndex,CONST.����_CDK);
		if (cdk == "123456") then
			Char.SetLoopEvent('./lua/Modules/worldBoss.lua','WorldBoss_LoopEvent',charIndex,10000);
			NLG.SystemMessage(charIndex, "[ϵ�y]���繲�Y���_ʼ��");
			NLG.UpChar(charIndex);
			return 0;
		end
	end
	return 1;
end
--����ÿ��������
function WorldBoss_LoopEvent(npc)

end

function boss_round_start(player, callback)

	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--��ʼս��
	tbl_UpIndex = {}
	battleindex = {}

	local bossDay = tonumber(os.date("%w",os.time()))
	if (bossDay==0) then bossDay=7; end
	for k,v in pairs(WorldBoss) do
		if ( bossDay==v.weekday ) then
			Char.HealAll(player);
			local battleindex = Battle.PVE( player, player, nil, Pos[bossDay][2], Pos[bossDay][3], nil)
			Battle.SetWinEvent("./lua/Modules/worldBoss.lua", "boss_round_callback", battleindex);
		end
	end
end

function boss_round_callback(battleindex, player)

	local winside = Battle.GetWinSide(battleindex);
	local sideM = 0;

	--��ȡʤ����
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end
	--��ȡʤ���������ָ�룬����վ��ǰ���ͺ�
	local w1 = Battle.GetPlayIndex(battleindex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleindex, 5 + sideM);
	local ww = nil;

	--��ʤ����Ҽ����б�
	tbl_win_user = {}
	if ( Char.GetData(w1, %����_����%) >= %��������_��% ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, %����_����%) >= %��������_��% ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	local player = tbl_win_user[1];
end


--������������
function Module:OnbattleStartEventCallback(battleIndex)
	local ret = SQL.Run("select Name,WorldLord1 from lua_hook_worldboss order by WorldLord1 asc limit 3");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP1=tonumber(ret["0_1"]);
	end
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP1;
		if enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406190  then
			Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
		end
	end
end
function Module:OnBeforeBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local ret = SQL.Run("select Name,WorldLord1 from lua_hook_worldboss order by WorldLord1 asc limit 3");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP1=tonumber(ret["0_1"]);
	end
	--print(LordHP1)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP1;
		if Round==0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406190  then
			Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
		elseif Round>0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406190  then
			Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
			if Round>=5 then
				Char.SetData(enemy, CONST.CHAR_������, 10000);
				Char.SetData(enemy, CONST.CHAR_����, 10000);
				Char.SetData(enemy, CONST.CHAR_����, 100);
				Char.SetData(enemy, CONST.CHAR_����, 100);
				Char.SetData(enemy, CONST.CHAR_����, 70);
			end
			if Round>=4 and Round<=8 then
				Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,114260);
			elseif Round>=9 then
				Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,114261);
			end
		end
	end
end
function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.CHAR_����) == CONST.��������_�� then
		player = leader0
	else
		player = leaderpet
	end
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406190  then
                                                            local HP = Char.GetData(enemy,CONST.CHAR_Ѫ);
			Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
			NLG.SystemMessage(player,"[ϵ�y]�^���I��Ŀǰʣ�NѪ��"..HP.."��");
			NLG.UpChar(enemy);
			--LordѪ��д���
			local cdk = Char.GetData(player,CONST.����_CDK) or nil;
			if (cdk~=nil) then
				SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE CdKey='"..cdk.."')");
				SQL.Run("update lua_hook_worldboss set WorldLord1= '"..HP.."' where CdKey='"..cdk.."'")
				NLG.UpChar(player);
			end
		end
	end
end
--����ģʽ����ʩ��
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
            local enemy = Battle.GetPlayer(battleIndex, i);
            if Round>=5 and Round<=9 and enemy>= 0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406190  then
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8609);
            elseif Round>=10 and enemy>= 0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406190  then
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8659);
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

--[[
    for k,v in pairs(WorldBoss) do
        if tbl_WorldBossNPCIndex[k] == nil then
            local WorldBossNPC = self:NPC_createNormal(v.lordName, v.lordImage, { map = v.waitingArea.map, x = v.waitingArea.X, y = v.waitingArea.Y, direction = 6, mapType = 0 })
            tbl_WorldBossNPCIndex[k] = WorldBossNPC
	self:NPC_regWindowTalkedEvent(tbl_WorldBossNPCIndex[k], function(npc, player, _seqno, _select, _data)
		local cdk = Char.GetData(player,CONST.����_CDK);
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
			--�������
			local i;
			i = Char.GetData(player, CONST.����_����);
			if i >= 4 then 
				i = i - 4;
			else
				i = i + 4;		
			end
			Char.SetData(player, CONST.����_����,i);
			NLG.UpChar(player);
			--����BOSS
			local json = Field.Get(player, 'WorldDate');
			local ret, WorldDate = nil, nil;
			if json then
				ret, WorldDate = pcall(JSON.decode, json)
			else
				return
			end
			if ret and #WorldDate > 0 then
				if WorldDate[bossDay][1]==os.date("%d",os.time()) then
					NLG.SystemMessage(player,"[ϵ�y]ÿ�ՃH���M��1��ӑ����");
					return;
				end

			else
				WorldDate = {};
				for i=1,7 do
					WorldDate[i]={"32",};
				end
			end
			local playerName = Char.GetData(player,CONST.CHAR_����);
			local partyname = playerName .. "���";
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
--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;