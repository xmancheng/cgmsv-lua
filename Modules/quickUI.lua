local QuickUI = ModuleBase:createModule('quickUI')

local PartyMember={}
local onlinePlayerRewards = {}
local rewardsCount = {}

QuickUI:addMigration(1, 'init lua_hook_character', function()
  SQL.querySQL([[
      CREATE TABLE if not exists `lua_hook_character` (
    `Name` char(32) COLLATE gbk_bin NOT NULL,
    `CdKey` char(32) COLLATE gbk_bin NOT NULL,
    `RankedPoints` int(10) NOT NULL Default 0,
    `WingCover` int(10) NOT NULL Default 1,
    `OriginalImageNumber` int(10) NOT NULL,
    `SwitchImageNumber2` int(10) Default 1,
    `SwitchImageNumber3` int(10) Default 1,
    `SwitchImageNumber4` int(10) Default 1,
    `SwitchImageNumber5` int(10) Default 1,
    `SwitchImageNumber6` int(10) Default 1,
    `SwitchImageNumber7` int(10) Default 1,
    `SwitchImageNumber8` int(10) Default 1,
    `SwitchImageNumber9` int(10) Default 1,
    `SwitchImageNumber10` int(10) Default 1,
    `Tenjo` int(10) NOT NULL Default 0,
    `MatchDraw1` mediumtext COLLATE gbk_bin NULL,
    PRIMARY KEY (`CdKey`),
    KEY `Name` (`Name`) USING BTREE
  ) ENGINE=Innodb DEFAULT CHARSET=gbk COLLATE=gbk_bin
  ]])
end);

QuickUI:addMigration(2, 'insertinto lua_hook_character', function()
  SQL.querySQL([[
      INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character;
  ]])
end);

function QuickUI:headcover(player, hcID)
  --self:logDebug('headcover', player, hcID)
  if player>=0 and player < 800  then
      --local cdk = Char.GetData(player,CONST.对象_CDK);
      --local WingCover = tonumber(SQL.Run("select WingCover from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
      if hcID == 1 and Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 and Char.EndEvent(player,143) == 1 then
            local charPtr = Char.GetCharPointer(player)
            ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 200);   --walkSpeed
            return 108510;
      end
      if hcID == 1 and Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 then
            local charPtr = Char.GetCharPointer(player)
            ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 170);   --walkSpeed
            return 120054;
      end
      if hcID == 1 and Char.EndEvent(player,21) == 1 then
            local charPtr = Char.GetCharPointer(player)
            ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 150);   --walkSpeed
            return 114177;
      end
      if hcID == 1 and Char.EndEvent(player,0) == 1 then
            local charPtr = Char.GetCharPointer(player)
            ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 130);   --walkSpeed
            return 114206;
      end
  end
  return hcID;
end

function QuickUI:shortcut(player, actionID)
  if actionID == %动作_跑步% then
    self:walkingspeed(self.speedNpc,player);
  elseif actionID == %动作_攻击% then
    self:teamfever(self.feverNpc,player);
  elseif actionID == %动作_魔法% then
    self:teamheal(self.healNpc,player);
  elseif actionID == %动作_防御% then
    self:metamo(self.imageNpc,player);
  elseif actionID == %动作_点头% then
    self:gather(player);
  elseif actionID == %动作_坐下% then
    self:partyenter(player);
  elseif actionID == %动作_招手% then
    self:partyform(player);
  elseif actionID == %动作_剪刀% then
    self:petinfo(player);
  elseif actionID == %动作_投掷% then
    self:pettalk(player);
  end
end

function QuickUI:walkingspeed(npc, player)
      local msg = "\\n@c【移動加速】完成任務逐步提升至最高走路速度！\\n\\n1.王宮召喚士蓋茲[死者戒指]【150】\\n\\n2.女神卡連[六曜之塔]【200】\\n\\n3.受傷的女人[森羅萬象]【250】\\n\\n4.賽格梅特之魂[失翼之龍]【300】\\n";
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
end

function QuickUI:teamfever(npc, player)
      local msg = "\\n\\n@c【一鍵全隊打卡】\\n\\n非打卡狀態→打卡狀態\\n\\n打卡狀態→非打卡狀態\\n\\n[確定]幫全隊進行打卡|全隊的打卡結束\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 2, msg);
end

function QuickUI:teamheal(npc, player)
      local msg = "\\n\\n@c回復魔法值（+等量生命值）\\n\\n回復生命值\\n\\n回復寵物的生命值和魔法值\\n\\n一鍵回復全隊人物和寵物魔法、生命\\n";
      NLG.ShowWindowTalked(player, self.healNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 3, msg);
