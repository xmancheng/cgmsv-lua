---模块类
local Module = ModuleBase:createModule('mazeWorld')
local playerexp_itemid = 68011;    --人物經驗加倍券(1H)
local petexp_itemid = 68013;         --寵物經驗加倍券(1H)
local exp_itemid = 70040;               --角色招經驗貓(1.5倍)
local expshare_itemid = 70041;     --寵物學習裝置

Module:addMigration(1, 'init lua_hook_worldboss', function()
  SQL.querySQL([[
      CREATE TABLE if not exists `lua_hook_worldboss` (
    `Name` char(32) COLLATE gbk_bin NOT NULL,
    `CdKey` char(32) COLLATE gbk_bin NOT NULL,
    `regNo` int(11) NOT NULL,
    `WorldLord1` int(10) NOT NULL Default 100000,
    `LordEnd1` int(10) NOT NULL Default 0,
    `WorldLord2` int(10) NOT NULL Default 200000,
    `LordEnd2` int(10) NOT NULL Default 0,
    `WorldLord3` int(10) NOT NULL Default 300000,
    `LordEnd3` int(10) NOT NULL Default 0,
    `WorldLord4` int(10) NOT NULL Default 400000,
    `LordEnd4` int(10) NOT NULL Default 0,
    `WorldLord5` int(10) NOT NULL Default 500000,
    `LordEnd5` int(10) NOT NULL Default 0,
    `WorldLord6` int(10) NOT NULL Default 600000,
    `LordEnd6` int(10) NOT NULL Default 0,
    `WorldLord7` int(10) NOT NULL Default 700000,
    `LordEnd7` int(10) NOT NULL Default 0,
    `WorldLord8` int(10) NOT NULL Default 800000,
    `LordEnd8` int(10) NOT NULL Default 0,
    `WorldLord9` int(10) NOT NULL Default 900000,
    `LordEnd9` int(10) NOT NULL Default 0,
    `WorldLord10` int(10) NOT NULL Default 1000000,
    `LordEnd10` int(10) NOT NULL Default 0,
    PRIMARY KEY (`CdKey`),
    KEY `regNo` (`regNo`) USING BTREE
  ) ENGINE=Innodb DEFAULT CHARSET=gbk COLLATE=gbk_bin
  ]])
end);


local worldPoints = {
  { "迷霧森林Lv110", 0, 7900, 4, 1, 5000 },
  { "古代遺跡Lv120", 0, 7901, 2, 60, 5000 },
  { "黑夜貓村Lv130", 0, 60006, 107, 80, 5000 },
  { "荒漠峽谷Lv140", 0, 60008, 33, 24, 5000 },
  { "精靈之都Lv150", 0, 60010, 46, 42, 5000 },
  { "烏龜秘境Lv160", 0, 60012, 15, 15, 5000 },
  { "天馬原野Lv170", 0, 60014, 44, 51, 5000 },
  { "龍族墳場Lv180", 0, 60016, 26, 47, 5000 },
}

local mazeMap = {
    { 7900, 7900 }, { 7901, 7901 }, { 60006, 60006 }, { 60008, 60001 }, { 60010, 60001 }, { 60012, 60001 }, { 60014, 60001 },
}
local worldExp = {
    { Event="LordEnd1", L_level=101, R_level=110, Upload=120, UniItem=70258},
    { Event="LordEnd2", L_level=111, R_level=120, Upload=130, UniItem=70260},
    { Event="LordEnd3", L_level=121, R_level=130, Upload=140, UniItem=70262},
    { Event="LordEnd4", L_level=131, R_level=140, Upload=150, UniItem=70264},
    { Event="LordEnd5", L_level=141, R_level=150, Upload=160, UniItem=70266},
    { Event="LordEnd6", L_level=151, R_level=160, Upload=170, UniItem=70267},
    { Event="LordEnd7", L_level=161, R_level=170, Upload=180, UniItem=70270},
}

