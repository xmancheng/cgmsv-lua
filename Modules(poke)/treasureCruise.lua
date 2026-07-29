---模块类
local Module = ModuleBase:createModule('treasureCruise')

-- 設置與變量定義
local MAP_ID = 64000			-- 副本活动地图 ID
local LX_LY = {245,105}			-- 副本活动地图左点(形成矩形范围)
local RX_RY = {450,300}			-- 副本活动地图右点(形成矩形范围)
local GOAL_SCORE = 1000			-- 通关所需积分
local REFRESH_MONITOR = 10		-- 监测至少不超过铜宝箱刷新(秒数)
local DEBUFF_TIME = 180			-- 处罚时间 (3分钟)
local DEBUFF_CHANCE = 30		-- 黑/红宝箱触发惩罚的机率 (%)
local Invitation_ItemID = 17910	-- 邀请函ItemID
local Global_ItemID = 17911		-- 环球积分ItemID

local BOX_SET = {
      { boxScores=1, boxNum=20, boxName="銅寶箱", boxImage=27894, spawnInterval=10, spawnMax=20 },	--积分、生成数量、名称、外显形象(不重复)、刷新间隔、数量上限
      { boxScores=5, boxNum=10, boxName="白寶箱", boxImage=27898, spawnInterval=20, spawnMax=10 },
      { boxScores=10, boxNum=5, boxName="黑寶箱", boxImage=27896, spawnInterval=30, spawnMax=5 },
      { boxScores=20, boxNum=2, boxName="紅寶箱", boxImage=27900, spawnInterval=60, spawnMax=2 },
}
------------------------------------------------
local LastSpawnTime = {0, 0, 0, 0}
local IsEventActive = false -- 活動開關
tbl_BoxNPCIndex = tbl_BoxNPCIndex or {}

function getStart()
	IsEventActive = true;
	return IsEventActive;
end
function setOver()
	IsEventActive = false;
	return IsEventActive;
end
function getBoxNPC()
	tbl = tbl_BoxNPCIndex;
	return tbl;
end
function setBoxNPC(tbl)
	tbl_BoxNPCIndex = tbl;
