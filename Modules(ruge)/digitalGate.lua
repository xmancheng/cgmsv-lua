---模块类
local Module = ModuleBase:createModule('digitalGate')


--背景设置
local Pts= 70075;		--70206真女神苹果.70075任务币
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  --数码门道具
  self:regCallback('ItemString', Func.bind(self.digitalTravel, self),"LUA_useDigiTrip");
  DigitalGateNPC = self:NPC_createNormal('數碼旅行', 103013, { x = 42, y = 31, mapType = 0, map = 777, direction = 6 });
  Char.SetData(DigitalGateNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regTalkedEvent(DigitalGateNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
                local msg = "\\n\\n@c【系統通知】"
                  .."\\n\\n"
                  .."\\n未知的傳送門出現\\n"
                  .."\\n是否進入數碼世界？\\n";
        NLG.ShowWindowTalked(player, DigitalGateNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(DigitalGateNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ComIndex =ComIndex;
    local ComSlot = ComSlot;
    local Target_FloorId = Char.GetData(player,CONST.对象_地图)--地图编号
    local Target_X = Char.GetData(player,CONST.对象_X)--地图x
    local Target_Y = Char.GetData(player,CONST.对象_Y)--地图y
    --local playerLv = Char.GetData(player,CONST.对象_等级);
    local playerLv = calcTeamLevel(player);
    if select > 0 then
      if seqno == 1 and select == CONST.按钮_否 then
          Char.SetData(npc,CONST.对象_X, 42);
          Char.SetData(npc,CONST.对象_Y, 31);
          Char.SetData(npc,CONST.对象_地图, 777);
          NLG.UpChar(npc); 
          return;
      elseif seqno == 1 and select == CONST.按钮_是 then
          if (Char.ItemNum(player, 75030)<=0) then
              NLG.SystemMessage(player,"[系統]你沒有進入資格。");
              return;
          end
          if (playerLv>=1 and playerLv<=49) then
              Char.Warp(player,0, 25009, 78, 19);
              Char.DelItem(player, 75030, 1);
              NLG.SystemMessage(player, "[系统]進入數碼世界。")
          elseif (playerLv>=50 and playerLv<=100) then
              Char.Warp(player,0, 25009, 48, 19);
              Char.DelItem(player, 75030, 1);
              NLG.SystemMessage(player, "[系统]進入數碼世界。")
          elseif (playerLv>=101) then
              Char.Warp(player,0, 25009, 18, 19);
              Char.DelItem(player, 75030, 1);
              NLG.SystemMessage(player, "[系统]進入數碼世界。")
          end
          Char.SetData(npc,CONST.对象_X, 42);
          Char.SetData(npc,CONST.对象_Y, 31);
          Char.SetData(npc,CONST.对象_地图, 777);
          NLG.UpChar(npc); 
      else
          return;
      end
    end
  end)

end
------------------------------------------------
----
function Module:digitalTravel(charIndex,targetIndex,itemSlot)
    ComItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    ComSlot =itemSlot;
    ComIndex = Char.GetItemIndex(charIndex,itemSlot);
    local Target_FloorId = Char.GetData(charIndex,CONST.对象_地图);
	local Target_X = Char.GetData(charIndex,CONST.对象_X);
	local Target_Y = Char.GetData(charIndex,CONST.对象_Y);
	local warpX = NLG.Rand(Target_X-5, Target_X+5);
	local warpY = NLG.Rand(Target_Y-5, Target_Y+5);
	if (Target_FloorId~=25009) then
	  Char.SetData(DigitalGateNPC,CONST.对象_X, warpX);
	  Char.SetData(DigitalGateNPC,CONST.对象_Y, warpY);
	  Char.SetData(DigitalGateNPC,CONST.对象_地图, Target_FloorId);
	  NLG.UpChar(DigitalGateNPC);
      Char.Warp(charIndex,0, Target_FloorId, Target_X, Target_Y);
	  NLG.SystemMessage(charIndex,"[系統]未知的傳送門出現在附近("..warpX..","..warpY..")");
    else
      NLG.SystemMessage(charIndex,"[系統]數碼世界中無法再開傳送門");
      return 1;
	end
--[[
                local msg = "\\n\\n@c【系統通知】"
                  .."\\n\\n"
                  .."\\n未知的傳送門出現\\n"
                  .."\\n是否進入數碼世界？\\n";
    NLG.ShowWindowTalked(charIndex, DigitalGateNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
]]
    return 1;
end

function calcTeamLevel(player)
	local m = 0;
	local k = 0;
	for slot = 0,4 do
		local p = Char.GetPartyMember(player,slot);
		if (p>=0) then
			m = m + Char.GetData(p,CONST.对象_等级);
			k = k+1;
		end
	end
	--计算平均等级及等第
	local lv = math.floor(m/k);
	return lv;
end

function heads(CoinNo)
	local h,r,s = 0,0,0;
	local result_tbl = {};
	for i=1,CoinNo do
		local result = NLG.Rand(0,1);
		table.insert(result_tbl,result);
	end
	for k,v in pairs(result_tbl) do
		if (v==1) then
			h = h + 1;
		elseif (v==0) then
			r = r + 1;
		end
	end
	if (h==#result_tbl or r==#result_tbl) then
		s = 1;
	end
	return h,r,s
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;