end

function QuickUI:metamo(npc, player)
      local cdk = Char.GetData(player,CONST.对象_CDK);
      SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
      local dressing_OImage = tonumber(SQL.Run("select OriginalImageNumber from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
      local msg = ""..dressing_OImage.."|【人物形象衣櫃】\\n\\n選[是]使角色更換此形象\\n\\n選[否]換下一頁的形象\\n\\n      1 / 10\\n";
      NLG.ShowWindowTalked(player, self.imageNpc, CONST.窗口_图框, CONST.按钮_是否, 4, msg);
end

function QuickUI:gather(player)
      local playerMapType = Char.GetData(player, CONST.CHAR_地图类型);
      local playerMap = Char.GetData(player, CONST.CHAR_地图);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
            for slot = 1,4 do
                local p = Char.GetPartyMember(player,slot)
                if(p>=0) then
                      Char.Warp(p, playerMapType, playerMap, playerX, playerY);
                end
            end
      else
            NLG.SystemMessage(player, '隊長才可使用！');
      end
end

function QuickUI:partyenter(player)
      local cdk = Char.GetData(player,CONST.对象_CDK);
      local playerMapType = Char.GetData(player, CONST.CHAR_地图类型);
      local playerMap = Char.GetData(player, CONST.CHAR_地图);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
             PartyMember[cdk] = {}
             for partySlot = 0,4 do 
                    local targetcharIndex = Char.GetPartyMember(player,partySlot);
                    if targetcharIndex >= 0  then
                          table.insert(PartyMember[cdk], partySlot+1, targetcharIndex);
                    else
                          table.insert(PartyMember[cdk], partySlot+1, -1);
                    end
             end
             table.insert(PartyMember[cdk],cdk);
             NLG.SystemMessage(player, '隊伍成員紀錄完畢！');
      else
            NLG.SystemMessage(player, '隊長才可使用！');
      end
end

function QuickUI:partyform(player)
      local cdk = Char.GetData(player,CONST.对象_CDK);
      local playerMapType = Char.GetData(player, CONST.CHAR_地图类型);
      local playerMap = Char.GetData(player, CONST.CHAR_地图);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      if PartyMember[cdk] ~= nill and cdk == PartyMember[cdk][6] then
            if Char.PartyNum(player) == -1 then
                  for i,v in ipairs(PartyMember[cdk]) do
                        local memberMap = Char.GetData(v, CONST.CHAR_地图);
                        local memberX = Char.GetData(v, CONST.CHAR_X);
                        local memberY = Char.GetData(v, CONST.CHAR_Y);
                        if i<=5 and v>-1 and v~=player and memberMap == playerMap then
                              if memberX >= playerX-5 and memberX <= playerX+5 and memberY>= playerY-5 and memberY<= playerY+5 then
                                    Char.Warp(v, playerMapType, playerMap, playerX, playerY);
                                    Char.JoinParty(v, player);
                              else
                                    NLG.SystemMessage(player, '有隊員距離過遠入隊失敗！');
                              end
                        end
                  end
            end
      else
            NLG.SystemMessage(player, '請先記錄或覆寫隊伍成員！');
      end
end

function QuickUI:petinfo(player)
      for petSlot = 0,4 do
            local petIndex = Char.GetPet(player, petSlot);
            local petname = Char.GetData(petIndex, CONST.CHAR_名字);
            local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_体成);
            local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_力成);
            local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_强成);
            local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_敏成);
            local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_魔成);
            local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,petSlot);
            if a6 >= 0 then
                  NLG.SystemMessage(player, '---------------------------------------');
                  NLG.SystemMessage(player, ''..petname..'：總共-'..a6..'檔次！');
                  NLG.SystemMessage(player, '體'..arr_rank1..'(-'..a1..')力'..arr_rank2..'(-'..a2..')強'..arr_rank3..'(-'..a3..')速'..arr_rank4..'(-'..a4..')魔'..arr_rank5..'(-'..a5..')');
            end
      end
      NLG.SystemMessage(player, '---------------------------------------');
end

