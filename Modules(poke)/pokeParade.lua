---模块类
local Module = ModuleBase:createModule('pokeParade')

local PokeEnemy = {
      { palType=1, palNum=20, enMode=0, palName="野生寶可夢", palImage=121000, popArea={map=80028,LX=60,LY=70, RX=130,RY=140},	--palNum生成数量、palImage外显形象(不重复)、出没范围(方形坐标)
         encount=80, prizeItem_id={75024,74200}, prizeItem_count={1,1} },						--encount遇敌机率、prizeItem奖励组合(可重复多组，提高该组合机率)
      { palType=2, palNum=15, enMode=0, palName="野生寶可夢", palImage=121091, popArea={map=80028,LX=60,LY=70, RX=130,RY=140},
         encount=80, prizeItem_id={75024,74200}, prizeItem_count={1,1} },
      { palType=3, palNum=10, enMode=0, palName="野生寶可夢", palImage=121021, popArea={map=80028,LX=60,LY=70, RX=130,RY=140},
         encount=80, prizeItem_id={75024,74200}, prizeItem_count={1,1} },
      { palType=4, palNum=5, enMode=0, palName="野生寶可夢", palImage=121115, popArea={map=80028,LX=60,LY=70, RX=130,RY=140},
         encount=80, prizeItem_id={75024,74200}, prizeItem_count={3,3} },
      { palType=5, palNum=1, enMode=2, palName="區域頭目", palImage=121046, popArea={map=80028,LX=91,LY=100, RX=96,RY=95},
         encount=100, prizeItem_id={75025}, prizeItem_count={1} },
      { palType=6, palNum=1, enMode=3, palName="區域頭目", palImage=121047, popArea={map=80028,LX=102,LY=95, RX=107,RY=100},
         encount=100, prizeItem_id={75025}, prizeItem_count={1} },
      { palType=7, palNum=1, enMode=4, palName="區域領主", palImage=121286, popArea={map=80028,LX=67,LY=74, RX=130,RY=79},
         encount=100, prizeItem_id={75026}, prizeItem_count={1} },
}
------------------------------------------------
local EnemySet = {}
local BaseLevelSet = {}
EnemySet[1] = {416360, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[1] = {30, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[2] = {416434, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[2] = {40, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[3] = {416380, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[3] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[4] = {416459, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[4] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[5] = {416402, 0, 0, 0, 0, 416398, 416398, 416398, 416398, 416398}	--0代表没有怪
BaseLevelSet[5] = {150, 0, 0, 0, 0, 120, 120, 120, 120, 120}
EnemySet[6] = {416403, 0, 0, 0, 0, 416399, 416399, 416399, 416399, 416399}	--0代表没有怪
BaseLevelSet[6] = {150, 0, 0, 0, 0, 120, 120, 120, 120, 120}
EnemySet[7] = {416356, 0, 0, 416426, 416426, 0, 416427, 416427, 0, 0}	--0代表没有怪
BaseLevelSet[7] = {150, 0, 0, 130, 130, 0, 130, 130, 0, 0}
------------------------------------------------
local FTime = os.time();			--时间表
tbl_PokeEnemyNPCIndex = tbl_PokeEnemyNPCIndex or {}
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoopEvent', Func.bind(self.PokeEnemy_LoopEvent,self))
  for k,v in pairs(PokeEnemy) do
    if (tbl_PokeEnemyNPCIndex[k] == nil) then
        tbl_PokeEnemyNPCIndex[k] = {}
    end
    for i=1, v.palNum do
       if (tbl_PokeEnemyNPCIndex[k][i] == nil) then
           local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
           local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
           local PokeEnemyNPC = self:NPC_createNormal(v.palName, v.palImage, { map = v.popArea.map, x = palX, y = palY, direction = 5, mapType = 0 })
           tbl_PokeEnemyNPCIndex[k][i] = PokeEnemyNPC
           Char.SetLoopEvent('./lua/Modules/pokeParade.lua','PokeEnemy_LoopEvent',tbl_PokeEnemyNPCIndex[k][i], 1000);
           self:regCallback('CharActionEvent', function(player, actionID)
             local Target_FloorId = Char.GetData(player,CONST.对象_地图);
             if (actionID == CONST.动作_攻击 and Target_FloorId==80028 and v.enMode==1) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.对象_形象);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        if ( Char.ItemSlot(player)>19)then
                            NLG.SystemMessage(player,"[系統]物品欄已滿。");
                            return;
                        else
                            if( NLG.Rand(1,100) <= v.encount )then
                                Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                                pal_clear(player, npc);
                            else
                                local rand = NLG.Rand(1,#v.prizeItem_id);
                                Char.GiveItem(player, v.prizeItem_id[rand], v.prizeItem_count[rand]);
                                pal_clear(player, npc);
                                local Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--地图类型
                                local Target_FloorId = Char.GetData(player,CONST.对象_地图)--地图编号
                                local Target_X = Char.GetData(player,CONST.对象_X)--地图x
                                local Target_Y = Char.GetData(player,CONST.对象_Y)--地图y
                                Char.Warp(player,Target_MapId,Target_FloorId,Target_X,Target_Y);
                                NLG.UpChar(player);
                            end
                        end
                     end
                  end
             elseif (v.enMode==0 or v.enMode==2) then
                      return;
             else
             end
           end)

           self:NPC_regWindowTalkedEvent(tbl_PokeEnemyNPCIndex[k][i], function(npc, player, _seqno, _select, _data)
             local cdk = Char.GetData(player,CONST.对象_CDK);
             local seqno = tonumber(_seqno)
             local select = tonumber(_select)
             local data = tonumber(_data)
           end)
           self:NPC_regTalkedEvent(tbl_PokeEnemyNPCIndex[k][i], function(npc, player)
             if(NLG.CheckInFront(player, npc, 1)==false) then
                 return ;
             end
             if (v.enMode==1 and NLG.CanTalk(npc, player) == true) then
                 NLG.SystemMessage(player,"[系統]請使用攻擊動作抓捕。");
                 return ;
             elseif (v.enMode==0 and NLG.CanTalk(npc, player) == true) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.对象_形象);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        --if ( Char.ItemSlot(player)>19)then
                            --NLG.SystemMessage(player,"[系統]物品欄已滿。");
                            --return;
                        --else
                            --if( NLG.Rand(1,100) <= v.encount )then
                                Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                                pal_clear(player, npc);
                            --else
                            --    local rand = NLG.Rand(1,#v.prizeItem_id);
                            --    Char.GiveItem(player, v.prizeItem_id[rand], v.prizeItem_count[rand]);
                            --    pal_clear(player, npc);
                            --    local Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--地图类型
                            --    local Target_FloorId = Char.GetData(player,CONST.对象_地图)--地图编号
                            --    local Target_X = Char.GetData(player,CONST.对象_X)--地图x
                            --    local Target_Y = Char.GetData(player,CONST.对象_Y)--地图y
                            --    Char.Warp(player,Target_MapId,Target_FloorId,Target_X,Target_Y);
                            --    NLG.UpChar(player);
                            --end
                        --end
                     end
                  end
             elseif (v.enMode==2 and NLG.CanTalk(npc, player) == true) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.对象_形象);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        if ( Char.HaveItem(player, 631085)<0 and Char.HaveItem(player, 631086)<0 )then
                            NLG.SystemMessage(player,"[系統]缺少字卡「挑」、字卡「戰」。");
                            return;
                        elseif ( Char.HaveItem(player, 631085)<0 and Char.HaveItem(player, 631086)>0 )then
                            NLG.SystemMessage(player,"[系統]缺少字卡「挑」。");
                            return;
                        elseif ( Char.HaveItem(player, 631085)>0 and Char.HaveItem(player, 631086)<0 )then
                            NLG.SystemMessage(player,"[系統]缺少字卡「戰」。");
                            return;
                        end
                        Char.DelItem(player,631085,1,1);
                        Char.DelItem(player,631086,1,1);
                        local battleIndex = Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                        Battle.SetWinEvent("./lua/Modules/pokeParade.lua", "paradeBossNPC_BattleWin", battleIndex);
                        pal_clear(player, npc);
                     end
                  end
             elseif (v.enMode==3 and NLG.CanTalk(npc, player) == true) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.对象_形象);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        if ( Char.HaveItem(player, 631087)<0 and Char.HaveItem(player, 631088)<0 )then
                            NLG.SystemMessage(player,"[系統]缺少字卡「區」、字卡「域」。");
                            return;
                        elseif ( Char.HaveItem(player, 631087)<0 and Char.HaveItem(player, 631088)>0 )then
                            NLG.SystemMessage(player,"[系統]缺少字卡「區」。");
                            return;
                        elseif ( Char.HaveItem(player, 631087)>0 and Char.HaveItem(player, 631088)<0 )then
                            NLG.SystemMessage(player,"[系統]缺少字卡「域」。");
                            return;
                        end
                        Char.DelItem(player,631087,1,1);
                        Char.DelItem(player,631088,1,1);
                        local battleIndex = Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                        Battle.SetWinEvent("./lua/Modules/pokeParade.lua", "paradeBossNPC_BattleWin", battleIndex);
                        pal_clear(player, npc);
                     end
                  end
             elseif (v.enMode==4 and NLG.CanTalk(npc, player) == true) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.对象_形象);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        if ( Char.HaveItem(player, 631085)<0 or Char.HaveItem(player, 631086)<0 or Char.HaveItem(player, 631087)<0 or Char.HaveItem(player, 631088)<0 or Char.HaveItem(player, 631089)<0 or Char.HaveItem(player, 631090)<0 )then
                            NLG.SystemMessage(player,"[系統]集齊字卡「挑」、「戰」、「區」、「域」、「領」、「主」。");
                            return;
                        end
                        Char.DelItem(player,631085,1,1);
                        Char.DelItem(player,631086,1,1);
                        Char.DelItem(player,631087,1,1);
                        Char.DelItem(player,631088,1,1);
                        Char.DelItem(player,631089,1,1);
                        Char.DelItem(player,631090,1,1);
                        local battleIndex = Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                        Battle.SetWinEvent("./lua/Modules/pokeParade.lua", "paradeLordNPC_BattleWin", battleIndex);
                        pal_clear(player, npc);
                     end
                  end
             end
             return
           end)
       end
    end
  end

  huntingNPC = self:NPC_createNormal('狩獵祭大會報名', 14580, { map = 80010, x = 106, y = 96, direction = 4, mapType = 0 })
  Char.SetData(huntingNPC,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(huntingNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if seqno == 1 then  ----报名对战执行
     if select == 4 then
       if (os.date("%H",os.time())~="20") then
         NLG.SystemMessage(player,"[大會公告]報名入場時間為每日20:00-20:29！");
         return;
       end
       if (os.date("%H",os.time())=="20") and (os.date("%M",os.time())>="31") then
         NLG.SystemMessage(player,"[大會公告]狩獵祭大會已經開始，請等待明日報名！");
         return;
       end
       Char.Warp(player,0,80028,98,139);
     else
       return 0;
     end
    end

  end)
  self:NPC_regTalkedEvent(huntingNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c狩獵祭大會說明\\n"
                  .. "\\n每日晚上八點報名進入\\n"
                  .. "半小時後關閉報名入場\\n"
                  .. "每次大會時間為一小時\\n\\n"
                  .. "組合掉落字卡進行對戰\\n"
                  .. "收集字卡兌換各式獎品\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)


end
------------------------------------------------
-------功能设置
--转移
function PokeEnemy_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	if (os.date("%X",os.time())=="19:59:59") then
		local MapUser = NLG.GetMapPlayer(0,80028);
		if (MapUser~=-3) then
			for _,v in pairs(MapUser) do
				Char.Warp(v,0,80010,103,103);
			end
		end
		NLG.SystemMessage(-1,"[大會公告]狩獵祭大會即將開始，請盡速報名入場。");
	elseif (os.date("%X",os.time())=="20:20:00") then
		NLG.SystemMessage(-1,"[大會公告]狩獵祭大會報名剩下10分鐘，請盡速報名入場。");
	elseif (os.date("%X",os.time())=="21:00:00") then
		local MapUser = NLG.GetMapPlayer(0,80028);
		if (MapUser~=-3) then
			for _,v in pairs(MapUser) do
				Char.Warp(v,0,80010,103,103);
			end
		end
		NLG.SystemMessage(-1,"[大會公告]本日狩獵祭大會已結束，將傳送參加者離場。");
	--[[elseif (os.date("%H",os.time())~="20") then
		local MapUser = NLG.GetMapPlayer(0,80028);
		if (MapUser~=-3) then
			for _,v in pairs(MapUser) do
				Char.Warp(v,0,80010,103,103);
			end
		end]]
	elseif (os.date("%M",os.time())=="08") or (os.date("%M",os.time())=="16") or (os.date("%M",os.time())=="24") or (os.date("%M",os.time())=="32") or (os.date("%M",os.time())=="40") or (os.date("%M",os.time())=="48") or (os.date("%M",os.time())=="56") or (os.date("%M",os.time())=="00") then
		if (os.date("%S",os.time())=="00") or (os.date("%S",os.time())=="01") then
		for k,v in pairs(PokeEnemy) do
			local npcImage = Char.GetData(npc,CONST.对象_形象);
			local npcFloorId = Char.GetData(npc,CONST.对象_地图);
			if ( k==v.palType and npcImage==v.palImage and npcFloorId==777 ) then
				local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
				local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
				Char.SetData(npc,CONST.对象_X, palX);
				Char.SetData(npc,CONST.对象_Y, palY);
				Char.SetData(npc,CONST.对象_地图, v.popArea.map);
				NLG.UpChar(npc);
			end
		end
		end
	elseif (os.date("%X",os.time())=="23:59:59") or (os.date("%X",os.time())=="19:59:59") then
		for k,v in pairs(PokeEnemy) do
			local npcImage = Char.GetData(npc,CONST.对象_形象);
			if ( k==v.palType and npcImage==v.palImage ) then
				Char.SetData(npc,CONST.对象_X, 43);
				Char.SetData(npc,CONST.对象_Y, 38);
				Char.SetData(npc,CONST.对象_地图, 777);
				NLG.UpChar(npc);
			end
		end
	end
	local excess = math.random(1,10);
	if (Char.GetData(npc,CONST.对象_地图)==80028 and excess>=7) then
		local dir = math.random(0, 7);
		local walk = 1;
		local X,Y = Char.GetLocation(npc,dir);
		if (NLG.Walkable(0, 80028, X, Y)==1) then
			NLG.SetAction(npc,walk);
			NLG.WalkMove(npc,dir);
			NLG.UpChar(npc);
		end
	end
end

function pal_clear(player, npc)
	--转移至隐藏空间
	Char.SetData(npc,CONST.对象_X, 43);
	Char.SetData(npc,CONST.对象_Y, 38);
	Char.SetData(npc,CONST.对象_地图, 777);
	NLG.UpChar(npc);
end

function paradeBossNPC_BattleWin(battleIndex, charIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end

	if (Char.GetData(charIndex, CONST.对象_地图)==80028) then
	--分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = {0,0,0,0,0,1,1,1,1,1,}
		local rand = drop[NLG.Rand(1,10)];
		local dropMenu = {70052,70052,68018};
		if player>=0 and Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
			Char.GiveItem(player, dropMenu[NLG.Rand(1,3)], rand);
		end
	end
	end
	Battle.UnsetWinEvent(battleIndex);
end

function paradeLordNPC_BattleWin(battleIndex, charIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end

	if (Char.GetData(charIndex, CONST.对象_地图)==80028) then
	--分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = {0,0,0,0,0,1,1,1,1,1,}
		local rand = drop[NLG.Rand(1,10)];
		local dropMenu = {70052,70052,68017};
		if player>=0 and Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
			Char.GiveItem(player, dropMenu[NLG.Rand(1,3)], rand);
		end
	end
	end
	Battle.UnsetWinEvent(battleIndex);
end

Char.GetLocation = function(npc,dir)
	local X = Char.GetData(npc,CONST.对象_X)--地图x
	local Y = Char.GetData(npc,CONST.对象_Y)--地图y
	if dir==0 then
		Y=Y-1;
	elseif dir==1 then
		X=X+1;
		Y=Y-1;
	elseif dir==2 then
		X=X+1;
	elseif dir==3 then
		X=X+1;
		Y=Y+1;
	elseif dir==4 then
		Y=Y+1;
	elseif dir==5 then
		X=X-1;
		Y=Y+1;
	elseif dir==6 then
		X=X-1;
	elseif dir==7 then
		X=X-1;
		Y=Y-1;
	end
	return X,Y;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end


return Module;
