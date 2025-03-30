---ģ����
local Module = ModuleBase:createModule('legendBoss')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
EnemySet[1] = {606029, 606028, 606028, 606028, 606028, 606028, 606028, 606028, 606028, 606028}--0����û�й�
BaseLevelSet[1] = {199, 180, 180, 180, 180, 180, 180, 180, 180, 180}
Pos[1] = {"�����B",EnemySet[1],BaseLevelSet[1]}
EnemySet[2] = {606032, 606031, 606031, 606031, 606031, 606031, 606031, 606031, 606031, 606031}--0����û�й�
BaseLevelSet[2] = {199, 180, 180, 180, 180, 180, 180, 180, 180, 180}
Pos[2] = {"�W��B",EnemySet[2],BaseLevelSet[2]}
EnemySet[3] = {606035, 606034, 606034, 606034, 606034, 606034, 606034, 606034, 606034, 606034}--0����û�й�
BaseLevelSet[3] = {199, 180, 180, 180, 180, 180, 180, 180, 180, 180}
Pos[3] = {"�׵�",EnemySet[3],BaseLevelSet[3]}
EnemySet[4] = {606067, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[4] = {199, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[4] = {"���恆",EnemySet[4],BaseLevelSet[4]}
EnemySet[5] = {606068, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[5] = {199, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[5] = {"�P��",EnemySet[5],BaseLevelSet[5]}
EnemySet[6] = {0, 0, 606073, 0, 0, 606070, 0, 0, 606071, 606072}--0����û�й�
BaseLevelSet[6] = {0, 0, 199, 0, 0, 120, 0, 0, 120, 120}
Pos[6] = {"�b�׳���",EnemySet[6],BaseLevelSet[6]}
------------------------------------------------------
--��������
local Pts= 70206;                                    --��Ů��ƻ��
local LegendBoss = {
      { lordNum=1, timesec=3600, soul=1000, lordName="�����B", startImage=119736, transImage = 119736, waitingArea={map=777,X=38,Y=41}, warpArea={map=20244,X=96,Y=129},
        rewardsItem={47558}, rewardsItem_count=1, prizeItem={70206}, prizeItem_count=3},
      { lordNum=2, timesec=3600, soul=1000, lordName="�W��B", startImage=119737, transImage = 119737, waitingArea={map=777,X=38,Y=43}, warpArea={map=20242,X=12,Y=14},
        rewardsItem={47558}, rewardsItem_count=1, prizeItem={70206}, prizeItem_count=3},
      { lordNum=3, timesec=3600, soul=1000, lordName="�׵�", startImage=119735, transImage = 119735, waitingArea={map=777,X=38,Y=45}, warpArea={map=20249,X=50,Y=41},
        rewardsItem={47558}, rewardsItem_count=1, prizeItem={70206}, prizeItem_count=3},
      { lordNum=4, timesec=3600, soul=1000, lordName="���恆", startImage=119742, transImage = 119742, waitingArea={map=777,X=38,Y=47}, warpArea={map=7400,X=9,Y=9},
        rewardsItem={47558}, rewardsItem_count=1, prizeItem={70206}, prizeItem_count=3},
      { lordNum=5, timesec=3600, soul=1000, lordName="�P��", startImage=119743, transImage = 119743, waitingArea={map=777,X=38,Y=49}, warpArea={map=7400,X=11,Y=26},
        rewardsItem={47558}, rewardsItem_count=1, prizeItem={70206}, prizeItem_count=3},
      { lordNum=6, timesec=3600, soul=1000, lordName="�b�׳���", startImage=119739, transImage = 119740, waitingArea={map=20247,X=11,Y=151}, warpArea={map=20248,X=72,Y=86},
        rewardsItem={47558}, rewardsItem_count=1, prizeItem={70206}, prizeItem_count=3},
}
local tbl_duel_user = {};			--��ǰ������ҵ��б�
local tbl_win_user = {};
local LegendInfo = {}				--��ȴʱ���
local LegendSetting = {}
local LegendCD = {}
local legendBossBattle = {}
tbl_LegendBossNPCIndex = tbl_LegendBossNPCIndex or {}
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  --self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('BeforeBattleTurnStartEvent', Func.bind(self.OnBeforeBattleTurnStartCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleDodgeRateEvent', Func.bind(self.OnBattleDodgeRateEvent, self))
  --self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('LoopEvent', Func.bind(self.LegendBoss_LoopEvent,self))
  for k,v in pairs(LegendBoss) do
   if tbl_LegendBossNPCIndex[k] == nil then
    local LegendBossNPC = self:NPC_createNormal(v.lordName, v.startImage, { map = v.waitingArea.map, x = v.waitingArea.X, y = v.waitingArea.Y, direction = 5, mapType = 0 })
    tbl_LegendBossNPCIndex[k] = LegendBossNPC
    self:NPC_regWindowTalkedEvent(tbl_LegendBossNPCIndex[k], function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
    end)
    self:NPC_regTalkedEvent(tbl_LegendBossNPCIndex[k], function(npc, player)
      if(NLG.CheckInFront(player, npc, 1)==false) then
          return ;
      end
      if (NLG.CanTalk(npc, player) == true) then
               --�������
               local i;
               i = Char.GetData(player, CONST.����_����);
               if i >= 4 then 
                              i = i - 4;
               else
                              i = i + 4;		
               end
               Char.SetData(npc, CONST.����_����,i);
               NLG.UpChar(npc);
               --���fBOSS
	local playerName = Char.GetData(player,CONST.CHAR_����);
	local partyname = playerName .. "���";
	local playerLv = Char.GetData(player,CONST.CHAR_�ȼ�);
	if playerLv<=100 then
		NLG.SystemMessage(player,"[ϵ�y]ӑ�����h��L�ȼ�Ҫ100����");
		return;
	end

	--local Target_X = Char.GetData(npc, CONST.CHAR_X)  --��ͼx
	--local Target_Y = Char.GetData(npc, CONST.CHAR_Y)  --��ͼy
	local bossImage = Char.GetData(npc,CONST.����_����);
	for k,v in pairs(LegendBoss) do
		if ( k==v.lordNum and bossImage==v.startImage ) then
			table.insert(tbl_duel_user,player);
			table.insert(tbl_duel_user,npc);
			boss_round_start(player, npc, boss_round_callback);

			--Char.DelItem(player, v.keyItem, 1);
                                                            --local slot = Char.FindItemId(player, v.keyItem);
                                                            --local item_indexA = Char.GetItemIndex(player,slot);
			--�μӽ���
			--local rand = NLG.Rand(1,#v.prizeItem);
			--Char.GiveItem(player, v.prizeItem[rand], v.prizeItem_count);
			--local PartyNum = Char.PartyNum(player);
			--if (PartyNum>1) then
			--	for Slot=1,4 do
			--		local TeamPlayer = Char.GetPartyMember(player,Slot);
			--		if Char.IsDummy(TeamPlayer)==false then
			--			local rand = NLG.Rand(1,#v.prizeItem);
			--			Char.GiveItem(TeamPlayer, v.prizeItem[rand], v.prizeItem_count);
			--		end
			--	end
			--end
		end
	end
      end
      return
    end)
   end
  end

  LegendMonitorNPC = self:NPC_createNormal('���f�O��', 14682, { map = 777, x = 40, y = 31,  direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(LegendMonitorNPC, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(LegendMonitorNPC, function(npc, player)
	local gmIndex = NLG.FindUser(123456);
	local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")["0_0"])
	local LegendCD = {};
	if (type(sqldata)=="string" and sqldata~='') then
		LegendCD = JSON.decode(sqldata);
	else
		LegendCD = {};
	end

	winMsg = "\\n            ���������f���ɉ��YӍ�������"
		.. "\\n\\n  ���ɉ���          ����λ��             ��s����\\n"
		.. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
		for k,v in pairs(LegendBoss) do
			local bossImage = tonumber(LegendCD[k]);
			if (k==v.lordNum and bossImage==v.startImage) then
				local Name = v.lordName;
				local mapsname = "�[�ؿ��g";
				local mapsX = "xxx";
				local mapsY = "yyy";
				if (k==6) then mapsname = NLG.GetMapName(0, v.waitingArea.map); mapsX = v.waitingArea.X; mapsY = v.waitingArea.Y; end
				local CTime = LegendInfo[k] or os.time();
				local CDTime = ""..v.timesec - (os.time() - CTime).." ��";
				winMsg = winMsg .. "\\n  "..Name.."        "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
			elseif (k==v.lordNum and bossImage==0) then
				local Name = v.lordName;
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				local mapsX = v.warpArea.X;
				local mapsY = v.warpArea.Y;
				local CDTime = "�����";
				winMsg = winMsg .. "\\n  "..Name.."        "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
			end
		end
		winMsg = winMsg .. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T";
	NLG.ShowWindowTalked(player,npc, CONST.����_����Ϣ��, CONST.��ť_�ر�, 1, winMsg);
        return
  end)

end
------------------------------------------------
-------��������
--ָ������ѭ��
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr legend on]") then
		local cdk = Char.GetData(charIndex,CONST.����_CDK);
		if (cdk == "123456") then
			--����
			LegendInfo = {};
			LegendSetting = {};
			for k=1,6 do
				--print(tbl_LegendBossNPCIndex[k])
				Char.SetLoopEvent('./lua/Modules/legendBoss.lua','LegendBoss_LoopEvent',tbl_LegendBossNPCIndex[k],1000);
				LegendInfo[k] = os.time();
				LegendSetting[k] = nil;
				LegendCD[k] = 0;
			end
			NLG.SystemMessage(charIndex, "[ϵ�y]���f���ɉ��_�š�");
			NLG.UpChar(charIndex);

			local gmIndex = NLG.FindUser(123456);
			Char.SetExtData(charIndex, '��˵��ȴ_set', JSON.encode(LegendCD));
			local newdata = JSON.encode(LegendCD);
			SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")
			NLG.UpChar(gmIndex);
			return 0;
		end
	elseif (msg=="/legend" or msg=="/leg") then
		local gmIndex = NLG.FindUser(123456);
		local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")["0_0"])
		local LegendCD = {};
		if (type(sqldata)=="string" and sqldata~='') then
			LegendCD = JSON.decode(sqldata);
		else
			LegendCD = {};
		end

		winMsg = "\\n            ���������f���ɉ��YӍ�������"
			.. "\\n\\n  ���ɉ���          ����λ��             ��s����\\n"
			.. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
			for k,v in pairs(LegendBoss) do
				local bossImage = tonumber(LegendCD[k]);
				if (k==v.lordNum and bossImage==v.startImage) then
					local Name = v.lordName;
					local mapsname = "�[�ؿ��g";
					local mapsX = "xxx";
					local mapsY = "yyy";
					if (k==6) then mapsname = NLG.GetMapName(0, v.waitingArea.map); mapsX = v.waitingArea.X; mapsY = v.waitingArea.Y; end
					local CTime = LegendInfo[k] or os.time();
					local CDTime = ""..v.timesec - (os.time() - CTime).." ��";
					winMsg = winMsg .. "\\n  "..Name.."        "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
				elseif (k==v.lordNum and bossImage==0) then
					local Name = v.lordName;
					local mapsname = NLG.GetMapName(0, v.warpArea.map);
					local mapsX = v.warpArea.X;
					local mapsY = v.warpArea.Y;
					local CDTime = "�����";
					winMsg = winMsg .. "\\n  "..Name.."        "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
				end
			end
			winMsg = winMsg .. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T";
		NLG.ShowWindowTalked(charIndex, LegendMonitorNPC, CONST.����_����Ϣ��, CONST.��ť_�ر�, 1, winMsg);
		return 0;
	end
	return 1;
end
--ת��
function LegendBoss_LoopEvent(npc)
	local gmIndex = NLG.FindUser(123456);
	local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")["0_0"])
	local LegendCD = {};
	if (type(sqldata)=="string" and sqldata~='') then
		LegendCD = JSON.decode(sqldata);
	else
		LegendCD = {};
	end

	if (os.date("%X",os.time())=="00:00:01") then
		for k,v in pairs(LegendBoss) do
			local mapsname = NLG.GetMapName(0, v.warpArea.map);
			local bossImage = Char.GetData(npc,CONST.����_����);
			if ( k==v.lordNum and bossImage==v.startImage ) then
				LegendInfo[k] = os.time();
				LegendSetting[k] = 1;
				NLG.SystemMessage(-1,"[ϵ�y]"..v.lordName.."���F��"..mapsname.."("..v.warpArea.X..","..v.warpArea.Y..")");
				Char.SetData(npc,CONST.����_X, v.warpArea.X);
				Char.SetData(npc,CONST.����_Y, v.warpArea.Y);
				Char.SetData(npc,CONST.����_��ͼ, v.warpArea.map);
				NLG.UpChar(npc);

				LegendCD[k] = 0;
				--local newdata = JSON.encode(LegendCD);
				--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")
				--NLG.UpChar(gmIndex);
			end
		end
		local newdata = JSON.encode(LegendCD);
		--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")
		SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")
		NLG.UpChar(gmIndex);
	elseif (os.date("%X",os.time())=="23:59:59")  then
		for k,v in pairs(LegendBoss) do
			local bossImage = Char.GetData(npc,CONST.����_����);
			if ( k==v.lordNum and bossImage==v.startImage ) then
				Char.SetData(npc,CONST.����_X, v.waitingArea.X);
				Char.SetData(npc,CONST.����_Y, v.waitingArea.Y);
				Char.SetData(npc,CONST.����_��ͼ, v.waitingArea.map);
				NLG.UpChar(npc);
			end
		end
	else
		for k,v in pairs(LegendBoss) do
			if (LegendSetting[k]==nil) then
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				local bossImage = Char.GetData(npc,CONST.����_����);
				if ( k==v.lordNum and bossImage==v.startImage) then
					LegendInfo[k] = os.time();
					LegendSetting[k] = 1;
					NLG.SystemMessage(-1,"[ϵ�y]"..v.lordName.."���F��"..mapsname.."("..v.warpArea.X..","..v.warpArea.Y..")");
					Char.SetData(npc,CONST.����_X, v.warpArea.X);
					Char.SetData(npc,CONST.����_Y, v.warpArea.Y);
					Char.SetData(npc,CONST.����_��ͼ, v.warpArea.map);
					NLG.UpChar(npc);
				end
			elseif (LegendSetting[k]==1) then
				LegendInfo[k] = os.time()
			elseif (LegendSetting[k]==2) then
				local STime = os.time()
				local timec = STime - LegendInfo[k];
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				local bossImage = Char.GetData(npc,CONST.����_����);
				if ( timec > v.timesec and k==v.lordNum and bossImage==v.startImage) then
					LegendInfo[k] = os.time();
					LegendSetting[k] = 1;
					NLG.SystemMessage(-1,"[ϵ�y]"..v.lordName.."���F��"..mapsname.."("..v.warpArea.X..","..v.warpArea.Y..")");
					Char.SetData(npc,CONST.����_X, v.warpArea.X);
					Char.SetData(npc,CONST.����_Y, v.warpArea.Y);
					Char.SetData(npc,CONST.����_��ͼ, v.warpArea.map);
					NLG.UpChar(npc);

					LegendCD[k] = 0;
					--local newdata = JSON.encode(LegendCD);
					--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")
					--NLG.UpChar(gmIndex);
				end
			end
		end
		local newdata = JSON.encode(LegendCD);
		--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")
		SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")
		NLG.UpChar(gmIndex);
	end
end

function boss_round_start(player, npc, callback)

	--local npc = tbl_duel_user[2];
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);
	table.insert(tbl_duel_user,npc);

	--��ʼս��
	tbl_UpIndex = {}
	battleindex = {}

	for k,v in pairs(LegendBoss) do
		local bossImage = Char.GetData(npc,CONST.����_����);
		if ( k==v.lordNum and bossImage==v.startImage ) then
			local battleindex = Battle.PVE( player, player, nil, Pos[k][2], Pos[k][3], nil)
			Battle.SetWinEvent("./lua/Modules/legendBoss.lua", "boss_round_callback", battleindex);
			legendBossBattle={}
			table.insert(legendBossBattle, battleindex);
			Char.SetTempData(player, '��˵', npc);
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
	--local npc = tbl_duel_user[2];

	--�ж����ĸ���˵������
	local npc = Char.GetTempData(player, '��˵') or 0;
	--print(npc)

	for k,v in pairs(LegendBoss) do
		local bossImage = Char.GetData(npc,CONST.����_����);
		if ( k==v.lordNum and bossImage==v.startImage ) then
			--local slot = Char.FindItemId(player, v.keyItem);
			--local item_indexA = Char.GetItemIndex(player,slot);
			local rand = NLG.Rand(1,#v.rewardsItem);
			Char.GiveItem(player, v.rewardsItem[rand], v.rewardsItem_count);
			Char.SetData(player,CONST.CHAR_�˺���, Char.GetData(player,CONST.CHAR_�˺���)+v.soul);
			NLG.SystemMessage(-1,"[����] "..v.lordName.."�� "..Char.GetData(player,CONST.����_����).." ӑ���ˡ�");
			NLG.UpChar(player);
		end
	end
	--���ѽ���
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
			local TeamPlayer = Char.GetPartyMember(player,Slot);
			if Char.IsDummy(TeamPlayer)==false then
				for k,v in pairs(LegendBoss) do
					local bossImage = Char.GetData(npc,CONST.����_����);
					if ( k==v.lordNum and bossImage==v.startImage ) then
						local rand = NLG.Rand(1,#v.rewardsItem);
						Char.GiveItem(TeamPlayer, v.rewardsItem[rand], v.rewardsItem_count);
						Char.SetData(TeamPlayer,CONST.CHAR_�˺���, Char.GetData(TeamPlayer,CONST.CHAR_�˺���)+v.soul);
						NLG.UpChar(TeamPlayer);
					end
				end
			end
		end
	end
	--������ȴʱ��
	local gmIndex = NLG.FindUser(123456);
	local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")["0_0"])
	local LegendCD = {};
	if (type(sqldata)=="string" and sqldata~='') then
		LegendCD = JSON.decode(sqldata);
	else
		LegendCD = {};
	end
	for k,v in pairs(LegendBoss) do
		local bossImage = Char.GetData(npc,CONST.����_����);
		if ( k==v.lordNum and bossImage==v.startImage ) then
			LegendInfo[k] = os.time();
			LegendSetting[k] = 2;
			Char.SetData(npc,CONST.����_X, v.waitingArea.X);
			Char.SetData(npc,CONST.����_Y, v.waitingArea.Y);
			Char.SetData(npc,CONST.����_��ͼ, v.waitingArea.map);
			NLG.UpChar(npc);

			LegendCD[k] = bossImage;
			local newdata = JSON.encode(LegendCD);
			SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��˵��ȴ_set'")
			NLG.UpChar(gmIndex);
		end
	end
	Battle.UnsetWinEvent(battleindex);
	legendBossBattle ={};
	Char.SetTempData(player, '��˵',0);
end

--��������
function Module:OnbattleStartEventCallback(battleIndex)

	local playerCount = #NLG.GetPlayer();
	table.forEach(legendBossBattle, function(e)
		if  e==battleIndex  then
			--NLG.SystemMessage(-1,"[ϵ�y]���f���ɉ�Ѫ��������.������"..playerCount.."�����x5�f��Ѫ����");
		end
	end)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = playerCount * 50000;
		table.forEach(legendBossBattle, function(e)
			if enemy>=0 and e==battleIndex  then
				if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==606073) then
					--Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
					Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
					NLG.SystemMessage(-1,"[ϵ�y]���f���ɉ�Ѫ����������");
				end
			end
		end)
	end
end
function Module:OnBeforeBattleTurnStartCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local playerCount = #NLG.GetPlayer() or 1;
	local HP = playerCount * 50000;
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		table.forEach(legendBossBattle, function(e)
		if Round==0 and enemy>=0 and e==battleIndex  then
			if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==606073) then
				--Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
				Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
			end
		elseif Round>0 and enemy>=0 and e==battleIndex  then
			if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==606073) then
				local Hp_10 = Char.GetData(enemy, CONST.CHAR_���Ѫ); 
				local Hp_8 = Char.GetData(enemy, CONST.CHAR_Ѫ);
				local Hp08 = Hp_8/Hp_10;

				--Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
				Char.SetData(enemy, CONST.CHAR_Ѫ, Hp_8);
				if Hp08<=0.8 then
					for k,v in pairs(LegendBoss) do
						if ( k==v.lordNum and Char.GetData(enemy, CONST.CHAR_����)==v.startImage ) then
							Char.SetData(enemy, CONST.CHAR_����, v.transImage);
							--Char.SetData(enemy, CONST.CHAR_����, v.transImage);
							--Char.SetData(enemy, CONST.CHAR_ԭ��, v.transImage);
							--Char.SetData(enemy, CONST.CHAR_ԭʼͼ��, v.transImage);
							NLG.UpChar(enemy);
						end
					end
					Char.SetData(enemy, CONST.CHAR_������, 10000);
					Char.SetData(enemy, CONST.CHAR_������, 666);
					Char.SetData(enemy, CONST.CHAR_����, 666);
					Char.SetData(enemy, CONST.CHAR_����, 10000);
					Char.SetData(enemy, CONST.CHAR_�ظ�, 66);
					Char.SetData(enemy, CONST.CHAR_��ɱ, 70);
					Char.SetData(enemy, CONST.CHAR_����, 70);
					Char.SetData(enemy, CONST.CHAR_����, 70);
					Char.SetData(enemy, CONST.CHAR_����, 70);
					--Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,108511);
				end
			end
		end
		--NLG.SystemMessage(-1,"[ϵ�y]���f���ɉ�Ѫ����������");
		end)
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
		table.forEach(legendBossBattle, function(e)
		if Round>=0 and enemy>=0 and e==battleIndex  then
			if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==606073) then
				local HP = Char.GetData(enemy,CONST.CHAR_Ѫ);
				--Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
				Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
				NLG.UpChar(enemy);
			end
		end
		end)
	end
end
--����ģʽ����ʩ��
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
         local enemy = Battle.GetPlayer(battleIndex, i);
         if enemy>= 0 then
            if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==606073) then
                table.forEach(legendBossBattle, function(e)
                if Round==5 and e==battleIndex  then
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8607);
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 0, 350);
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, 40, 2109);
                elseif Round==10 and e==battleIndex  then
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8609);
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 0, 358);
                elseif Round>=15 and e==battleIndex  then
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8659);
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 0, 359);
                end
                end)
            end
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