local Horcrux = {
  { 301, },  { 302, },  { 303, },  { 304, },  { 305, },  { 306, },  { 307, },
}
--- 页数计算
local function calcWarp()
  local totalpage = math.modf(#worldPoints / 7) + 1
  local remainder = math.fmod(#worldPoints, 7)
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
  local mazeNPC = self:NPC_createNormal('時空傳送', 121001, { map = 1000, x = 242, y = 88, direction = 0, mapType = 0 })
  Char.SetData(mazeNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regWindowTalkedEvent(mazeNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
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
      local count = 7 * (warpPage - 1)
      if warpPage == totalPage then
        local cdk = Char.GetData(player,CONST.对象_CDK);
        local winMsg = "2\\n@c前往轉生後的裏空間冒險\\n"
                               .."　　————————————————————\\n";
        for i = 1 + count, remainder + count do
            local flag=i-1;
            local event = tonumber(SQL.Run("select LordEnd"..flag.." from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
            if (event == 1) then
                if (i>=#worldPoints+1) then
                        winMsg = winMsg
                else
                        winMsg = winMsg .. worldPoints[i][1] .. "  △隊伍每人傳送費: ".. worldPoints[i][6] .."\\n"
                end
            else
                winMsg = winMsg
            end
            --[[if (i>=9) then
                        winMsg = winMsg .. worldPoints[i][1] .. "  △隊伍每人傳送費: ".. worldPoints[i][6] .."\\n"
            end]]
        end
        NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
      else
        local winMsg = "2\\n@c前往轉生後的裏空間冒險\\n"
                           .."　　————————————————————\\n"
        local cdk = Char.GetData(player,CONST.对象_CDK);
        for i = 1 + count, 7 + count do
            local flag=i;
            local event = tonumber(SQL.Run("select LordEnd"..flag.." from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
            if (i==1) then
                winMsg = winMsg .. worldPoints[1][1] .. "  △隊伍每人傳送費: ".. worldPoints[1][6] .."\\n"
            end
            if (event == 1) then
                if (i>=7) then
                    winMsg = winMsg
                else
                    winMsg = winMsg .. worldPoints[i+1][1] .. "  △隊伍每人傳送費: ".. worldPoints[i+1][6] .."\\n"
                end
            else
                winMsg= winMsg
            end
        end
        NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
      end
    else
      local count = 7 * (warpPage - 1) + column
      local short = worldPoints[count]
      local lastTimes = Char.GetExtData(player, "MazeTimeF") or 0;
      --[[
      if (Char.GetData(player,CONST.CHAR_金币)<5000) then
          NLG.SystemMessage(player,"[系統]裏空間傳送代價5000魔幣！！");
          return;
      elseif (Char.PartyNum(player)>=2) then
          NLG.SystemMessage(player,"[系統]裏空間須要單人進行傳送！！");
          return;
      ]]
      if (count==8) then
          if (Char.PartyNum(player)>=2) then
            NLG.SystemMessage(player,"[系統]裏空間須要單人進行傳送！！");
            return;
          end
          local flagEvent1 = Char.EndEvent(player,Horcrux[1][1]);
          local flagEvent2 = Char.EndEvent(player,Horcrux[2][1]);
          local flagEvent3 = Char.EndEvent(player,Horcrux[3][1]);
          local flagEvent4 = Char.EndEvent(player,Horcrux[4][1]);
          local flagEvent5 = Char.EndEvent(player,Horcrux[5][1]);
          local flagEvent6 = Char.EndEvent(player,Horcrux[6][1]);
          local flagEvent7 = Char.EndEvent(player,Horcrux[7][1]);
          if (flagEvent1==1 and flagEvent2==1 and flagEvent3==1 and flagEvent4==1 and flagEvent5==1 and flagEvent6==1 and flagEvent7==1) then
                  Char.AddGold(player, -5000);
                  Char.Warp(player, short[2], short[3], short[4], short[5])
          else
                  NLG.SystemMessage(player,"[系統]七罪魂器都啟動才符合進入資格！！");
                  return;
          end
      else
          if lastTimes == 0 then
              local PartyNum = Char.PartyNum(player);
              if (PartyNum>0 and Char.GetData(player,CONST.对象_金币) >= short[6]*PartyNum) then
                local fee = short[6]*PartyNum;
		        Char.SetData(player,CONST.对象_金币, Char.GetData(player,CONST.对象_金币) - fee);
		        NLG.UpChar(player);
		        NLG.SystemMessage(player,"隊長交出了"..fee.."。");
                Char.Warp(player, short[2], short[3], short[4], short[5])
                Char.SetExtData(player, "MazeTimeF", os.time());
                Char.SetExtData(player, "MazeTimeS", 0);
                Char.SetExtData(player, "MazeTimeT", 0);
                Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
              elseif (PartyNum>0 and Char.GetData(player,CONST.对象_金币) < short[6]*PartyNum) then
		        NLG.SystemMessage(player,"不夠支付全隊傳送費用，請解散隊伍。");
              elseif (Char.GetData(player,CONST.对象_金币) >= short[6]) then
		        Char.SetData(player,CONST.对象_金币, Char.GetData(player,CONST.对象_金币) - short[6]);
		        NLG.UpChar(player);
                Char.Warp(player, short[2], short[3], short[4], short[5])
                Char.SetExtData(player, "MazeTimeF", os.time());
                Char.SetExtData(player, "MazeTimeS", 0);
                Char.SetExtData(player, "MazeTimeT", 0);
                Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
              elseif (Char.GetData(player,CONST.对象_金币) < short[6]) then
		        NLG.SystemMessage(player,"傳送費用不足。");
              end
          else
              Char.Warp(player, short[2], short[3], short[4], short[5])
              NLG.SystemMessage(player,"[系統]還在時限內傳送不需要費用。");
              Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
          end
      end
    end
  end)
  self:NPC_regTalkedEvent(mazeNPC, function(npc, player)
    local name = Char.GetData(player,CONST.对象_名字);
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local regNumber = Char.GetData(player,CONST.对象_RegistNumber);

    local ret, open = nil,nil;
    ret, open = pcall(SQL.Run,"select regNo from lua_hook_worldboss where CdKey='"..cdk.."'")
    if (open==-3) then
      SQL.querySQL("REPLACE INTO lua_hook_worldboss (Name,CdKey,regNo) VALUES ("..SQL.sqlValue(name)..","..SQL.sqlValue(cdk)..","..SQL.sqlValue(regNumber)..") ");
    end
    --SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");

    if (NLG.CanTalk(npc, player) == true) then
      local winCase = CONST.窗口_选择框
      local winButton = CONST.BUTTON_关闭;
      local winMsg = "2\\n@c前往轉生後的裏空間冒險\\n"
                           .."　　————————————————————\\n"
      for i = 1,7 do
            local flag=i;
            local event = tonumber(SQL.Run("select LordEnd"..flag.." from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
            if (i==1) then
                winMsg = winMsg .. worldPoints[1][1] .. "  △隊伍每人傳送費: ".. worldPoints[1][6] .."\\n"
            end
            if (event == 1) then
                if (i>=7) then
                    winButton = CONST.BUTTON_下取消;
                    winMsg = winMsg
                else
                    winMsg = winMsg .. worldPoints[i+1][1] .. "  △隊伍每人傳送費: ".. worldPoints[i+1][6] .."\\n"
                end
            else
                winMsg = winMsg
            end
      end
      if (Char.GetData(player, CONST.对象_名色)<=0) then
                winMsg = "\\n\\n\\n@c你的實力還不夠\\n"
                       .."\\n轉生後再來這裡\\n";
                winCase = CONST.窗口_信息框;
                winButton = CONST.BUTTON_关闭;
      end
      NLG.ShowWindowTalked(player, npc, winCase, winButton, 1, winMsg);
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
	--print(Target_FloorId)
	if (Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_人 and Char.GetData(charIndex, CONST.对象_名色)>0 and Char.GetData(charIndex,CONST.对象_等级)>=101) then
		if (Target_FloorId==mazeMap[1][1] or Target_FloorId==mazeMap[1][2]) then
			if (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[1].R_level and Char.GetWorldCheck(1) == 0) then
				NLG.SystemMessage(charIndex,"您已高於轉生後"..worldExp[1].R_level.."級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[1].Upload and Char.GetWorldCheck(1) == 1) then
				NLG.SystemMessage(charIndex,"請前往下一章世界與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[1].L_level and Char.GetData(charIndex,CONST.对象_等级)<worldExp[1].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[1].UniItem)>0 and Target_FloorId==mazeMap[1][1]) then    --队友有独特装备
						NLG.SystemMessage(charIndex,"[隊友獨特裝備] 經驗加成1.5倍！");
						return exp * 1.5;  --角色获取的经验1.5倍
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[2][1] or Target_FloorId==mazeMap[2][2]) then
			if (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[2].R_level and Char.GetWorldCheck(2) == 0) then
				NLG.SystemMessage(charIndex,"您已高於轉生後"..worldExp[2].R_level.."級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[2].Upload and Char.GetWorldCheck(2) == 1) then
				NLG.SystemMessage(charIndex,"請前往下一章世界與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[2].L_level and Char.GetData(charIndex,CONST.对象_等级)<worldExp[2].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[2].UniItem)>0 and Target_FloorId==mazeMap[2][1]) then    --队友有独特装备
						NLG.SystemMessage(charIndex,"[隊友獨特裝備] 經驗加成1.5倍！");
						return exp * 1.5;  --角色获取的经验1.5倍
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[3][1] or Target_FloorId==mazeMap[3][2]) then
			if (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[3].R_level and Char.GetWorldCheck(3) == 0) then
				NLG.SystemMessage(charIndex,"您已高於轉生後"..worldExp[3].R_level.."級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[3].Upload and Char.GetWorldCheck(3) == 1) then
				NLG.SystemMessage(charIndex,"請前往下一章世界與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[3].L_level and Char.GetData(charIndex,CONST.对象_等级)<worldExp[3].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[3].UniItem)>0 and Target_FloorId==mazeMap[3][1]) then    --队友有独特装备
						NLG.SystemMessage(charIndex,"[隊友獨特裝備] 經驗加成1.5倍！");
						return exp * 1.5;  --角色获取的经验1.5倍
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[4][1] or Target_FloorId==mazeMap[4][2]) then
			if (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[4].R_level and Char.GetWorldCheck(4) == 0) then
				NLG.SystemMessage(charIndex,"您已高於轉生後"..worldExp[4].R_level.."級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[4].Upload and Char.GetWorldCheck(4) == 1) then
				NLG.SystemMessage(charIndex,"請前往下一章世界與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[4].L_level and Char.GetData(charIndex,CONST.对象_等级)<worldExp[4].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[4].UniItem)>0 and Target_FloorId==mazeMap[4][1]) then    --队友有独特装备
						NLG.SystemMessage(charIndex,"[隊友獨特裝備] 經驗加成1.5倍！");
						return exp * 1.5;  --角色获取的经验1.5倍
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[5][1] or Target_FloorId==mazeMap[5][2]) then
			if (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[5].R_level and Char.GetWorldCheck(5) == 0) then
				NLG.SystemMessage(charIndex,"您已高於轉生後"..worldExp[5].R_level.."級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[5].Upload and Char.GetWorldCheck(5) == 1) then
				NLG.SystemMessage(charIndex,"請前往下一章世界與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[5].L_level and Char.GetData(charIndex,CONST.对象_等级)<worldExp[5].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[5].UniItem)>0 and Target_FloorId==mazeMap[5][1]) then    --队友有独特装备
						NLG.SystemMessage(charIndex,"[隊友獨特裝備] 經驗加成1.5倍！");
						return exp * 1.5;  --角色获取的经验1.5倍
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[6][1] or Target_FloorId==mazeMap[6][2]) then
			if (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[6].R_level and Char.GetWorldCheck(6) == 0) then
				NLG.SystemMessage(charIndex,"您已高於轉生後"..worldExp[6].R_level.."級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[6].Upload and Char.GetWorldCheck(6) == 1) then
				NLG.SystemMessage(charIndex,"請前往下一章世界與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[6].L_level and Char.GetData(charIndex,CONST.对象_等级)<worldExp[6].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[6].UniItem)>0 and Target_FloorId==mazeMap[6][1]) then    --队友有独特装备
						NLG.SystemMessage(charIndex,"[隊友獨特裝備] 經驗加成1.5倍！");
						return exp * 1.5;  --角色获取的经验1.5倍
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[7][1] or Target_FloorId==mazeMap[7][2]) then
			if (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[7].R_level and Char.GetWorldCheck(7) == 0) then
				NLG.SystemMessage(charIndex,"您已高於轉生後"..worldExp[7].R_level.."級，請與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[7].Upload and Char.GetWorldCheck(7) == 1) then
				NLG.SystemMessage(charIndex,"請前往下一章世界與玩家合作通關BOSS，當前經驗已被鎖定。")
				return 0
			elseif (Char.GetData(charIndex,CONST.对象_等级)>=worldExp[7].L_level and Char.GetData(charIndex,CONST.对象_等级)<worldExp[7].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[7].UniItem)>0 and Target_FloorId==mazeMap[7][1]) then    --队友有独特装备
						NLG.SystemMessage(charIndex,"[隊友獨特裝備] 經驗加成1.5倍！");
						return exp * 1.5;  --角色获取的经验1.5倍
					end
				end
				return exp;
			end
		else
			if Char.GetData(charIndex,CONST.对象_队聊开关) == 1 then
				NLG.SystemMessage(charIndex,"轉生後請前往裏空間或下一章世界，當前經驗已被鎖定。")
			end
			return 0
		end
	else
		if (Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_宠) then
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
		elseif (Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_人) then
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
 if player>=0 then
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local TTime = Char.GetExtData(player, "MazeTimeT") or 0;
  local Target_FloorId = Char.GetData(player,CONST.对象_地图);
  if FTime > 0 then
    if STime >0 then
        if (os.time() - TTime) >= 12000 - (STime - FTime) and Target_FloorId>=7900 and Target_FloorId<=7907 then
            Char.Warp(player,0,1000,241,88);
            NLG.SystemMessage(player,"[系統]時限結束傳送離開裏空間。");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.SetExtData(player, "MazeTimeT", 0);
            Char.UnsetLoopEvent(player);
        elseif (os.time() - TTime) == 300 - (STime - FTime) and Target_FloorId>=7900 and Target_FloorId<=7907 then
            NLG.SystemMessage(player,"[系統]剩下五分鐘將傳送離開裏空間。");
        end
    else
        if (os.time() - FTime) >= 12000 and Target_FloorId>=7900 and Target_FloorId<=7907 then
            Char.Warp(player,0,1000,241,88);
            NLG.SystemMessage(player,"[系統]時限結束傳送離開裏空間。");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.SetExtData(player, "MazeTimeT", 0);
            Char.UnsetLoopEvent(player);
        elseif (os.time() - FTime) == 300 and Target_FloorId>=7900 and Target_FloorId<=7907 then
            NLG.SystemMessage(player,"[系統]剩下五分鐘將傳送離開裏空間。");
        end
    end
  else

  end
 end
end

function Module:onLogoutEvent(player)
 if player>=0 then
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
    Char.UnsetLoopEvent(player);
  end
 end
end

function Module:onLoginEvent(player)
 if player>=0 then
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local TTime = Char.GetExtData(player, "MazeTimeT") or 0;
  if FTime > 0 then
            Char.SetExtData(player, "MazeTimeT", os.time());
            Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
  else
            local Target_FloorId = Char.GetData(player,CONST.对象_地图);
            if Target_FloorId>=7900 and Target_FloorId<=7907 then
                Char.Warp(player,0,1000,241,88);
                Char.UnsetLoopEvent(player);
                NLG.SystemMessage(player,"[系統]時空傳送回原本世界。");
            end
  end
 end
end

Char.GetWorldCheck = function(chapter)
	local LordEnd = worldExp[chapter].Event;
	local ret = SQL.Run("select Name,"..LordEnd.." from lua_hook_worldboss order by "..LordEnd.." desc ");
	if (type(ret)=="table" and ret["0_1"]~=nil) then
		worldLayer = tonumber(ret["0_1"]);
	end
	return worldLayer;
end
--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
