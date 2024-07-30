---模块类
local Module = ModuleBase:createModule('palParade')

local PalEnemy = {
      { palType=1, palNum=20, palName="野生的帕魯", palImage=129024, popArea={map=7337,LX=32,LY=82, RX=79,RY=85},	--palNum生成数量、palImage外显形象(不重复)、出没范围(方形坐标)
         encount=30, prizeItem_id={51020,15615}, prizeItem_count={5,3} },						--encount遇敌机率、prizeItem奖励组合(可重复多组，提高该组合机率)
      { palType=2, palNum=12, palName="野生的帕魯", palImage=129025, popArea={map=7337,LX=26,LY=60, RX=59,RY=59},
         encount=30, prizeItem_id={900632,900633}, prizeItem_count={1,1} },
      { palType=3, palNum=4, palName="野生的帕魯", palImage=129026, popArea={map=7337,LX=49,LY=36, RX=61,RY=42},
         encount=30, prizeItem_id={13649,13669,13629}, prizeItem_count={1,1,1} },
      { palType=4, palNum=4, palName="野生的帕魯", palImage=129027, popArea={map=7337,LX=35,LY=21, RX=53,RY=30},
         encount=30, prizeItem_id={66668}, prizeItem_count={5} },
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
------------------------------------------------
local FTime = os.time()
local ParadeCD = {}				--时间表
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
           Char.SetLoopEvent('./lua/Modules/palParade.lua','PalEnemy_LoopEvent',tbl_PalEnemyNPCIndex[k][i], math.random(5000,10000));
           self:regCallback('CharActionEvent', function(player, actionID)
             local Target_FloorId = Char.GetData(player,CONST.CHAR_地图);
             if (actionID == CONST.动作_投掷 and Target_FloorId==7337) then
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
             if (NLG.CanTalk(npc, player) == true) then
                 NLG.SystemMessage(player,"[系統]請使用投擲動作抓捕帕魯。");
                 return ;
             end
             return
           end)
       end
    end
  end
  ParadeCD[1] = FTime;

end
------------------------------------------------
-------功能设置
--转移
function PalEnemy_LoopEvent(npc)
	local CTime = (os.date("%H",ParadeCD[1])) or (os.date("%H",os.time()));
	if (os.date("%H",os.time()) - CTime>=1) or (os.date("%H",os.time()) - CTime<0) then
		for k,v in pairs(PalEnemy) do
			local npcImage = Char.GetData(npc,CONST.对象_形象);
			if ( k==v.palType and npcImage==v.palImage ) then
				local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
				local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
				Char.SetData(npc,CONST.对象_X, palX);
				Char.SetData(npc,CONST.对象_Y, palY);
				Char.SetData(npc,CONST.对象_地图, v.popArea.map);
				NLG.UpChar(npc);
				ParadeCD[1] = os.time();
			end
		end
	elseif (os.date("%X",os.time())=="23:59:59") or (os.date("%X",os.time())=="11:59:59") or (os.date("%X",os.time())=="12:59:59") or (os.date("%X",os.time())=="16:59:59") or (os.date("%X",os.time())=="17:59:59") or (os.date("%X",os.time())=="19:59:59") or (os.date("%X",os.time())=="20:59:59") or (os.date("%X",os.time())=="21:59:59") then
		for k,v in pairs(PalEnemy) do
			local npcImage = Char.GetData(npc,CONST.对象_形象);
			if ( k==v.palType and npcImage==v.palImage ) then
				Char.SetData(npc,CONST.对象_X, 40);
				Char.SetData(npc,CONST.对象_Y, 40);
				Char.SetData(npc,CONST.对象_地图, 777);
				NLG.UpChar(npc);
			end
		end
	else
		local dir = math.random(0, 7);
		local walk = 1;
		local X,Y = Char.GetLocation(npc,dir);
		if (NLG.Walkable(0, 7337, X, Y)==1) then
			NLG.SetAction(npc,walk);
			NLG.WalkMove(npc,dir);
			NLG.UpChar(npc);
		end
	end
end

function pal_clear(player, npc)
	--转移至隐藏空间
	Char.SetData(npc,CONST.对象_X, 40);
	Char.SetData(npc,CONST.对象_Y, 40);
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
