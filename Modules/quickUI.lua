local QuickUI = ModuleBase:createModule('quickUI')

function QuickUI:shortcut(player, actionID)
  if actionID == %动作_跑步% then
    self:walkingspeed(self.speedNpc,player);
  elseif actionID == %动作_攻击% then
    self:teamfever(self.feverNpc,player);
  end
end

function QuickUI:walkingspeed(npc, player)
      local msg = "\\n\\n@c【移動加速】完成任務逐步提升至最高走路速度！\\n\\n1.王宮召喚士蓋茲[死者戒指]【120】\\n\\n2.女神卡連[六曜之塔]【140】\\n";
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
end

function QuickUI:teamfever(npc, player)
      local msg = "\\n\\n@c【一鍵全隊打卡】\\n\\n非打卡狀態→打卡狀態\\n\\n打卡狀態→非打卡狀態\\n\\n[確定]幫全隊進行打卡、全隊的打卡結束\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 2, msg);
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

end

function QuickUI:onUnload()
  self:logInfo('unload')
end

return QuickUI;
