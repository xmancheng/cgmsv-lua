---模块类
local Module = ModuleBase:createModule('seaParade')

local PalEnemy = {
      { palType=1, palNum=2, enMode=1, palName="小丑魚", palImage=108136, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},	--palNum生成数量、palImage外显形象(不重复)、出没范围(方形坐标)
         encount=0, prizeItem_id={50005}, prizeItem_count={1} },						--encount遇敌机率、prizeItem奖励组合(可重复多组，提高该组合机率)
      { palType=2, palNum=2, enMode=1, palName="小丑魚", palImage=108137, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},
         encount=0, prizeItem_id={50006}, prizeItem_count={1} },
      { palType=3, palNum=2, enMode=1, palName="小丑魚", palImage=108138, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},
         encount=0, prizeItem_id={50001}, prizeItem_count={1} },
      { palType=4, palNum=2, enMode=1, palName="小丑魚", palImage=108139, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},
         encount=0, prizeItem_id={50002}, prizeItem_count={1} },
      { palType=5, palNum=1, enMode=1, palName="小丑魚霸王", palImage=108141, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},
         encount=0, prizeItem_id={50003}, prizeItem_count={2} },

      { palType=6, palNum=2, enMode=1, palName="水母", palImage=108123, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={49002}, prizeItem_count={1} },
      { palType=7, palNum=2, enMode=1, palName="水母", palImage=108124, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={50017}, prizeItem_count={1} },
      { palType=8, palNum=2, enMode=1, palName="水母", palImage=108125, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={50001}, prizeItem_count={1} },
      { palType=9, palNum=2, enMode=1, palName="水母", palImage=108126, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={50011}, prizeItem_count={1} },
      { palType=10, palNum=1, enMode=1, palName="水母霸王", palImage=108127, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={50004}, prizeItem_count={2} },

      { palType=11, palNum=2, enMode=1, palName="魷魚", palImage=108117, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50014}, prizeItem_count={1} },
      { palType=12, palNum=2, enMode=1, palName="魷魚", palImage=108118, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50016}, prizeItem_count={1} },
      { palType=13, palNum=2, enMode=1, palName="魷魚", palImage=108119, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50018}, prizeItem_count={1} },
      { palType=14, palNum=2, enMode=1, palName="魷魚", palImage=108120, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50013}, prizeItem_count={1} },
      { palType=15, palNum=1, enMode=1, palName="魷魚霸王", palImage=108121, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50015}, prizeItem_count={2} },

      { palType=16, palNum=2, enMode=1, palName="龍蝦", palImage=108111, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50010}, prizeItem_count={1} },
      { palType=17, palNum=2, enMode=1, palName="龍蝦", palImage=108112, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50008}, prizeItem_count={1} },
      { palType=18, palNum=2, enMode=1, palName="龍蝦", palImage=108113, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50007}, prizeItem_count={1} },
      { palType=19, palNum=2, enMode=1, palName="龍蝦", palImage=108114, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50009}, prizeItem_count={1} },
      { palType=20, palNum=1, enMode=1, palName="龍蝦霸王", palImage=108116, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50012}, prizeItem_count={2} },

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
           Char.SetLoopEvent('./lua/Modules/seaParade.lua','PalEnemy_LoopEvent',tbl_PalEnemyNPCIndex[k][i], 1000);
           self:regCallback('CharActionEvent', function(player, actionID)
             local Target_FloorId = Char.GetData(player,CONST.CHAR_地图);
             if (actionID == CONST.动作_攻击 and Target_FloorId==32744 and v.enMode==1) then
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
                 NLG.SystemMessage(player,"[系統]請使用攻擊動作抓捕。");
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
	if (Char.GetData(npc,CONST.对象_地图)==32744 and excess>=7) then
		local dir = math.random(0, 7);
		local walk = 1;
		local X,Y = Char.GetLocation(npc,dir);
		if (NLG.Walkable(0, 32744, X, Y)==1) then
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