local t1 = {"你睡著了喔?我都快餓死了..."};
local t2 = {"你自己一直偷吃都不餵我..."};
local t3 = {"我需要甜食，就是那個啦!"};
local t4 = {"我...我...太感動了!"};
local t5 = {"最近天氣不錯..."};
local t6 = {"無聊就吃東西吧..."};
local t7 = {"讓你喘口氣也好!"};
local t8 = {"哈哈!接下來要去挑戰誰呀!"};
local t9 = {"今天非常順利哦!走吧!我們再去練!"};
local t10 = {"不要以為就可以輕鬆的死亡!"};
local t11 = {"精神不夠啊，重新開始吧"};
local t12 = {"我有出眾的力量和智慧!"};
local t13 = {"很抱歉你只到這種水平... 很讓我失望"};
local t14 = {"活著是空虛的..."};
local t15 = {"不好意思!讓主人擔心了!"};
local t16 = {"恭喜呦!您是我心目中的英雄"};
local t17 = {"時間就是金幣啊! 朋友!"};
local t18 = {"先別急著冒險,讓我陪您喝杯茶再說吧!"};
local t19 = {"是的! 老大!"};
local t20 = {"嗚啦啊啊啊啊啊!!!"};
local talknotes = {t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20};
function QuickUI:pettalk(player)
      local playerMapType = Char.GetData(player, CONST.CHAR_地图类型);
      local playerMap = Char.GetData(player, CONST.CHAR_地图);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      local playerDir = Char.GetData(player, CONST.CHAR_方向);
      if (onlinePlayerRewards[player]==nil and rewardsCount[player]==nil) then
             onlinePlayerRewards[player] = os.time();
             rewardsCount[player] = 0;
      end
      if (rewardsCount[player]>0 and tonumber(os.date("%H",os.time())) - tonumber(os.date("%H",onlinePlayerRewards[player])) < 1) then
            NLG.SystemMessage(player,"在線獎勵領取時間紀錄"..os.date("%X",onlinePlayerRewards[player])..":請1小時後再次領取");
            return
      end
      if (foodNpc == nil) then
            if playerDir==0 then playerX=playerX; playerY=playerY-1;
            elseif playerDir==1 then playerX=playerX+1; playerY=playerY-1;
            elseif playerDir==2 then playerX=playerX+1; playerY=playerY;
            elseif playerDir==3 then playerX=playerX+1; playerY=playerY+1;
            elseif playerDir==4 then playerX=playerX; playerY=playerY+1;
            elseif playerDir==5 then playerX=playerX-1; playerY=playerY+1;
            elseif playerDir==6 then playerX=playerX-1; playerY=playerY;
            elseif playerDir==7 then playerX=playerX-1; playerY=playerY-1;
            end
            foodNpc = self:NPC_createNormal(' ', 27304, { x = playerX, y = playerY, mapType = playerMapType, map = playerMap, direction = 0 });
            rewardsCount[player] = 0;
      elseif (foodNpc ~= nil and Char.ItemSlot(player)<=18) then
            onlinePlayerRewards[player] = os.time();
            rewardsCount[player] = 1;
            for hbnum = 1,4 do 
                  local targetcharIndex = Char.GetPartyMember(player,hbnum);
                  if targetcharIndex >= 0 and Char.IsDummy(targetcharIndex) then
                        local r = math.random(2,20);
                        NLG.SystemMessage(player,""..Char.GetData(targetcharIndex,%对象_名字%)..":"..talknotes[r][1].."");
                  end
            end
            local giftItemID = {900497,900498,70016,75011}   --大蒜油、怪物餅乾、1000魔幣交換卡、精靈球
            local rx = math.random(1,4);
            Char.GiveItem(player, giftItemID[rx], rx, '你的寵物帶回來了一些道具給你！');
            NL.DelNpc(foodNpc);
            foodNpc = nil;
      elseif (foodNpc ~= nil and Char.ItemSlot(player)>=19) then
            NLG.SystemMessage(player,'物品欄快滿了，請空出兩格');
            return
      end
end