end
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoopEvent', Func.bind(Box_LoopEvent,self))
  self:regCallback('Box_LoopEvent', function(NPC)
    if not IsEventActive then return end
    local now = os.time()

    for k, v in pairs(BOX_SET) do
        if now - LastSpawnTime[k] >= v.spawnInterval then
            local spawned = 0
            for i = 1, v.boxNum do
                tbl_BoxNPCIndex = getBoxNPC();
                local boxNPC = tbl_BoxNPCIndex[k][i];
                if Char.GetData(boxNPC, CONST.对象_地图) == 777 then
                    repeat
                        bx = NLG.Rand(LX_LY[1], RX_RY[1]);
                        by = NLG.Rand(LX_LY[2], RX_RY[2]);
                    until (Map.IsWalkable(0, MAP_ID, bx-2, by+2) == 1) and (Map.IsWalkable(0, MAP_ID, bx+2, by-2) == 1)

                    Char.SetData(boxNPC, CONST.对象_X, bx);
                    Char.SetData(boxNPC, CONST.对象_Y, by);
                    Char.SetData(boxNPC, CONST.对象_地图, MAP_ID);
                    NLG.UpChar(boxNPC);

                    spawned = spawned + 1;
                    if spawned >= v.spawnMax then break end
                end
            end
            LastSpawnTime[k] = now
        end
    end
  end)
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self.CruiseNPC = self:NPC_createNormal('祕寶巡航', 14682, { x = 44, y = 38, mapType = 0, map = 777, direction = 0 });
  Char.SetData(self.CruiseNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  Char.SetLoopEvent('./lua/Modules/treasureCruise.lua','Box_LoopEvent',self.CruiseNPC, REFRESH_MONITOR*1000);
  self:NPC_regWindowTalkedEvent(self.CruiseNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if seqno == 1 then
      if select == CONST.按钮_是 then
        if (Char.HaveItem(player, Invitation_ItemID)>0) then
          NLG.SystemMessage(player, "[系統]已經有入場券了。");
          return;
        else
          Char.GiveItem(player, Invitation_ItemID, 1);
        end
      elseif select == CONST.按钮_否 then
        return;
      end
      return;
    else
      return;
    end
  end)
  self:NPC_regTalkedEvent(self.CruiseNPC, function(npc, player)
    if (NLG.CanTalk(npc, player)) then
        local msg = "@c【寶箱爭奪戰】\\n\\n"
               .. "GM發來的參與爭奪戰邀請函\\n"
               .. "\\n"
               .. "選擇「是」領取資格　選「否」將放棄參加\\n";
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
  end)


  --寶箱
  for k,v in pairs(BOX_SET) do
    if (tbl_BoxNPCIndex[k] == nil) then
        tbl_BoxNPCIndex[k] = {}
    end
    for i=1, v.boxNum do
       if (tbl_BoxNPCIndex[k][i] == nil) then
           --repeat
           --  boxX = NLG.Rand(LX_LY[1], RX_RY[1]);
           --  boxY = NLG.Rand(LX_LY[2], RX_RY[2]);
           --until (Map.IsWalkable(0, MAP_ID, boxX-2, boxY+2) == 1) and (Map.IsWalkable(0, MAP_ID, boxX+2, boxY-2) == 1)
           -- 初始化所有寶箱 NPC 到隱藏地圖 (777)
           BoxNPC = self:NPC_createNormal(v.boxName, v.boxImage, { map = 777, x = 43, y = 38, direction = 5, mapType = 0 })
           tbl_BoxNPCIndex[k][i] = BoxNPC;
           Char.SetData( tbl_BoxNPCIndex[k][i],CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
           self:NPC_regWindowTalkedEvent(tbl_BoxNPCIndex[k][i], function(npc, player, _seqno, _select, _data)
             local cdk = Char.GetData(player,CONST.对象_CDK);
             local seqno = tonumber(_seqno)
             local select = tonumber(_select)
             local data = tonumber(_data)
           end)
           self:NPC_regTalkedEvent(tbl_BoxNPCIndex[k][i], function(npc, player)
             if(NLG.CheckInFront(player, npc, 1)==false) then
                 return ;
             end
             if (NLG.CanTalk(npc, player) == true) then
                local npcImage = Char.GetData(tbl_BoxNPCIndex[k][i],CONST.对象_形象);
                local npc = tbl_BoxNPCIndex[k][i];
                if (npcImage==v.boxImage) then
                  -- 檢查是否處於懲罰期Char.GetTempData(v, 'is_debuffed')
                  if Char.GetTempData(player, 'is_debuffed') > os.time() then
                      NLG.SystemMessage(player, "你現在手太累了，暫時無法開啟任何寶箱！")
                      return
                  end

                  local score_add = v.boxScores or 0;
                  local current_score = Char.GetTempData(player, 'current_score') or 0;
    
                  -- 更新積分
                  Char.SetTempData(player, 'current_score', current_score + score_add)
                  NLG.SystemMessage(player, "打開 " .. v.boxName .. " 積分 "..current_score.. "+" ..score_add);

                  -- 黑寶箱與紅寶箱的懲罰機率
                  if (v.boxName == "黑寶箱" or v.boxName == "紅寶箱") then
                      if (math.random(1, 100) <= DEBUFF_CHANCE) then
                          Char.SetTempData(player, 'is_debuffed', os.time() + DEBUFF_TIME);
                          NLG.SystemMessage(player, "【糟糕！】寶箱機關觸發，你 3 分鐘內無法開啟寶箱！");
                      end
                  end

                  -- 檢查是否達到 1000 分通關
                  local players = NLG.GetPlayer()--获取在线玩家表
                  local TOTAL_SCORE = getAllPlayerScore(players)
                  if (TOTAL_SCORE >= GOAL_SCORE) then		--玩家们需要凑齐1000分方可通关
                      OnPlayer_Win(players,self.CruiseNPC);
                  end

                  --寶箱消失畫面刷新
                  Box_Clear(player, npc)
                  local Target_MapId = Char.GetData(player,CONST.对象_MAP)--地图类型
                  local Target_FloorId = Char.GetData(player,CONST.对象_地图)--地图编号
                  local Target_X = Char.GetData(player,CONST.对象_X)--地图x
                  local Target_Y = Char.GetData(player,CONST.对象_Y)--地图y
                  Char.Warp(player,Target_MapId,Target_FloorId,Target_X,Target_Y);
                  NLG.UpChar(player);
                end
             end
             return
           end)
       end
    end
    setBoxNPC(tbl_BoxNPCIndex);
  end


end
------------------------------------------------
-- UI 顯示
function Module:Cruise(npc, player)
	local msg = "@c【寶箱爭奪戰】\\n\\n"
		.. "GM發來的參與爭奪戰邀請函\\n"
		.. "\\n"
		.. "選擇「是」領取資格　選「否」將放棄參加\\n";
	NLG.ShowWindowTalked(player, self.CruiseNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
end
function Module:handleTalkEvent(player,msg,color,range,size)
	if (Char.GetData(player,CONST.对象_GM)==1 and msg=="[treasure Invitation]") then
		local MapUser = NLG.GetMapPlayer(0,MAP_ID);--获取并清理争夺战场地
		if (MapUser~=-3) then
			for _,v in pairs(MapUser) do
				Char.Warp(v,0,1000,242,88);
			end
		end
		players = NLG.GetPlayer()--获取在线玩家表
		for k, v in pairs(players) do
			if (Char.IsPlayer(v)==true) then
				NLG.SystemMessage(v,"【活動公告】寶箱爭奪戰即將開始！想要參加的玩家請點選「是」領取入場券。");
				self:Cruise(self.CruiseNPC,v);
			end
		end
		return 0;
	elseif (Char.GetData(player,CONST.对象_GM)==1 and msg=="[treasure Start]") then
		players = NLG.GetPlayer()--获取在线玩家表
		for k, v in pairs(players) do
			if (Char.IsPlayer(v)==true and Char.HaveItem(v, Invitation_ItemID)>0) then
				if (Char.GetData(v, CONST.对象_地图) ~= MAP_ID) then
					NLG.SystemMessage(v,"【活動公告】傳送所有擁有入場券的玩家參與寶箱爭奪戰！");
					repeat
						playerX = NLG.Rand(LX_LY[1], RX_RY[1]);
						playerY = NLG.Rand(LX_LY[2], RX_RY[2]);
					until (Map.IsWalkable(0, MAP_ID, playerX-2, playerY+2) == 1) and (Map.IsWalkable(0, MAP_ID, playerX+2, playerY-2) == 1)
					Char.Warp(v, 0, MAP_ID, playerX, playerY);
					Char.SetTempData(v, 'current_score', 0);		-- 初始化玩家積分
					Char.SetTempData(v, 'is_debuffed', 0);			-- 初始化負面狀態
					NLG.SystemMessage(v,"【活動公告】你已進入寶箱爭奪戰地圖！努力搶奪積分吧！");
					NLG.UpChar(v);
				end
			end
		end
		--爭奪戰開始
		IsEventActive = getStart();
		tbl_BoxNPCIndex = tbl_BoxNPCIndex;
		Char.SetLoopEvent('./lua/Modules/treasureCruise.lua','Box_LoopEvent',self.CruiseNPC, REFRESH_MONITOR*1000);
		--[[for r,t in pairs(BOX_SET) do
			for i=1, t.boxNum do	
				Box_ResetEvent(tbl_BoxNPCIndex[r][i]);
			end
		end]]
		return 0;
	end
	return 1;
end

--开始宝箱位置重置
--[[function Box_ResetEvent(npc)
	if (Char.GetData(npc,CONST.对象_地图)==777 or Char.GetData(npc,CONST.对象_地图)==MAP_ID) then
		repeat
			boxX = NLG.Rand(LX_LY[1], RX_RY[1]);
			boxY = NLG.Rand(LX_LY[2], RX_RY[2]);
		until (Map.IsWalkable(0, MAP_ID, boxX-2, boxY+2) == 1) and (Map.IsWalkable(0, MAP_ID, boxX+2, boxY-2) == 1)
		Char.SetData(npc,CONST.对象_X, boxX);
		Char.SetData(npc,CONST.对象_Y, boxY);
		Char.SetData(npc,CONST.对象_地图, MAP_ID);
		NLG.UpChar(npc);
	end
end]]
--[[function Box_LoopEvent(npc)
	IsEventActive = getStart();
	if not IsEventActive then return end
	local now = os.time()

	for k, v in pairs(BOX_SET) do
		if now - LastSpawnTime[k] >= v.spawnInterval then
			local spawned = 0
			for i = 1, v.boxNum do
				tbl_BoxNPCIndex = getBoxNPC();
				local boxNPC = tbl_BoxNPCIndex[k][i];
				if Char.GetData(boxNPC, CONST.对象_地图) == 777 then
					repeat
						bx = NLG.Rand(LX_LY[1], RX_RY[1]);
						by = NLG.Rand(LX_LY[2], RX_RY[2]);
					until (Map.IsWalkable(0, MAP_ID, bx-2, by+2) == 1) and (Map.IsWalkable(0, MAP_ID, bx+2, by-2) == 1)

					Char.SetData(boxNPC, CONST.对象_X, bx);
					Char.SetData(boxNPC, CONST.对象_Y, by);
					Char.SetData(boxNPC, CONST.对象_地图, MAP_ID);
					NLG.UpChar(boxNPC);

					spawned = spawned + 1;
					if spawned >= v.spawnMax then break end
				end
			end
			LastSpawnTime[k] = now
		end
	end
end]]
--转移至隐藏空间
function Box_Clear(player, npc)
	Char.SetData(npc,CONST.对象_X, 43);
	Char.SetData(npc,CONST.对象_Y, 38);
	Char.SetData(npc,CONST.对象_地图, 777);
	NLG.UpChar(npc);
end
--计算全体总积分
function getAllPlayerScore(players)
	local total = 0;
	for k, v in pairs(players) do
		if (Char.IsPlayer(v)==true and Char.HaveItem(v, Invitation_ItemID)>0) then
			local player_score = Char.GetTempData(v, 'current_score') or 0;
			total = total + player_score;
		end
	end
	return total
end
--排名玩家积分
function Event_Ranking(players)
	local rank_tbl = {}
	for k, v in pairs(players) do
		if (Char.IsPlayer(v)==true and Char.HaveItem(v, Invitation_ItemID)>0) then
			local cdk = Char.GetData(v,CONST.对象_CDK);
			local player_score = Char.GetTempData(v, 'current_score') or 0;
			-- 插入表格：包含玩家指針、CDK與積分
			table.insert(rank_tbl, {player_ptr=v, cdk=cdk, score=player_score} );
		end
	end
	-- 使用 table.sort 進行降序排序
	table.sort(rank_tbl, function(a, b)
		return a.score > b.score
	end)
	return rank_tbl
end
--該玩家的排名
function Event_GetPlayerRank(rank_tbl,player)
	local player_cdk = Char.GetData(player,CONST.对象_CDK);
	for rank, data in ipairs(rank_tbl) do
		if data.cdk == player_cdk then
		return rank;	-- 返回索引值，即為排名 (1, 2, 3...)
		end
	end
    return nil;
end
--结算与奖励发放
function OnPlayer_Win(players,NPC)
	IsEventActive = false -- 停止 Loop 刷新
	-- 伺服器全局排名
	local rank_tbl = Event_Ranking(players)

	--玩家排名確認
	for k, v in pairs(players) do
		local rank = Event_GetPlayerRank(rank_tbl,v);
		local points = 0

		if rank == 1 then points = 1000
		elseif rank == 2 then points = 800
		elseif rank == 3 then points = 500
		elseif rank == 4 then points = 300
		else points = 0 end

		-- 發放環球積分道具
		if points > 0 then
			Char.GiveItem(v, Global_ItemID, points);
		end
		-- 全服公告
		if (rank~=nil) then
			NLG.SystemMessage(-1,"恭喜玩家 [" .. Char.GetData(v,CONST.对象_名字) .. "] 獲得寶箱爭奪戰第 " .. rank .. " 名！");
		end
		-- 傳送回主城並清理入場券
		Char.DelItem(v, Invitation_ItemID, 1);
		Char.Warp(v,0,1000, 242, 88);

		-- 回收地圖上所有寶箱
		for r, t in pairs(BOX_SET) do
			for i = 1, t.boxNum do
				Char.SetData(tbl_BoxNPCIndex[r][i],CONST.对象_X, 43);
				Char.SetData(tbl_BoxNPCIndex[r][i],CONST.对象_Y, 38);
				Char.SetData(tbl_BoxNPCIndex[r][i],CONST.对象_地图, 777);
				NLG.UpChar(tbl_BoxNPCIndex[r][i]);
			end
		end
		IsEventActive = setOver();
		Char.SetLoopEvent('./lua/Modules/treasureCruise.lua','Box_LoopEvent',NPC,0);
	end
end
--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;