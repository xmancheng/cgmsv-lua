---模块类
local Module = ModuleBase:createModule('mazeWorld')
local playerexp_itemid = 68011;    --人物經驗加倍券(1H)
local petexp_itemid = 68013;         --寵物經驗加倍券(1H)
local exp_itemid = 70040;               --角色招經驗貓(1.5倍)
local expshare_itemid = 70041;     --寵物學習裝置

local worldPoints = {
  { "天界空村Lv1", 0, 60001, 21, 30 },
  { "迷霧森林Lv30", 0, 60002, 114, 104 },
  { "古代遺跡Lv50", 0, 60004, 10, 10 },
  { "黑夜貓村Lv70", 0, 60006, 10, 10 },
  { "鋼鐵叢林Lv90", 0, 60008, 10, 10 },
  { "五行崑崙Lv110", 0, 60010, 10, 10 },
  { "烏龜島嶼Lv130", 0, 60012, 10, 10 },
  { "群龍之巔Lv150", 0, 60014, 10, 10 },
}

--- 页数计算
local function calcWarp()
  local totalpage = math.modf(#worldPoints / 6) + 1
  local remainder = math.fmod(#worldPoints, 6)
  return totalpage, remainder
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('GetExpEvent', Func.bind(self.onGetExpEvent,self));
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('DropEvent', Func.bind(self.LogoutEvent, self));
  self:regCallback('LoopEvent', Func.bind(self.InTheWorld_LoopEvent,self))
  local mazeNPC = self:NPC_createNormal('裏世界傳送門', 108511, { map = 25003, x = 15, y = 28, direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(mazeNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "3\\n@c前往轉生後的裏世界冒險\\n"
                           .."\\n　　════════════════════\\n"
                           .. worldPoints[1][1] .. "\\n";
    local winButton = CONST.BUTTON_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.BUTTON_下一页 then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
          winButton = CONST.BUTTON_上取消
        else
          winButton = CONST.BUTTON_上下取消
        end
      elseif _select == CONST.BUTTON_上一页 then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_下取消
        else
          winButton = CONST.BUTTON_下取消
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 6 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
          winMsg = winMsg .. worldPoints[i][1] .. "\\n"
        end
      else
        for i = 1 + count, 6 + count do
          winMsg = winMsg .. worldPoints[i][1] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 6 * (warpPage - 1) + column
      local short = worldPoints[count]
      local lastTimes = Char.GetExtData(player, "MazeTimeF") or 0;
      if (Char.GetData(player,CONST.CHAR_金币)<5000) then
          NLG.SystemMessage(player,"[系統]]裏世界傳送代價5000魔幣！！");
          return;
      elseif (Char.PartyNum(player)>=2) then
          NLG.SystemMessage(player,"[系統]裏世界須要單人進行傳送！！");
          return;
      else
          if lastTimes == 0 then
              Char.AddGold(player, -5000);
              Char.Warp(player, short[2], short[3], short[4], short[5])
              Char.SetExtData(player, "MazeTimeF", os.time());
              Char.SetExtData(player, "MazeTimeS", 0);
              Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
          else
              Char.Warp(player, short[2], short[3], short[4], short[5])
              Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
          end
      end
    end
  end)
  self:NPC_regTalkedEvent(mazeNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winCase = CONST.窗口_选择框
      local winButton = CONST.BUTTON_关闭;
      local msg = "3\\n@c前往轉生後的裏世界冒險\\n"
                           .."\\n　　════════════════════\\n"
                           .. worldPoints[1][1] .. "\\n";
      for i = 1,7 do
        local flag=i+300;
        if (Char.EndEvent(player,flag) == 1) then
            msg = msg .. worldPoints[i+1][1] .. "\\n"
            if (i>=7) then
                winButton = CONST.BUTTON_下取消;
            end
        else
            msg = msg
        end
      end
      --[[if (Char.GetData(player, CONST.对象_名色)<=0 or Char.GetData(player, CONST.ALBUM31)<=0) then
                msg = "\\n\\n\\n@c你的實力還不夠\\n"
                                            .."\\n轉生後再來這裡\\n";
                winCase = CONST.窗口_信息框;
      end]]
      NLG.ShowWindowTalked(player, npc, winCase, winButton, 1, msg);
    end
    return
  end)

end


function Module:onGetExpEvent(charIndex, exp)
	local ret1 = SQL.Run("select EndEvent301 from tbl_character order by EndEvent301 desc ");
	local ret2 = SQL.Run("select EndEvent302 from tbl_character order by EndEvent302 desc ");
	local ret3 = SQL.Run("select EndEvent303 from tbl_character order by EndEvent303 desc ");
	local ret4 = SQL.Run("select EndEvent304 from tbl_character order by EndEvent304 desc ");
	local ret5 = SQL.Run("select EndEvent305 from tbl_character order by EndEvent305 desc ");
	local ret6 = SQL.Run("select EndEvent306 from tbl_character order by EndEvent306 desc ");
	local ret7 = SQL.Run("select EndEvent307 from tbl_character order by EndEvent307 desc ");
	if (type(ret1)=="table" and ret1["1_0"]~=nil) then
		worldLayer1 = ret1["1_0"];
	elseif (type(ret2)=="table" and ret2["1_0"]~=nil) then
		worldLayer2 = ret2["1_0"];
	elseif (type(ret3)=="table" and ret3["1_0"]~=nil) then
		worldLayer3 = ret3["1_0"];
	elseif (type(ret4)=="table" and ret4["1_0"]~=nil) then
		worldLayer4 = ret4["1_0"];
	elseif (type(ret5)=="table" and ret5["1_0"]~=nil) then
		worldLayer5 = ret5["1_0"];
	elseif (type(ret6)=="table" and ret6["1_0"]~=nil) then
		worldLayer6 = ret6["1_0"];
	elseif (type(ret7)=="table" and ret7["1_0"]~=nil) then
		worldLayer7 = ret7["1_0"];
	end
	--[[worldLayer1 = Char.EndEvent(charIndex,301);	worldLayer2 = Char.EndEvent(charIndex,302);	worldLayer3 = Char.EndEvent(charIndex,303);
	worldLayer4 = Char.EndEvent(charIndex,304);	worldLayer5 = Char.EndEvent(charIndex,305);	worldLayer6 = Char.EndEvent(charIndex,306);
	worldLayer7 = Char.EndEvent(charIndex,307);
	]]
	if (Char.GetData(charIndex, CONST.对象_名色)>0 or Char.GetData(charIndex, CONST.ALBUM31)>0) then
		if Char.GetData(charIndex,CONST.对象_等级) >= 30 and worldLayer1 == 0 then
			NLG.SystemMessage(charIndex,"您已高於轉生後30級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
			return 0
		end
		if Char.GetData(charIndex,CONST.对象_等级) >= 50 and worldLayer2 == 0 then
			NLG.SystemMessage(charIndex,"您已高於轉生後50級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
			return 0
		end
		if Char.GetData(charIndex,CONST.对象_等级) >= 70 and worldLayer3 == 0 then
			NLG.SystemMessage(charIndex,"您已高於轉生後70級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
			return 0
		end
		if Char.GetData(charIndex,CONST.对象_等级) >= 90 and worldLayer4 == 0 then
			NLG.SystemMessage(charIndex,"您已高於轉生後90級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
			return 0
		end
		if Char.GetData(charIndex,CONST.对象_等级) >= 110 and worldLayer5 == 0 then
			NLG.SystemMessage(charIndex,"您已高於轉生後110級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
			return 0
		end
		if Char.GetData(charIndex,CONST.对象_等级) >= 130 and worldLayer6 == 0 then
			NLG.SystemMessage(charIndex,"您已高於轉生後130級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
			return 0
		end
		if Char.GetData(charIndex,CONST.对象_等级) >= 150 and worldLayer7 == 0 then
			NLG.SystemMessage(charIndex,"您已高於轉生後150級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
			return 0
		end
	else
		if(Char.ItemNum(charIndex,playerexp_itemid) >= 0 or Char.ItemNum(charIndex,petexp_itemid) >= 0 or Char.ItemNum(charIndex,expshare_itemid) >= 0 or Char.ItemNum(charIndex,exp_itemid) >= 0) then
			if(Char.ItemNum(charIndex,expshare_itemid) > 0) then
				for Slot=0,4 do
					local PetIndex = Char.GetPet(charIndex,Slot);
					if(PetIndex >=0 and Char.ItemNum(charIndex,petexp_itemid) == 0) then
						local Exp = Char.GetData(PetIndex,%对象_经验%);
						local Ne = Exp + exp;
						Char.SetData(PetIndex,%对象_经验%,Ne);
						NLG.UpChar(PetIndex);
						--NLG.TalkToCli(charIndex,-1,"[宠物学习器] 角色原始经验已共享给所有宠物！",%颜色_黄色%,%字体_中%);
					end
					if(PetIndex >=0 and Char.ItemNum(charIndex,petexp_itemid) == 1) then
						local Exp = Char.GetData(PetIndex,%对象_经验%);
						local Ne = Exp + exp* 2;
						Char.SetData(PetIndex,%对象_经验%,Ne);
						NLG.UpChar(PetIndex);
						--NLG.TalkToCli(charIndex,-1,"[宠物学习器] 角色原始经验已双倍共享给所有宠物！",%颜色_黄色%,%字体_中%);
					end
				end
			end
			if(Char.ItemNum(charIndex,exp_itemid) > 0 and Char.ItemNum(charIndex,playerexp_itemid) > 0) then
				return exp * 3;  --角色获取的经验3倍
			elseif(Char.ItemNum(charIndex,exp_itemid) > 0 and Char.ItemNum(charIndex,playerexp_itemid) == 0) then
				return exp * 1.5;  --角色获取的经验1.5倍
			elseif(Char.ItemNum(charIndex,exp_itemid) == 0 and Char.ItemNum(charIndex,playerexp_itemid) > 0) then
				return exp * 2;  --角色获取的经验双倍
			end
		end
	end
end

function InTheWorld_LoopEvent(player)
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local Target_FloorId = Char.GetData(player,CONST.CHAR_地图);
  if FTime > 0 then
    if STime >0 then
        if ( (os.time() - STime) + (STime - FTime) ) >= 12000 and Target_FloorId>=60002 and Target_FloorId<=60007 then
            Char.Warp(player,0,25003,14,27);
            NLG.SystemMessage(player,"[系統]時限結束傳送離開裏世界。");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.UnsetLoopEvent(player);
        elseif ( (os.time() - STime) + (STime - FTime) ) >= 300 and Target_FloorId>=60002 and Target_FloorId<=60007 then
            NLG.SystemMessage(player,"[系統]剩下五分鐘將傳送離開裏世界。");
        end
    else
        if (os.time() - FTime) >= 12000 and Target_FloorId>=60002 and Target_FloorId<=60007 then
            Char.Warp(player,0,25003,14,27);
            NLG.SystemMessage(player,"[系統]時限結束傳送離開裏世界。");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.UnsetLoopEvent(player);
        elseif (os.time() - FTime) >= 300 and Target_FloorId>=60002 and Target_FloorId<=60007 then
            NLG.SystemMessage(player,"[系統]剩下五分鐘將傳送離開裏世界。");
        end
    end
  else

  end
end

function Module:onLogoutEvent(player)
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  if FTime > 0 then
    if STime >0 then
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
    else
            Char.SetExtData(player, "MazeTimeS", os.time());
    end
  end
end

function Module:onLoginEvent(player)
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  if FTime > 0 then
            Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
  else
            local Target_FloorId = Char.GetData(player,CONST.CHAR_地图);
            if Target_FloorId>=60002 and Target_FloorId<=60007 then
                Char.Warp(player,0,25003,14,27);
                NLG.SystemMessage(player,"[系統]時空傳送回原本世界。");
            end
  end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
