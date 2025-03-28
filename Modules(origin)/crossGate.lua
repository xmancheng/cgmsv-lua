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
EnemySet[1] = {1801, 21, 22, 23, 24, 0, 21, 22, 23, 24}--0����û�й�
BaseLevelSet[1] = {35, 20, 20, 20, 20, 0, 20, 20, 20, 20}
Pos[1] = {"δ֪ħ��",EnemySet[1],BaseLevelSet[1]}
EnemySet[2] = {1802, 601, 603, 601, 603, 0, 0, 0, 0, 0}--0����û�й�
BaseLevelSet[2] = {35, 20, 20, 20, 20, 0, 0, 0, 0, 0}
Pos[2] = {"δ֪ħ��",EnemySet[2],BaseLevelSet[2]}
EnemySet[3] = {1803, 9072, 9072, 0, 0, 9090, 0, 0, 9090, 9090}--0����û�й�
BaseLevelSet[3] = {45, 30, 30, 0, 0, 30, 0, 0, 30, 30}
Pos[3] = {"δ֪ħ��",EnemySet[3],BaseLevelSet[3]}
EnemySet[4] = {1804, 715, 715, 0, 0, 715, 0, 0, 715, 715}--0����û�й�
BaseLevelSet[4] = {45, 30, 30, 0, 0, 30, 0, 0, 30, 30}
Pos[4] = {"δ֪ħ��",EnemySet[4],BaseLevelSet[4]}
EnemySet[5] = {1805, 9042, 9042, 0, 0, 9042, 0, 0, 9042, 9042}--0����û�й�
BaseLevelSet[5] = {65, 50, 50, 0, 0, 50, 0, 0, 50, 50}
Pos[5] = {"δ֪ħ��",EnemySet[5],BaseLevelSet[5]}
EnemySet[6] = {1806, 0, 0, 0, 0, 12122, 12122, 12122, 12122, 12122}--0����û�й�
BaseLevelSet[6] = {65, 0, 0, 0, 0, 50, 50, 50, 50, 50}
Pos[6] = {"δ֪ħ��",EnemySet[6],BaseLevelSet[6]}
EnemySet[7] = {1807, 41402, 41402, 0, 0, 41391, 41391, 41391, 0, 0}--0����û�й�
BaseLevelSet[7] = {80, 70, 70, 0, 0, 70, 70, 70, 0, 0}
Pos[7] = {"δ֪ħ��",EnemySet[7],BaseLevelSet[7]}
------------------------------------------------------
--��������
local Pts= 70075;		--70206��Ů��ƻ��.70075�����
local CrossGate = {
      { lordNum=1, timesec=1800, limit=30, fallName="���ص�ħ��F", gateLevel="E�������T1", lordName="δ֪ħ��F", startImage=121001, lordImage = 104595,
         waitingArea={map=25008,X=25,Y=12}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=25,Y=12}},
      { lordNum=2, timesec=1800, limit=30, fallName="���ص�ħ��E",gateLevel="E�������T2", lordName="δ֪ħ��E", startImage=121001, lordImage = 104605,
         waitingArea={map=25008,X=55,Y=44}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=55,Y=44}},
      { lordNum=3, timesec=3600, limit=40, fallName="���ص�ħ��D",gateLevel="C�������T1", lordName="δ֪ħ��D", startImage=121001, lordImage = 110585,
         waitingArea={map=25008,X=55,Y=12}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=55,Y=12}},
      { lordNum=4, timesec=3600, limit=40, fallName="���ص�ħ��C",gateLevel="C�������T2", lordName="δ֪ħ��C", startImage=121001, lordImage = 104326,
         waitingArea={map=25008,X=25,Y=44}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=25,Y=44}},
      { lordNum=5, timesec=7200, limit=60, fallName="���ص�ħ��B",gateLevel="A�������T1", lordName="δ֪ħ��B", startImage=121001, lordImage = 104720,
         waitingArea={map=25008,X=85,Y=44}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=85,Y=44}},
      { lordNum=6, timesec=7200, limit=60, fallName="���ص�ħ��A",gateLevel="A�������T2", lordName="δ֪ħ��A", startImage=121001, lordImage = 104819,
         waitingArea={map=25008,X=54,Y=76}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=54,Y=76}},
      { lordNum=7, timesec=28800, limit=70, fallName="���ص�ħ��S",gateLevel="S�������T", lordName="δ֪ħ��S", startImage=121001, lordImage = 104706,
         waitingArea={map=25008,X=85,Y=76}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=85,Y=76}},
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
                NLG.SystemMessage(player,"[ϵ�y]�����T���h��L�ȼ�Ҫ"..v.limit.."����");
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

    GateInfo = getGateInfo();
    winMsg = "\\n            �����������T�YӍ�������"
          .. "\\n\\n  �����T          ����λ��             ��s����\\n"
          .. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
      for k,v in pairs(CrossGate) do
        local floor = Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_��ͼ)
        local bossImage = tonumber(GateCD[k]);
        if (k==v.lordNum and bossImage==v.lordImage and floor==v.waitingArea.map) then
          local Name = v.gateLevel;
          local mapsname = "��ʧ��";
          local mapsX = "xxx";
          local mapsY = "yyy";
          local CTime = GateInfo[k] or os.time();
          local CDTime = ""..v.timesec - (os.time() - CTime).." ��";
          winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
        elseif (k==v.lordNum and bossImage==0 and floor==v.warpArea.map) then
          local Name = v.gateLevel;
          local mapsname = NLG.GetMapName(0, v.warpArea.map);
          local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_X));
          local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_Y));
          local CDTime = "���F��";
          winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")     "..CDTime.."\\n"
        elseif (k==v.lordNum and bossImage==0 and floor==v.bossArea.map) then
          local Name = v.gateLevel;
          local mapsname = NLG.GetMapName(0, v.bossArea.map);
          local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_X));
          local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_Y));
          local CDTime = "������";
          winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")     "..CDTime.."\\n"
        end
      end
      winMsg = winMsg .. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T";
      NLG.ShowWindowTalked(player,npc, CONST.����_����Ϣ��, CONST.��ť_�ر�, 1, winMsg);
      return
  end)


  --ͨ�ó�ȡ����
  self:regCallback('ItemString', Func.bind(self.shadowExtraction, self),"LUA_useSdExtra");
  self.shadowExtractionNPC = self:NPC_createNormal('�Ӱ��ȡ', 14682, { x = 41, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.shadowExtractionNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c���Ӱ��ȡ��" ..	"\\n\\n\\n�_��Ҫ�Lԇ��ȡ�Ӱʿ���K��ȡ��";
        NLG.ShowWindowTalked(player, self.shadowExtractionNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.shadowExtractionNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ComIndex =ComIndex;
    local ComSlot = ComSlot;
    local Target_FloorId = Char.GetData(player,CONST.����_��ͼ)--��ͼ���
    local Target_X = Char.GetData(player,CONST.����_X)--��ͼx
    local Target_Y = Char.GetData(player,CONST.����_Y)--��ͼy
    local playerLv = Char.GetData(player,CONST.����_�ȼ�);
    if select > 0 then
      if seqno == 1 and Char.ItemSlot(player)==20 and select == CONST.��ť_�� then
                 NLG.SystemMessage(player,"[ϵ�y]��Ʒ��λ���ѝM��");
                 return;
      elseif seqno == 1 and select == CONST.��ť_�� then
                 return;
      elseif seqno == 1 and select == CONST.��ť_�� then
          for k,v in pairs(CrossGate) do
		    if ( k==v.lordNum and Target_FloorId==v.waitingArea.map ) then
              if Target_X>=v.waitingArea.X-15 and Target_X<=v.waitingArea.X+3 and Target_Y>=v.waitingArea.Y-3 and Target_Y<=v.waitingArea.Y+15 then
		    	enemyId = Pos[k][2][1];	--10��λ��Ϊ��ȡ����enemyId
                goto continue
              end
		    end
          end
          ::continue::
          local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(enemyId);
          local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
          local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_����);
          local EnemyDataIndex = Data.EnemyGetDataIndex(enemyId)
          local enemyLevel = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_��ߵȼ�);
          local extraRate = NLG.Rand(1, 100);
          --print(extraRate)
          if (playerLv-enemyLevel)>=-10 then 
              success=20;
          elseif (playerLv-enemyLevel)<-10 and (playerLv-enemyLevel)>=-20 then 
              success=14;
          elseif (playerLv-enemyLevel)<-20 and (playerLv-enemyLevel)>=-30 then 
              success=6;
          elseif (playerLv-enemyLevel)<-30 then 
              success=1;	--99%ʧ��
          end
          if (enemyId ~=nil and enemyId>0) then
              if (extraRate>success) then
                  Char.DelItem(player, 75027, 1);
                  NLG.Say(player,player,"���� ��Rise������",14,3);
                  NLG.PlaySe(player, 258, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
                  NLG.SystemMessage(player,"[ϵ�y]��ȡʧ����");
                  return;
              end
              --��������λ��
              local EmptySlot = Char.GetItemEmptySlot(player);
              --if (NLG.Rand(0,1)==0) then	--��ȡΪ����
                 Char.GiveItem(player, 75028, 1);
                 local ItemIndex = Char.GetItemIndex(player, EmptySlot);
                 Item.SetData(ItemIndex, CONST.����_����,EnemyName.."�Ӱʿ��");
                 Item.SetData(ItemIndex,CONST.����_�Ӳ�һ,enemyId);
                 Item.SetData(ItemIndex,CONST.����_�Ӳζ�,enemyLevel);
                 Item.UpItem(player, EmptySlot);
                 NLG.UpChar(player);
                 Char.DelItem(player, 75027, 1);
                 NLG.Say(player,player,"���� ��Rise������",14,3);
                 NLG.PlaySe(player, 257, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
                 NLG.SystemMessage(player, "[ϵͳ]"..EnemyName.."�ɹ���ȡ���Ӱʿ����")
              --[[elseif (NLG.Rand(0,1)==1) then	--��ȡΪӶ��
                 Char.GiveItem(player, 75029, 1);
                 local ItemIndex = Char.GetItemIndex(player, EmptySlot);
                 Item.SetData(ItemIndex, CONST.����_����,EnemyName.."�Ӱⷰ�");
                 Item.SetData(ItemIndex,CONST.����_�Ӳ�һ,50);
                 Item.SetData(ItemIndex,CONST.����_�Ӳζ�,heroesNo);
                 Item.UpItem(player, EmptySlot);
                 NLG.UpChar(player);
                 Char.DelItem(player, 75027, 1);
                 NLG.Say(player,player,"���� ��Rise������",14,3);
                 NLG.PlaySe(player, 257, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
                 NLG.SystemMessage(player, "[ϵͳ]"..EnemyName.."�ɹ���ȡ���Ӱⷰ顣")
              end]]
          elseif (enemyId ==nil) then
              NLG.SystemMessage(player,"[ϵ�y]�@߅�o��ʹ���Ӱ��ȡ��");
              return;
          else
              NLG.SystemMessage(player,"[ϵ�y]�����e�`��");
              return;
          end
      else
              return;
      end
    end
  end)

  --ͨ���ٻ�����
  self:regCallback('ItemString', Func.bind(self.shadowSummon, self),"LUA_useSdSum");
  self.shadowSummonNPC = self:NPC_createNormal('�Ӱ�ن�', 14682, { x = 40, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.shadowSummonNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c���Ӱ�ن���" ..	"\\n\\n\\n�_��Ҫ�ų���ȡ���Ӱʿ����";
        NLG.ShowWindowTalked(player, self.shadowSummonNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.shadowSummonNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local BallIndex =BallIndex;
    local BallSlot = BallSlot;
    local BallName = Item.GetData(BallIndex, CONST.����_����);
    local last = string.find(BallName, "�", 1);
    local enemyName =string.sub(BallName, 1, last-1);
    local enemyId = Item.GetData(BallIndex,CONST.����_�Ӳ�һ);
    local enemyLevel = Item.GetData(BallIndex,CONST.����_�Ӳζ�);
    if select > 0 then
      if seqno == 1 and Char.PetNum(player)==5 and select == CONST.��ť_�� then
                 NLG.SystemMessage(player,"[ϵ�y]�����λ���ѝM��");
                 return;
      elseif seqno == 1 and select == CONST.��ť_�� then
                 return;
      elseif seqno == 1 and select == CONST.��ť_�� then
          if (enemyId ~=nil and enemyId>0) then
              Char.AddPet(player,enemyId);
              Char.DelItemBySlot(player, BallSlot);
              NLG.SystemMessage(player, "[ϵͳ]"..enemyName.."�ɹ��ن�����")
          else
              NLG.SystemMessage(player,"[ϵ�y]�����e�`��");
              return;
          end
      else
              return;
      end
    end
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

		GateInfo = getGateInfo();
		winMsg = "\\n            �����������T�YӍ�������"
			.. "\\n\\n  �����T          ����λ��             ��s����\\n"
			.. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
			for k,v in pairs(CrossGate) do
				local floor = Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_��ͼ)
				local bossImage = tonumber(GateCD[k]);
				if (k==v.lordNum and bossImage==v.lordImage and floor==v.waitingArea.map) then
					local Name = v.gateLevel;
					local mapsname = "��ʧ��";
					local mapsX = "xxx";
					local mapsY = "yyy";
					local CTime = GateInfo[k] or os.time();
					local CDTime = ""..v.timesec - (os.time() - CTime).." ��";
					winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
				elseif (k==v.lordNum and bossImage==0 and floor==v.warpArea.map) then
					local Name = v.gateLevel;
					local mapsname = NLG.GetMapName(0, v.warpArea.map);
					local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_X));
					local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_Y));
					local CDTime = "���F��";
					winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")     "..CDTime.."\\n"
				elseif (k==v.lordNum and bossImage==0 and floor==v.bossArea.map) then
					local Name = v.gateLevel;
					local mapsname = NLG.GetMapName(0, v.bossArea.map);
					local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_X));
					local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.����_Y));
					local CDTime = "������";
					winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")     "..CDTime.."\\n"
				end
			end
			winMsg = winMsg .. "\\n�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T";
		NLG.ShowWindowTalked(charIndex, GateMonitorNPC, CONST.����_����Ϣ��, CONST.��ť_�ر�, 1, winMsg);
		return 0;
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
	if (os.date("%M",os.time())=="30") or (os.date("%M",os.time())=="00") then
		if ( os.date("%S",os.time())=="00") or (os.date("%S",os.time())=="01") or (os.date("%S",os.time())=="02") or (os.date("%S",os.time())=="03") or (os.date("%S",os.time())=="04") or (os.date("%S",os.time())=="05") then
		for k,v in pairs(CrossGate) do
            repeat
              warpX = NLG.Rand(v.warpArea.LX, v.warpArea.RX);
              warpY = NLG.Rand(v.warpArea.LY, v.warpArea.RY);
            until (Map.IsWalkable(0, 43100, warpX - 2, warpY + 2) == 1)

			local mapsname = NLG.GetMapName(0, v.warpArea.map);
			--local bossImage = Char.GetData(npc,CONST.����_����);
			local gateName = Char.GetData(npc,CONST.����_����);
			if ( k==v.lordNum and gateName==v.fallName ) then
				GateInfo[k] = os.time();
				GateSetting[k] = 0;
				NLG.SystemMessage(-1,"[ϵ�y]"..v.gateLevel.."���F��"..mapsname.."("..v.warpArea.X..","..v.warpArea.Y..")");
				Char.SetData(npc,CONST.����_X, warpX);
				Char.SetData(npc,CONST.����_Y, warpY);
				Char.SetData(npc,CONST.����_��ͼ, v.warpArea.map);
				Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
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
		--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
		SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
		NLG.UpChar(gmIndex);
	elseif (os.date("%M",os.time())=="15") or (os.date("%M",os.time())=="45") then
		if ( os.date("%S",os.time())=="00") or (os.date("%S",os.time())=="01") or (os.date("%S",os.time())=="02") or (os.date("%S",os.time())=="03") or (os.date("%S",os.time())=="04") or (os.date("%S",os.time())=="05") then
		for k,v in pairs(CrossGate) do
			--local bossImage = Char.GetData(npc,CONST.����_����);
			local gateName = Char.GetData(npc,CONST.����_����);
			if ( k==v.lordNum and bossImage==v.lordImage ) then
				Char.SetData(npc,CONST.����_X, v.waitingArea.X);
				Char.SetData(npc,CONST.����_Y, v.waitingArea.Y);
				Char.SetData(npc,CONST.����_��ͼ, v.waitingArea.map);
				Char.Warp(npc,0, v.waitingArea.map, v.waitingArea.X, v.waitingArea.Y);
				Char.SetData(npc,CONST.����_����, v.fallName);
				Char.SetData(npc,CONST.����_����, v.lordImage);
				NLG.UpChar(npc);
			end
		end
		end
	else
		for k,v in pairs(CrossGate) do
			repeat
				warpX = NLG.Rand(v.warpArea.LX, v.warpArea.RX);
				warpY = NLG.Rand(v.warpArea.LY, v.warpArea.RY);
			until (Map.IsWalkable(0, 43100, warpX - 2, warpY + 2) == 1)

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
					Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
					Char.SetData(npc,CONST.����_����, v.gateLevel);
					Char.SetData(npc,CONST.����_����, v.startImage);
					NLG.UpChar(npc);
				end
			elseif (GateSetting[k]==1) then
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				local gateName = Char.GetData(npc,CONST.����_����);
				if ( k==v.lordNum and gateName==v.fallName ) then
					GateSetting[k] = 0;
					NLG.SystemMessage(-1,"[ϵ�y]"..v.gateLevel.."���F��"..mapsname.."("..warpX..","..warpY..")");
					Char.SetData(npc,CONST.����_X, warpX);
					Char.SetData(npc,CONST.����_Y, warpY);
					Char.SetData(npc,CONST.����_��ͼ, v.warpArea.map);
					Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
					Char.SetData(npc,CONST.����_����, v.gateLevel);
					Char.SetData(npc,CONST.����_����, v.startImage);
					NLG.UpChar(npc);

					GateCD[k] = 0;
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
					Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
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
					Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
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
		--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
		SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
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
		local bossImage = Char.GetData(npc,CONST.����_����);
		local gateName = Char.GetData(npc,CONST.����_����);
		if ( k==v.lordNum and gateName==v.lordName ) then
			GateInfo[k] = os.time();
			GateSetting[k] = 2;
			--Char.SetData(npc,CONST.����_X, v.waitingArea.X);
			--Char.SetData(npc,CONST.����_Y, v.waitingArea.Y);
			--Char.SetData(npc,CONST.����_��ͼ, v.waitingArea.map);
			Char.Warp(npc,0, v.waitingArea.map, v.waitingArea.X, v.waitingArea.Y);
			Char.SetData(npc,CONST.����_����, v.fallName);
			Char.SetData(npc,CONST.����_����, v.lordImage);
			NLG.UpChar(npc);

			GateCD[k] = bossImage;
			local newdata = JSON.encode(GateCD);
			SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='��������ȴ_set'")
			NLG.UpChar(gmIndex);

			Char.Warp(player,0, v.waitingArea.map, v.waitingArea.X-3, v.waitingArea.Y+3);
		end
	end
	Battle.UnsetWinEvent(battleindex);
	crossGateBattle ={};
	Char.SetTempData(player, '������',0);
end

----------------------------------------------------------------
function Module:shadowExtraction(charIndex,targetIndex,itemSlot)
    ComItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    ComSlot =itemSlot;
    ComIndex = Char.GetItemIndex(charIndex,itemSlot);
    local msg = "\\n@c���Ӱ��ȡ��" ..	"\\n\\n\\n�_��Ҫ�Lԇ��ȡ�Ӱʿ���K��ȡ��";
    NLG.ShowWindowTalked(charIndex, self.shadowExtractionNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    return 1;
end

function Module:shadowSummon(charIndex,targetIndex,itemSlot)
    BallItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    BallSlot =itemSlot;
    BallIndex = Char.GetItemIndex(charIndex,itemSlot);
    local msg = "\\n@c���Ӱ�ن���" ..	"\\n\\n\\n�_��Ҫ�ų���ȡ���Ӱʿ����";
    NLG.ShowWindowTalked(charIndex, self.shadowSummonNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    return 1;
end

Char.GetItemEmptySlot = function(charIndex)
  for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;