---模块类
local Module = ModuleBase:createModule('mazeWorld')
local playerexp_itemid = 68011;    --人物經驗加倍券(1H)
local petexp_itemid = 68013;         --寵物經驗加倍券(1H)
local exp_itemid = 70040;               --角色招經驗貓(1.5倍)
local expshare_itemid = 70041;     --寵物學習裝置

local worldPoints = {
  { "天界空村Lv1", 0, 60001, 21, 30 },
  { "迷霧森林Lv30", 0, 60002, 115, 104 },
  { "古代遺跡Lv50", 0, 60004, 11, 64 },
  { "黑夜貓村Lv70", 0, 60006, 107, 80 },
  { "荒漠峽谷Lv90", 0, 60008, 33, 24 },
  { "精靈之都Lv110", 0, 60010, 10, 10 },
  { "烏龜島嶼Lv130", 0, 60012, 10, 10 },
  { "群龍之巔Lv150", 0, 60014, 10, 10 },
}

local mazeMap = {
    { 60002 }, { 60004 }, { 60006 }, { 60008 }, { 60010 }, { 60012 }, { 60014 },
}
local worldExp = {
    { Event="LordEnd1", L_level=0, R_level=30, UniItem=70258},
    { Event="LordEnd2", L_level=30, R_level=50, UniItem=70260},
    { Event="LordEnd3", L_level=50, R_level=70, UniItem=70262},
    { Event="LordEnd4", L_level=70, R_level=90, UniItem=70264},
    { Event="LordEnd5", L_level=90, R_level=110, UniItem=70266},
    { Event="LordEnd6", L_level=110, R_level=130, UniItem=70267},
    { Event="LordEnd7", L_level=130, R_level=150, UniItem=70270},
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
  local mazeNPC = self:NPC_createNormal('裏空間傳送門', 108511, { map = 1000, x = 242, y = 88, direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(mazeNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "3\\n@c前往轉生後的裏空間冒險\\n"
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
          NLG.SystemMessage(player,"[系統]]裏空間傳送代價5000魔幣！！");
          return;
      elseif (Char.PartyNum(player)>=2) then
          NLG.SystemMessage(player,"[系統]裏空間須要單人進行傳送！！");
          return;
      else
          if lastTimes == 0 then
              Char.AddGold(player, -5000);
              Char.Warp(player, short[2], short[3], short[4], short[5])
              Char.SetExtData(player, "MazeTimeF", os.time());
              Char.SetExtData(player, "MazeTimeS", 0);
              Char.SetExtData(player, "MazeTimeT", 0);
              Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
          else
              Char.Warp(player, short[2], short[3], short[4], short[5])
              Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
          end
      end
    end
  end)
  self:NPC_regTalkedEvent(mazeNPC, function(npc, player)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");
    if (NLG.CanTalk(npc, player) == true) then
      local winCase = CONST.窗口_选择框
      local winButton = CONST.BUTTON_关闭;
      local msg = "3\\n@c前往轉生後的裏空間冒險\\n"
                           .."\\n　　════════════════════\\n"
                           .. worldPoints[1][1] .. "\\n";
      for i = 1,7 do
        local flag=i;
        local event = tonumber(SQL.Run("select LordEnd"..flag.." from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
        if (i==1) then
            msg = msg .. worldPoints[2][1] .. "\\n";
        end
        if (event == 1) then
            msg = msg .. worldPoints[i+2][1] .. "\\n";
            if (i>=7) then
                winButton = CONST.BUTTON_下取消;
            end
        else
            msg = msg
        end
      end
      if (Char.GetData(player, CONST.对象_名色)<=0 or Char.GetData(player, CONST.ALBUM31)<=0) then
                msg = "\\n\\n\\n@c你的實力還不夠\\n"
                                            .."\\n轉生後再來這裡\\n";
                winCase = CONST.窗口_信息框;
      end
      NLG.ShowWindowTalked(player, npc, winCase, winButton, 1, msg);
    end
    return
  end)

end


function Module:onGetExpEvent(charIndex, exp)
	--[[worldLayer1 = Char.EndEvent(charIndex,301);	worldLayer2 = Char.EndEvent(charIndex,302);	worldLayer3 = Char.EndEvent(charIndex,303);
	worldLayer4 = Char.EndEvent(charIndex,304);	worldLayer5 = Char.EndEvent(charIndex,305);	worldLayer6 = Char.EndEvent(charIndex,306);
	worldLayer7 = Char.EndEvent(charIndex,307);
	]]
	local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图);
	if (Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 and Char.GetData(charIndex, CONST.对象_名色)>0 or Char.GetData(charIndex, CONST.ALBUM31)>0) then
		for i, v in ipairs(mazeMap) do
			for _, FloorId in ipairs(v) do
				local LordEnd = worldExp[i].Event;
				local ret = SQL.Run("select Name,"..LordEnd.." from lua_hook_worldboss order by "..LordEnd.." desc ");
				if (type(ret)=="table" and ret["0_1"]~=nil) then
					worldLayer = tonumber(ret["0_1"]);
				end
				print(worldLayer)
				if (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[i].R_level and Target_FloorId==FloorId and worldLayer == 0) then
					NLG.SystemMessage(charIndex,"您已高於轉生後"..worldExp[i].R_level.."級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
					return 0
				elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[i].R_level and Target_FloorId==FloorId and worldLayer == 1) then
					NLG.SystemMessage(charIndex,"請前往下一層世界，當前經驗已被鎖定。")
					return 0
				elseif (Char.GetData(charIndex,CONST.对象_等级)>worldExp[i].L_level and Target_FloorId~=FloorId) then
					NLG.SystemMessage(charIndex,"轉生後請前往裏空間，當前經驗已被鎖定。")
					return 0
				else
					for Slot=0,4 do
						local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
						if (Char.GetData(charIndex,CONST.对象_等级)<=worldExp[i].R_level and PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[i].UniItem)>0 and Target_FloorId==FloorId) then    --队友有独特装备
							NLG.SystemMessage(charIndex,"[隊友獨特裝備] 經驗加成1.5倍！");
							return exp * 1.5;  --角色获取的经验1.5倍
						end
					end
				end
				
			end
		end
	else
		if (Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠) then
			local PetIndex = charIndex;
			local OwnercharIndex = Pet.GetOwner(PetIndex);
			if (Char.ItemNum(OwnercharIndex,petexp_itemid) == 1) then
				local exp=exp * 2;
				if (Char.ItemNum(OwnercharIndex,expshare_itemid) > 0) then
					for Slot=0,4 do
						local PocketPetIndex = Char.GetPet(OwnercharIndex,Slot);
						if (PocketPetIndex>=0 and PocketPetIndex~=PetIndex) then
							local Exp = Char.GetData(PocketPetIndex,%对象_经验%);
							local Ne = Exp + exp;
							Char.SetData(PocketPetIndex,%对象_经验%,Ne);
							Pet.UpPet(OwnercharIndex, PocketPetIndex);
							--NLG.TalkToCli(OwnercharIndex,-1,"[宠物学习器] 宠物经验已双倍共享给其他宠物！",%颜色_黄色%,%字体_中%);
						end
					end
				end
				return exp;  --宠物获取的经验2倍
			elseif (Char.ItemNum(OwnercharIndex,petexp_itemid) == 0) then
				local exp=exp;
				if (Char.ItemNum(OwnercharIndex,expshare_itemid) > 0) then
					for Slot=0,4 do
						local PocketPetIndex = Char.GetPet(OwnercharIndex,Slot);
						if (PocketPetIndex>=0 and PocketPetIndex~=PetIndex) then
							local Exp = Char.GetData(PocketPetIndex,%对象_经验%);
							local Ne = Exp + exp;
							Char.SetData(PocketPetIndex,%对象_经验%,Ne);
							Pet.UpPet(OwnercharIndex, PocketPetIndex);
							--NLG.TalkToCli(OwnercharIndex,-1,"[宠物学习器] 宠物经验已共享给其他宠物！",%颜色_黄色%,%字体_中%);
						end
					end
				end
				return exp;  --宠物获取的经验无加倍
			end
		elseif (Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人) then
 			if (Char.ItemNum(charIndex,playerexp_itemid) >= 0 or Char.ItemNum(charIndex,exp_itemid) >= 0) then
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
end

function InTheWorld_LoopEvent(player)
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local TTime = Char.GetExtData(player, "MazeTimeT") or 0;
  local Target_FloorId = Char.GetData(player,CONST.CHAR_地图);
  if FTime > 0 then
    if STime >0 then
        if (os.time() - TTime) >= 12000 - (STime - FTime) and Target_FloorId>=60002 and Target_FloorId<=60015 then
            Char.Warp(player,0,1000,241,88);
            NLG.SystemMessage(player,"[系統]時限結束傳送離開裏空間。");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.SetExtData(player, "MazeTimeT", 0);
            Char.UnsetLoopEvent(player);
        elseif (os.time() - TTime) == 300 - (STime - FTime) and Target_FloorId>=60002 and Target_FloorId<=60015 then
            NLG.SystemMessage(player,"[系統]剩下五分鐘將傳送離開裏空間。");
        end
    else
        if (os.time() - FTime) >= 12000 and Target_FloorId>=60002 and Target_FloorId<=60015 then
            Char.Warp(player,0,1000,241,88);
            NLG.SystemMessage(player,"[系統]時限結束傳送離開裏空間。");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.SetExtData(player, "MazeTimeT", 0);
            Char.UnsetLoopEvent(player);
        elseif (os.time() - FTime) == 300 and Target_FloorId>=60002 and Target_FloorId<=60015 then
            NLG.SystemMessage(player,"[系統]剩下五分鐘將傳送離開裏空間。");
        end
    end
  else

  end
end

function Module:onLogoutEvent(player)
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local TTime = Char.GetExtData(player, "MazeTimeT") or 0;
  if FTime > 0 then
    if STime >0 then
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.SetExtData(player, "MazeTimeT", 0);
    else
            Char.SetExtData(player, "MazeTimeS", os.time());
    end
  end
end

function Module:onLoginEvent(player)
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local TTime = Char.GetExtData(player, "MazeTimeT") or 0;
  if FTime > 0 then
            Char.SetExtData(player, "MazeTimeT", os.time());
            Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
  else
            local Target_FloorId = Char.GetData(player,CONST.CHAR_地图);
            if Target_FloorId>=60002 and Target_FloorId<=60015 then
                Char.Warp(player,0,1000,241,88);
                Char.UnsetLoopEvent(player);
                NLG.SystemMessage(player,"[系統]時空傳送回原本世界。");
            end
  end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
