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
           Char.SetLoopEvent('./lua/Modules/palParade.lua','PalEnemy_LoopEvent',tbl_PalEnemyNPCIndex[k][i],1000);
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
                        if ( Char.ItemSlot(player)>19)then
                            NLG.SystemMessage(player,"[系統]物品欄已滿。");
                            return;
                        else
                            local rand = NLG.Rand(1,#v.prizeItem);
                            Char.GiveItem(player, v.prizeItem[rand], v.prizeItem_count);
                            pal_clear(player, npc);
                            NLG.UpChar(player);
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

end
------------------------------------------------
-------功能设置
--转移
function PalEnemy_LoopEvent(npc)
	if (os.date("%X",os.time())=="00:00:01") then
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
	elseif (os.date("%X",os.time())=="23:59:59")  then
		for k,v in pairs(PalEnemy) do
			local npcImage = Char.GetData(npc,CONST.对象_形象);
			if ( k==v.palType and npcImage==v.palImage ) then
				Char.SetData(npc,CONST.对象_X, 40);
				Char.SetData(npc,CONST.对象_Y, 40);
				Char.SetData(npc,CONST.对象_地图, 777);
				NLG.UpChar(npc);
			end
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
