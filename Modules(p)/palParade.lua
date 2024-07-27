---模块类
local Module = ModuleBase:createModule('palParade')

local PalEnemy = {
      { palType=1, palNum=2, palName="帕魯", palImage=129024, popArea={map=7400,LX=25,RX=35,LY=50,RY=60},
         prizeItem={900504}, prizeItem_count=1},
      { palType=2, palNum=2, palName="帕魯", palImage=129025, popArea={map=7400,LX=25,RX=35,LY=50,RY=60},
         prizeItem={900504}, prizeItem_count=2},
      { palType=3, palNum=2, palName="帕魯", palImage=129026, popArea={map=7400,LX=25,RX=35,LY=50,RY=60},
         prizeItem={900504}, prizeItem_count=3},
      { palType=4, palNum=2, palName="帕魯", palImage=129027, popArea={map=7400,LX=25,RX=35,LY=50,RY=60},
         prizeItem={900504}, prizeItem_count=4},
}

local ParadeInfo = {}				--冷却时间表
local ParadeSetting = {}
local ParadeCD = {}
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
           self:regCallback('CharActionEvent', function(player, actionID)
             local Target_FloorId = Char.GetData(player,CONST.CHAR_地图);
             if (actionID == CONST.动作_投掷 and Target_FloorId==7400) then
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
                        local rand = NLG.Rand(1,#v.prizeItem);
                        Char.GiveItem(player, v.prizeItem[rand], v.prizeItem_count);
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

end
------------------------------------------------
-------功能设置
--转移
function LegendBoss_LoopEvent(npc)
	local gmIndex = NLG.FindUser(123456);
	local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='珀鲁冷却_set'")["0_0"])
	local ParadeCD = {};
	if (type(sqldata)=="string" and sqldata~='') then
		ParadeCD = JSON.decode(sqldata);
	else
		ParadeCD = {};
	end

	if (os.date("%X",os.time())=="00:00:01") then
		for k,v in pairs(PalEnemy) do
			local mapsname = NLG.GetMapName(0, v.warpArea.map);
			local npcImage = Char.GetData(npc,CONST.对象_形象);
			if ( k==v.palType and npcImage==v.palImage ) then
				ParadeInfo[k] = os.time();
				ParadeSetting[k] = 0;

				Char.SetData(npc,CONST.对象_X, v.warpArea.X);
				Char.SetData(npc,CONST.对象_Y, v.warpArea.Y);
				Char.SetData(npc,CONST.对象_地图, v.warpArea.map);
				NLG.UpChar(npc);

				ParadeCD[k] = 0;
				local newdata = JSON.encode(LegendCD);
				SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='珀鲁冷却_set'")
				NLG.UpChar(gmIndex);
			end
		end
	elseif (os.date("%X",os.time())=="23:59:59")  then
		for k,v in pairs(PalEnemy) do
			local npcImage = Char.GetData(npc,CONST.对象_形象);
			if ( k==v.palType and npcImage==v.palImage ) then
				Char.SetData(npc,CONST.对象_X, v.waitingArea.X);
				Char.SetData(npc,CONST.对象_Y, v.waitingArea.Y);
				Char.SetData(npc,CONST.对象_地图, v.waitingArea.map);
				NLG.UpChar(npc);
			end
		end
	else
		for k,v in pairs(PalEnemy) do
			if (ParadeSetting[k]==nil) then
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				local npcImage = Char.GetData(npc,CONST.对象_形象);
				if ( k==v.palType and npcImage==v.palImage) then
					ParadeInfo[k] = os.time();
					ParadeSetting[k] = 0;

					Char.SetData(npc,CONST.对象_X, v.warpArea.X);
					Char.SetData(npc,CONST.对象_Y, v.warpArea.Y);
					Char.SetData(npc,CONST.对象_地图, v.warpArea.map);
					NLG.UpChar(npc);
				end
			elseif (ParadeSetting[k]==2) then
				local CTime = ParadeInfoInfo[k] or os.time();
				local mapsname = NLG.GetMapName(0, v.warpArea.map);
				local npcImage = Char.GetData(npc,CONST.对象_形象);
				if ( (os.time() - CTime) >= 7200 and k==v.palType and npcImage==v.palImage) then
					ParadeInfo[k] = os.time();
					ParadeSetting[k] = 1;

					Char.SetData(npc,CONST.对象_X, v.warpArea.X);
					Char.SetData(npc,CONST.对象_Y, v.warpArea.Y);
					Char.SetData(npc,CONST.对象_地图, v.warpArea.map);
					NLG.UpChar(npc);

					ParadeCD[k] = 0;
					local newdata = JSON.encode(ParadeCD);
					SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='珀鲁冷却_set'")
					NLG.UpChar(gmIndex);
				end
			end
		end
	end
end


function boss_round_callback(battleindex, player)

	--进入冷却时间
	local gmIndex = NLG.FindUser(123456);
	local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='".."123456".."' and sKey='珀鲁冷却_set'")["0_0"])
	local ParadeCD = {};
	if (type(sqldata)=="string" and sqldata~='') then
		ParadeCD = JSON.decode(sqldata);
	else
		ParadeCD = {};
	end
	for k,v in pairs(PalEnemy) do
		local npcImage = Char.GetData(npc,CONST.对象_形象);
		if ( npcImage==v.palImage ) then
			ParadeInfo[k] = os.time();
			ParadeSetting[k] = 2;
			Char.SetData(npc,CONST.对象_X, v.waitingArea.X);
			Char.SetData(npc,CONST.对象_Y, v.waitingArea.Y);
			Char.SetData(npc,CONST.对象_地图, v.waitingArea.map);
			NLG.UpChar(npc);

			ParadeCD[k] = npcImage;
			local newdata = JSON.encode(ParadeCD);
			SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='".."123456".."' and sKey='珀鲁冷却_set'")
			NLG.UpChar(gmIndex);
		end
	end
	Char.SetTempData(player, '珀鲁',0);
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;