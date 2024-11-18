---模块类
local Module = ModuleBase:createModule('palParade')

local PalEnemy = {
      { palType=1, palNum=5, enMode=1, palName="野生的帕魯", palImage=129024, popArea={map=7337,LX=32,LY=82, RX=79,RY=85},	--palNum生成数量、palImage外显形象(不重复)、出没范围(方形坐标)
         encount=30, prizeItem_id={15615,75011}, prizeItem_count={3,1} },						--encount遇敌机率、prizeItem奖励组合(可重复多组，提高该组合机率)
      { palType=2, palNum=4, enMode=1, palName="野生的帕魯", palImage=129025, popArea={map=7337,LX=26,LY=60, RX=59,RY=59},
         encount=30, prizeItem_id={900632,900633}, prizeItem_count={1,1} },
      { palType=3, palNum=3, enMode=1, palName="野生的帕魯", palImage=129026, popArea={map=7337,LX=49,LY=36, RX=61,RY=42},
         encount=30, prizeItem_id={13649,13669,13629}, prizeItem_count={1,1,1} },
      { palType=4, palNum=2, enMode=1, palName="野生的帕魯", palImage=129027, popArea={map=7337,LX=35,LY=21, RX=53,RY=30},
         encount=30, prizeItem_id={75011}, prizeItem_count={3} },
      { palType=5, palNum=3, enMode=0, palName="卡比獸", palImage=119750, popArea={map=20300,LX=276,LY=440, RX=331,RY=480},
         encount=60, prizeItem_id={51071}, prizeItem_count={3} },
      { palType=6, palNum=4, enMode=0, palName="化石飛龍", palImage=119752, popArea={map=20300,LX=415,LY=100, RX=510,RY=176},
         encount=60, prizeItem_id={51071}, prizeItem_count={3} },
      { palType=7, palNum=4, enMode=0, palName="班基拉", palImage=119754, popArea={map=20300,LX=410,LY=235, RX=535,RY=255},
         encount=60, prizeItem_id={51071}, prizeItem_count={3} },
      { palType=8, palNum=3, enMode=0, palName="請假王", palImage=119756, popArea={map=20300,LX=330,LY=444, RX=410,RY=490},
         encount=60, prizeItem_id={51071}, prizeItem_count={3} },
      { palType=9, palNum=3, enMode=0, palName="鐵掌力士", palImage=119758, popArea={map=20300,LX=60,LY=290, RX=246,RY=436},
         encount=60, prizeItem_id={51071}, prizeItem_count={3} },
      { palType=10, palNum=5, enMode=0, palName="波士可多拉", palImage=119760, popArea={map=20300,LX=75,LY=440, RX=205,RY=505},
         encount=60, prizeItem_id={51071}, prizeItem_count={3} },
      { palType=11, palNum=4, enMode=0, palName="烈咬陸鯊", palImage=119762, popArea={map=20300,LX=60,LY=230, RX=200,RY=265},
         encount=60, prizeItem_id={51071}, prizeItem_count={3} },
      { palType=12, palNum=4, enMode=0, palName="暴飛龍", palImage=119764, popArea={map=20300,LX=400,LY=300, RX=540,RY=400},
         encount=60, prizeItem_id={51071}, prizeItem_count={3} },
}
------------------------------------------------
local EnemySet = {}
local BaseLevelSet = {}
EnemySet[1] = {600101, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[1] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[2] = {600102, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[2] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[3] = {600103, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[3] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[4] = {600104, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[4] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[5] = {600074, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[5] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[6] = {600075, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[6] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[7] = {600076, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[7] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[8] = {600077, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[8] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[9] = {600078, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[9] = {30, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[10] = {600079, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[10] = {30, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[11] = {600080, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[11] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[12] = {600081, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[12] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
------------------------------------------------
local FTime = os.time();			--时间表
tbl_PalEnemyNPCIndex = tbl_PalEnemyNPCIndex or {}
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoopEvent', Func.bind(self.PalEnemy_LoopEvent,self))
  for k,v in pairs(PalEnemy) do
    if (tbl_PalEnemyNPCIndex[k] == nil) then
        tbl_PalEnemyNPCIndex[k] = {}
    end
    for i=1, v.palNum do
       if (tbl_PalEnemyNPCIndex[k][i] == nil) then
           local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
           local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
           local PalEnemyNPC = self:NPC_createNormal(v.palName, v.palImage, { map = v.popArea.map, x = palX, y = palY, direction = 5, mapType = 0 })
           tbl_PalEnemyNPCIndex[k][i] = PalEnemyNPC
           Char.SetLoopEvent('./lua/Modules/palParade.lua','PalEnemy_LoopEvent',tbl_PalEnemyNPCIndex[k][i], 1000);
           self:regCallback('CharActionEvent', function(player, actionID)
             local Target_FloorId = Char.GetData(player,CONST.CHAR_地图);
             if (actionID == CONST.动作_投掷 and Target_FloorId==7337 and v.enMode==1) then
                  local playerLv = Char.GetData(player,CONST.CHAR_等级);
                  if (playerLv<=100) then
                      NLG.SystemMessage(player,"[系統]等級須要100以上。");
                      return;
                  end
                  local npcImage = Char.GetData(tbl_PalEnemyNPCIndex[k][i],CONST.对象_形象);
                  local npc = tbl_PalEnemyNPCIndex[k][i];
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
                                local Target_FloorId = Char.GetData(player,CONST.CHAR_地图)--地图编号
                                local Target_X = Char.GetData(player,CONST.CHAR_X)--地图x
                                local Target_Y = Char.GetData(player,CONST.CHAR_Y)--地图y
                                Char.Warp(player,Target_MapId,Target_FloorId,Target_X,Target_Y);
                                NLG.UpChar(player);
                            end
                        end
                     end
                  end
             elseif (v.enMode==0) then
                      return;
             else
             end
           end)
           self:NPC_regWindowTalkedEvent(tbl_PalEnemyNPCIndex[k][i], function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
           end)
           self:NPC_regTalkedEvent(tbl_PalEnemyNPCIndex[k][i], function(npc, player)
             if(NLG.CheckInFront(player, npc, 1)==false) then
                 return ;
             end
             if (v.enMode==1 and NLG.CanTalk(npc, player) == true) then
                 NLG.SystemMessage(player,"[系統]請使用投擲動作抓捕帕魯。");
                 return ;
             elseif (v.enMode==0 and NLG.CanTalk(npc, player) == true) then
                  local playerLv = Char.GetData(player,CONST.CHAR_等级);
                  if (playerLv<=100) then
                      NLG.SystemMessage(player,"[系統]等級須要100以上。");
                      return;
                  end
                  local npcImage = Char.GetData(tbl_PalEnemyNPCIndex[k][i],CONST.对象_形象);
                  local npc = tbl_PalEnemyNPCIndex[k][i];
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
                                local Target_FloorId = Char.GetData(player,CONST.CHAR_地图)--地图编号
                                local Target_X = Char.GetData(player,CONST.CHAR_X)--地图x
                                local Target_Y = Char.GetData(player,CONST.CHAR_Y)--地图y
                                Char.Warp(player,Target_MapId,Target_FloorId,Target_X,Target_Y);
                                NLG.UpChar(player);
                            end
                        end
                     end
                  end

             end
             return
           end)
       end
    end
  end


end
------------------------------------------------
-------功能设置
--转移
function PalEnemy_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	if ( os.date("%M",os.time())=="15") or (os.date("%M",os.time())=="30") or (os.date("%M",os.time())=="45") or (os.date("%M",os.time())=="00") then
		if ( os.date("%S",os.time())=="00") or (os.date("%S",os.time())=="01") or (os.date("%S",os.time())=="02") then
		for k,v in pairs(PalEnemy) do
			local npcImage = Char.GetData(npc,CONST.对象_形象);
			if ( k==v.palType and npcImage==v.palImage ) then
				local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
				local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
				Char.SetData(npc,CONST.对象_X, palX);
				Char.SetData(npc,CONST.对象_Y, palY);
				Char.SetData(npc,CONST.对象_地图, v.popArea.map);
				NLG.UpChar(npc);
			end
		end
		end
	elseif (os.date("%X",os.time())=="23:59:59") or (os.date("%X",os.time())=="11:59:59") or (os.date("%X",os.time())=="12:59:59") or (os.date("%X",os.time())=="16:59:59") or (os.date("%X",os.time())=="17:59:59") or (os.date("%X",os.time())=="19:59:59") or (os.date("%X",os.time())=="20:59:59") or (os.date("%X",os.time())=="21:59:59") then
		for k,v in pairs(PalEnemy) do
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
	if (Char.GetData(npc,CONST.对象_地图)==7337 and excess>=7) then
		local dir = math.random(0, 7);
		local walk = 1;
		local X,Y = Char.GetLocation(npc,dir);
		if (NLG.Walkable(0, 7337, X, Y)==1) then
			NLG.SetAction(npc,walk);
			NLG.WalkMove(npc,dir);
			NLG.UpChar(npc);
		end
	elseif (Char.GetData(npc,CONST.对象_地图)==20300 and excess>=7) then
		local dir = math.random(0, 7);
		local walk = 1;
		local X,Y = Char.GetLocation(npc,dir);
		if (NLG.Walkable(0, 20300, X, Y)==1) then
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

Char.GetLocation = function(npc,dir)
	local X = Char.GetData(npc,CONST.CHAR_X)--地图x
	local Y = Char.GetData(npc,CONST.CHAR_Y)--地图y
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