function Module:OnBattleDodgeRateEvent(battleIndex, aIndex, fIndex, rate)
         --self:logDebug('OnBattleDodgeRateCallBack', battleIndex, aIndex, fIndex, rate)
         if Char.IsPlayer(fIndex) and Char.IsEnemy(aIndex) then
               local battleIndex = Char.GetBattleIndex(aIndex);
               local Round = Battle.GetTurn(battleIndex);
               if (Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==606073) then
                   if (Round==5 or Round==10 or Round>=15)  then
                       rate = 0;
                       return rate
                   end
               end
         end
         return rate
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local Round = Battle.GetTurn(battleIndex);
      if Char.IsEnemy(charIndex) and Char.IsPlayer(defCharIndex) then
        if (Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==606073) then
          if (math.fmod(Round, 3)==0 and math.random(1, 100)>=85) then
              local slot = Char.GetEmptyItemSlot(defCharIndex);
              local itemIndex, wslot = Char.GetWeapon(defCharIndex);
              if itemIndex >= 0 then
                  NLG.SystemMessage(defCharIndex,"[ϵ�y]"..Char.GetData(defCharIndex, CONST.CHAR_����).."������ж���ˣ�");
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
        end
        return damage;

      elseif Char.IsEnemy(defCharIndex) and Char.IsPlayer(charIndex) then
        local enemyId = Char.GetData(defCharIndex, CONST.����_ENEMY_ID);
        --print(enemyId)
        if (enemyId==606070 or enemyId==606071 or enemyId==606072 or enemyId==606073) then
            if flg == CONST.DamageFlags.Combo  then
                Char.GiveItem(charIndex, 66668, 1);
                NLG.SortItem(charIndex);

            end
        end
        return damage;
      end
  return damage;
