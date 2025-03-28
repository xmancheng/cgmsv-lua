---模块类
local Module = ModuleBase:createModule('crossGate')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
local PowerOn = 1;
--队列解释
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------对战NPC设置------------
EnemySet[1] = {1801, 21, 22, 23, 24, 0, 21, 22, 23, 24}--0代表没有怪
BaseLevelSet[1] = {35, 20, 20, 20, 20, 0, 20, 20, 20, 20}
Pos[1] = {"未知魔物",EnemySet[1],BaseLevelSet[1]}
EnemySet[2] = {1802, 601, 603, 601, 603, 0, 0, 0, 0, 0}--0代表没有怪
BaseLevelSet[2] = {35, 20, 20, 20, 20, 0, 0, 0, 0, 0}
Pos[2] = {"未知魔物",EnemySet[2],BaseLevelSet[2]}
EnemySet[3] = {1803, 9072, 9072, 0, 0, 9090, 0, 0, 9090, 9090}--0代表没有怪
BaseLevelSet[3] = {45, 30, 30, 0, 0, 30, 0, 0, 30, 30}
Pos[3] = {"未知魔物",EnemySet[3],BaseLevelSet[3]}
EnemySet[4] = {1804, 715, 715, 0, 0, 715, 0, 0, 715, 715}--0代表没有怪
BaseLevelSet[4] = {45, 30, 30, 0, 0, 30, 0, 0, 30, 30}
Pos[4] = {"未知魔物",EnemySet[4],BaseLevelSet[4]}
EnemySet[5] = {1805, 9042, 9042, 0, 0, 9042, 0, 0, 9042, 9042}--0代表没有怪
BaseLevelSet[5] = {65, 50, 50, 0, 0, 50, 0, 0, 50, 50}
Pos[5] = {"未知魔物",EnemySet[5],BaseLevelSet[5]}
EnemySet[6] = {1806, 0, 0, 0, 0, 12122, 12122, 12122, 12122, 12122}--0代表没有怪
BaseLevelSet[6] = {65, 0, 0, 0, 0, 50, 50, 50, 50, 50}
Pos[6] = {"未知魔物",EnemySet[6],BaseLevelSet[6]}
EnemySet[7] = {1807, 41402, 41402, 0, 0, 41391, 41391, 41391, 0, 0}--0代表没有怪
BaseLevelSet[7] = {80, 70, 70, 0, 0, 70, 70, 70, 0, 0}
Pos[7] = {"未知魔物",EnemySet[7],BaseLevelSet[7]}
------------------------------------------------------
--背景设置
local Pts= 70075;		--70206真女神苹果.70075任务币
local CrossGate = {
      { lordNum=1, timesec=1800, limit=30, fallName="倒地的魔物F", gateLevel="E級傳送門1", lordName="未知魔物F", startImage=121001, lordImage = 104595,
         waitingArea={map=25008,X=25,Y=12}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=25,Y=12}},
      { lordNum=2, timesec=1800, limit=30, fallName="倒地的魔物E",gateLevel="E級傳送門2", lordName="未知魔物E", startImage=121001, lordImage = 104605,
         waitingArea={map=25008,X=55,Y=44}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=55,Y=44}},
      { lordNum=3, timesec=3600, limit=40, fallName="倒地的魔物D",gateLevel="C級傳送門1", lordName="未知魔物D", startImage=121001, lordImage = 110585,
         waitingArea={map=25008,X=55,Y=12}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=55,Y=12}},
      { lordNum=4, timesec=3600, limit=40, fallName="倒地的魔物C",gateLevel="C級傳送門2", lordName="未知魔物C", startImage=121001, lordImage = 104326,
         waitingArea={map=25008,X=25,Y=44}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=25,Y=44}},
      { lordNum=5, timesec=7200, limit=60, fallName="倒地的魔物B",gateLevel="A級傳送門1", lordName="未知魔物B", startImage=121001, lordImage = 104720,
         waitingArea={map=25008,X=85,Y=44}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=85,Y=44}},
      { lordNum=6, timesec=7200, limit=60, fallName="倒地的魔物A",gateLevel="A級傳送門2", lordName="未知魔物A", startImage=121001, lordImage = 104819,
         waitingArea={map=25008,X=54,Y=76}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=54,Y=76}},
      { lordNum=7, timesec=28800, limit=70, fallName="倒地的魔物S",gateLevel="S級傳送門", lordName="未知魔物S", startImage=121001, lordImage = 104706,
         waitingArea={map=25008,X=85,Y=76}, warpArea={map=43100,LX=78,LY=53, RX=162,RY=195}, bossArea={map=25007,X=85,Y=76}},
}
local tbl_duel_user = {};			--当前场次玩家的列表
local tbl_win_user = {};
local GateInfo = {}				--冷却时间表
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
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('LoopEvent', Func.bind(self.CrossGate_LoopEvent,self))
  for k,v in pairs(CrossGate) do
   if tbl_CrossGateNPCIndex[k] == nil then
    local CrossGateNPC = self:NPC_createNormal(v.fallName, v.lordImage, { map = v.waitingArea.map, x = v.waitingArea.X, y = v.waitingArea.Y, direction = 5, mapType = 0 })
    tbl_CrossGateNPCIndex[k] = CrossGateNPC
    Char.SetData(CrossGateNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
    self:NPC_regWindowTalkedEvent(tbl_CrossGateNPCIndex[k], function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
    if select == CONST.按钮_否 then
        return;
    elseif seqno == 1 and select == CONST.按钮_是 then
          --傳送門BOSS
          local playerName = Char.GetData(player,CONST.对象_名字);
          local partyname = playerName .. "－隊";
          local playerLv = Char.GetData(player,CONST.对象_等级);
          local gateName = Char.GetData(npc,CONST.对象_名字);
          local floor = Char.GetData(npc,CONST.对象_地图);
          for k,v in pairs(CrossGate) do
            if ( k==v.lordNum and gateName==v.gateLevel and floor==v.warpArea.map ) then
              if (playerLv < v.limit) then
                NLG.SystemMessage(player,"[系統]傳送門建議隊長等級要"..v.limit.."以上");
                return;
              else
                Char.Warp(player,0, v.bossArea.map, v.bossArea.X-10, v.bossArea.Y+10);
                Char.SetData(npc,CONST.对象_X, v.bossArea.X);
                Char.SetData(npc,CONST.对象_Y, v.bossArea.Y);
                Char.SetData(npc,CONST.对象_地图, v.bossArea.map);
                Char.SetData(npc,CONST.对象_名字, v.lordName);
                Char.SetData(npc,CONST.对象_形象, v.lordImage);
                NLG.UpChar(npc);
              end
            end
          end
    elseif seqno == 2 and select == CONST.按钮_是 then
          local gateName = Char.GetData(npc,CONST.对象_名字);
          local floor = Char.GetData(npc,CONST.对象_地图);
          for k,v in pairs(CrossGate) do
            if ( k==v.lordNum and gateName==v.lordName and floor==v.bossArea.map ) then
              table.insert(tbl_duel_user,player);
              table.insert(tbl_duel_user,npc);
              boss_round_start(player, npc, boss_round_callback);
            end
          end
    elseif seqno == 3 and select == CONST.按钮_是 then
          local gateName = Char.GetData(npc,CONST.对象_名字);
          local floor = Char.GetData(npc,CONST.对象_地图);
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
          local gateName = Char.GetData(npc,CONST.对象_名字);
          local floor = Char.GetData(npc,CONST.对象_地图);
          for k,v in pairs(CrossGate) do
            if ( k==v.lordNum and gateName==v.gateLevel and floor==v.warpArea.map ) then
                local msg = "\\n\\n@c【"..gateName.."】"
                  .."\\n\\n"
                  .."\\n請組建好攻略傳送門的隊伍\\n"
                  .."\\n是否進入傳送門？\\n";
                NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
            elseif ( k==v.lordNum and gateName==v.lordName and floor==v.bossArea.map ) then
                local msg = "\\n\\n@c【系統通知】"
                  .."\\n\\n"
                  .."\\n未知的魔物企圖消滅人類\\n"
                  .."\\n是否進入戰鬥？\\n";
                NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 2, msg);
            elseif ( k==v.lordNum and gateName==v.fallName and floor==v.waitingArea.map ) then
				NLG.SetAction(npc, CONST.动作_倒下);
                local msg = "\\n\\n@c【系統通知】"
                  .."\\n\\n"
                  .."\\n完成提取闇影士兵？\\n"
                  .."\\n是否離開傳送門？\\n";
                NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 3, msg);
            end
          end
      end
      return
    end)
   end
  end

  if (PowerOn==1) then 
    --重置
    GateInfo = {};
    GateSetting = {};
    for k=1,#CrossGate do
        --print(tbl_CrossGateNPCIndex[k])
        Char.SetLoopEvent('./lua/Modules/crossGate.lua','CrossGate_LoopEvent',tbl_CrossGateNPCIndex[k],60000);
        GateInfo[k] = os.time();
        GateSetting[k] = nil;
        GateCD[k] = 0;
    end
    --NLG.SystemMessage(charIndex, "[系統]傳送門開放。");
    --NLG.UpChar(charIndex);

    local gmIndex = NLG.FindUser(123456);
    --Char.SetExtData(gmIndex, '传送门冷却_set', JSON.encode(GateCD));
    local newdata = JSON.encode(GateCD);
    SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
    NLG.UpChar(gmIndex);
    PowerOn = 0;
  end

  GateMonitorNPC = self:NPC_createNormal('傳送門監控', 14682, { map = 777, x = 41, y = 32,  direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(GateMonitorNPC, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(GateMonitorNPC, function(npc, player)
    local gmIndex = NLG.FindUser(123456);
    local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='传送门冷却_set'")["0_0"])
    local GateCD = {};
    if (type(sqldata)=="string" and sqldata~='') then
        GateCD = JSON.decode(sqldata);
    else
        GateCD = {};
    end

    GateInfo = getGateInfo();
    winMsg = "\\n            ★★★★★★傳送門資訊★★★★★★"
          .. "\\n\\n  傳送門          所在位置             冷卻倒數\\n"
          .. "\\n═════════════════════════════"
      for k,v in pairs(CrossGate) do
        local floor = Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_地图)
        local bossImage = tonumber(GateCD[k]);
        if (k==v.lordNum and bossImage==v.lordImage and floor==v.waitingArea.map) then
          local Name = v.gateLevel;
          local mapsname = "消失中";
          local mapsX = "xxx";
          local mapsY = "yyy";
          local CTime = GateInfo[k] or os.time();
          local CDTime = ""..v.timesec - (os.time() - CTime).." 秒";
          winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
        elseif (k==v.lordNum and bossImage==0 and floor==v.warpArea.map) then
          local Name = v.gateLevel;
          local mapsname = NLG.GetMapName(0, v.warpArea.map);
          local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_X));
          local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_Y));
          local CDTime = "出現中";
          winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")     "..CDTime.."\\n"
        elseif (k==v.lordNum and bossImage==0 and floor==v.bossArea.map) then
          local Name = v.gateLevel;
          local mapsname = NLG.GetMapName(0, v.bossArea.map);
          local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_X));
          local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_Y));
          local CDTime = "被攻略";
          winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")     "..CDTime.."\\n"
        end
      end
      winMsg = winMsg .. "\\n═════════════════════════════";
      NLG.ShowWindowTalked(player,npc, CONST.窗口_巨信息框, CONST.按钮_关闭, 1, winMsg);
      return
  end)


  --通用抽取道具
  self:regCallback('ItemString', Func.bind(self.shadowExtraction, self),"LUA_useSdExtra");
  self.shadowExtractionNPC = self:NPC_createNormal('闇影抽取', 14682, { x = 41, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.shadowExtractionNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【闇影抽取】" ..	"\\n\\n\\n確定要嘗試抽取闇影士兵並存取？";
        NLG.ShowWindowTalked(player, self.shadowExtractionNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.shadowExtractionNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ComIndex =ComIndex;
    local ComSlot = ComSlot;
    local Target_FloorId = Char.GetData(player,CONST.对象_地图)--地图编号
    local Target_X = Char.GetData(player,CONST.对象_X)--地图x
    local Target_Y = Char.GetData(player,CONST.对象_Y)--地图y
    local playerLv = Char.GetData(player,CONST.对象_等级);
    if select > 0 then
      if seqno == 1 and Char.ItemSlot(player)==20 and select == CONST.按钮_是 then
                 NLG.SystemMessage(player,"[系統]物品欄位置已滿。");
                 return;
      elseif seqno == 1 and select == CONST.按钮_否 then
                 return;
      elseif seqno == 1 and select == CONST.按钮_是 then
          for k,v in pairs(CrossGate) do
		    if ( k==v.lordNum and Target_FloorId==v.waitingArea.map ) then
              if Target_X>=v.waitingArea.X-15 and Target_X<=v.waitingArea.X+3 and Target_Y>=v.waitingArea.Y-3 and Target_Y<=v.waitingArea.Y+15 then
		    	enemyId = Pos[k][2][1];	--10号位必为抽取对象enemyId
                goto continue
              end
		    end
          end
          ::continue::
          local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(enemyId);
          local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
          local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);
          local EnemyDataIndex = Data.EnemyGetDataIndex(enemyId)
          local enemyLevel = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_最高等级);
          local extraRate = NLG.Rand(1, 100);
          --print(extraRate)
          if (playerLv-enemyLevel)>=-10 then 
              success=20;
          elseif (playerLv-enemyLevel)<-10 and (playerLv-enemyLevel)>=-20 then 
              success=14;
          elseif (playerLv-enemyLevel)<-20 and (playerLv-enemyLevel)>=-30 then 
              success=6;
          elseif (playerLv-enemyLevel)<-30 then 
              success=1;	--99%失败
          end
          if (enemyId ~=nil and enemyId>0) then
              if (extraRate>success) then
                  Char.DelItem(player, 75027, 1);
                  NLG.Say(player,player,"起來 【Rise】！！",14,3);
                  NLG.PlaySe(player, 258, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                  NLG.SystemMessage(player,"[系統]提取失敗。");
                  return;
              end
              --道具栏空位置
              local EmptySlot = Char.GetItemEmptySlot(player);
              --if (NLG.Rand(0,1)==0) then	--抽取为宠物
                 Char.GiveItem(player, 75028, 1);
                 local ItemIndex = Char.GetItemIndex(player, EmptySlot);
                 Item.SetData(ItemIndex, CONST.道具_名字,EnemyName.."闇影士兵");
                 Item.SetData(ItemIndex,CONST.道具_子参一,enemyId);
                 Item.SetData(ItemIndex,CONST.道具_子参二,enemyLevel);
                 Item.UpItem(player, EmptySlot);
                 NLG.UpChar(player);
                 Char.DelItem(player, 75027, 1);
                 NLG.Say(player,player,"起來 【Rise】！！",14,3);
                 NLG.PlaySe(player, 257, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                 NLG.SystemMessage(player, "[系统]"..EnemyName.."成功提取為闇影士兵。")
              --[[elseif (NLG.Rand(0,1)==1) then	--抽取为佣兵
                 Char.GiveItem(player, 75029, 1);
                 local ItemIndex = Char.GetItemIndex(player, EmptySlot);
                 Item.SetData(ItemIndex, CONST.道具_名字,EnemyName.."闇影夥伴");
                 Item.SetData(ItemIndex,CONST.道具_子参一,50);
                 Item.SetData(ItemIndex,CONST.道具_子参二,heroesNo);
                 Item.UpItem(player, EmptySlot);
                 NLG.UpChar(player);
                 Char.DelItem(player, 75027, 1);
                 NLG.Say(player,player,"起來 【Rise】！！",14,3);
                 NLG.PlaySe(player, 257, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                 NLG.SystemMessage(player, "[系统]"..EnemyName.."成功提取為闇影夥伴。")
              end]]
          elseif (enemyId ==nil) then
              NLG.SystemMessage(player,"[系統]這邊無法使用闇影抽取。");
              return;
          else
              NLG.SystemMessage(player,"[系統]道具錯誤。");
              return;
          end
      else
              return;
      end
    end
  end)

  --通用召唤道具
  self:regCallback('ItemString', Func.bind(self.shadowSummon, self),"LUA_useSdSum");
  self.shadowSummonNPC = self:NPC_createNormal('闇影召喚', 14682, { x = 40, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.shadowSummonNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【闇影召喚】" ..	"\\n\\n\\n確定要放出存取的闇影士兵？";
        NLG.ShowWindowTalked(player, self.shadowSummonNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.shadowSummonNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local BallIndex =BallIndex;
    local BallSlot = BallSlot;
    local BallName = Item.GetData(BallIndex, CONST.道具_名字);
    local last = string.find(BallName, "闇", 1);
    local enemyName =string.sub(BallName, 1, last-1);
    local enemyId = Item.GetData(BallIndex,CONST.道具_子参一);
    local enemyLevel = Item.GetData(BallIndex,CONST.道具_子参二);
    if select > 0 then
      if seqno == 1 and Char.PetNum(player)==5 and select == CONST.按钮_是 then
                 NLG.SystemMessage(player,"[系統]寵物欄位置已滿。");
                 return;
      elseif seqno == 1 and select == CONST.按钮_否 then
                 return;
      elseif seqno == 1 and select == CONST.按钮_是 then
          if (enemyId ~=nil and enemyId>0) then
              Char.AddPet(player,enemyId);
              Char.DelItemBySlot(player, BallSlot);
              NLG.SystemMessage(player, "[系统]"..enemyName.."成功召喚出來。")
          else
              NLG.SystemMessage(player,"[系統]道具錯誤。");
              return;
          end
      else
              return;
      end
    end
  end)

end
------------------------------------------------
-------功能设置
--指令启动循环
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr gate on]") then
		local cdk = Char.GetData(charIndex,CONST.对象_CDK);
		if (cdk == "123456") then
			--重置
			GateInfo = {};
			GateSetting = {};
			for k=1,#CrossGate do
				--print(tbl_CrossGateNPCIndex[k])
				Char.SetLoopEvent('./lua/Modules/crossGate.lua','CrossGate_LoopEvent',tbl_CrossGateNPCIndex[k],60000);
				GateInfo[k] = os.time();
				GateSetting[k] = nil;
				GateCD[k] = 0;
			end
			NLG.SystemMessage(charIndex, "[系統]傳送門開放。");
			NLG.UpChar(charIndex);

			local gmIndex = NLG.FindUser(123456);
			Char.SetExtData(charIndex, '传送门冷却_set', JSON.encode(GateCD));
			local newdata = JSON.encode(GateCD);
			SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
			NLG.UpChar(gmIndex);
			return 0;
		end
	elseif (msg=="/cross") then
		local gmIndex = NLG.FindUser(123456);
		local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='传送门冷却_set'")["0_0"])
		local GateCD = {};
		if (type(sqldata)=="string" and sqldata~='') then
			GateCD = JSON.decode(sqldata);
		else
			GateCD = {};
		end

		GateInfo = getGateInfo();
		winMsg = "\\n            ★★★★★★傳送門資訊★★★★★★"
			.. "\\n\\n  傳送門          所在位置             冷卻倒數\\n"
			.. "\\n═════════════════════════════"
			for k,v in pairs(CrossGate) do
				local floor = Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_地图)
				local bossImage = tonumber(GateCD[k]);
				if (k==v.lordNum and bossImage==v.lordImage and floor==v.waitingArea.map) then
					local Name = v.gateLevel;
					local mapsname = "消失中";
					local mapsX = "xxx";
					local mapsY = "yyy";
					local CTime = GateInfo[k] or os.time();
					local CDTime = ""..v.timesec - (os.time() - CTime).." 秒";
					winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")        "..CDTime.."\\n"
				elseif (k==v.lordNum and bossImage==0 and floor==v.warpArea.map) then
					local Name = v.gateLevel;
					local mapsname = NLG.GetMapName(0, v.warpArea.map);
					local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_X));
					local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_Y));
					local CDTime = "出現中";
					winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")     "..CDTime.."\\n"
				elseif (k==v.lordNum and bossImage==0 and floor==v.bossArea.map) then
					local Name = v.gateLevel;
					local mapsname = NLG.GetMapName(0, v.bossArea.map);
					local mapsX = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_X));
					local mapsY = tonumber(Char.GetData(tbl_CrossGateNPCIndex[k],CONST.对象_Y));
					local CDTime = "被攻略";
					winMsg = winMsg .. "\\n  "..Name.."     "..mapsname.."("..mapsX..","..mapsY..")     "..CDTime.."\\n"
				end
			end
			winMsg = winMsg .. "\\n═════════════════════════════";
		NLG.ShowWindowTalked(charIndex, GateMonitorNPC, CONST.窗口_巨信息框, CONST.按钮_关闭, 1, winMsg);
		return 0;
	end
	return 1;
