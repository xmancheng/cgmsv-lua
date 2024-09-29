local QuickUI = ModuleBase:createModule('quickUI')

local PartyMember={}

function QuickUI:shortcut(player, actionID)
  if actionID == %动作_剪刀% then
    self:petinfo(player);
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
            local TrueName = Char.GetData(petIndex,CONST.对象_原名);
            local last = string.find(TrueName, "異種", 1) or nil;
            local a61 = arr_rank1+arr_rank2+arr_rank3+arr_rank4+arr_rank5;
            if last~=nil then
                  NLG.SystemMessage(player, '---------------------------------------');
                  NLG.SystemMessage(player, ''..TrueName..'：總共是《'..a61..'》成長檔次');
                  NLG.SystemMessage(player, '體成長'..arr_rank1..' 力成長'..arr_rank2..' 強成長'..arr_rank3..' 速成長'..arr_rank4..' 魔成長'..arr_rank5);
            elseif last==nil and a6 >= 0 then
                  NLG.SystemMessage(player, '---------------------------------------');
                  NLG.SystemMessage(player, ''..petname..'：總共-'..a6..'檔次！');
                  NLG.SystemMessage(player, '體'..arr_rank1..'(-'..a1..')力'..arr_rank2..'(-'..a2..')強'..arr_rank3..'(-'..a3..')速'..arr_rank4..'(-'..a4..')魔'..arr_rank5..'(-'..a5..')');
            end
      end
      NLG.SystemMessage(player, '---------------------------------------');
end

function QuickUI:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/book") then
		local msg = "2\\n@c　特殊便捷功能選單\\n"
			.."　　════════════════════\\n"
			.."　《組隊一鍵打卡》\\n"
			.."　《組隊一鍵恢復》\\n"
			.."　《隊伍成員紀錄》\\n"
			.."　《隊伍成員集結》\\n"
			.."　《成員集中一點》\\n"
			.."　《走路移動加速》\\n"
			.."　《寵物一鍵算檔》\\n";
		NLG.ShowWindowTalked(charIndex, self.quickUInpc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
		return 0;
	end
	return 1;
end

function QuickUI:onLoad()
  self:logInfo('load');
  self:regCallback('CharActionEvent', Func.bind(self.shortcut, self))
  self:regCallback('ItemString', Func.bind(self.imageCollection, self),"LUA_useMetamoCT");
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self.quickUInpc = self:NPC_createNormal('动作快捷图示', 98972, { x = 36, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.quickUInpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "2\\n@c　特殊便捷功能選單\\n"
            .."　　════════════════════\\n"
            .."　《組隊一鍵打卡》\\n"
            .."　《組隊一鍵恢復》\\n"
            .."　《隊伍成員紀錄》\\n"
            .."　《隊伍成員集結》\\n"
            .."　《成員集中一點》\\n"
            .."　《走路移動加速》\\n"
            .."　《寵物一鍵算檔》\\n";
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
            self:partyenter(player);
          elseif menuSelect == 4 then
            self:partyform(player);
          elseif menuSelect == 5 then
            self:gather(player);
          elseif menuSelect == 6 then
            self:walkingspeed(self.speedNpc,player);
          elseif menuSelect == 7 then
            self:petinfo(player);
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
