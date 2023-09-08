local QuickUI = ModuleBase:createModule('quickUI')

local PartyMember={}

function QuickUI:shortcut(player, actionID)
  if actionID == %动作_跑步% then
    self:walkingspeed(self.speedNpc,player);
  elseif actionID == %动作_攻击% then
    self:teamfever(self.feverNpc,player);
  elseif actionID == %动作_魔法% then
    self:teamheal(self.healNpc,player);
  elseif actionID == %动作_点头% then
    self:gather(player);
  elseif actionID == %动作_坐下% then
    self:partyenter(player);
  elseif actionID == %动作_招手% then
    self:partyform(player);
  end
end

function QuickUI:walkingspeed(npc, player)
      local msg = "\\n\\n@c【移動加速】完成任務逐步提升至最高走路速度！\\n\\n1.王宮召喚士蓋茲[死者戒指]【120】\\n\\n2.女神卡連[六曜之塔]【140】\\n";
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

function QuickUI:onLoad()
  self:logInfo('load');
  self:regCallback('CharActionEvent', Func.bind(self.shortcut, self))
  self.quickUINpc = self:NPC_createNormal('动作快捷图示', 98972, { x = 36, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.quickUINpc, Func.bind(self.shortcut, self))
  self:NPC_regWindowTalkedEvent(self.quickUINpc, Func.bind(self.shortcut, self))

  --移動速度
  self.speedNpc = self:NPC_createNormal('速度快捷', 98972, { x = 37, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.speedNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c【移動加速】完成任務逐步提升至最高走路速度！\\n\\n1.王宮召喚士蓋茲[死者戒指]【120】\\n\\n2.女神卡連[六曜之塔]【140】\\n";
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
      if seqno == 1 and select == CONST.按钮_确定 then
            if Char.EndEvent(player,0) == 1 then
                local charPtr = Char.GetCharPointer(player)
                ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 120);   --walkSpeed
                NLG.SetHeadIcon(player,114206);
                NLG.UpChar(player)
            end
            if Char.EndEvent(player,21) == 1 then
                local charPtr = Char.GetCharPointer(player)
                ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 140);   --walkSpeed
                NLG.SetHeadIcon(player,114177);
                NLG.UpChar(player)
            end
      elseif seqno == 1 and select == CONST.按钮_关闭 then
                local charPtr = Char.GetCharPointer(player)
                ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 100);   --walkSpeed
                NLG.SetHeadIcon(player,1);
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
                local daka = Char.GetData(p, 4008);
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
                NLG.SystemMessage(player, "組隊狀態才能用此全隊打卡。");
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
        local gold = Char.GetData(player, CONST.CHAR_金币);
        local totalGold = 0;
        local FpGold = 0;
        local LpGold = 0;
        --計算回復總金額
        for slot = 0,4 do
          local p = Char.GetPartyMember(player,slot)
          if(p>=0) then
                local lp = Char.GetData(p, CONST.CHAR_血)
                local maxLp = Char.GetData(p, CONST.CHAR_最大血)
                local fp = Char.GetData(p, CONST.CHAR_魔)
                local maxFp = Char.GetData(p, CONST.CHAR_最大魔)
                if fp < maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp < maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
          end
        end
        if FpGold*0.5 >= LpGold then
          totalGold = FpGold;
        else
          totalGold = FpGold + LpGold - FpGold*0.5;
        end
        --人物寵物補血魔
        if gold < totalGold then
                NLG.SystemMessage(player, '金幣不足無法回復');
                return
        else
                for slot = 0,4 do
                       local p = Char.GetPartyMember(player,slot)
                       if(p>=0) then
                           local maxLp = Char.GetData(p, CONST.CHAR_最大血)
                           local maxFp = Char.GetData(p, CONST.CHAR_最大魔)
                           Char.SetData(p, CONST.CHAR_血, maxLp);
                           Char.SetData(p, CONST.CHAR_魔, maxFp);
                           NLG.UpChar(p);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(p,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.CHAR_最大血)
                                  local maxFp = Char.GetData(petIndex, CONST.CHAR_最大魔)
                                  Char.SetData(petIndex, CONST.CHAR_血, maxLp);
                                  Char.SetData(petIndex, CONST.CHAR_魔, maxFp);
                                  Pet.UpPet(player, petIndex);
                              end
                           end
                       else
                              NLG.SystemMessage(player, "組隊狀態才能用此全隊回復。");
                              return
                       end
                end
        end
        Char.AddGold(player, -totalGold);
        NLG.UpChar(player);
      end
    end
  end)

end

function QuickUI:onUnload()
  self:logInfo('unload')
end

return QuickUI;