end
--转移
function CrossGate_LoopEvent(npc)
	local gmIndex = NLG.FindUser(123456);
	local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='传送门冷却_set'")["0_0"])
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
			--local bossImage = Char.GetData(npc,CONST.对象_形象);
			local gateName = Char.GetData(npc,CONST.对象_名字);
			if ( k==v.lordNum and gateName==v.fallName ) then
				GateInfo[k] = os.time();
				GateSetting[k] = 0;
				NLG.SystemMessage(-1,"[系統]"..v.gateLevel.."出現在"..mapsname.."("..v.warpArea.X..","..v.warpArea.Y..")");
				Char.SetData(npc,CONST.对象_X, warpX);
				Char.SetData(npc,CONST.对象_Y, warpY);
				Char.SetData(npc,CONST.对象_地图, v.warpArea.map);
				Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
				Char.SetData(npc,CONST.对象_名字, v.gateLevel);
				Char.SetData(npc,CONST.对象_形象, v.startImage);
				NLG.UpChar(npc);

				GateCD[k] = 0;
				--local newdata = JSON.encode(GateCD);
				--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
				--NLG.UpChar(gmIndex);
			end
		end
		end
		local newdata = JSON.encode(GateCD);
		--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
		SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
		NLG.UpChar(gmIndex);
	elseif (os.date("%M",os.time())=="15") or (os.date("%M",os.time())=="45") then
		if ( os.date("%S",os.time())=="00") or (os.date("%S",os.time())=="01") or (os.date("%S",os.time())=="02") or (os.date("%S",os.time())=="03") or (os.date("%S",os.time())=="04") or (os.date("%S",os.time())=="05") then
		for k,v in pairs(CrossGate) do
			--local bossImage = Char.GetData(npc,CONST.对象_形象);
			local gateName = Char.GetData(npc,CONST.对象_名字);
			if ( k==v.lordNum and bossImage==v.lordImage ) then
				Char.SetData(npc,CONST.对象_X, v.waitingArea.X);
				Char.SetData(npc,CONST.对象_Y, v.waitingArea.Y);
				Char.SetData(npc,CONST.对象_地图, v.waitingArea.map);
				Char.Warp(npc,0, v.waitingArea.map, v.waitingArea.X, v.waitingArea.Y);
				Char.SetData(npc,CONST.对象_名字, v.fallName);
				Char.SetData(npc,CONST.对象_形象, v.lordImage);
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
				--local bossImage = Char.GetData(npc,CONST.对象_形象);
				local gateName = Char.GetData(npc,CONST.对象_名字);
				if ( k==v.lordNum and gateName==v.fallName) then
					GateInfo[k] = os.time();
					GateSetting[k] = 0;
					NLG.SystemMessage(-1,"[系統]"..v.gateLevel.."出現在"..mapsname.."("..warpX..","..warpY..")");
					Char.SetData(npc,CONST.对象_X, warpX);
					Char.SetData(npc,CONST.对象_Y, warpY);
					Char.SetData(npc,CONST.对象_地图, v.warpArea.map);
					Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
					Char.SetData(npc,CONST.对象_名字, v.gateLevel);
					Char.SetData(npc,CONST.对象_形象, v.startImage);
					NLG.UpChar(npc);
				end
			elseif (GateSetting[k]==1) then
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				local gateName = Char.GetData(npc,CONST.对象_名字);
				if ( k==v.lordNum and gateName==v.fallName ) then
					GateSetting[k] = 0;
					NLG.SystemMessage(-1,"[系統]"..v.gateLevel.."出現在"..mapsname.."("..warpX..","..warpY..")");
					Char.SetData(npc,CONST.对象_X, warpX);
					Char.SetData(npc,CONST.对象_Y, warpY);
					Char.SetData(npc,CONST.对象_地图, v.warpArea.map);
					Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
					Char.SetData(npc,CONST.对象_名字, v.gateLevel);
					Char.SetData(npc,CONST.对象_形象, v.startImage);
					NLG.UpChar(npc);

					GateCD[k] = 0;
				end
			elseif (GateSetting[k]==2) then
				local CTime = GateInfo[k] or os.time();
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				--local bossImage = Char.GetData(npc,CONST.对象_形象);
				local gateName = Char.GetData(npc,CONST.对象_名字);
				if ( (os.time() - CTime) >= v.timesec and k==v.lordNum and gateName==v.fallName) then
					GateInfo[k] = os.time();
					GateSetting[k] = 1;
					NLG.SystemMessage(-1,"[系統]"..v.gateLevel.."出現在"..mapsname.."("..warpX..","..warpY..")");
					Char.SetData(npc,CONST.对象_X, warpX);
					Char.SetData(npc,CONST.对象_Y, warpY);
					Char.SetData(npc,CONST.对象_地图, v.warpArea.map);
					Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
					Char.SetData(npc,CONST.对象_名字, v.gateLevel);
					Char.SetData(npc,CONST.对象_形象, v.startImage);
					NLG.UpChar(npc);

					GateCD[k] = 0;
					--local newdata = JSON.encode(GateCD);
					--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
					--NLG.UpChar(gmIndex);
				elseif ( v.timesec - (os.time() - CTime) < 0 and k==v.lordNum and gateName==v.fallName) then
					GateInfo[k] = os.time();
					GateSetting[k] = 1;
					NLG.SystemMessage(-1,"[系統]"..v.gateLevel.."出現在"..mapsname.."("..warpX..","..warpY..")");
					Char.SetData(npc,CONST.对象_X, warpX);
					Char.SetData(npc,CONST.对象_Y, warpY);
					Char.SetData(npc,CONST.对象_地图, v.warpArea.map);
					Char.Warp(npc,0, v.warpArea.map, warpX, warpY);
					Char.SetData(npc,CONST.对象_名字, v.gateLevel);
					Char.SetData(npc,CONST.对象_形象, v.startImage);
					NLG.UpChar(npc);

					GateCD[k] = 0;
					--local newdata = JSON.encode(GateCD);
					--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
					--NLG.UpChar(gmIndex);
				end
			end
		end
		local newdata = JSON.encode(GateCD);
		--SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
		SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
		NLG.UpChar(gmIndex);

	end