end

function CheckIP(player)
	local teamplayers = Char.PartyNum(player);	--��ȡ��������
	local p1 = NLG.GetIp(Char.GetPartyMember(player,0));	--��ȡ���1��ip
	local p2 = NLG.GetIp(Char.GetPartyMember(player,1));	--��ȡ���2��ip
	local p3 = NLG.GetIp(Char.GetPartyMember(player,2));	--��ȡ���3��ip
	local p4 = NLG.GetIp(Char.GetPartyMember(player,3));	--��ȡ���4��ip
	local p5 = NLG.GetIp(Char.GetPartyMember(player,4));	--��ȡ���5��ip
	print("������Աip��ʾ���£�"..p1,p2,p3,p4,p5.."")	--cgmsv.exe���ڽ�������Ϣ
	if p1 == -2 then--�޶���
		return 400
	elseif p2 == -2 then
		p2 = 2;	--p2������ʱ������һ����ͬ����
	elseif p3 == -2 then
		p3 = 3;	--p3������ʱ������һ����ͬ����
	elseif p4 == -2 then
		p4 = 4;	--p4������ʱ������һ����ͬ����
	elseif p5 == -2 then
		p5 = 5;	--p5������ʱ������һ����ͬ����
	end
	if (teamplayers==5) then
		if p1 == p2 and p1 == p3 and p1 == p4 and p1 == p5 then
			return 405			--5��
		elseif p1 == p2 and p1 == p3 and p1 == p4 and p1 ~= p5 then
			return 404			--4��
		elseif p1 == p2 and p1 == p3 and p1 ~= p4 and p1 == p5 then
			return 404			--4��
		elseif p1 == p2 and p1 ~= p3 and p1 == p4 and p1 == p5 then
			return 404			--4��
		elseif p1 ~= p2 and p1 == p3 and p1 == p4 and p1 == p5 then
			return 404			--4��
		elseif p1 == p2 and p1 == p3 and p1 ~= p4 and p1 ~= p5 then
			if  (p4 ~= p5) then
				return 400		--3��+2��ͬ
			end
			return 403			--3��+2��
		elseif p1 == p2 and p1 ~= p3 and p1 == p4 and p1 ~= p5 then
			if  (p3 ~= p5) then
				return 400		--3��+2��ͬ
			end
			return 403			--3��+2��
		elseif p1 ~= p2 and p1 == p3 and p1 == p4 and p1 ~= p5 then
			if  (p2 ~= p5) then
				return 400		--3��+2��ͬ
			end
			return 403			--3��+2��
		elseif p1 == p2 and p1 ~= p3 and p1 ~= p4 and p1 ~= p5 then
			if  (p4 ~= p5 or p3 ~= p5) then
				return 400		--2��+2��+1��ͬ
			end
			return 402			--2��+3��
		elseif p1 ~= p2 and p1 == p3 and p1 ~= p4 and p1 ~= p5 then
			if  (p4 ~= p5 or p2 ~= p5) then
				return 400		--2��+2��+1��ͬ
			end
			return 402			--2��+3��
		elseif p1 ~= p2 and p1 ~= p3 and p1 == p4 and p1 ~= p5 then
			if  (p2 ~= p5 or p3 ~= p5) then
				return 400		--2��+2��+1��ͬ
			end
			return 402			--2��+3��
		elseif p1 ~= p2 and p1 ~= p3 and p1 ~= p4 and p1 == p5 then
			if  (p2 ~= p4 or p3 ~= p4) then
				return 400		--2��+2��+1��ͬ
			end
			return 402			--2��+3��
		elseif p1 ~= p2 and p1 ~= p3 and p1 ~= p4 and p1 ~= p5 then
			if p2 == p3 and p2 == p4 and p2 == p5 then
				return 404		--1��+4��
			end
			return 400
		else
			return 400
		end
	elseif (teamplayers==4) then
		if p1 == p2 and p1 == p3 and p1 == p4 then
			return 404			--4��
		elseif p1 == p2 and p1 == p3 and p1 ~= p4 then
			return 403			--3��+1��
		elseif p1 == p2 and p1 ~= p3 and p1 == p4 then
			return 403			--3��+1��
		elseif p1 ~= p2 and p1 == p3 and p1 == p4 then
			return 403			--3��+1��
		elseif p1 == p2 and p1 ~= p3 and p1 ~= p4 then
			if (p3 ~= p4) then
				return 400		--2��+2��ͬ
			end
			return 403			--2��+2��
		elseif p1 ~= p2 and p1 == p3 and p1 ~= p4 then
			if (p2 ~= p4) then
				return 400		--2��+2��ͬ
			end
			return 403			--2��+2��
		elseif p1 ~= p2 and p1 ~= p3 and p1 == p4 then
			if (p2 ~= p3) then
				return 400		--2��+2��ͬ
			end
			return 403			--2��+2��
		elseif p1 ~= p2 and p1 ~= p3 and p1 ~= p4 then
			if p2 == p3 and p2 == p4 then
				return 403		--1��+3��
			end
			return 400
		else
			return 400
		end
	elseif (teamplayers==3) then
		if p1 == p2 and p1 == p3 then
			return 403			--3��
		elseif p1 ~= p2 and p1 ~= p3 then
			if (p2 ~= p3) then
				return 400		--1��+1��+1��
			end
			return 402			--1��+2��
		else
			return 400
		end
	else
		return 400
	end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;