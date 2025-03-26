---ģ����
local Module = ModuleBase:createModule('crossGate')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
local PowerOn = 1;
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
EnemySet[1] = {700061, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[1] = {199, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[1] = {"δ֪ħ��",EnemySet[1],BaseLevelSet[1]}
EnemySet[2] = {700062, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[2] = {199, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[2] = {"δ֪ħ��",EnemySet[2],BaseLevelSet[2]}
EnemySet[3] = {700063, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[3] = {199, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[3] = {"δ֪ħ��",EnemySet[3],BaseLevelSet[3]}
EnemySet[4] = {700064, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[4] = {199, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[4] = {"δ֪ħ��",EnemySet[4],BaseLevelSet[4]}
EnemySet[5] = {700065, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[5] = {199, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[5] = {"δ֪ħ��",EnemySet[5],BaseLevelSet[5]}
EnemySet[6] = {700066, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[6] = {199, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[6] = {"δ֪ħ��",EnemySet[6],BaseLevelSet[6]}
EnemySet[7] = {700067, 0, 0, 0, 0, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[7] = {199, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[7] = {"δ֪ħ��",EnemySet[7],BaseLevelSet[7]}
------------------------------------------------------
--��������
local Pts= 70075;		--70206��Ů��ƻ��.70075�����
local CrossGate = {
      { lordNum=1, timesec=1800, limit=30, fallName="���ص�ħ��F", gateLevel="E�������T1", lordName="δ֪ħ��F", startImage=103011, lordImage = 120038,
         waitingArea={map=777,X=36,Y=41}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=1000,X=242,Y=75}},
      { lordNum=2, timesec=1800, limit=30, fallName="���ص�ħ��E",gateLevel="E�������T2", lordName="δ֪ħ��E", startImage=103011, lordImage = 120026,
         waitingArea={map=777,X=36,Y=42}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=1000,X=241,Y=76}},
      { lordNum=3, timesec=3600, limit=40, fallName="���ص�ħ��D",gateLevel="C�������T1", lordName="δ֪ħ��D", startImage=103011, lordImage = 120036,
         waitingArea={map=777,X=36,Y=43}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=1000,X=240,Y=77}},
      { lordNum=4, timesec=3600, limit=40, fallName="���ص�ħ��C",gateLevel="C�������T2", lordName="δ֪ħ��C", startImage=103011, lordImage = 120183,
         waitingArea={map=777,X=36,Y=44}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=1000,X=239,Y=78}},
      { lordNum=5, timesec=7200, limit=60, fallName="���ص�ħ��B",gateLevel="A�������T1", lordName="δ֪ħ��B", startImage=103011, lordImage = 120332,
         waitingArea={map=777,X=36,Y=45}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=1000,X=238,Y=79}},
      { lordNum=6, timesec=7200, limit=60, fallName="���ص�ħ��A",gateLevel="A�������T2", lordName="δ֪ħ��A", startImage=103011, lordImage = 120290,
         waitingArea={map=777,X=36,Y=46}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=1000,X=237,Y=80}},
      { lordNum=7, timesec=28800, limit=70, fallName="���ص�ħ��S",gateLevel="S�������T", lordName="δ֪ħ��S", startImage=103011, lordImage = 120063,
         waitingArea={map=777,X=36,Y=47}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=1000,X=236,Y=81}},
}
local tbl_duel_user = {};			--��ǰ������ҵ��б�
local tbl_win_user = {};
local GateInfo = {}				--��ȴʱ���
local GateSetting = {}
local GateCD = {}
local crossGateBattle = {}
tbl_CrossGateNPCIndex = tbl_CrossGateNPCIndex or {}

function getGateInfo()
	GateInfo = GateInfo;
	return GateInfo;
end
function getGateSetting()
	GateSetting = GateSetting;
	return GateSetting;
end
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('LoopEvent', Func.bind(self.CrossGate_LoopEvent,self))
  for k,v in pairs(CrossGate) do
   if tbl_CrossGateNPCIndex[k] == nil then
    local CrossGateNPC = self:NPC_createNormal(v.fallName, v.lordImage, { map = v.waitingArea.map, x = v.waitingArea.X, y = v.waitingArea.Y, direction = 5, mapType = 0 })
    tbl_CrossGateNPCIndex[k] = CrossGateNPC
    Char.SetData(CrossGateNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
    self:NPC_regWindowTalkedEvent(tbl_CrossGateNPCIndex[k], function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
    if select == CONST.��ť_�� then
        return;
    elseif seqno == 1 and select == CONST.��ť_�� then
          --�����TBOSS
          local playerName = Char.GetData(player,CONST.����_����);
          local partyname = playerName .. "���";
          local playerLv = Char.GetData(player,CONST.����_�ȼ�);
          local gateName = Char.GetData(npc,CONST.����_����);
          local floor = Char.GetData(npc,CONST.����_��ͼ);
          for k,v in pairs(CrossGate) do
            if ( k==v.lordNum and gateName==v.gateLevel and floor==v.warpArea.map ) then
              if (playerLv < v.limit) then
                NLG.SystemMessage(player,"[ϵ�y]�����T���h��L�ȼ�Ҫ100����");
                return;
              else
                Char.Warp(player,0, v.bossArea.map, v.bossArea.X-10, v.bossArea.Y+10);
                Char.SetData(npc,CONST.����_X, v.bossArea.X);
                Char.SetData(npc,CONST.����_Y, v.bossArea.Y);
                Char.SetData(npc,CONST.����_��ͼ, v.bossArea.map);
                Char.SetData(npc,CONST.����_����, v.lordName);
                Char.SetData(npc,CONST.����_����, v.lordImage);
                NLG.UpChar(npc);
              end
            end
          end
    elseif seqno == 2 and select == CONST.��ť_�� then
          local gateName = Char.GetData(npc,CONST.����_����);
          local floor = Char.GetData(npc,CONST.����_��ͼ);
          for k,v in pairs(CrossGate) do
            if ( k==v.lordNum and gateName==v.lordName and floor==v.bossArea.map ) then
              table.insert(tbl_duel_user,player);
              table.insert(tbl_duel_user,npc);
              boss_round_start(player, npc, boss_round_callback);
            end
          end
    elseif seqno == 3 and select == CONST.��ť_�� then
          local gateName = Char.GetData(npc,CONST.����_����);
          local floor = Char.GetData(npc,CONST.����_��ͼ);
          for k,v in pairs(CrossGate) do
            if ( k==v.lordNum and gateName==v.fallName and floor==v.waitingArea.map ) then
              Char.Warp(player,0, 1000, 241, 88);
            end
          end
    end
    end)
    self:NPC_regTalkedEvent(tbl_CrossGateNPCIndex[k], function(npc, player)
      if(NLG.CheckInFront(player, npc, 1)==false) then
          return ;
      end
      if (NLG.CanTalk(npc, player) == true) then
          local gateName = Char.GetData(npc,CONST.����_����);
          local floor = Char.GetData(npc,CONST.����_��ͼ);
          for k,v in pairs(CrossGate) do
            if ( k==v.lordNum and gateName==v.gateLevel and floor==v.warpArea.map ) then
                local msg = "\\n\\n@c��"..gateName.."��"
                  .."\\n\\n"
                  .."\\nՈ�M���ù��Ԃ����T�����\\n"
                  .."\\n�Ƿ��M������T��\\n";
                NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
            elseif ( k==v.lordNum and gateName==v.lordName and floor==v.bossArea.map ) then
                local msg = "\\n\\n@c��ϵ�y֪ͨ��"
                  .."\\n\\n"
                  .."\\nδ֪��ħ����D�������\\n"
                  .."\\n�Ƿ��M����Y��\\n";
                NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2, msg);
            elseif ( k==v.lordNum and gateName==v.fallName and floor==v.waitingArea.map ) then
				NLG.SetAction(npc, CONST.����_����);
                local msg = "\\n\\n@c��ϵ�y֪ͨ��"
                  .."\\n\\n"
                  .."\\n�����ȡ�Ӱʿ����\\n"
                  .."\\n�Ƿ��x�_�����T��\\n";
                NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 3, msg);
            end
          end
      end
      return
    end)
   end
  end

  if (PowerOn==1) then 
    --����
    GateInfo = {};
    GateSetting = {};
    for k=1,#CrossGate do
        --print(tbl_CrossGateNPCIndex[k])
        Char.SetLoopEvent('./lua/Modules/crossGate.lua','CrossGate_LoopEvent',tbl_CrossGateNPCIndex[k],60000);
        GateInfo[k] = os.time();
        GateSetting[k] = nil;
        GateCD[k] = 0;
    end
    --NLG.SystemMessage(charIndex, "[ϵ�y]�����T�_�š�");
    --NLG.UpChar(charIndex);

    local gmIndex = NLG.FindUser(123456);
    --Char.SetExtData(gmIndex, '��������ȴ_set', JSON.encode(GateCD));
    local newdata = JSON.encode(GateCD);
    SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
    NLG.UpChar(gmIndex);
    PowerOn = 0;
  end

  GateMonitorNPC = self:NPC_createNormal('�����T�O��', 14682, { map = 777, x = 41, y = 32,  direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(GateMonitorNPC, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(GateMonitorNPC, function(npc, player)
    local gmIndex = NLG.FindUser(123456);
    local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='��������ȴ_set'")["0_0"])
    local GateCD = {};
    if (type(sqldata)=="string" and sqldata~='') then
        GateCD = JSON.decode(sqldata);
    else
        GateCD = {};
    end

    winMsg = "\\n            �����������T�YӍ�������"
          .. "\\n\\n  �����T          ����λ��             ��s����\\n"
          .. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
      for k,v in pairs(CrossGate) do
        --local bossImage = tonumber(GateCD[k]);
        local gateName = tonumber(GateCD[k]);
        if (k==v.lordNum and gateName==v.fallName) then
          local Name = v.gateLevel;
          local mapsname = "��ʧ��";
          local mapsX = "xxx";
          local mapsY = "yyy";
          local CTime = GateInfo[k] or os.time();
          local CDTime = ""..v.timesec - (os.time() - CTime).." ��";
          winMsg = winMsg .. "\\n  "..Name.."        "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
        elseif (k==v.lordNum and gateName==0) then
          local Name = v.gateLevel;
          local mapsname = NLG.GetMapName(0, v.warpArea.map);
          local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_X));
          local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_Y));
          local CDTime = "���F�л򱻹���(��ʧ)";
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
	if (msg=="[nr gate on]") then
		local cdk = Char.GetData(charIndex,CONST.����_CDK);
		if (cdk == "123456") then
			--����
			GateInfo = {};
			GateSetting = {};
			for k=1,#CrossGate do
				--print(tbl_CrossGateNPCIndex[k])
				Char.SetLoopEvent('./lua/Modules/crossGate.lua','CrossGate_LoopEvent',tbl_CrossGateNPCIndex[k],60000);
				GateInfo[k] = os.time();
				GateSetting[k] = nil;
				GateCD[k] = 0;
			end
			NLG.SystemMessage(charIndex, "[ϵ�y]�����T�_�š�");
			NLG.UpChar(charIndex);

			local gmIndex = NLG.FindUser(123456);
			Char.SetExtData(charIndex, '��������ȴ_set', JSON.encode(GateCD));
			local newdata = JSON.encode(GateCD);
			SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
			NLG.UpChar(gmIndex);
			return 0;
		end
	elseif (msg=="/cross") then
		local gmIndex = NLG.FindUser(123456);
		local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='��������ȴ_set'")["0_0"])
		local GateCD = {};
		if (type(sqldata)=="string" and sqldata~='') then
			GateCD = JSON.decode(sqldata);
		else
			GateCD = {};
		end

		winMsg = "\\n            �����������T�YӍ�������"
			.. "\\n\\n  �����T          ����λ��             ��s����\\n"
			.. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
			for k,v in pairs(CrossGate) do
				--local bossImage = tonumber(GateCD[k]);
				local gateName = tonumber(GateCD[k]);
				if (k==v.lordNum and gateName==v.fallName) then
					local Name = v.gateLevel;
					local mapsname = "��ʧ��";
					local mapsX = "xxx";
					local mapsY = "yyy";
					local CTime = GateInfo[k] or os.time();
					local CDTime = ""..v.timesec - (os.time() - CTime).." ��";
					winMsg = winMsg .. "\\n  "..Name.."        "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
				elseif (k==v.lordNum and gateName==0) then
					local Name = v.gateLevel;
					local mapsname = NLG.GetMapName(0, v.warpArea.map);
					local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_X));
					local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_Y));
					local CDTime = "���F�л򱻹���(��ʧ)";
					winMsg = winMsg .. "\\n  "..Name.."        "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
				end
			end
			winMsg = winMsg .. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T";
		NLG.ShowWindowTalked(charIndex, GateMonitorNPC, CONST.����_����Ϣ��, CONST.��ť_�ر�, 1, winMsg);
	end
	return 1;
end
--ת��
function CrossGate_LoopEvent(npc)
	local gmIndex = NLG.FindUser(123456);
	local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='��������ȴ_set'")["0_0"])
	local GateCD = {};
	if (type(sqldata)=="string" and sqldata~='') then
		GateCD = JSON.decode(sqldata);
	else
		GateCD = {};
	end

	GateInfo = getGateInfo();
	GateSetting = getGateSetting();
	if (os.date("%X",os.time())=="00:00:00") then
		for k,v in pairs(CrossGate) do
           local warpX = NLG.Rand(v.warpArea.LX, v.warpArea.RX);
           local warpY = NLG.Rand(v.warpArea.LY, v.warpArea.RY);

			local mapsname = NLG.GetMapName(0, v.warpArea.map);
			--local bossImage = Char.GetData(npc,CONST.����_����);
			local gateName = Char.GetData(npc,CONST.����_����);
			if ( k==v.lordNum and gateName==v.fallName ) then
				GateInfo[k] = os.time();
				GateSetting[k] = 0;
				NLG.SystemMessage(-1,"[ϵ�y]"..v.gateLevel.."���F��"..mapsname.."("..v.warpArea.X..","..v.warpArea.Y..")");
				Char.SetData(npc,CONST.����_X, v.warpArea.X);
				Char.SetData(npc,CONST.����_Y, v.warpArea.Y);
				Char.SetData(npc,CONST.����_��ͼ, v.warpArea.map);
				Char.SetData(npc,CONST.����_����, v.gateLevel);
				Char.SetData(npc,CONST.����_����, v.startImage);
				NLG.UpChar(npc);

				GateCD[k] = 0;
				--local newdata = JSON.encode(GateCD);
				--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
				--NLG.UpChar(gmIndex);
			end
		end
		local newdata = JSON.encode(GateCD);
		SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
		NLG.UpChar(gmIndex);
	elseif (os.date("%X",os.time())=="23:59:00")  then
		for k,v in pairs(CrossGate) do
			--local bossImage = Char.GetData(npc,CONST.����_����);
			local gateName = Char.GetData(npc,CONST.����_����);
			if ( k==v.lordNum and bossImage==v.lordImage ) then
				Char.SetData(npc,CONST.����_X, v.waitingArea.X);
				Char.SetData(npc,CONST.����_Y, v.waitingArea.Y);
				Char.SetData(npc,CONST.����_��ͼ, v.waitingArea.map);
				Char.SetData(npc,CONST.����_����, v.fallName);
				Char.SetData(npc,CONST.����_����, v.lordImage);
				NLG.UpChar(npc);
			end
		end
	else
		for k,v in pairs(CrossGate) do
            local warpX = NLG.Rand(v.warpArea.LX, v.warpArea.RX);
            local warpY = NLG.Rand(v.warpArea.LY, v.warpArea.RY);

			if (GateSetting[k]==nil) then
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				--local bossImage = Char.GetData(npc,CONST.����_����);
				local gateName = Char.GetData(npc,CONST.����_����);
				if ( k==v.lordNum and gateName==v.fallName) then
					GateInfo[k] = os.time();
					GateSetting[k] = 0;
					NLG.SystemMessage(-1,"[ϵ�y]"..v.gateLevel.."���F��"..mapsname.."("..warpX..","..warpY..")");
					Char.SetData(npc,CONST.����_X, warpX);
					Char.SetData(npc,CONST.����_Y, warpY);
					Char.SetData(npc,CONST.����_��ͼ, v.warpArea.map);
					Char.SetData(npc,CONST.����_����, v.gateLevel);
					Char.SetData(npc,CONST.����_����, v.startImage);
					NLG.UpChar(npc);
				end
			elseif (GateSetting[k]==2) then
				local CTime = GateInfo[k] or os.time();
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				--local bossImage = Char.GetData(npc,CONST.����_����);
				local gateName = Char.GetData(npc,CONST.����_����);
				if ( (os.time() - CTime) >= v.timesec and k==v.lordNum and gateName==v.fallName) then
					GateInfo[k] = os.time();
					GateSetting[k] = 1;
					NLG.SystemMessage(-1,"[ϵ�y]"..v.gateLevel.."���F��"..mapsname.."("..warpX..","..warpY..")");
					Char.SetData(npc,CONST.����_X, warpX);
					Char.SetData(npc,CONST.����_Y, warpY);
					Char.SetData(npc,CONST.����_��ͼ, v.warpArea.map);
					Char.SetData(npc,CONST.����_����, v.gateLevel);
					Char.SetData(npc,CONST.����_����, v.startImage);
					NLG.UpChar(npc);

					GateCD[k] = 0;
					--local newdata = JSON.encode(GateCD);
					--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
					--NLG.UpChar(gmIndex);
				elseif ( v.timesec - (os.time() - CTime) < 0 and k==v.lordNum and gateName==v.fallName) then
					GateInfo[k] = os.time();
					GateSetting[k] = 1;
					NLG.SystemMessage(-1,"[ϵ�y]"..v.gateLevel.."���F��"..mapsname.."("..warpX..","..warpY..")");
					Char.SetData(npc,CONST.����_X, warpX);
					Char.SetData(npc,CONST.����_Y, warpY);
					Char.SetData(npc,CONST.����_��ͼ, v.warpArea.map);
					Char.SetData(npc,CONST.����_����, v.gateLevel);
					Char.SetData(npc,CONST.����_����, v.startImage);
					NLG.UpChar(npc);

					GateCD[k] = 0;
					--local newdata = JSON.encode(GateCD);
					--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
					--NLG.UpChar(gmIndex);
				end
			end
		end
		local newdata = JSON.encode(GateCD);
		SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
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

	for k,v in pairs(CrossGate) do
		--local bossImage = Char.GetData(npc,CONST.����_����);
		local gateName = Char.GetData(npc,CONST.����_����);
		if ( k==v.lordNum and gateName==v.lordName ) then
			local battleindex = Battle.PVE( player, player, nil, Pos[k][2], Pos[k][3], nil)
			Battle.SetWinEvent("./lua/Modules/crossGate.lua", "boss_round_callback", battleindex);
			crossGateBattle={}
			table.insert(crossGateBattle, battleindex);
			Char.SetTempData(player, '������', npc);
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
	if ( Char.GetData(w1, CONST.����_����) >= CONST.��������_��) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, CONST.����_����) >= CONST.��������_�� ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	local player = tbl_win_user[1];
	--local npc = tbl_duel_user[2];

	--�ж����ĸ�������
	local npc = Char.GetTempData(player, '������') or 0;
	--print(npc)

	for k,v in pairs(CrossGate) do
		--local bossImage = Char.GetData(npc,CONST.����_����);
		local gateName = Char.GetData(npc,CONST.����_����);
		if ( k==v.lordNum and gateName==v.lordName ) then
			NLG.SystemMessage(-1,"[����] "..v.gateLevel.."�� "..Char.GetData(player,CONST.����_����).." �����ˡ�");
			NLG.UpChar(player);
		end
	end

	--������ȴʱ��
	local gmIndex = NLG.FindUser(123456);
	local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='��������ȴ_set'")["0_0"])
	local GateCD = {};
	if (type(sqldata)=="string" and sqldata~='') then
		GateCD = JSON.decode(sqldata);
	else
		GateCD = {};
	end
	for k,v in pairs(CrossGate) do
		--local bossImage = Char.GetData(npc,CONST.����_����);
		local gateName = Char.GetData(npc,CONST.����_����);
		if ( k==v.lordNum and gateName==v.lordName ) then
			GateInfo[k] = os.time();
			GateSetting[k] = 2;
			Char.Warp(player,0, v.waitingArea.map, v.waitingArea.X-3, v.waitingArea.Y+3);
			Char.SetData(npc,CONST.����_X, v.waitingArea.X);
			Char.SetData(npc,CONST.����_Y, v.waitingArea.Y);
			Char.SetData(npc,CONST.����_��ͼ, v.waitingArea.map);
			Char.SetData(npc,CONST.����_����, v.fallName);
			Char.SetData(npc,CONST.����_����, v.lordImage);
			NLG.UpChar(npc);

			GateCD[k] = gateName;
			local newdata = JSON.encode(GateCD);
			SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
			NLG.UpChar(gmIndex);
		end
	end
	Battle.UnsetWinEvent(battleindex);
	crossGateBattle ={};
	Char.SetTempData(player, '������',0);
end


--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;