end

function boss_round_start(player, npc, callback)

	--local npc = tbl_duel_user[2];
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);
	table.insert(tbl_duel_user,npc);

	--开始战斗
	tbl_UpIndex = {}
	battleindex = {}

	for k,v in pairs(CrossGate) do
		--local bossImage = Char.GetData(npc,CONST.对象_形象);
		local gateName = Char.GetData(npc,CONST.对象_名字);
		if ( k==v.lordNum and gateName==v.lordName ) then
			local battleindex = Battle.PVE( player, player, nil, Pos[k][2], Pos[k][3], nil)
			Battle.SetWinEvent("./lua/Modules/crossGate.lua", "boss_round_callback", battleindex);
			crossGateBattle={}
			table.insert(crossGateBattle, battleindex);
			Char.SetTempData(player, '传送门', npc);
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
	if ( Char.GetData(w1, CONST.对象_类型) >= CONST.对象类型_人) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, CONST.对象_类型) >= CONST.对象类型_人 ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	local player = tbl_win_user[1];
	--local npc = tbl_duel_user[2];

	--判定是哪个传送门
	local npc = Char.GetTempData(player, '传送门') or 0;
	--print(npc)

	for k,v in pairs(CrossGate) do
		--local bossImage = Char.GetData(npc,CONST.对象_形象);
		local gateName = Char.GetData(npc,CONST.对象_名字);
		if ( k==v.lordNum and gateName==v.lordName ) then
			NLG.SystemMessage(-1,"[公告] "..v.gateLevel.."被 "..Char.GetData(player,CONST.对象_名字).." 攻克了。");
			NLG.UpChar(player);
		end
	end

	--进入冷却时间
	local gmIndex = NLG.FindUser(123456);
	local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='传送门冷却_set'")["0_0"])
	local GateCD = {};
	if (type(sqldata)=="string" and sqldata~='') then
		GateCD = JSON.decode(sqldata);
	else
		GateCD = {};
	end
	for k,v in pairs(CrossGate) do
		local bossImage = Char.GetData(npc,CONST.对象_形象);
		local gateName = Char.GetData(npc,CONST.对象_名字);
		if ( k==v.lordNum and gateName==v.lordName ) then
			GateInfo[k] = os.time();
			GateSetting[k] = 2;
			--Char.SetData(npc,CONST.对象_X, v.waitingArea.X);
			--Char.SetData(npc,CONST.对象_Y, v.waitingArea.Y);
			--Char.SetData(npc,CONST.对象_地图, v.waitingArea.map);
			Char.Warp(npc,0, v.waitingArea.map, v.waitingArea.X, v.waitingArea.Y);
			Char.SetData(npc,CONST.对象_名字, v.fallName);
			Char.SetData(npc,CONST.对象_形象, v.lordImage);
			NLG.UpChar(npc);

			GateCD[k] = bossImage;
			local newdata = JSON.encode(GateCD);
			SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='传送门冷却_set'")
			NLG.UpChar(gmIndex);

			Char.Warp(player,0, v.waitingArea.map, v.waitingArea.X-3, v.waitingArea.Y+3);
		end
	end
	Battle.UnsetWinEvent(battleindex);
	crossGateBattle ={};
	Char.SetTempData(player, '传送门',0);
end

----------------------------------------------------------------
function Module:shadowExtraction(charIndex,targetIndex,itemSlot)
    ComItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    ComSlot =itemSlot;
    ComIndex = Char.GetItemIndex(charIndex,itemSlot);
    local msg = "\\n@c【闇影抽取】" ..	"\\n\\n\\n確定要嘗試抽取闇影士兵並存取？";
    NLG.ShowWindowTalked(charIndex, self.shadowExtractionNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    return 1;
end

function Module:shadowSummon(charIndex,targetIndex,itemSlot)
    BallItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    BallSlot =itemSlot;
    BallIndex = Char.GetItemIndex(charIndex,itemSlot);
    local msg = "\\n@c【闇影召喚】" ..	"\\n\\n\\n確定要放出存取的闇影士兵？";
    NLG.ShowWindowTalked(charIndex, self.shadowSummonNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;