function QuickUI:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/book") then
		local msg = "2\\n@c　特殊便捷功能選單\\n"
			.."　　════════════════════\\n"
			.."　《組隊一鍵打卡》\\n"
			.."　《組隊一鍵恢復》\\n"
			.."　《形象替換衣櫃》\\n"
			.."　《走路移動加速》\\n"
			.."　《寵物一鍵算檔》\\n"
			.."　《成員集中一點》\\n"
			.."　《寵物互動(每小時1次)》\\n";
		NLG.ShowWindowTalked(charIndex, self.quickUInpc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
		return 0;
	end
	return 1;
end

function QuickUI:onLoad()
  self:logInfo('load');
  self:regCallback('CharActionEvent', Func.bind(self.shortcut, self))
  self:regCallback('HeadCoverEvent', Func.bind(self.headcover, self))
  self:regCallback('ItemString', Func.bind(self.imageCollection, self),"LUA_useMetamoCT");
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self.quickUInpc = self:NPC_createNormal('动作快捷图示', 98972, { x = 36, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.quickUInpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "2\\n@c　特殊便捷功能選單\\n"
            .."　　════════════════════\\n"
            .."　《組隊一鍵打卡》\\n"
            .."　《組隊一鍵恢復》\\n"
            .."　《形象替換衣櫃》\\n"
            .."　《走路移動加速》\\n"
            .."　《寵物一鍵算檔》\\n"
            .."　《成員集中一點》\\n"
            .."　《寵物互動(每小時1次)》\\n";
      NLG.ShowWindowTalked(player, self.quickUInpc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.quickUInpc, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
    else
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          local menuSelect = data;
          if menuSelect == 1 then
            self:teamfever(self.feverNpc,player);
          elseif menuSelect == 2 then
            self:teamheal(self.healNpc,player);
          elseif menuSelect == 3 then
            self:metamo(self.imageNpc,player);
          elseif menuSelect == 4 then
            self:walkingspeed(self.speedNpc,player);
          elseif menuSelect == 5 then
            self:petinfo(player);
          elseif menuSelect == 6 then
            self:gather(player);
          elseif menuSelect == 7 then
            self:pettalk(player);
          end
      end
    end
  end)

  --移動速度
  self.speedNpc = self:NPC_createNormal('速度快捷', 98972, { x = 37, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.speedNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c【移動加速】完成任務逐步提升至最高走路速度！\\n\\n1.王宮召喚士蓋茲[死者戒指]【130】\\n\\n2.女神卡連[六曜之塔]【150】\\n\\n3.受傷的女人[森羅萬象]【170】\\n\\n4.賽格梅特之魂[失翼之龍]【200】\\n";
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.speedNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
--[[
      local AccessoryIndex,Slot = Char.GetAccessory(player);
      if seqno == 1 and select == CONST.按钮_确定 and AccessoryIndex>=0 then
            if Item.GetData(AccessoryIndex, CONST.道具_ID) ~= 900331  then
                Item.SetData(AccessoryIndex, CONST.道具_ID, 900331);
                Item.SetData(AccessoryIndex, CONST.道具_名字, Item.GetData(AccessoryIndex, CONST.道具_名字).."[翅膀]" );
                Item.SetData(AccessoryIndex, CONST.道具_丢地消失, 1);
                Item.SetData(AccessoryIndex,CONST.道具_宠邮, 0);
                Item.UpItem(player, Slot);
                NLG.SetHeadIcon(player,1) 
            elseif Item.GetData(AccessoryIndex, CONST.道具_ID) == 900331  then
                self:headcover(player, hcID);
            end
      elseif seqno == 1 and select == CONST.按钮_确定 and AccessoryIndex<0 then
                NLG.SystemMessage(player, "翅膀系統走路加速，需要有任意裝飾品");
      elseif seqno == 1 and select == CONST.按钮_关闭 then
                local charPtr = Char.GetCharPointer(player)
                ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 100);   --walkSpeed
                NLG.UpChar(player)
      end
]]
      if seqno == 1 and select == CONST.按钮_确定 then
          if Char.EndEvent(player,0) == 1 then
                Char.SetData(player, CONST.对象_移速,150);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 114206);
          end
          if  Char.EndEvent(player,21) == 1 then
                Char.SetData(player, CONST.对象_移速,200);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 114177);
          end
          if  Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 then
                Char.SetData(player, CONST.对象_移速,250);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 120054);
          end
          if  Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 and Char.EndEvent(player,143) == 1 then
                Char.SetData(player, CONST.对象_移速,300);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 108510)
          end
      elseif seqno == 1 and select == CONST.按钮_关闭 then
                Char.SetData(player, CONST.对象_移速,100);
                NLG.UpChar(player)
      end
    end
  end)
  --全隊打卡
  self.feverNpc = self:NPC_createNormal('打卡快捷', 98972, { x = 38, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.feverNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c【一鍵全隊打卡】\\n\\n非打卡狀態→打卡狀態\\n\\n打卡狀態→非打卡狀態\\n\\n[確定]幫全隊進行打卡、全隊的打卡結束\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 2, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.feverNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 2 and select == CONST.按钮_确定 then
        for slot = 0,4 do
          local p = Char.GetPartyMember(player,slot)
          if(p>=0) then
                local daka = Char.GetData(p, CONST.对象_打卡);
                local name = Char.GetData(p,CONST.CHAR_名字);
                if daka == 1 then
                      Char.FeverStop(p);
                      NLG.UpChar(p);
                      NLG.SystemMessage(player, name.."關閉打卡。");
                end
                if daka == 0 then
                      if Char.IsDummy(p) then
                          Char.SetData(p, CONST.CHAR_卡时, 24 * 3600);
                      end
                      Char.FeverStart(p);
                      NLG.UpChar(p);
                      NLG.SystemMessage(player, name.."打卡成功。");
                end
          else
                --NLG.SystemMessage(player, "組隊狀態才能用此全隊打卡。");
                return
          end
        end
      end
    end
  end)
  --全隊補血
  self.healNpc = self:NPC_createNormal('补血快捷', 98972, { x = 39, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.healNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c回復魔法值（+等量生命值）\\n\\n回復生命值\\n\\n回復寵物的生命值和魔法值\\n\\n一鍵回復全隊人物和寵物魔法、生命\\n";
      NLG.ShowWindowTalked(player, self.healNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 3, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.healNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 3 and select == CONST.按钮_确定 then
        gold = Char.GetData(player, CONST.CHAR_金币);
        totalGold = 0;
        FpGold = 0;
        LpGold = 0;
        --計算回復總金額
        for slot = 0,4 do
          local p = Char.GetPartyMember(player,slot)
          if(p>=0) then
                local lp = Char.GetData(p, CONST.CHAR_血)
                local maxLp = Char.GetData(p, CONST.CHAR_最大血)
                local fp = Char.GetData(p, CONST.CHAR_魔)
                local maxFp = Char.GetData(p, CONST.CHAR_最大魔)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
          end
        end
        print(FpGold,LpGold)
        if FpGold*0.5 >= LpGold then
          totalGold = FpGold;
        else
          totalGold = FpGold + LpGold - FpGold*0.5;
        end
        local msg = "\\n\\n@c全隊回復需要花費"..totalGold.."個金幣\\n\\n現有金錢是"..gold.."個金幣\\n\\n\\n要回復嗎？\\n";
        NLG.ShowWindowTalked(player, self.healNpc, CONST.窗口_信息框, CONST.按钮_是否, 31, msg);
      --人物寵物補血魔
      elseif seqno == 31 and select == CONST.按钮_是 then
        if gold < totalGold then
                NLG.SystemMessage(player, '金幣不足無法回復');
                return
        else
                if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
                    for slot = 0,4 do
                       local p = Char.GetPartyMember(player,slot);
                       if(p>=0) then
                           local maxLp = Char.GetData(p, CONST.CHAR_最大血);
                           local maxFp = Char.GetData(p, CONST.CHAR_最大魔);
                           Char.SetData(p, CONST.CHAR_血, maxLp);
                           Char.SetData(p, CONST.CHAR_魔, maxFp);
                           NLG.UpChar(p);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(p,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.CHAR_最大血);
                                  local maxFp = Char.GetData(petIndex, CONST.CHAR_最大魔);
                                  Char.SetData(petIndex, CONST.CHAR_血, maxLp);
                                  Char.SetData(petIndex, CONST.CHAR_魔, maxFp);
                                  Pet.UpPet(p, petIndex);
                              end
                           end
                       end
                    end
                    Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                else
                    NLG.SystemMessage(player, '隊長才可使用！');
                end
        end

      end
    end
  end)

  --人物衣櫃
  self.imageNpc = self:NPC_createNormal('形象快捷', 98972, { x = 40, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.imageNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local cdk = Char.GetData(player,CONST.对象_CDK);
      SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
      local dressing_OImage = tonumber(SQL.Run("select OriginalImageNumber from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
      local msg = ""..dressing_OImage.."|【人物形象衣櫃】\\n\\n選[是]使角色更換此形象\\n\\n選[否]換下一頁的形象\\n\\n      1 / 10\\n";
      NLG.ShowWindowTalked(player, self.imageNpc, CONST.窗口_图框, CONST.按钮_是否, 4, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.imageNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local dressing_BImage = tonumber(Char.GetData(player,CONST.对象_形象));
    local dressing_OImage = tonumber(SQL.Run("select OriginalImageNumber from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
    if select > 0 then
      if seqno == 4 and select == CONST.按钮_是 then
            Char.SetData(player,CONST.对象_形象, dressing_OImage);
            Char.SetData(player,CONST.对象_原形, dressing_OImage);
            Char.SetData(player,CONST.对象_原始图档, dressing_OImage);
            NLG.UpChar(player)
      elseif seqno == 4 and select == CONST.按钮_否 then
            page = seqno*10+1;
            local dressing = tonumber(SQL.Run("select SwitchImageNumber2 from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
            local msg = ""..dressing.."|【人物形象衣櫃】\\n\\n選[是]使角色更換此形象\\n\\n選[否]換下一頁的形象\\n\\n      2 / 10\\n";
            NLG.ShowWindowTalked(player, self.imageNpc, CONST.窗口_图框, CONST.按钮_是否, page, msg);
      end
      --第二頁以後的新增形象展示
      if seqno == page and select == CONST.按钮_是 then
            local imagepage = page-40+1;
            if page<=49 then
                local dressing = tonumber(SQL.Run("select SwitchImageNumber"..imagepage.." from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
                if dressing_BImage ~= dressing and dressing > 1 then
                    Char.SetData(player,CONST.对象_形象, dressing);
                    Char.SetData(player,CONST.对象_原形, dressing);
                    Char.SetData(player,CONST.对象_原始图档, dressing);
                    NLG.UpChar(player)                
                else
                    NLG.SystemMessage(player, '請先登記取得的造型形象卡片。');
                    return;
                end
            end
      elseif seqno == page and select == CONST.按钮_否 then
            page = page+1;
            local imagepage = page-40+1;
            if page<=49 then
                local dressing =  tonumber(SQL.Run("select SwitchImageNumber"..imagepage.." from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
                local msg = ""..dressing.."|【人物形象衣櫃】\\n\\n選[是]使角色更換此形象\\n\\n選[否]換下一頁的形象\\n\\n      "..imagepage.." / 10\\n";
                NLG.ShowWindowTalked(player, self.imageNpc, CONST.窗口_图框, CONST.按钮_是否, page, msg);
            else
                return;
            end
      end

    end
  end)


end

Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_体成);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_力成);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_强成);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_敏成);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_魔成);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_体成);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_力成);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_强成);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_敏成);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_魔成);
    local a1 = math.abs(arr_rank11 - arr_rank1);
    local a2 = math.abs(arr_rank21 - arr_rank2);
    local a3 = math.abs(arr_rank31 - arr_rank3);
    local a4 = math.abs(arr_rank41 - arr_rank4);
    local a5 = math.abs(arr_rank51 - arr_rank5);
    local a6 = a1 + a2+ a3+ a4+ a5;
    return a6, a1, a2, a3, a4, a5;
  end
  return -1;
end

function QuickUI:imageCollection(charIndex,targetIndex,itemSlot)
    local cdk = Char.GetData(charIndex,CONST.对象_CDK);
    local name = Char.GetData(charIndex, CONST.CHAR_名字);
    SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
    local Name_data =  SQL.Run("select Name from lua_hook_character where CdKey='"..cdk.."'")["0_0"]

    local ItemIndex = Char.GetItemIndex(charIndex, itemSlot);
    local ItemID = Item.GetData(ItemIndex,0);
    local Special = Item.GetData(ItemIndex,CONST.道具_特殊类型);
    local Para1 = tonumber(Item.GetData(ItemIndex,CONST.道具_子参一));
    local Para2 = tonumber(Item.GetData(ItemIndex,CONST.道具_子参二));

    if (Name_data == name) then
        if (Special == 14 and Para1 == 1 and Para2 ~= 0) then
            for image=2,10 do
                local Number =  tonumber(SQL.Run("select SwitchImageNumber"..image.." from lua_hook_character where Name='"..name.."'")["0_0"])
                if Number == 1 then
                    SQL.Run("update lua_hook_character set SwitchImageNumber"..image.." = '"..Para2.."' where Name='"..name.."'");
                    Char.DelItemBySlot(charIndex, itemSlot);
                    return;
                else
                    --NLG.SystemMessage(charIndex, '人物形象收藏暫時已滿！');
                end
            end
        end
    end
end


Char.GetAccessory = function(charIndex)
  local itemType = {
    { type=15},{ type=16},{ type=17},{ type=18},{ type=19},{ type=20},{ type=21},
  }
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_首饰1);
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.道具_类型)==v.type then
        return ItemIndex, CONST.EQUIP_首饰1;
      end
    end
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_首饰2)
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.道具_类型)==v.type then
        return ItemIndex, CONST.EQUIP_首饰2;
      end
    end
  end
  return -1, -1;
end

function QuickUI:onUnload()
  self:logInfo('unload')
end

return QuickUI;
